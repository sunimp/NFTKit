//
//  Eip1155SetApprovalForAllMethod.swift
//  NftKit
//
//  Created by Sun on 2024/8/21.
//

import Foundation

import BigInt
import EvmKit

class Eip1155SetApprovalForAllMethod: ContractMethod {
    static let methodSignature = "setApprovalForAll(address,bool)"

    let `operator`: Address
    let approved: Bool

    init(operator: Address, approved: Bool) {
        self.operator = `operator`
        self.approved = approved

        super.init()
    }

    override var methodSignature: String { Self.methodSignature }
    override var arguments: [Any] { [`operator`, approved] }
}
