//
//  EIP1155BalanceOfMethod.swift
//
//  Created by Sun on 2024/8/15.
//

import Foundation

import BigInt
import EVMKit

class EIP1155BalanceOfMethod: ContractMethod {
    // MARK: Overridden Properties

    override var methodSignature: String { "balanceOf(address,uint256)" }
    override var arguments: [Any] { [owner, tokenID] }

    // MARK: Properties

    private let owner: Address
    private let tokenID: BigUInt

    // MARK: Lifecycle

    init(owner: Address, tokenID: BigUInt) {
        self.owner = owner
        self.tokenID = tokenID
    }
}
