//
// Created by Thomas Burguiere on 21.01.18.
//

import XCTest
import RxSwift

@testable import CryptoLib


class CryptoCompareCoinServiceTest: XCTestCase {

    private let service = CryptoCompareCoinService(caller: RestCallerService())

    func test_list_coins_works() {

        let ex = self.expectation(description: "Fetching succeeds")
        let actualObs = service.list()

        _ = actualObs.subscribe(onNext: { coinList in
            XCTAssertTrue(!coinList.isEmpty)

            let bitcoin: Coin? = coinList.first(where: { (coin: Coin) -> Bool in
                return coin.name == "BTC"
            })
            XCTAssertNotNil(bitcoin)
            ex.fulfill()
        })

        self.wait(for: [ex], timeout: 10.0)
    }

    func test_coin_price() {
        let ex = self.expectation(description: "Fetching succeeds")

        let actualObs = service.price(currency: Coin(id: "BTC", name: "BTC"), targets: [RealCurrency(name: "EUR")])
        _ = actualObs.subscribe(onNext: { priceData in
            print(priceData)
            XCTAssertNotNil(priceData["EUR"])
            ex.fulfill()
        })


        self.wait(for: [ex], timeout: 10.0)
    }

    func test_coin_multiprice() {
        let ex = self.expectation(description: "Fetching succeeds")

        let actualObs = service.multiprice(sources: [Coin(id: "BTC", name: "BTC"), RealCurrency(name: "EUR")], targets: [RealCurrency(name: "USD"), RealCurrency(name: "EUR")])
        _ = actualObs.subscribe(onNext: { priceData in
            print(priceData)
            XCTAssertNotNil(priceData["EUR"])
            XCTAssertNotNil(priceData["EUR"]!["USD"])
            XCTAssertNotNil(priceData["EUR"]!["EUR"])
            XCTAssertEqual(priceData["EUR"]!["EUR"]!, 1.0)
            XCTAssertNotNil(priceData["BTC"])
            XCTAssertNotNil(priceData["BTC"]!["EUR"])
            XCTAssertNotNil(priceData["BTC"]!["USD"])
            ex.fulfill()
        })


        self.wait(for: [ex], timeout: 10.0)
    }

    func test_coin_histogram_minute() {

        let ex = self.expectation(description: "Fetching succeeds")
        let actualObs = service.histogramPerMinute(from: Coin(id:"XRP", name:"XRP"), to: RealCurrency(name: "USD"))

        _ = actualObs.subscribe(onNext: {histogramData in
            print(histogramData)
            ex.fulfill()
        })

        self.wait(for: [ex], timeout: 10.0)
    }



}
