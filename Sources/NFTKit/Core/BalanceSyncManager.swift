//
//  BalanceSyncManager.swift
//  NFTKit
//
//  Created by Sun on 2022/8/25.
//

import Foundation

import BigInt
import EVMKit
import SWExtensions

// MARK: - BalanceSyncManager

class BalanceSyncManager {
    // MARK: Properties

    weak var delegate: IBalanceSyncManagerDelegate?

    private let address: Address
    private let storage: Storage
    private let dataProvider: DataProvider
    private var tasks = Set<AnyTask>()

    private var syncing = false
    private var syncRequested = false

    private let queue = DispatchQueue(label: "com.sunimp.nft-kit.balance-sync-manager", qos: .userInitiated)

    // MARK: Lifecycle

    init(address: Address, storage: Storage, dataProvider: DataProvider) {
        self.address = address
        self.storage = storage
        self.dataProvider = dataProvider
    }

    // MARK: Functions

    private func _finishSync() {
        syncing = false

        if syncRequested {
            syncRequested = false
            sync()
        }
    }

    private func _handle(nftBalances: [NFT: Int?]) {
        var balanceInfos = [(NFT, Int)]()

        for (nft, balance) in nftBalances {
            if let balance {
//                print("Synced balance for \(nftBalance.nft.tokenName) - \(nftBalance.nft.contractAddress) -
//                \(nftBalance.nft.tokenId) - \(balance)")
                balanceInfos.append((nft, balance))
            } else {
                print("Failed to sync balance for \(nft.tokenName) - \(nft.contractAddress) - \(nft.tokenID)")
            }
        }

        try? storage.setSynced(balanceInfos: balanceInfos)

        delegate?.didFinishSyncBalances()

        _finishSync()
    }

    private func handle(nftBalances: [NFT: Int?]) {
        queue.async {
            self._handle(nftBalances: nftBalances)
        }
    }

    private func _syncBalances(nfts: [NFT]) async {
        let balances = await withTaskGroup(of: (NFT, Int?).self) { group in
            for nft in nfts {
                group.addTask {
                    await (nft, try? self.balance(nft: nft))
                }
            }

            var balances = [NFT: Int?]()

            for await (nft, nftBalance) in group {
                balances[nft] = nftBalance
            }

            return balances
        }

        handle(nftBalances: balances)
    }

    private func _sync() throws {
        if syncing {
            syncRequested = true
            return
        }

        syncing = true

        let nftBalances = try storage.nonSyncedNFTBalances()

        guard !nftBalances.isEmpty else {
            _finishSync()
            return
        }

//        print("NON SYNCED: \(nftBalances.count)")

        Task { [weak self] in
            await self?._syncBalances(nfts: nftBalances.map(\.nft))
        }.store(in: &tasks)
    }

    private func balance(nft: NFT) async throws -> Int {
        let address = address

        switch nft.type {
        case .eip721:
            do {
                let owner = try await dataProvider.getEIP721Owner(
                    contractAddress: nft.contractAddress,
                    tokenID: nft.tokenID
                )
                return owner == address ? 1 : 0
            } catch {
                if case JsonRpcResponse.ResponseError.rpcError = error {
                    return 0
                }

                throw error
            }

        case .eip1155:
            return try await dataProvider.getEIP1155Balance(
                contractAddress: nft.contractAddress,
                owner: address,
                tokenID: nft.tokenID
            )
        }
    }
}

extension BalanceSyncManager {
    func sync() {
        queue.async {
            try? self._sync()
        }
    }
}
