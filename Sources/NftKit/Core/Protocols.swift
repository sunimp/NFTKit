//
//  Protocols.swift
//  NftKit
//
//  Created by Sun on 2024/8/21.
//

import Foundation

// MARK: - ITransactionSyncerDelegate

protocol ITransactionSyncerDelegate: AnyObject {
    func didSync(nfts: [Nft], type: NftType)
}

// MARK: - IBalanceSyncManagerDelegate

protocol IBalanceSyncManagerDelegate: AnyObject {
    func didFinishSyncBalances()
}
