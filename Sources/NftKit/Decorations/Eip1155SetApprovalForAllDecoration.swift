//
//  Eip1155SetApprovalForAllDecoration.swift
//  NftKit
//
//  Created by Sun on 2024/8/21.
//

import Foundation

import BigInt
import EvmKit

public class Eip1155SetApprovalForAllDecoration: TransactionDecoration {
    public let contractAddress: Address
    public let `operator`: Address
    public let approved: Bool

    init(contractAddress: Address, operator: Address, approved: Bool) {
        self.contractAddress = contractAddress
        self.operator = `operator`
        self.approved = approved

        super.init()
    }

    override public func tags() -> [TransactionTag] {
        [
            TransactionTag(type: .approve, protocol: .eip1155, contractAddress: contractAddress),
        ]
    }
}
