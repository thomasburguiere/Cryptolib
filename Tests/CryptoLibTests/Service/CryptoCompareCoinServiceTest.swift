//
// Created by Thomas Burguiere on 21.01.18.
//

import XCTest
import RxSwift
import RxTest

@testable import CryptoLib


class CryptoCompareCoinServiceTest: XCTestCase {



    func test_list_coins() {
        let service = CryptoCompareCoinService(caller: RestCallerService())

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

        self.wait(for: [ex], timeout: 1.0)
    }

    func test_coin_price() {
        let service = CryptoCompareCoinService(caller: RestCallerService())
        let ex = self.expectation(description: "Fetching suecceds")

        service.price(currency: Coin(id: "BTC", name: "BTC"), targets: [RealCurrency(name: "EUR")]).subscribe(onNext: { priceData in
            print(priceData)
            XCTAssertNotNil(priceData["EUR"])
            ex.fulfill()
        })


        self.wait(for: [ex], timeout: 1.0)
    }

}
