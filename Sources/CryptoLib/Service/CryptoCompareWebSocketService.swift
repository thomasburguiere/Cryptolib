//
// Created by Thomas Burguiere on 26.01.18.
//

import Foundation
import SocketIO
import RxSwift


public class CryptoCompareWebSocketService {

    private let manager: SocketManager;
    private let socket: SocketIOClient;

    init() {
        self.manager = SocketManager(socketURL: URL(string: "https://streamer.cryptocompare.com")!, config: [.log(false), .compress])
        self.socket = manager.defaultSocket

    }

    public func waitForConnect() -> Observable<Any?> {
        self.socket.connect()
        return Observable.create { (observer: AnyObserver<Any?>) in

            self.socket.on(clientEvent: .connect, callback: { data, ack in
                observer.onNext(nil)
            })

            return Disposables.create(with: {})
        }
    }

    public func register(subscription: Array<String>) -> Observable<[String]> {
        self.socket.emit("SubAdd", ["subs": subscription])

        return Observable.create({ (observer: AnyObserver<Array<String>>) in

            self.socket.on("m", callback: { (data: [Any], ack) in
                let response = data[0] as! String
                if (!data.isEmpty && response.hasPrefix("401~")) {
                    observer.onError(NSError(domain: "", code: 401, userInfo: ["response": response]))
                }
                observer.onNext(data as! Array<String>)
            })

            return Disposables.create(with: {
                self.socket.disconnect()
            })
        })
    }
}
