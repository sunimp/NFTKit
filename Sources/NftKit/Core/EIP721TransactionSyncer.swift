//
//  EIP721TransactionSyncer.swift
//  NFTKit
//
//  Created by Sun on 2024/8/15.
//

import Foundation

import BigInt
import EVMKit

// MARK: - EIP721TransactionSyncer

class EIP721TransactionSyncer {
    // MARK: Properties

    weak var delegate: ITransactionSyncerDelegate?

    private let provider: ITransactionProvider
    private let storage: Storage

    // MARK: Lifecycle

    init(provider: ITransactionProvider, storage: Storage) {
        self.provider = provider
        self.storage = storage
    }

    // MARK: Functions

    private func handle(transactions: [ProviderEIP721Transaction]) {
        guard !transactions.isEmpty else {
            return
        }

        let events = transactions.map { tx in
            EIP721Event(
                hash: tx.hash,
                blockNumber: tx.blockNumber,
                contractAddress: tx.contractAddress,
                from: tx.from,
                to: tx.to,
                tokenID: tx.tokenID,
                tokenName: tx.tokenName,
                tokenSymbol: tx.tokenSymbol,
                tokenDecimal: tx.tokenDecimal
            )
        }

        try? storage.save(eip721Events: events)

        let nfts = Set<NFT>(events.map { event in
            NFT(
                type: .eip721,
                contractAddress: event.contractAddress,
                tokenID: event.tokenID,
                tokenName: event.tokenName
            )
        })

        delegate?.didSync(nfts: Array(nfts), type: .eip721)
    }
}

// MARK: ITransactionSyncer

extension EIP721TransactionSyncer: ITransactionSyncer {
    func transactions() async throws -> ([Transaction], Bool) {
        let lastBlockNumber = try storage.lastEIP721Event()?.blockNumber ?? 0
        let initial = lastBlockNumber == 0

        do {
            let transactions = try await provider.eip721Transactions(startBlock: lastBlockNumber + 1)

            handle(transactions: transactions)

            let array = transactions.map { tx in
                Transaction(
                    hash: tx.hash,
                    timestamp: tx.timestamp,
                    isFailed: false,
                    blockNumber: tx.blockNumber,
                    transactionIndex: tx.transactionIndex,
                    nonce: tx.nonce,
                    gasPrice: tx.gasPrice,
                    gasLimit: tx.gasLimit,
                    gasUsed: tx.gasUsed
                )
            }

            return (array, initial)
        } catch {
            return ([], initial)
        }
    }
}
