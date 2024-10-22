//
//  EIP1155MethodDecorator.swift
//  NFTKit
//
//  Created by Sun on 2024/8/15.
//

import Foundation

import EVMKit

// MARK: - EIP1155MethodDecorator

class EIP1155MethodDecorator {
    // MARK: Properties

    private let contractMethodFactories: ContractMethodFactories

    // MARK: Lifecycle

    init(contractMethodFactories: ContractMethodFactories) {
        self.contractMethodFactories = contractMethodFactories
    }
}

// MARK: IMethodDecorator

extension EIP1155MethodDecorator: IMethodDecorator {
    public func contractMethod(input: Data) -> ContractMethod? {
        contractMethodFactories.createMethod(input: input)
    }
}
