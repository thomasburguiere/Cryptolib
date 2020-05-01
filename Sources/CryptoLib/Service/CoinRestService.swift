//
// Created by Thomas Burguiere on 21.01.18.
//

import RxSwift
import Service
import Logging

public typealias CurrencyPrices = Dictionary<String, Double>

public protocol CoinRestService: Service {

    func list() -> Observable<Array<Coin>>
    func price(currency: Currency, targets: Array<Currency>) -> Observable<CurrencyPrices>
    func multiprice(sources: Array<Currency>, targets: Array<Currency>) -> Observable<Dictionary<String, CurrencyPrices>>
    func histogramPerMinute(from: Currency, to: Currency, numberOfPoints: Int?, toTimestamp: Int?) -> Observable<Array<PriceDataPoint>>
}

public struct CoinRestServiceProvider: Provider {
    public func register(_ services: inout Services) throws {
        services.register(CoinRestService.self) {container in
            return try CoinRestService_CryptoCompare(
                caller: RestCallerService(logger: self.logger(container)),
                logger: self.logger(container)
            )
        }
    }
    
    public func didBoot(_ container: Container) throws -> EventLoopFuture<Void> {
        return .done(on: container)
    }
    
    private func logger(_ container: Container) throws -> Logger {
        return try container.make(Logger.self)
    }
    
}
