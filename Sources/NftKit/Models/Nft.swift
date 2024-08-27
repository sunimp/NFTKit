//
//  Nft.swift
//  NftKit
//
//  Created by Sun on 2024/8/21.
//

import Foundation

import BigInt
import EvmKit

// MARK: - Nft

public struct Nft {
    public let type: NftType
    public let contractAddress: Address
    public let tokenID: BigUInt
    public let tokenName: String

    init(type: NftType, contractAddress: Address, tokenID: BigUInt, tokenName: String) {
        self.type = type
        self.contractAddress = contractAddress
        self.tokenID = tokenID
        self.tokenName = tokenName
    }
}

// MARK: Hashable

extension Nft: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(type)
        hasher.combine(contractAddress.raw)
        hasher.combine(tokenID)
    }
}

// MARK: Equatable

extension Nft: Equatable {
    public static func == (lhs: Nft, rhs: Nft) -> Bool {
        lhs.type == rhs.type && lhs.contractAddress == rhs.contractAddress && lhs.tokenID == rhs.tokenID
    }
}
