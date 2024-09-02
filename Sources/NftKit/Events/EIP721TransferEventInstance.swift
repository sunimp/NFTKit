//
//  EIP721TransferEventInstance.swift
//
//  Created by Sun on 2024/8/15.
//

import Foundation

import BigInt
import EVMKit

public class EIP721TransferEventInstance: ContractEventInstance {
    // MARK: Static Properties

    static let signature = ContractEvent(name: "Transfer", arguments: [.address, .address, .uint256]).signature

    // MARK: Properties

    public let from: Address
    public let to: Address
    public let tokenID: BigUInt

    public let tokenInfo: TokenInfo?

    // MARK: Lifecycle

    init(contractAddress: Address, from: Address, to: Address, tokenID: BigUInt, tokenInfo: TokenInfo? = nil) {
        self.from = from
        self.to = to
        self.tokenID = tokenID
        self.tokenInfo = tokenInfo

        super.init(contractAddress: contractAddress)
    }

    // MARK: Overridden Functions

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
