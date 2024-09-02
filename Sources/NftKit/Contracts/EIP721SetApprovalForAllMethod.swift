//
//  EIP721SetApprovalForAllMethod.swift
//
//  Created by Sun on 2024/8/15.
//

import Foundation

import BigInt
import EVMKit

class EIP721SetApprovalForAllMethod: ContractMethod {
    // MARK: Static Properties

    static let methodSignature = "setApprovalForAll(address,bool)"

    // MARK: Overridden Properties

    override var methodSignature: String { Self.methodSignature }
    override var arguments: [Any] { [`operator`, approved] }

    // MARK: Properties

    let `operator`: Address
    let approved: Bool

    // MARK: Lifecycle

    init(operator: Address, approved: Bool) {
        self.operator = `operator`
        self.approved = approved

        super.init()
    }
}
