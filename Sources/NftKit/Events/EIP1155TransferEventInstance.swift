//
//  EIP1155TransferEventInstance.swift
//  NFTKit
//
//  Created by Sun on 2024/8/15.
//

import Foundation

import BigInt
import EVMKit

public class EIP1155TransferEventInstance: ContractEventInstance {
    // MARK: Static Properties

    static let transferSingleSignature = ContractEvent(
        name: "TransferSingle",
        arguments: [.address, .address, .address, .uint256, .uint256]
    ).signature
    static let transferBatchSignature = ContractEvent(
        name: "TransferBatch",
        arguments: [.address, .address, .address, .uint256Array, .uint256Array]
    ).signature

    // MARK: Properties

    public let from: Address
    public let to: Address
    public let tokenID: BigUInt
    public let value: BigUInt

    public let tokenInfo: TokenInfo?

    // MARK: Lifecycle

    init(
        contractAddress: Address,
        from: Address,
        to: Address,
        tokenID: BigUInt,
        value: BigUInt,
        tokenInfo: TokenInfo? = nil
    ) {
        self.from = from
        self.to = to
        self.tokenID = tokenID
        self.value = value
        self.tokenInfo = tokenInfo

        super.init(contractAddress: contractAddress)
    }

    // MARK: Overridden Functions

    override public func tags(userAddress: Address) -> [TransactionTag] {
        var tags = [TransactionTag]()

        if from == userAddress {
            tags.append(TransactionTag(type: .outgoing, protocol: .eip1155, contractAddress: contractAddress))
        }

        if to == userAddress {
            tags.append(TransactionTag(type: .incoming, protocol: .eip1155, contractAddress: contractAddress))
        }

        return tags
    }
}
