//
//  Eip1155SafeTransferFromMethodFactory.swift
//  NftKit
//
//  Created by Sun on 2024/8/21.
//

import Foundation

import BigInt
import EvmKit

class Eip1155SafeTransferFromMethodFactory: IContractMethodFactory {
    let methodID: Data = ContractMethodHelper.methodID(signature: Eip1155SafeTransferFromMethod.methodSignature)

    func createMethod(inputArguments: Data) throws -> ContractMethod {
        Eip1155SafeTransferFromMethod(
            from: Address(raw: inputArguments[12 ..< 32]),
            to: Address(raw: inputArguments[44 ..< 64]),
            tokenID: BigUInt(inputArguments[64 ..< 96]),
            value: BigUInt(inputArguments[96 ..< 128]),
            data: inputArguments[128 ..< 160]
        )
    }
}
