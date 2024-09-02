//
//  EIP721SafeTransferFromMethodFactory.swift
//
//  Created by Sun on 2024/8/15.
//

import Foundation

import BigInt
import EVMKit

class EIP721SafeTransferFromMethodFactory: IContractMethodFactory {
    // MARK: Properties

    let methodID: Data = ContractMethodHelper.methodID(signature: EIP721SafeTransferFromMethod.methodSignature)

    // MARK: Functions

    func createMethod(inputArguments: Data) throws -> ContractMethod {
        EIP721SafeTransferFromMethod(
            from: Address(raw: inputArguments[12 ..< 32]),
            to: Address(raw: inputArguments[44 ..< 64]),
            tokenID: BigUInt(inputArguments[64 ..< 96]),
            data: inputArguments[96 ..< 128]
        )
    }
}
