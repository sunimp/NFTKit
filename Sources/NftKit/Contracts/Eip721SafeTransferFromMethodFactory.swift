//
//  Eip721SafeTransferFromMethodFactory.swift
//  NftKit
//
//  Created by Sun on 2024/8/21.
//

import Foundation

import BigInt
import EvmKit

class Eip721SafeTransferFromMethodFactory: IContractMethodFactory {
    let methodID: Data = ContractMethodHelper.methodID(signature: Eip721SafeTransferFromMethod.methodSignature)

    func createMethod(inputArguments: Data) throws -> ContractMethod {
        Eip721SafeTransferFromMethod(
            from: Address(raw: inputArguments[12 ..< 32]),
            to: Address(raw: inputArguments[44 ..< 64]),
            tokenID: BigUInt(inputArguments[64 ..< 96]),
            data: inputArguments[96 ..< 128]
        )
    }
}
