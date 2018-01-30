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
        var counter = 0
        _ = service.waitForConnect().subscribe(onNext: { noop in
            _ = service.register(subscription: ["5~CCCAGG~BTC~USD", "5~CCCAGG~ETH~USD"]).subscribe(
                    onNext: { (result: [String] ) in
                        print("\(counter + 1): \(result)\n")
                        counter += 1
                        if (!result.isEmpty && counter > 9) {
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
