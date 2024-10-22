//
//  EIP1155SetApprovalForAllMethodFactory.swift
//  NFTKit
//
//  Created by Sun on 2024/8/15.
//

import Foundation

import BigInt
import EVMKit

class EIP1155SetApprovalForAllMethodFactory: IContractMethodFactory {
    // MARK: Properties

    let methodID: Data = ContractMethodHelper.methodID(signature: EIP1155SetApprovalForAllMethod.methodSignature)

    // MARK: Functions

    func createMethod(inputArguments: Data) throws -> ContractMethod {
        EIP1155SetApprovalForAllMethod(
            operator: Address(raw: inputArguments[12 ..< 32]),
            approved: BigUInt(inputArguments[32 ..< 64]) != 0
        )
    }
}
