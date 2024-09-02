//
//  NFTBalance.swift
//
//  Created by Sun on 2024/8/15.
//

import Foundation

import BigInt
import EVMKit
import GRDB

public class NFTBalance: Record {
    // MARK: Nested Types

    enum Columns: String, ColumnExpression {
        case type
        case contractAddress
        case tokenID
        case tokenName
        case balance
        case synced
    }

    // MARK: Overridden Properties

    override public class var databaseTableName: String {
        "nftBalances"
    }

    // MARK: Properties

    public let nft: NFT
    public var balance: Int

    var synced: Bool

    // MARK: Lifecycle

    public required init(row: Row) throws {
        nft = NFT(
            type: row[Columns.type],
            contractAddress: Address(raw: row[Columns.contractAddress]),
            tokenID: row[Columns.tokenID],
            tokenName: row[Columns.tokenName]
        )
        balance = row[Columns.balance]
        synced = row[Columns.synced]

        try super.init(row: row)
    }

    init(nft: NFT, balance: Int, synced: Bool) {
        self.nft = nft
        self.balance = balance
        self.synced = synced

        super.init()
    }

    // MARK: Overridden Functions

    override public func encode(to container: inout PersistenceContainer) throws {
        container[Columns.type] = nft.type
        container[Columns.contractAddress] = nft.contractAddress.raw
        container[Columns.tokenID] = nft.tokenID
        container[Columns.tokenName] = nft.tokenName
        container[Columns.balance] = balance
        container[Columns.synced] = synced
    }
}
