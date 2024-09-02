//
//  EIP721ContractMethodFactories.swift
//
//  Created by Sun on 2024/8/15.
//

import Foundation

import EVMKit

class EIP721ContractMethodFactories: ContractMethodFactories {
    // MARK: Static Properties

    static let shared = EIP721ContractMethodFactories()

    // MARK: Lifecycle

    override init() {
        super.init()
        register(factories: [EIP721SafeTransferFromMethodFactory()])
    }
}
