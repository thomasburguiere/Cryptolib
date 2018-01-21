//
// Created by Thomas Burguiere on 21.01.18.
//

import Foundation
import RxSwift


fileprivate enum urls: String {
    case listCoin = "https://min-api.cryptocompare.com/data/all/coinlist"
    case coinPrice = "https://min-api.cryptocompare.com/data/price"
}

public class CryptoCompareCoinService: CoinService {

    private static let listUrl = "https://min-api.cryptocompare.com/data/all/coinlist"
    private let caller = RestCallerService()

    public func list() -> Observable<Array<Coin>> {
        return self.caller.callJsonRESTAsync(url: urls.listCoin.rawValue).map({ (jsonData: Dictionary<String, Any>?) -> Array<Coin> in
            var coins = Array<Coin>()

            if let coinData = jsonData!["Data"] as! Dictionary<String, Any>? {
                for jsonEntry in coinData.keys {
                    let coinValue = coinData[jsonEntry]! as! Dictionary<String, Any>

                    if let id = coinValue["Id"] as! String?, let name = coinValue["Name"] as! String? {
                        coins.append(Coin(id: id, name: name))
                    }
                }
            }
            return coins
        })
    }

    public func price(currency: Currency, targets: Array<Currency>) -> Observable<Dictionary<String, Float>> {
        let targetCurrenciesString: String = targets.reduce(into: "") { (result: inout String, currency: Currency) in
            result += "\(currency.name),"
        }
        let url = "\(urls.coinPrice.rawValue)?fsym=\(currency.name)&tsyms=\(targetCurrenciesString)"
        return self.caller.callJsonRESTAsync(url: url).map({ (jsonData: Dictionary<String, Any>?) in
            var result = Dictionary<String, Float>()

            for symbol: String in jsonData!.keys {
                result[symbol] = jsonData![symbol] as! Float
            }

            return result
        })
    }

}
