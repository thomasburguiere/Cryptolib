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

        self.socket.connect()
    }

    public func onConnected() -> Observable<Any?> {
        let subject: BehaviorSubject<Any?> = BehaviorSubject(value: nil)

        if(self.socket.status == .connected){
            subject.on(.completed)
            return subject
        }

        self.socket.on(clientEvent: .connect, callback: {(data: [Any], ack: SocketAckEmitter) in
            subject.on(.completed)
        })
        return subject
    }

    public func register(subscription: Array<String>) -> Observable<[String]> {
        self.socket.emit("SubAdd", ["subs", subscription])

        return Observable.create({(observer: AnyObserver<Array<String>>) in

            self.socket.on("m", callback: { (data: [Any], ack) in
                if(!data.isEmpty && (data[0] as! String).hasPrefix("4")) {
                    observer.onError(NSError(domain: "", code: 401))
                }
                observer.onNext(data as! Array<String>)
            })

            return Disposables.create(with: {
                self.socket.disconnect()
            })
        })
    }
}
