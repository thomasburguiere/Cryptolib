//
// Created by Thomas Burguiere on 06.02.18.
//

import Foundation
import RxSwift

public struct Subscription {
    public let from: Coin
    public let to: Currency
    public let kind: Kind
    public let market: String?

    public static func tradeSubscription(from: Coin, to: Currency, market: String) -> Subscription {
        return Subscription(from, to, .trade, market)
    }

    public static func currentAggregateSubscription(from: Coin, to: Currency) -> Subscription {
        return Subscription(from, to, .currentAggregate, nil)
    }

    public enum Kind {
        case trade
        case currentAggregate
    }

    private init(_ from: Coin, _ to: Currency, _ kind: Kind, _ market: String?) {
        self.from = from
        self.to = to
        self.kind = kind
        self.market = market
    }
}

public struct SubscriptionResult {
    public let from: Coin
    public let to: Currency
    public let price: Double

    public init(from: Coin, to: Currency, price: Double) {
        self.from = from
        self.to = to
        self.price = price
    }
}

public protocol CoinWebSocketService {
    func waitForConnect() -> Observable<Any?>
    func addSubscriptions(subscriptions: Array<Subscription>)
    func removeSubscriptions(subscriptions: Array<Subscription>)
    var obs: Observable<SubscriptionResult>? { get }
}
