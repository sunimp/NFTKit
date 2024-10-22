//
//  NFTType.swift
//  NFTKit
//
//  Created by Sun on 2024/8/15.
//

import Foundation

import GRDB

// MARK: - NFTType

public enum NFTType: String {
    case eip721
    case eip1155
}

// MARK: DatabaseValueConvertible

extension NFTType: DatabaseValueConvertible {
    public var databaseValue: DatabaseValue {
        rawValue.databaseValue
    }

    public static func fromDatabaseValue(_ dbValue: DatabaseValue) -> NFTType? {
        guard let rawValue = String.fromDatabaseValue(dbValue) else {
            return nil
        }

        return NFTType(rawValue: rawValue)
    }
}
