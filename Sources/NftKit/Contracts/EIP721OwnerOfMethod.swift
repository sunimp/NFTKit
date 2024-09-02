//
//  EIP721OwnerOfMethod.swift
//
//  Created by Sun on 2024/8/15.
//

import Foundation

import BigInt
import EVMKit

class EIP721OwnerOfMethod: ContractMethod {
    // MARK: Overridden Properties

    override var methodSignature: String { "ownerOf(uint256)" }
    override var arguments: [Any] { [tokenID] }

    // MARK: Properties

    private let tokenID: BigUInt

    // MARK: Lifecycle

    init(tokenID: BigUInt) {
        self.tokenID = tokenID
    }
}
