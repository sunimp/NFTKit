//
//  Extensions.swift
//  NftKit
//
//  Created by Sun on 2024/8/21.
//

import Foundation

import BigInt
import EvmKit

public extension TransactionLog {
    var eip721EventInstance: ContractEventInstance? {
        guard let signature = topics.first else {
            return nil
        }

        if signature == Eip721TransferEventInstance.signature, data.count == 96 {
            let from = data[0 ..< 32]
            let to = data[32 ..< 64]

            return Eip721TransferEventInstance(
                contractAddress: address,
                from: Address(raw: from),
                to: Address(raw: to),
                tokenId: BigUInt(data)
            )
        }

        return nil
    }

    var eip1155EventInstance: ContractEventInstance? {
        guard let _ = topics.first else {
            return nil
        }

        // todo

        return nil
    }
}
