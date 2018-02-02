//
// Created by Thomas Burguiere on 21.01.18.
//

import Foundation
import RxSwift


fileprivate enum urls: String {
    case listCoin = "https://min-api.cryptocompare.com/data/all/coinlist"
    case coinPrice = "https://min-api.cryptocompare.com/data/price"
    case coinMultiprice = "https://min-api.cryptocompare.com/data/pricemulti"
    case histogramPerMinute = "https://min-api.cryptocompare.com/data/histominute"
}

public class CryptoCompareCoinService: CoinService {

    private static let listUrl = "https://min-api.cryptocompare.com/data/all/coinlist"
    private let caller: RestCallerService

    public init(caller: RestCallerService) {
        self.caller = caller
    }

    public func list() -> Observable<Array<Coin>> {
        return self.caller.callJsonRESTAsync(url: urls.listCoin.rawValue).map({ (jsonDictionary: JSONDictionary) -> Array<Coin> in

            guard let coinData = jsonDictionary["Data"] as? JSONDictionary else {
                return []
            }

            var coins = Array<Coin>()

            for key: String in coinData.keys {
                if let coinValue = coinData[key] as? JSONDictionary,
                   let coin = Coin(dictionary: coinValue) {
                    coins.append(coin)
                }

            }
            return coins
        })
    }

    private let currencyListSymbolsReducer: (inout String, Currency) -> () = { (result: inout String, currency: Currency) in
        result += "\(currency.name),"
    }

    public func price(currency: Currency, targets: Array<Currency>) -> Observable<CurrencyPrices> {
        let targetCurrenciesString: String = targets.reduce(into: "", currencyListSymbolsReducer)
        let url = "\(urls.coinPrice.rawValue)?fsym=\(currency.name)&tsyms=\(targetCurrenciesString)"

        return self.caller.callJsonRESTAsync(url: url).map({ (jsonData: JSONDictionary) in
            var result = CurrencyPrices()

            for symbol: String in jsonData.keys {
                result[symbol] = jsonData[symbol] as? Float
            }

            return result
        })
    }

    public func multiprice(sources: Array<Currency>, targets: Array<Currency>) -> Observable<Dictionary<String, CurrencyPrices>> {
        let targetCurrenciesString: String = targets.reduce(into: "", currencyListSymbolsReducer)
        let sourceCurrenciesString: String = sources.reduce(into: "", currencyListSymbolsReducer)

        let url = "\(urls.coinMultiprice.rawValue)?fsyms=\(sourceCurrenciesString)&tsyms=\(targetCurrenciesString)"

        return self.caller.callJsonRESTAsync(url: url).map({ (jsonData: JSONDictionary) in
            var result = Dictionary<String, CurrencyPrices>()

            for sourceSymbol: String in jsonData.keys {
                result[sourceSymbol] = jsonData[sourceSymbol] as? CurrencyPrices
            }

            return result
        })
    }

    public func histogramPerMinute(from: Currency, to: Currency, limit: Int? = 60, toTimestamp toTimestampOpt: Int? = nil)
                    -> Observable<Array<PriceDataPoint>> {
        var url = "\(urls.histogramPerMinute.rawValue)?fsym=\(from.name)&tsym=\(to.name)&limit=\(limit!)"
        if let _toTimestamp = toTimestampOpt {
            url += "&toTs=\(_toTimestamp)"
        }

        return self.caller.callJsonRESTAsync(url: url).map({ (jsonData: JSONDictionary) -> Array<PriceDataPoint> in
            guard let histoData = jsonData["Data"] as? Array<JSONDictionary> else {
                return []
            }

            return histoData.flatMap({ (data: JSONDictionary) -> PriceDataPoint? in
                guard let datapoint = PriceDataPoint(dictionary: data) else {
                    return nil
                }
                return datapoint
            })
        })
    }
}
