//
//  Protocols.swift
//
//  Created by Sun on 2024/8/15.
//

import Foundation

// MARK: - ITransactionSyncerDelegate

protocol ITransactionSyncerDelegate: AnyObject {
    func didSync(nfts: [NFT], type: NFTType)
}

// MARK: - IBalanceSyncManagerDelegate

protocol IBalanceSyncManagerDelegate: AnyObject {
    func didFinishSyncBalances()
}
