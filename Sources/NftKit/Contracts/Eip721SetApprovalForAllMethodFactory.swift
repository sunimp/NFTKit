//
//  Eip721SetApprovalForAllMethodFactory.swift
//  NftKit
//
//  Created by Sun on 2024/8/21.
//

import Foundation

import BigInt
import EvmKit

class Eip721SetApprovalForAllMethodFactory: IContractMethodFactory {
    let methodId: Data = ContractMethodHelper.methodId(signature: Eip721SetApprovalForAllMethod.methodSignature)

    func createMethod(inputArguments: Data) throws -> ContractMethod {
        Eip721SetApprovalForAllMethod(
            operator: Address(raw: inputArguments[12 ..< 32]),
            approved: BigUInt(inputArguments[32 ..< 64]) != 0
        )
    }
}
