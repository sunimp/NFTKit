//
//  Protocols.swift
//  NftKit
//
//  Created by Sun on 2024/8/21.
//

import Foundation

protocol ITransactionSyncerDelegate: AnyObject {
    func didSync(nfts: [Nft], type: NftType)
}

protocol IBalanceSyncManagerDelegate: AnyObject {
    func didFinishSyncBalances()
}
