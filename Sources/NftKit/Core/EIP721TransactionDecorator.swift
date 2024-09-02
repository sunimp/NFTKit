//
//  EIP721TransactionDecorator.swift
//
//  Created by Sun on 2024/8/15.
//

import Foundation

import BigInt
import EVMKit

// MARK: - EIP721TransactionDecorator

class EIP721TransactionDecorator {
    // MARK: Properties

    private let userAddress: Address

    // MARK: Lifecycle

    init(userAddress: Address) {
        self.userAddress = userAddress
    }
}

// MARK: ITransactionDecorator

extension EIP721TransactionDecorator: ITransactionDecorator {
    public func decoration(
        from: Address?,
        to: Address?,
        value _: BigUInt?,
        contractMethod: ContractMethod?,
        internalTransactions _: [InternalTransaction],
        eventInstances: [ContractEventInstance]
    )
        -> TransactionDecoration? {
        guard let from, let to, let contractMethod else {
            return nil
        }

        if let transferMethod = contractMethod as? EIP721SafeTransferFromMethod {
            if from == userAddress {
                return EIP721SafeTransferFromDecoration(
                    contractAddress: to,
                    to: transferMethod.to,
                    tokenID: transferMethod.tokenID,
                    sentToSelf: transferMethod.to == userAddress,
                    tokenInfo: eventInstances.compactMap { $0 as? EIP721TransferEventInstance }
                        .first { $0.contractAddress == to }?.tokenInfo
                )
            }
        }

        if let method = contractMethod as? EIP721SetApprovalForAllMethod {
            if from == userAddress {
                return EIP721SetApprovalForAllDecoration(
                    contractAddress: to,
                    operator: method.operator,
                    approved: method.approved
                )
            }
        }

        return nil
    }
}
