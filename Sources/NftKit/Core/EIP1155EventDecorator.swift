//
//  EIP1155EventDecorator.swift
//  NFTKit
//
//  Created by Sun on 2024/8/15.
//

import Foundation

import BigInt
import EVMKit

// MARK: - EIP1155EventDecorator

class EIP1155EventDecorator {
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

extension EIP1155EventDecorator: IEventDecorator {
    public func contractEventInstancesMap(transactions: [Transaction]) -> [Data: [ContractEventInstance]] {
        let events: [EIP1155Event]

        do {
            if transactions.count > 100 {
                events = try storage.eip1155Events()
            } else {
                let hashes = transactions.map(\.hash)
                events = try storage.eip1155Events(hashes: hashes)
            }
        } catch {
            events = []
        }

        var map = [Data: [ContractEventInstance]]()

        for event in events {
            let eventInstance = EIP1155TransferEventInstance(
                contractAddress: event.contractAddress,
                from: event.from,
                to: event.to,
                tokenID: event.tokenID,
                value: BigUInt(event.tokenValue),
                tokenInfo: event.tokenName.isEmpty && event.tokenSymbol.isEmpty
                    ? nil
                    : TokenInfo(
                        tokenName: event.tokenName,
                        tokenSymbol: event.tokenSymbol,
                        tokenDecimal: 1
                    )
            )

            map[event.hash] = (map[event.hash] ?? []) + [eventInstance]
        }

        return map
    }

    public func contractEventInstances(logs: [TransactionLog]) -> [ContractEventInstance] {
        logs.compactMap { log -> ContractEventInstance? in
            guard let eventInstance = log.eip1155EventInstance else {
                return nil
            }

            switch eventInstance {
            case let transfer as EIP1155TransferEventInstance:
                if transfer.from == userAddress || transfer.to == userAddress {
                    return eventInstance
                }

            default: ()
            }

            return nil
        }
    }
}
