//
//  Storage.swift
//
//  Created by Sun on 2024/8/15.
//

import Foundation

import BigInt
import EVMKit
import GRDB

// MARK: - Storage

class Storage {
    // MARK: Properties

    private let dbPool: DatabasePool

    // MARK: Computed Properties

    var migrator: DatabaseMigrator {
        var migrator = DatabaseMigrator()

        migrator.registerMigration("create NFTBalance") { db in
            try db.create(table: NFTBalance.databaseTableName) { t in
                t.column(NFTBalance.Columns.type.name, .text).notNull()
                t.column(NFTBalance.Columns.contractAddress.name, .text).notNull()
                t.column(NFTBalance.Columns.tokenID.name, .text).notNull()
                t.column(NFTBalance.Columns.tokenName.name, .text).notNull()
                t.column(NFTBalance.Columns.balance.name, .integer).notNull()
                t.column(NFTBalance.Columns.synced.name, .boolean).notNull()

                t.primaryKey(
                    [NFTBalance.Columns.contractAddress.name, NFTBalance.Columns.tokenID.name],
                    onConflict: .replace
                )
            }
        }

        migrator.registerMigration("create EIP721Event") { db in
            try db.create(table: EIP721Event.databaseTableName) { t in
                t.column(EIP721Event.Columns.hash.name, .text).notNull()
                t.column(EIP721Event.Columns.blockNumber.name, .integer).notNull()
                t.column(EIP721Event.Columns.contractAddress.name, .text).notNull()
                t.column(EIP721Event.Columns.from.name, .text).notNull()
                t.column(EIP721Event.Columns.to.name, .text).notNull()
                t.column(EIP721Event.Columns.tokenID.name, .text).notNull()
                t.column(EIP721Event.Columns.tokenName.name, .text).notNull()
                t.column(EIP721Event.Columns.tokenSymbol.name, .text).notNull()
                t.column(EIP721Event.Columns.tokenDecimal.name, .text).notNull()
            }
        }

        migrator.registerMigration("create EIP1155Event") { db in
            try db.create(table: EIP1155Event.databaseTableName) { t in
                t.column(EIP1155Event.Columns.hash.name, .text).notNull()
                t.column(EIP1155Event.Columns.blockNumber.name, .integer).notNull()
                t.column(EIP1155Event.Columns.contractAddress.name, .text).notNull()
                t.column(EIP1155Event.Columns.from.name, .text).notNull()
                t.column(EIP1155Event.Columns.to.name, .text).notNull()
                t.column(EIP1155Event.Columns.tokenID.name, .text).notNull()
                t.column(EIP1155Event.Columns.tokenValue.name, .integer).notNull()
                t.column(EIP1155Event.Columns.tokenName.name, .text).notNull()
                t.column(EIP1155Event.Columns.tokenSymbol.name, .text).notNull()
            }
        }

        migrator.registerMigration("truncate EIP721Event, EIP1155Event") { db in
            try EIP721Event.deleteAll(db)
            try EIP1155Event.deleteAll(db)
        }

        return migrator
    }

    // MARK: Lifecycle

    init(databaseDirectoryURL: URL, databaseFileName: String) {
        let databaseURL = databaseDirectoryURL.appendingPathComponent("\(databaseFileName).sqlite")

        dbPool = try! DatabasePool(path: databaseURL.path)

        try? migrator.migrate(dbPool)
    }

    // MARK: Functions

    private func filter(nft: NFT) -> SQLSpecificExpressible {
        let conditions: [SQLSpecificExpressible] = [
            NFTBalance.Columns.contractAddress == nft.contractAddress.raw,
            NFTBalance.Columns.tokenID == nft.tokenID,
        ]

        return conditions.joined(operator: .and)
    }
}

extension Storage {
    func nftBalances(type: NFTType) throws -> [NFTBalance] {
        try dbPool.read { db in
            try NFTBalance.filter(NFTBalance.Columns.type == type).fetchAll(db)
        }
    }

    func existingNFTBalances() throws -> [NFTBalance] {
        try dbPool.read { db in
            try NFTBalance.filter(NFTBalance.Columns.balance > 0).fetchAll(db)
        }
    }

    func nonSyncedNFTBalances() throws -> [NFTBalance] {
        try dbPool.read { db in
            try NFTBalance.filter(NFTBalance.Columns.synced == false).fetchAll(db)
        }
    }

    func existingNFTBalance(contractAddress: Address, tokenID: BigUInt) throws -> NFTBalance? {
        try dbPool.read { db in
            try NFTBalance
                .filter(
                    NFTBalance.Columns.contractAddress == contractAddress.raw && NFTBalance.Columns
                        .tokenID == tokenID && NFTBalance.Columns.balance > 0
                ).fetchOne(db)
        }
    }

    func setNotSynced(nfts: [NFT]) throws {
        _ = try dbPool.write { db in
            try NFTBalance
                .filter(nfts.map { filter(nft: $0) }.joined(operator: .or))
                .updateAll(db, NFTBalance.Columns.synced.set(to: false))
        }
    }

    func setSynced(balanceInfos: [(NFT, Int)]) throws {
        try dbPool.write { db in
            for balanceInfo in balanceInfos {
                let (nft, balance) = balanceInfo

                try NFTBalance
                    .filter(filter(nft: nft))
                    .updateAll(
                        db,
                        NFTBalance.Columns.synced.set(to: true),
                        NFTBalance.Columns.balance.set(to: balance)
                    )
            }
        }
    }

    func save(nftBalances: [NFTBalance]) throws {
        try dbPool.write { db in
            for nftBalance in nftBalances {
                try nftBalance.save(db)
            }
        }
    }

    func lastEIP721Event() throws -> EIP721Event? {
        try dbPool.read { db in
            try EIP721Event.order(EIP721Event.Columns.blockNumber.desc).fetchOne(db)
        }
    }

    func eip721Events() throws -> [EIP721Event] {
        try dbPool.read { db in
            try EIP721Event.fetchAll(db)
        }
    }

    func eip721Events(hashes: [Data]) throws -> [EIP721Event] {
        try dbPool.read { db in
            try EIP721Event
                .filter(hashes.contains(EIP721Event.Columns.hash))
                .fetchAll(db)
        }
    }

    func save(eip721Events: [EIP721Event]) throws {
        try dbPool.write { db in
            for event in eip721Events {
                try event.save(db)
            }
        }
    }

    func lastEIP1155Event() throws -> EIP1155Event? {
        try dbPool.read { db in
            try EIP1155Event.order(EIP1155Event.Columns.blockNumber.desc).fetchOne(db)
        }
    }

    func eip1155Events() throws -> [EIP1155Event] {
        try dbPool.read { db in
            try EIP1155Event.fetchAll(db)
        }
    }

    func eip1155Events(hashes: [Data]) throws -> [EIP1155Event] {
        try dbPool.read { db in
            try EIP1155Event
                .filter(hashes.contains(EIP1155Event.Columns.hash))
                .fetchAll(db)
        }
    }

    func save(eip1155Events: [EIP1155Event]) throws {
        try dbPool.write { db in
            for event in eip1155Events {
                try event.save(db)
            }
        }
    }
}
