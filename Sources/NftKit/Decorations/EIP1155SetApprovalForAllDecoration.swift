//
//  EIP1155SetApprovalForAllDecoration.swift
//
//  Created by Sun on 2024/8/15.
//

import Foundation

import BigInt
import EVMKit

public class EIP1155SetApprovalForAllDecoration: TransactionDecoration {
    // MARK: Properties

    public let contractAddress: Address
    public let `operator`: Address
    public let approved: Bool

    // MARK: Lifecycle

    init(contractAddress: Address, operator: Address, approved: Bool) {
        self.contractAddress = contractAddress
        self.operator = `operator`
        self.approved = approved

        super.init()
    }

    // MARK: Overridden Functions

    override public func tags() -> [TransactionTag] {
        [
            TransactionTag(type: .approve, protocol: .eip1155, contractAddress: contractAddress),
        ]
    }
}
