//
//  EIP721SafeTransferFromDecoration.swift
//
//  Created by Sun on 2024/8/15.
//

import Foundation

import BigInt
import EVMKit

public class EIP721SafeTransferFromDecoration: TransactionDecoration {
    // MARK: Properties

    public let contractAddress: Address
    public let to: Address
    public let tokenID: BigUInt
    public let sentToSelf: Bool
    public let tokenInfo: TokenInfo?

    // MARK: Lifecycle

    init(contractAddress: Address, to: Address, tokenID: BigUInt, sentToSelf: Bool, tokenInfo: TokenInfo?) {
        self.contractAddress = contractAddress
        self.to = to
        self.tokenID = tokenID
        self.sentToSelf = sentToSelf
        self.tokenInfo = tokenInfo

        super.init()
    }

    // MARK: Overridden Functions

    override public func tags() -> [TransactionTag] {
        var tags = [
            TransactionTag(type: .outgoing, protocol: .eip721, contractAddress: contractAddress),
        ]

        if sentToSelf {
            tags.append(TransactionTag(type: .incoming, protocol: .eip721, contractAddress: contractAddress))
        }

        return tags
    }
}
