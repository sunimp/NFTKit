//
//  EIP721MethodDecorator.swift
//
//  Created by Sun on 2024/8/15.
//

import Foundation

import EVMKit

// MARK: - EIP721MethodDecorator

class EIP721MethodDecorator {
    // MARK: Properties

    private let contractMethodFactories: ContractMethodFactories

    // MARK: Lifecycle

    init(contractMethodFactories: ContractMethodFactories) {
        self.contractMethodFactories = contractMethodFactories
    }
}

// MARK: IMethodDecorator

extension EIP721MethodDecorator: IMethodDecorator {
    public func contractMethod(input: Data) -> ContractMethod? {
        contractMethodFactories.createMethod(input: input)
    }
}
