//
//  EIP1155TransactionDecorator.swift
//  NFTKit
//
//  Created by Sun on 2024/8/15.
//

import Foundation

import BigInt
import EVMKit

// MARK: - EIP1155TransactionDecorator

class EIP1155TransactionDecorator {
    // MARK: Properties

    private let userAddress: Address

    // MARK: Lifecycle

    init(userAddress: Address) {
        self.userAddress = userAddress
    }
}

// MARK: ITransactionDecorator

extension EIP1155TransactionDecorator: ITransactionDecorator {
    public func decoration(
        from: Address?,
        to: Address?,
        value: BigUInt?,
        contractMethod: ContractMethod?,
        internalTransactions _: [InternalTransaction],
        eventInstances: [ContractEventInstance]
    )
        -> TransactionDecoration? {
        guard let from, let to else {
            return nil
        }

        if let transferMethod = contractMethod as? EIP1155SafeTransferFromMethod {
            if from == userAddress {
                return EIP1155SafeTransferFromDecoration(
                    contractAddress: to,
                    to: transferMethod.to,
                    tokenID: transferMethod.tokenID,
                    value: transferMethod.value,
                    sentToSelf: transferMethod.to == userAddress,
                    tokenInfo: eventInstances.compactMap { $0 as? EIP1155TransferEventInstance }
                        .first { $0.contractAddress == to }?.tokenInfo
                )
            }
        }

        if let method = contractMethod as? EIP1155SetApprovalForAllMethod {
            if from == userAddress {
                return EIP1155SetApprovalForAllDecoration(
                    contractAddress: to,
                    operator: method.operator,
                    approved: method.approved
                )
            }
        }

        return nil
    }
}
