//
//  Eip721ContractMethodFactories.swift
//  NftKit
//
//  Created by Sun on 2024/8/21.
//

import Foundation

import EvmKit

class Eip721ContractMethodFactories: ContractMethodFactories {
    static let shared = Eip721ContractMethodFactories()

    override init() {
        super.init()
        register(factories: [Eip721SafeTransferFromMethodFactory()])
    }
}
