//
//  Protocols.swift
//  NFTKit
//
//  Created by Sun on 2022/8/24.
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
