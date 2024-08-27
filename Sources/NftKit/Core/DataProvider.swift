//
//  DataProvider.swift
//  NftKit
//
//  Created by Sun on 2024/8/21.
//

import Foundation

import BigInt
import EvmKit
import WWExtensions

// MARK: - DataProvider

class DataProvider {
    private let evmKit: EvmKit.Kit

    init(evmKit: EvmKit.Kit) {
        self.evmKit = evmKit
    }
}

extension DataProvider {
    func getEip721Owner(contractAddress: Address, tokenID: BigUInt) async throws -> Address {
        let data = try await evmKit.fetchCall(
            contractAddress: contractAddress,
            data: Eip721OwnerOfMethod(tokenID: tokenID).encodedABI()
        )
        return Address(raw: data)
    }

    func getEip1155Balance(contractAddress: Address, owner: Address, tokenID: BigUInt) async throws -> Int {
        let data = try await evmKit.fetchCall(
            contractAddress: contractAddress,
            data: Eip1155BalanceOfMethod(owner: owner, tokenID: tokenID).encodedABI()
        )

        guard let value = BigUInt(data.prefix(32).ww.hex, radix: 16) else {
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
