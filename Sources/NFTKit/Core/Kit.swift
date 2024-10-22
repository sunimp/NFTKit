//
//  Kit.swift
//  NFTKit
//
//  Created by Sun on 2022/8/24.
//

import Combine
import Foundation

import BigInt
import EVMKit

// MARK: - Kit

public class Kit {
    // MARK: Properties

    private let evmKit: EVMKit.Kit
    private let balanceManager: BalanceManager
    private let balanceSyncManager: BalanceSyncManager
    private let transactionManager: TransactionManager
    private let storage: Storage
    private var cancellables = Set<AnyCancellable>()

    // MARK: Lifecycle

    init(
        evmKit: EVMKit.Kit,
        balanceManager: BalanceManager,
        balanceSyncManager: BalanceSyncManager,
        transactionManager: TransactionManager,
        storage: Storage
    ) {
        self.evmKit = evmKit
        self.balanceManager = balanceManager
        self.balanceSyncManager = balanceSyncManager
        self.transactionManager = transactionManager
        self.storage = storage

        evmKit.syncStatePublisher
            .sink { [weak self] in
                self?.onUpdateSyncState(syncState: $0)
            }
            .store(in: &cancellables)
    }

    // MARK: Functions

    private func onUpdateSyncState(syncState: EVMKit.SyncState) {
        switch syncState {
        case .synced:
            balanceSyncManager.sync()
        case .syncing:
            ()
        case .notSynced:
            ()
        }
    }
}

extension Kit {
    public func sync() {
        if case .synced = evmKit.syncState {
            balanceSyncManager.sync()
        }
    }

    public var nftBalances: [NFTBalance] {
        balanceManager.nftBalances
    }

    public var nftBalancesPublisher: AnyPublisher<[NFTBalance], Never> {
        balanceManager.$nftBalances
    }

    public func nftBalance(contractAddress: Address, tokenID: BigUInt) -> NFTBalance? {
        balanceManager.nftBalance(contractAddress: contractAddress, tokenID: tokenID)
    }

    public func transferEIP721TransactionData(
        contractAddress: Address,
        to: Address,
        tokenID: BigUInt
    )
        -> TransactionData {
        transactionManager.transferEIP721TransactionData(contractAddress: contractAddress, to: to, tokenID: tokenID)
    }

    public func transferEIP1155TransactionData(
        contractAddress: Address,
        to: Address,
        tokenID: BigUInt,
        value: BigUInt
    )
        -> TransactionData {
        transactionManager.transferEIP1155TransactionData(
            contractAddress: contractAddress,
            to: to,
            tokenID: tokenID,
            value: value
        )
    }
}

// MARK: ITransactionSyncerDelegate

extension Kit: ITransactionSyncerDelegate {
    func didSync(nfts: [NFT], type: NFTType) {
        balanceManager.didSync(nfts: nfts, type: type)
    }
}

extension Kit {
    public func addEIP721TransactionSyncer() {
        let syncer = EIP721TransactionSyncer(provider: evmKit.transactionProvider, storage: storage)
        syncer.delegate = self
        evmKit.add(transactionSyncer: syncer)
    }

    public func addEIP1155TransactionSyncer() {
        let syncer = EIP1155TransactionSyncer(provider: evmKit.transactionProvider, storage: storage)
        syncer.delegate = self
        evmKit.add(transactionSyncer: syncer)
    }

    public func addEIP721Decorators() {
        evmKit
            .add(methodDecorator: EIP721MethodDecorator(contractMethodFactories: EIP721ContractMethodFactories.shared))
        evmKit.add(eventDecorator: EIP721EventDecorator(userAddress: evmKit.address, storage: storage))
        evmKit.add(transactionDecorator: EIP721TransactionDecorator(userAddress: evmKit.address))
    }

    public func addEIP1155Decorators() {
        evmKit
            .add(methodDecorator: EIP1155MethodDecorator(
                contractMethodFactories: EIP1155ContractMethodFactories
                    .shared
            ))
        evmKit.add(eventDecorator: EIP1155EventDecorator(userAddress: evmKit.address, storage: storage))
        evmKit.add(transactionDecorator: EIP1155TransactionDecorator(userAddress: evmKit.address))
    }
}

extension Kit {
    public static func instance(evmKit: EVMKit.Kit) throws -> Kit {
        let storage = try Storage(
            databaseDirectoryURL: dataDirectoryURL(),
            databaseFileName: "storage-\(evmKit.uniqueID)"
        )

        let dataProvider = DataProvider(evmKit: evmKit)
        let balanceSyncManager = BalanceSyncManager(
            address: evmKit.address,
            storage: storage,
            dataProvider: dataProvider
        )
        let balanceManager = BalanceManager(storage: storage, syncManager: balanceSyncManager)

        balanceSyncManager.delegate = balanceManager

        let transactionManager = TransactionManager(evmKit: evmKit)

        return Kit(
            evmKit: evmKit,
            balanceManager: balanceManager,
            balanceSyncManager: balanceSyncManager,
            transactionManager: transactionManager,
            storage: storage
        )
    }

    public static func clear(exceptFor excludedFiles: [String]) throws {
        let fileManager = FileManager.default
        let fileURLs = try fileManager.contentsOfDirectory(at: dataDirectoryURL(), includingPropertiesForKeys: nil)

        for filename in fileURLs {
            if !excludedFiles.contains(where: { filename.lastPathComponent.contains($0) }) {
                try fileManager.removeItem(at: filename)
            }
        }
    }

    private static func dataDirectoryURL() throws -> URL {
        let fileManager = FileManager.default

        let url = try fileManager
            .url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            .appendingPathComponent("nft-kit", isDirectory: true)

        try fileManager.createDirectory(at: url, withIntermediateDirectories: true)

        return url
    }
}
