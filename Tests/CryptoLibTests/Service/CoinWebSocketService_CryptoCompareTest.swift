//
// Created by Thomas Burguiere on 26.01.18.
//

import XCTest
import Logging

@testable import CryptoLib


private let printLogger = PrintLogger()

class CoinWebSocketService_CryptoCompareTest: XCTestCase {

    func test_websocket() {

        let ex = self.expectation(description: "Fetching succeeds")

        let service: CoinWebSocketService = CoinWebSocketService_CryptoCompare(logger: printLogger)
        var isFulfilled = false
        var receivedMessageCounter = 0
        _ = service.waitForConnect().subscribe(onNext: { _ in
                service.addSubscriptions(subscriptions: [Subscription.currentAggregateSubscription(from: Coin("BTC"), to: RealCurrency("USD"))])
            _ = service.subscriptionResults!.subscribe(
                    onNext: { (result: SubscriptionResult ) in
                        printLogger.info("\(receivedMessageCounter + 1): \(result)\n")
                        receivedMessageCounter += 1
                        if (/*!result.isEmpty && */receivedMessageCounter > 5) {
                            self.fulfillOnce(ex: ex, &isFulfilled)
                        }
                    },
                    onError: { error in
                        XCTFail("\(error)")
                        self.fulfillOnce(ex: ex, &isFulfilled)
                    }
            )
        })


        self.wait(for: [ex], timeout: 30.0)

    }

    private func fulfillOnce(ex: XCTestExpectation, _ isFulfilled: inout Bool) {
        if (!isFulfilled) {
            isFulfilled = true
            ex.fulfill()
        }
    }
}
