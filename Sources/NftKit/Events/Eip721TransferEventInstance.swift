//
//  Eip721TransferEventInstance.swift
//  NftKit
//
//  Created by Sun on 2024/8/21.
//

import Foundation

import BigInt
import EvmKit

public class Eip721TransferEventInstance: ContractEventInstance {
    static let signature = ContractEvent(name: "Transfer", arguments: [.address, .address, .uint256]).signature

    public let from: Address
    public let to: Address
    public let tokenID: BigUInt

    public let tokenInfo: TokenInfo?

    init(contractAddress: Address, from: Address, to: Address, tokenID: BigUInt, tokenInfo: TokenInfo? = nil) {
        self.from = from
        self.to = to
        self.tokenID = tokenID
        self.tokenInfo = tokenInfo

        super.init(contractAddress: contractAddress)
    }

    override public func tags(userAddress: Address) -> [TransactionTag] {
        var tags = [TransactionTag]()

        if from == userAddress {
            tags.append(TransactionTag(type: .outgoing, protocol: .eip721, contractAddress: contractAddress))
        }

        if to == userAddress {
            tags.append(TransactionTag(type: .incoming, protocol: .eip721, contractAddress: contractAddress))
        }

        return tags
    }
}
