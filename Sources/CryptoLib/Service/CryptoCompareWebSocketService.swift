//
// Created by Thomas Burguiere on 26.01.18.
//

import Foundation
import SocketIO
import RxSwift


public class CryptoCompareWebSocketService: CoinWebSocketService {

    private var internalMessageObservable: Observable<Dictionary<String, Any>>?
    public var obs: Observable<SubscriptionResult>? {
        get {
            guard let o: Observable<Dictionary<String, Any>> = self.internalMessageObservable else {
                return nil
            }
            let filterOutEmptyOptionals: (SubscriptionResult?) -> Bool = { entry in
                if let _ = entry {
                    return true
                }
                return false
            }
            let unwrapOptional: (SubscriptionResult?) -> SubscriptionResult = { entry in
                return entry!
            }
            return o.map({ (entry: Dictionary<String, Any>) -> SubscriptionResult? in
                guard let from = entry["FROMSYMBOL"] as? String,
                      let to = entry["TOSYMBOL"] as? String,
                      let price = entry["PRICE"] as? Float else {
                    return nil
                }
                return SubscriptionResult(from: Coin(from), to: RealCurrency(to), price: price)
            }).filter(filterOutEmptyOptionals).map(unwrapOptional)
        }

    }

    private let manager: SocketManager;
    private let socket: SocketIOClient;
    private let disposeBag = DisposeBag()

    public init() {
        self.manager = SocketManager(socketURL: URL(string: "https://streamer.cryptocompare.com")!, config: [.log(false), .compress])
        self.socket = manager.defaultSocket

    }

    public func waitForConnect() -> Observable<Any?> {
        self.socket.connect()
        return Observable.create { (observer: AnyObserver<Any?>) -> Disposable in

            self.socket.on(clientEvent: .connect, callback: { data, ack in

                self.internalMessageObservable = self.setupMessageObservable()
                observer.onNext(nil)
            })

            return Disposables.create(with: {})
        }
    }

    public func addSubscriptions(subscriptions: Array<Subscription>) {
        let stringSubscriptions: Array<String> = CryptoCompareWebSocketService.subscriptionAsCryptoCompareString(subscriptions)
        self.addSubscriptions(subscriptions: stringSubscriptions)
    }

    public func removeSubscriptions(subscriptions: Array<Subscription>) {
        let stringSubscriptions: Array<String> = CryptoCompareWebSocketService.subscriptionAsCryptoCompareString(subscriptions)
        self.socket.emit("SubRemove", ["subs": stringSubscriptions])
    }

    private static func subscriptionAsCryptoCompareString(_ subs: Array<Subscription>) -> Array<String> {
        return subs.flatMap({ sub in
            if sub.kind == .currentAggregate {
                return "5~CCCAGG~\(sub.from.name)~\(sub.to.name)"
            }
            if sub.kind == .trade {
                return "0~\(sub.market!)~\(sub.from.name)~\(sub.to.name)"
            }
            return nil
        })
    }

    private func addSubscriptions(subscriptions: Array<String>) {
        self.socket.emit("SubAdd", ["subs": subscriptions])
    }

    private func removeSubscriptions(subscriptions: Array<String>) {
        self.socket.emit("SubRemove", ["subs": subscriptions])
    }

    private func setupMessageObservable() -> Observable<Dictionary<String, Any>> {

        let subject = PublishSubject<Dictionary<String, Any>>()

        self.socket.on("m", callback: { (data: [Any], ack) in
            guard let response = data[0] as? String else {
                subject.onError(NSError(domain: "", code: 404, userInfo: ["cause": "no response"]))
                return
            }
            if response.hasPrefix("401~") {
                subject.onError(NSError(domain: "", code: 401, userInfo: ["response": response]))
                return
            }
            guard let unpackedResponse = CryptoCompareUtils.unpack(response) else {
                subject.onError(NSError(domain: "", code: 400, userInfo: ["cause": "could not unpack response"]))
                return
            }

            subject.onNext(unpackedResponse)
        })
        subject.disposed(by: disposeBag)
        return subject
    }
}
