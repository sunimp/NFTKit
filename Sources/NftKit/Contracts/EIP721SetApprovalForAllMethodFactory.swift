//
//  EIP721SetApprovalForAllMethodFactory.swift
//
//  Created by Sun on 2024/8/15.
//

import Foundation

import BigInt
import EVMKit

class EIP721SetApprovalForAllMethodFactory: IContractMethodFactory {
    // MARK: Properties

    let methodID: Data = ContractMethodHelper.methodID(signature: EIP721SetApprovalForAllMethod.methodSignature)

    // MARK: Functions

    func createMethod(inputArguments: Data) throws -> ContractMethod {
        EIP721SetApprovalForAllMethod(
            operator: Address(raw: inputArguments[12 ..< 32]),
            approved: BigUInt(inputArguments[32 ..< 64]) != 0
        )
    }
}
