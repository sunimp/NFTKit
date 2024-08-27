//
//  Eip1155SetApprovalForAllMethodFactory.swift
//  NftKit
//
//  Created by Sun on 2024/8/21.
//

import Foundation

import BigInt
import EvmKit

class Eip1155SetApprovalForAllMethodFactory: IContractMethodFactory {
    let methodID: Data = ContractMethodHelper.methodID(signature: Eip1155SetApprovalForAllMethod.methodSignature)

    func createMethod(inputArguments: Data) throws -> ContractMethod {
        Eip1155SetApprovalForAllMethod(
            operator: Address(raw: inputArguments[12 ..< 32]),
            approved: BigUInt(inputArguments[32 ..< 64]) != 0
        )
    }
}
