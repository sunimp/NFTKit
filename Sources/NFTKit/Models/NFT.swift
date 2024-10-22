//
//  NFT.swift
//  NFTKit
//
//  Created by Sun on 2022/8/25.
//

import Foundation

import BigInt
import EVMKit

// MARK: - NFT

public struct NFT {
    // MARK: Properties

    public let type: NFTType
    public let contractAddress: Address
    public let tokenID: BigUInt
    public let tokenName: String

    // MARK: Lifecycle

    init(type: NFTType, contractAddress: Address, tokenID: BigUInt, tokenName: String) {
        self.type = type
        self.contractAddress = contractAddress
        self.tokenID = tokenID
        self.tokenName = tokenName
    }
}

// MARK: Hashable

extension NFT: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(type)
        hasher.combine(contractAddress.raw)
        hasher.combine(tokenID)
    }
}

// MARK: Equatable

extension NFT: Equatable {
    public static func == (lhs: NFT, rhs: NFT) -> Bool {
        lhs.type == rhs.type && lhs.contractAddress == rhs.contractAddress && lhs.tokenID == rhs.tokenID
    }
}
