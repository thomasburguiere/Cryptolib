//
// Created by Thomas Burguiere on 26.01.18.
//

import XCTest

@testable import CryptoLib

class CryptoCompareWebSocketServiceTest: XCTestCase {

    func test() {

        let ex = self.expectation(description: "Fetching succeeds")

        let service = CryptoCompareWebSocketService()
        var isFulfilled = false
        var receivedMessageCounter = 0
        _ = service.waitForConnect().subscribe(onNext: { noop in
            service.addSubscriptions(subscriptions: ["5~CCCAGG~BTC~USD", "5~CCCAGG~ETH~USD"])
            _ = service.messageUpdateObservable!.subscribe(
                    onNext: { (result: String ) in
                        print("\(receivedMessageCounter + 1): \(result)\n")
                        receivedMessageCounter += 1
                        if (!result.isEmpty && receivedMessageCounter > 9) {
                            self.fulfillOnce(ex: ex, &isFulfilled)
                        }
                    },
                    onError: { error in
                        XCTFail("\(error)")
                        self.fulfillOnce(ex: ex, &isFulfilled)
                    }
            )
        })


        self.wait(for: [ex], timeout: 10.0)

    }

    private func fulfillOnce(ex: XCTestExpectation, _ isFulfilled: inout Bool) {
        if (!isFulfilled) {
            isFulfilled = true
            ex.fulfill()
        }
    }
}
