//
//  EIP1155SafeTransferFromMethod.swift
//  NFTKit
//
//  Created by Sun on 2024/8/15.
//

import Foundation

import BigInt
import EVMKit

class EIP1155SafeTransferFromMethod: ContractMethod {
    // MARK: Static Properties

    static let methodSignature = "safeTransferFrom(address,address,uint256,uint256,bytes)"

    // MARK: Overridden Properties

    override var methodSignature: String { Self.methodSignature }
    override var arguments: [Any] { [from, to, tokenID, value, data] }

    // MARK: Properties

    let from: Address
    let to: Address
    let tokenID: BigUInt
    let value: BigUInt
    let data: Data

    // MARK: Lifecycle

    init(from: Address, to: Address, tokenID: BigUInt, value: BigUInt, data: Data) {
        self.from = from
        self.to = to
        self.tokenID = tokenID
        self.value = value
        self.data = data

        super.init()
    }
}
