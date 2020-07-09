import OpenSslKit
import BigInt

public struct Pair {
    private let tokenAmount0: TokenAmount
    private let tokenAmount1: TokenAmount

    init(tokenAmount0: TokenAmount, tokenAmount1: TokenAmount) {
        self.tokenAmount0 = tokenAmount0
        self.tokenAmount1 = tokenAmount1
    }

    var token0: Data {
        tokenAmount0.token
    }

    var token1: Data {
        tokenAmount1.token
    }

    var reserve0: BigUInt {
        tokenAmount0.amount
    }

    var reserve1: BigUInt {
        tokenAmount1.amount
    }

    private func other(token: Data) -> Data {
        token0 == token ? token1 : token0
    }

    private func reserve(token: Data) -> BigUInt {
        token0 == token ? reserve0 : reserve1
    }

    func tokenAmountOut(tokenAmountIn: TokenAmount) -> TokenAmount {
        // todo: guards

        let tokenIn = tokenAmountIn.token
        let tokenOut = other(token: tokenIn)

        let reserveIn = reserve(token: tokenIn)
        let reserveOut = reserve(token: tokenOut)

        let amountInWithFee = tokenAmountIn.amount * 997
        let numerator = amountInWithFee * reserveOut
        let denominator = reserveIn * 1000 + amountInWithFee
        let amountOut = numerator / denominator

        return TokenAmount(token: tokenOut, amount: amountOut)
    }

    func tokenAmountIn(tokenAmountOut: TokenAmount) -> TokenAmount {
        // todo: guards

        let tokenOut = tokenAmountOut.token
        let tokenIn = other(token: tokenOut)

        let reserveOut = reserve(token: tokenOut)
        let reserveIn = reserve(token: tokenIn)

        let numerator = reserveIn * tokenAmountOut.amount * 1000
        let denominator = (reserveOut - tokenAmountOut.amount) * 997
        let amountIn = numerator / denominator + 1

        return TokenAmount(token: tokenIn, amount: amountIn)
    }

    static func address(token0: Data, token1: Data) -> Data {
        let data = Data(hex: "ff")! +
                Data(hex: "0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f")! +
                OpenSslKit.Kit.sha3(token0 + token1) +
                Data(hex: "0x96e8ac4277198ff8b6f785478aa9a39f403cb768dd02cbee326c3e7da348845f")!

        return OpenSslKit.Kit.sha3(data).suffix(20)
    }

}

extension Pair: CustomStringConvertible {

    public var description: String {
        "Pair:\n[token0: \(token0.toHexString()), reserve0: \(reserve0.description)]\n[token1: \(token1.toHexString()), reserve1: \(reserve1.description)]"
    }

}
