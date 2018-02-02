//
// Created by Thomas Burguiere on 21.01.18.
//

import RxSwift


public typealias CurrencyPrices = Dictionary<String, Float>

public protocol CoinService {

    func list() -> Observable<Array<Coin>>
    func price(currency: Currency, targets: Array<Currency>) -> Observable<CurrencyPrices>
    func multiprice(sources: Array<Currency>, targets: Array<Currency>) -> Observable<Dictionary<String, CurrencyPrices>>
    func histogramPerMinute(from: Currency, to: Currency, numberOfPoints: Int?, toTimestamp: Int?) -> Observable<Array<PriceDataPoint>>
}
