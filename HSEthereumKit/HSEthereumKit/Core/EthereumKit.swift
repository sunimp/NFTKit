import Foundation
import RxSwift

public class EthereumKit {
    private let disposeBag = DisposeBag()

    public weak var delegate: IEthereumKitDelegate?

    private let blockchain: IBlockchain
    private let storage: IStorage
    private let addressValidator: IAddressValidator
    private let state: EthereumKitState

    init(blockchain: IBlockchain, storage: IStorage, addressValidator: IAddressValidator, state: EthereumKitState = EthereumKitState()) {
        self.blockchain = blockchain
        self.storage = storage
        self.addressValidator = addressValidator
        self.state = state

        state.balance = storage.balance(forAddress: blockchain.ethereumAddress)
        state.lastBlockHeight = storage.lastBlockHeight
    }

}

// Public API Extension

extension EthereumKit {

    public func start() {
        blockchain.start()
    }

    public func clear() {
        delegate = nil

        blockchain.clear()
        storage.clear()
        state.clear()
    }

    public var lastBlockHeight: Int? {
        return state.lastBlockHeight
    }

    public var balance: Decimal {
        return state.balance ?? 0
    }

    public var syncState: SyncState {
        return blockchain.syncState
    }

    public var receiveAddress: String {
        return blockchain.ethereumAddress
    }

    public func register(contractAddress: String, decimal: Int, delegate: IEthereumKitDelegate) {
        guard !state.has(contractAddress: contractAddress) else {
            return
        }

        state.add(contractAddress: contractAddress, decimal: decimal, delegate: delegate)
        state.set(balance: storage.balance(forAddress: contractAddress) ?? 0, contractAddress: contractAddress)

        blockchain.register(contractAddress: contractAddress, decimal: decimal)
    }

    public func unregister(contractAddress: String) {
        blockchain.unregister(contractAddress: contractAddress)
        state.remove(contractAddress: contractAddress)
    }

    public func validate(address: String) throws {
        try addressValidator.validate(address: address)
    }

    public func fee(gasPriceInWei: Int? = nil) -> Decimal {
        // only for standard transactions without data
        return Decimal(gasPriceInWei ?? blockchain.gasPriceInWei) / pow(10, 18) * Decimal(blockchain.gasLimitEthereum)
    }

    public func transactionsSingle(fromHash: String? = nil, limit: Int? = nil) -> Single<[EthereumTransaction]> {
        return storage.transactionsSingle(fromHash: fromHash, limit: limit, contractAddress: nil)
    }

    public func sendSingle(to address: String, amount: Decimal, gasPriceInWei: Int? = nil) -> Single<EthereumTransaction> {
        return blockchain.sendSingle(to: address, amount: amount, gasPriceInWei: gasPriceInWei)
    }

    public var debugInfo: String {
        var lines = [String]()

//        lines.append("PUBLIC KEY: \(hdWallet.publicKey()) ADDRESS: \(hdWallet.address())")
        lines.append("ADDRESS: \(blockchain.ethereumAddress)")

        return lines.joined(separator: "\n")
    }

}

// Public ERC20 API Extension

extension EthereumKit {

    public func feeErc20(gasPriceInWei: Int? = nil) -> Decimal {
        // only for erc20 coin maximum fee
        return Decimal(gasPriceInWei ?? blockchain.gasPriceInWei) / pow(10, 18) * Decimal(blockchain.gasLimitErc20)
    }

    public func balanceErc20(contractAddress: String) -> Decimal {
        return state.balance(contractAddress: contractAddress) ?? 0
    }

    public func syncStateErc20(contractAddress: String) -> SyncState {
        return blockchain.syncState(contractAddress: contractAddress)
    }

    public func transactionsErc20Single(contractAddress: String, fromHash: String? = nil, limit: Int? = nil) -> Single<[EthereumTransaction]> {
        return storage.transactionsSingle(fromHash: fromHash, limit: limit, contractAddress: contractAddress)
    }

    public func sendErc20Single(to address: String, contractAddress: String, amount: Decimal, gasPriceInWei: Int? = nil) -> Single<EthereumTransaction> {
        return blockchain.sendErc20Single(to: address, contractAddress: contractAddress, amount: amount, gasPriceInWei: gasPriceInWei)
    }

}

extension EthereumKit: IBlockchainDelegate {

    func onUpdate(lastBlockHeight: Int) {
        state.lastBlockHeight = lastBlockHeight

        delegate?.onUpdateLastBlockHeight()
        state.erc20Delegates.forEach { delegate in
            delegate.onUpdateLastBlockHeight()
        }
    }

    func onUpdate(balance: Decimal) {
        state.balance = balance
        delegate?.onUpdateBalance()
    }

    func onUpdateErc20(balance: Decimal, contractAddress: String) {
        state.set(balance: balance, contractAddress: contractAddress)
        state.delegate(contractAddress: contractAddress)?.onUpdateBalance()
    }

    func onUpdate(syncState: SyncState) {
        delegate?.onUpdateSyncState()
    }

    func onUpdateErc20(syncState: SyncState, contractAddress: String) {
        state.delegate(contractAddress: contractAddress)?.onUpdateSyncState()
    }

    func onUpdate(transactions: [EthereumTransaction]) {
        delegate?.onUpdate(transactions: transactions)
    }

    func onUpdateErc20(transactions: [EthereumTransaction], contractAddress: String) {
        state.delegate(contractAddress: contractAddress)?.onUpdate(transactions: transactions)
    }

}

extension EthereumKit {

    public static func ethereumKit(words: [String], walletId: String, testMode: Bool, infuraKey: String, etherscanKey: String, debugPrints: Bool = false) throws -> EthereumKit {
        let storage = GrdbStorage(databaseFileName: "\(walletId)-\(testMode)")
        let blockchain = try ApiBlockchain.apiBlockchain(storage: storage, words: words, testMode: testMode, infuraKey: infuraKey, etherscanKey: etherscanKey, debugPrints: debugPrints)
        let addressValidator = AddressValidator()

        let ethereumKit = EthereumKit(blockchain: blockchain, storage: storage, addressValidator: addressValidator)

        blockchain.delegate = ethereumKit

        return ethereumKit
    }

}

extension EthereumKit {

    public enum SyncState {
        case synced
        case syncing
        case notSynced
    }

}
