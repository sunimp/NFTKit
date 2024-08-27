//
//  NftType.swift
//  NftKit
//
//  Created by Sun on 2024/8/21.
//

import Foundation

import GRDB

// MARK: - NftType

public enum NftType: String {
    case eip721
    case eip1155
}

// MARK: DatabaseValueConvertible

extension NftType: DatabaseValueConvertible {
    public var databaseValue: DatabaseValue {
        rawValue.databaseValue
    }

    public static func fromDatabaseValue(_ dbValue: DatabaseValue) -> NftType? {
        guard let rawValue = String.fromDatabaseValue(dbValue) else {
            return nil
        }

        return NftType(rawValue: rawValue)
    }
}
