//
//  BalanceManager.swift
//
//  Created by Sun on 2024/8/15.
//

import Combine
import Foundation

import BigInt
import EVMKit
import WWExtensions

// MARK: - BalanceManager

class BalanceManager {
    // MARK: Properties

    @PostPublished
    private(set) var nftBalances: [NFTBalance] = []

    private let storage: Storage
    private let syncManager: BalanceSyncManager

    // MARK: Lifecycle

    init(storage: Storage, syncManager: BalanceSyncManager) {
        self.storage = storage
        self.syncManager = syncManager

        syncNFTBalances()
    }

    // MARK: Functions

    private func syncNFTBalances() {
        do {
            nftBalances = try storage.existingNFTBalances()
        } catch {
            // todo
        }
    }

    private func handleNFTsFromTransactions(type: NFTType, nfts: [NFT]) throws {
        let existingBalances = try storage.nftBalances(type: type)

        let existingNFTs = existingBalances.map(\.nft)
        let newNFTs = nfts.filter { !existingNFTs.contains($0) }

        try storage.setNotSynced(nfts: existingNFTs)
        try storage.save(nftBalances: newNFTs.map { NFTBalance(nft: $0, balance: 0, synced: false) })

        syncManager.sync()
    }
}

extension BalanceManager {
    func nftBalance(contractAddress: Address, tokenID: BigUInt) -> NFTBalance? {
        try? storage.existingNFTBalance(contractAddress: contractAddress, tokenID: tokenID)
    }

    func didSync(nfts: [NFT], type: NFTType) {
        DispatchQueue.global(qos: .utility).async { [weak self] in
            try? self?.handleNFTsFromTransactions(type: type, nfts: nfts)
        }
    }
}

// MARK: IBalanceSyncManagerDelegate

extension BalanceManager: IBalanceSyncManagerDelegate {
    func didFinishSyncBalances() {
        syncNFTBalances()
    }
}
