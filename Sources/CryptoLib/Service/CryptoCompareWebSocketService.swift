//
// Created by Thomas Burguiere on 26.01.18.
//

import Foundation
import SocketIO
import RxSwift


public class CryptoCompareWebSocketService {

    private let manager: SocketManager;
    private let socket: SocketIOClient;
    var messageUpdateObservable: Observable<String>?

    init() {
        self.manager = SocketManager(socketURL: URL(string: "https://streamer.cryptocompare.com")!, config: [.log(false), .compress])
        self.socket = manager.defaultSocket

    }

    public func waitForConnect() -> Observable<Any?> {
        self.socket.connect()
        return Observable.create { (observer: AnyObserver<Any?>) in

            self.socket.on(clientEvent: .connect, callback: { data, ack in

                self.messageUpdateObservable = Observable.create({ (observer: AnyObserver<String>) in

                    self.socket.on("m", callback: { (data: [Any], ack) in
                        guard let response = data[0] as? String else {
                            observer.onError(NSError(domain: "", code: 401, userInfo: ["cause": "no response"]))
                            return
                        }
                        if response.hasPrefix("401~") {
                            observer.onError(NSError(domain: "", code: 401, userInfo: ["response": response]))
                        }
                        observer.onNext(response)
                    })

                    return Disposables.create(with: {
                        self.socket.disconnect()
                    })
                })

                observer.onNext(nil)
            })

            return Disposables.create(with: {})
        }
    }

    public func addSubscriptions(subscriptions: Array<String>) {
        self.socket.emit("SubAdd", ["subs": subscriptions])
    }
}
