//
//  Eip1155BalanceOfMethod.swift
//  NftKit
//
//  Created by Sun on 2024/8/21.
//

import Foundation

import BigInt
import EvmKit

class Eip1155BalanceOfMethod: ContractMethod {
    private let owner: Address
    private let tokenId: BigUInt

    init(owner: Address, tokenId: BigUInt) {
        self.owner = owner
        self.tokenId = tokenId
    }

    override var methodSignature: String { "balanceOf(address,uint256)" }
    override var arguments: [Any] { [owner, tokenId] }
}
