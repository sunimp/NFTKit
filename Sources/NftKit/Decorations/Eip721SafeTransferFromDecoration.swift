//
//  Eip721SafeTransferFromDecoration.swift
//  NftKit
//
//  Created by Sun on 2024/8/21.
//

import Foundation

import BigInt
import EvmKit

public class Eip721SafeTransferFromDecoration: TransactionDecoration {
    public let contractAddress: Address
    public let to: Address
    public let tokenID: BigUInt
    public let sentToSelf: Bool
    public let tokenInfo: TokenInfo?

    init(contractAddress: Address, to: Address, tokenID: BigUInt, sentToSelf: Bool, tokenInfo: TokenInfo?) {
        self.contractAddress = contractAddress
        self.to = to
        self.tokenID = tokenID
        self.sentToSelf = sentToSelf
        self.tokenInfo = tokenInfo

        super.init()
    }

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
