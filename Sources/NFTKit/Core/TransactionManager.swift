//
//  TransactionManager.swift
//
//  Created by Sun on 2024/8/15.
//

import Foundation

import BigInt
import EVMKit

// MARK: - TransactionManager

class TransactionManager {
    // MARK: Properties

    private let address: Address

    // MARK: Lifecycle

    init(evmKit: EVMKit.Kit) {
        address = evmKit.receiveAddress
    }
}

extension TransactionManager {
    func transferEIP721TransactionData(contractAddress: Address, to: Address, tokenID: BigUInt) -> TransactionData {
        TransactionData(
            to: contractAddress,
            value: BigUInt.zero,
            input: EIP721SafeTransferFromMethod(from: address, to: to, tokenID: tokenID, data: Data()).encodedABI()
        )
    }

    func transferEIP1155TransactionData(
        contractAddress: Address,
        to: Address,
        tokenID: BigUInt,
        value: BigUInt
    )
        -> TransactionData {
        TransactionData(
            to: contractAddress,
            value: BigUInt.zero,
            input: EIP1155SafeTransferFromMethod(from: address, to: to, tokenID: tokenID, value: value, data: Data())
                .encodedABI()
        )
    }
}
