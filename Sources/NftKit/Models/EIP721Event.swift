//
//  EIP721Event.swift
//  NFTKit
//
//  Created by Sun on 2024/8/15.
//

import Foundation

import BigInt
import EVMKit
import GRDB

class EIP721Event: Record {
    // MARK: Nested Types

    enum Columns: String, ColumnExpression {
        case hash
        case blockNumber
        case contractAddress
        case from
        case to
        case tokenID
        case tokenName
        case tokenSymbol
        case tokenDecimal
    }

    // MARK: Overridden Properties

    override class var databaseTableName: String {
        "eip721Events"
    }

    // MARK: Properties

    let hash: Data
    let blockNumber: Int
    let contractAddress: Address
    let from: Address
    let to: Address
    let tokenID: BigUInt
    let tokenName: String
    let tokenSymbol: String
    let tokenDecimal: Int

    // MARK: Lifecycle

    init(
        hash: Data,
        blockNumber: Int,
        contractAddress: Address,
        from: Address,
        to: Address,
        tokenID: BigUInt,
        tokenName: String,
        tokenSymbol: String,
        tokenDecimal: Int
    ) {
        self.hash = hash
        self.blockNumber = blockNumber
        self.contractAddress = contractAddress
        self.from = from
        self.to = to
        self.tokenID = tokenID
        self.tokenName = tokenName
        self.tokenSymbol = tokenSymbol
        self.tokenDecimal = tokenDecimal

        super.init()
    }

    required init(row: Row) throws {
        hash = row[Columns.hash]
        blockNumber = row[Columns.blockNumber]
        contractAddress = Address(raw: row[Columns.contractAddress])
        from = Address(raw: row[Columns.from])
        to = Address(raw: row[Columns.to])
        tokenID = row[Columns.tokenID]
        tokenName = row[Columns.tokenName]
        tokenSymbol = row[Columns.tokenSymbol]
        tokenDecimal = row[Columns.tokenDecimal]

        try super.init(row: row)
    }

    // MARK: Overridden Functions

    override func encode(to container: inout PersistenceContainer) throws {
        container[Columns.hash] = hash
        container[Columns.blockNumber] = blockNumber
        container[Columns.contractAddress] = contractAddress.raw
        container[Columns.from] = from.raw
        container[Columns.to] = to.raw
        container[Columns.tokenID] = tokenID
        container[Columns.tokenName] = tokenName
        container[Columns.tokenSymbol] = tokenSymbol
        container[Columns.tokenDecimal] = tokenDecimal
    }
}
