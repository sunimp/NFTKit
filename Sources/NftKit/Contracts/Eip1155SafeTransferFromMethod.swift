//
//  Eip1155SafeTransferFromMethod.swift
//  NftKit
//
//  Created by Sun on 2024/8/21.
//

import Foundation

import BigInt
import EvmKit

class Eip1155SafeTransferFromMethod: ContractMethod {
    static let methodSignature = "safeTransferFrom(address,address,uint256,uint256,bytes)"

    let from: Address
    let to: Address
    let tokenID: BigUInt
    let value: BigUInt
    let data: Data

    init(from: Address, to: Address, tokenID: BigUInt, value: BigUInt, data: Data) {
        self.from = from
        self.to = to
        self.tokenID = tokenID
        self.value = value
        self.data = data

        super.init()
    }

    override var methodSignature: String { Self.methodSignature }
    override var arguments: [Any] { [from, to, tokenID, value, data] }
}
