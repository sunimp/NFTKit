//
//  EIP721EventDecorator.swift
//  NFTKit
//
//  Created by Sun on 2024/8/15.
//

import Foundation

import EVMKit

// MARK: - EIP721EventDecorator

class EIP721EventDecorator {
    // MARK: Properties

    private let userAddress: Address
    private let storage: Storage

    // MARK: Lifecycle

    init(userAddress: Address, storage: Storage) {
        self.userAddress = userAddress
        self.storage = storage
    }
}

// MARK: IEventDecorator

extension EIP721EventDecorator: IEventDecorator {
    public func contractEventInstancesMap(transactions: [Transaction]) -> [Data: [ContractEventInstance]] {
        let events: [EIP721Event]

        do {
            if transactions.count > 100 {
                events = try storage.eip721Events()
            } else {
                let hashes = transactions.map(\.hash)
                events = try storage.eip721Events(hashes: hashes)
            }
        } catch {
            events = []
        }

        var map = [Data: [ContractEventInstance]]()

        for event in events {
            let eventInstance = EIP721TransferEventInstance(
                contractAddress: event.contractAddress,
                from: event.from,
                to: event.to,
                tokenID: event.tokenID,
                tokenInfo: event.tokenName.isEmpty && event.tokenSymbol.isEmpty
                    ? nil
                    : TokenInfo(
                        tokenName: event.tokenName,
                        tokenSymbol: event.tokenSymbol,
                        tokenDecimal: event.tokenDecimal
                    )
            )

            map[event.hash] = (map[event.hash] ?? []) + [eventInstance]
        }

        return map
    }

    public func contractEventInstances(logs: [TransactionLog]) -> [ContractEventInstance] {
        logs.compactMap { log -> ContractEventInstance? in
            guard let eventInstance = log.eip721EventInstance else {
                return nil
            }

            switch eventInstance {
            case let transfer as EIP721TransferEventInstance:
                if transfer.from == userAddress || transfer.to == userAddress {
                    return eventInstance
                }

            default: ()
            }

            return nil
        }
    }
}
