//
//  Eip1155ContractMethodFactories.swift
//  NftKit
//
//  Created by Sun on 2024/8/21.
//

import Foundation

import EvmKit

class Eip1155ContractMethodFactories: ContractMethodFactories {
    static let shared = Eip1155ContractMethodFactories()

    override init() {
        super.init()
        register(factories: [Eip1155SafeTransferFromMethodFactory()])
    }
}
