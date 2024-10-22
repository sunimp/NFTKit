//
//  DataProvider.swift
//  NFTKit
//
//  Created by Sun on 2022/8/25.
//

import Foundation

import BigInt
import EVMKit
import SWExtensions

// MARK: - DataProvider

class DataProvider {
    // MARK: Properties

    private let evmKit: EVMKit.Kit

    // MARK: Lifecycle

    init(evmKit: EVMKit.Kit) {
        self.evmKit = evmKit
    }
}

extension DataProvider {
    func getEIP721Owner(contractAddress: Address, tokenID: BigUInt) async throws -> Address {
        let data = try await evmKit.fetchCall(
            contractAddress: contractAddress,
            data: EIP721OwnerOfMethod(tokenID: tokenID).encodedABI()
        )
        return Address(raw: data)
    }

    func getEIP1155Balance(contractAddress: Address, owner: Address, tokenID: BigUInt) async throws -> Int {
        let data = try await evmKit.fetchCall(
            contractAddress: contractAddress,
            data: EIP1155BalanceOfMethod(owner: owner, tokenID: tokenID).encodedABI()
        )

        guard let value = BigUInt(data.prefix(32).sw.hex, radix: 16) else {
            throw ContractCallError.invalidBalanceData
        }

        return Int(value)
    }
}

// MARK: DataProvider.ContractCallError

extension DataProvider {
    enum ContractCallError: Error {
        case invalidBalanceData
    }
}
