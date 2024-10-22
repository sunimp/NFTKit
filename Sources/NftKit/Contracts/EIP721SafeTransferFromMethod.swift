//
//  EIP721SafeTransferFromMethod.swift
//  NFTKit
//
//  Created by Sun on 2024/8/15.
//

import Foundation

import BigInt
import EVMKit

class EIP721SafeTransferFromMethod: ContractMethod {
    // MARK: Static Properties

    static let methodSignature = "safeTransferFrom(address,address,uint256,bytes)"

    // MARK: Overridden Properties

    override var methodSignature: String { Self.methodSignature }
    override var arguments: [Any] { [from, to, tokenID, data] }

    // MARK: Properties

    let from: Address
    let to: Address
    let tokenID: BigUInt
    let data: Data

    // MARK: Lifecycle

    init(from: Address, to: Address, tokenID: BigUInt, data: Data) {
        self.from = from
        self.to = to
        self.tokenID = tokenID
        self.data = data

        super.init()
    }
}
