//
//  EIP1155SafeTransferFromMethodFactory.swift
//
//  Created by Sun on 2024/8/15.
//

import Foundation

import BigInt
import EVMKit

class EIP1155SafeTransferFromMethodFactory: IContractMethodFactory {
    // MARK: Properties

    let methodID: Data = ContractMethodHelper.methodID(signature: EIP1155SafeTransferFromMethod.methodSignature)

    // MARK: Functions

    func createMethod(inputArguments: Data) throws -> ContractMethod {
        EIP1155SafeTransferFromMethod(
            from: Address(raw: inputArguments[12 ..< 32]),
            to: Address(raw: inputArguments[44 ..< 64]),
            tokenID: BigUInt(inputArguments[64 ..< 96]),
            value: BigUInt(inputArguments[96 ..< 128]),
            data: inputArguments[128 ..< 160]
        )
    }
}
