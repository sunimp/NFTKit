//
//  Eip1155MethodDecorator.swift
//  NftKit
//
//  Created by Sun on 2024/8/21.
//

import Foundation

import EvmKit

class Eip1155MethodDecorator {
    private let contractMethodFactories: ContractMethodFactories

    init(contractMethodFactories: ContractMethodFactories) {
        self.contractMethodFactories = contractMethodFactories
    }
}

extension Eip1155MethodDecorator: IMethodDecorator {
    public func contractMethod(input: Data) -> ContractMethod? {
        contractMethodFactories.createMethod(input: input)
    }
}
