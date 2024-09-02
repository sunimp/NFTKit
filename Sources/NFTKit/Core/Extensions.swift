//
//  Extensions.swift
//
//  Created by Sun on 2024/8/15.
//

import Foundation

import BigInt
import EVMKit

extension TransactionLog {
    public var eip721EventInstance: ContractEventInstance? {
        guard let signature = topics.first else {
            return nil
        }

        if signature == EIP721TransferEventInstance.signature, data.count == 96 {
            let from = data[0 ..< 32]
            let to = data[32 ..< 64]

            return EIP721TransferEventInstance(
                contractAddress: address,
                from: Address(raw: from),
                to: Address(raw: to),
                tokenID: BigUInt(data)
            )
        }

        return nil
    }

    public var eip1155EventInstance: ContractEventInstance? {
        guard let _ = topics.first else {
            return nil
        }

        // todo

        return nil
    }
}
