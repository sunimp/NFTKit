//
//  Eip721OwnerOfMethod.swift
//  NftKit
//
//  Created by Sun on 2024/8/21.
//

import Foundation

import BigInt
import EvmKit

class Eip721OwnerOfMethod: ContractMethod {
    private let tokenID: BigUInt

    init(tokenID: BigUInt) {
        self.tokenID = tokenID
    }

    override var methodSignature: String { "ownerOf(uint256)" }
    override var arguments: [Any] { [tokenID] }
}
