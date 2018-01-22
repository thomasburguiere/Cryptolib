//
// Created by Thomas Burguiere on 21.01.18.
//

import XCTest
import RxSwift

@testable import CryptoLib


class CryptoCompareCoinServiceTest: XCTestCase {

    private let service = CryptoCompareCoinService(caller: RestCallerService())

    func test_list_coins() {

        let ex = self.expectation(description: "Fetching suecceds")
        let actualObs = service.list()

        actualObs.subscribe(onNext: { coinList in
            XCTAssertTrue(!coinList.isEmpty)

            let bitcoin: Coin? = coinList.first(where: { (coin: Coin) -> Bool in
                return coin.name == "BTC"
            })
            XCTAssertNotNil(bitcoin)
            ex.fulfill()
        })

        self.wait(for: [ex], timeout: 2.0)
    }

    func test_coin_price() {
        let ex = self.expectation(description: "Fetching suecceds")

        let actualObservable = service.price(currency: Coin(id: "BTC", name: "BTC"), targets: [RealCurrency(name: "EUR")])
        actualObservable.subscribe(onNext: { priceData in
            print(priceData)
            XCTAssertNotNil(priceData["EUR"])
            ex.fulfill()
        })


        self.wait(for: [ex], timeout: 2.0)
    }

}
