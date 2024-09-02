# NFTKit.Swift

`NFTKit.Swift` extends `EVMKit.Swift` to support `EIP721` and `EIP1155` non-fungible tokens(NFT).

## Features

- Supports ERC-721 and ERC-1155 NFT smart contracts
- Synchronization of NFTs owned by the user
- Send/Receive NFTs

## Usage

### Initialization

```swift
import EVMKit
import NFTKit

let evmKit = try Kit.instance(
	address: try EVMKit.Address(hex: "0x..user..address.."),
	chain: .ethereum,
	rpcSource: .ethereumInfuraWebsocket(projectId: "...", projectSecret: "..."),
	transactionSource: .ethereumEtherscan(apiKey: "..."),
	walletID: "unique_wallet_id",
	minLogLevel: .error
)

let nftKit = try NFTKit.Kit.instance(evmKit: evmKit)

// Decorators are needed to detect transactions as `Uniswap` transactions
nftKit.addEIP721Decorators()
nftKit.addEIP1155Decorators()

// Transaction syncers are needed to pull the NFT transfer transactions from Etherscan
nftKit.addEIP721TransactionSyncer()
nftKit.addEIP1155TransactionSyncer()
```

### Get NFTs owned by the user

```swift
let balances = nftKit.balances

for nftBalance in balances {
	print("---- \(nftBalance.balance) pieces of \(nftBalance.nft.name) ---")
	print("Contract Address: \(nftBalance.nft.contractAddress.eip55)")
	print("TokenID: \(nftBalance.nft.tokenId.description)")
}
```


### Send an NFT

```swift
// Get Signer object
let seed = Mnemonic.seed(mnemonic: ["mnemonic", "words", ...])!
let signer = try Signer.instance(seed: seed, chain: .ethereum)

let nftContractAddress = try EVMKit.Address(hex: "0x..contract..address")
let tokenId = BigUInt("234123894712031638516723498")
let to = try EVMKit.Address(hex: "0x..recipient..address")
let gasPrice = GasPrice.legacy(gasPrice: 50_000_000_000)

// Construct a TransactionData
let transactionData = nftKit.transferEIP721TransactionData(contractAddress: nftContractAddress, to: to, tokenId: tokenId)

// Estimate gas for the transaction
let estimateGasSingle = evmKit.estimateGas(transactionData: transactionData, gasPrice: gasPrice)

// Generate a raw transaction which is ready to be signed
let rawTransactionSingle = estimateGasSingle.flatMap { estimatedGasLimit in
    evmKit.rawTransaction(transactionData: transactionData, gasPrice: gasPrice, gasLimit: estimatedGasLimit)
}

let sendSingle = rawTransactionSingle.flatMap { rawTransaction in
    // Sign the transaction
    let signature = try signer.signature(rawTransaction: rawTransaction)
    
    // Send the transaction to RPC node
    return evmKit.sendSingle(rawTransaction: rawTransaction, signature: signature)
}


let disposeBag = DisposeBag()

sendSingle
    .subscribe(
        onSuccess: { fullTransaction in
            let transaction = fullTransaction.transaction
            print("Transaction sent: \(transaction.hash.ww.hexString)")
        }, onError: { error in
            print("Send failed: \(error)")
        }
    )
    .disposed(by: disposeBag)
```
## Requirements

* Xcode 15.4+
* Swift 5.10+
* iOS 14.0+

## Installation

### Swift Package Manager

```swift
dependencies: [
    .package(url: "https://github.com/sunimp/NFTKit.Swift.git", .upToNextMajor(from: "2.4.0"))
]
```

## License

The `NFTKit.Swift` toolkit is open source and available under the terms of the [MIT License](https://github.com/sunimp/NFTKit.Swift/blob/main/LICENSE).

