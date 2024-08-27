//
//  TransactionManager.swift
//  NftKit
//
//  Created by Sun on 2024/8/21.
//

import Foundation

import BigInt
import EvmKit

// MARK: - TransactionManager

class TransactionManager {
    private let address: Address

    init(evmKit: EvmKit.Kit) {
        address = evmKit.receiveAddress
    }
}

extension TransactionManager {
    func transferEip721TransactionData(contractAddress: Address, to: Address, tokenID: BigUInt) -> TransactionData {
        TransactionData(
            to: contractAddress,
            value: BigUInt.zero,
            input: Eip721SafeTransferFromMethod(from: address, to: to, tokenID: tokenID, data: Data()).encodedABI()
        )
    }

    func transferEip1155TransactionData(
        contractAddress: Address,
        to: Address,
        tokenID: BigUInt,
        value: BigUInt
    ) -> TransactionData {
        TransactionData(
            to: contractAddress,
            value: BigUInt.zero,
            input: Eip1155SafeTransferFromMethod(from: address, to: to, tokenID: tokenID, value: value, data: Data()).encodedABI()
        )
    }
}
