//
//  EIP1155ContractMethodFactories.swift
//  NFTKit
//
//  Created by Sun on 2024/8/15.
//

import Foundation

import EVMKit

class EIP1155ContractMethodFactories: ContractMethodFactories {
    // MARK: Static Properties

    static let shared = EIP1155ContractMethodFactories()

    // MARK: Lifecycle

    override init() {
        super.init()
        register(factories: [EIP1155SafeTransferFromMethodFactory()])
    }
}
