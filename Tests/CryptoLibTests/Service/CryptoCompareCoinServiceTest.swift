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

        self.wait(for: [ex], timeout: 2.0)
    }

    func test__mocked__list_returns_empty_array_if_no_Data_entry_in_json() throws {

        let callerMock = RestCallerMock(jsonResponseStub: """
        {"test": "aaa"}
        """)
        let service = CryptoCompareCoinService(caller: callerMock)

        _ = service.list().subscribe(onNext: { coinList in
            XCTAssertTrue(coinList.isEmpty)
        })

        callerMock.resolve()
    }

    func test__mocked__list_returns_array_containing_only_valid_Coin_entries_in_Data_entry_in_json() {

        let callerMock = RestCallerMock(jsonResponseStub: """
        {"Data": {
            "invalid1": {},
            "invalid2": {"miscKey": "miscValue"},
            "incomplete": {"Name": "incomplete"},
            "valid": {"Name": "valid", "Id": "123"}
            }
        }
        """
        )
        let service = CryptoCompareCoinService(caller: callerMock)

        _ = service.list().subscribe(onNext: { coinList in
            XCTAssertFalse(coinList.isEmpty)
            XCTAssertEqual(coinList.count, 1)
            XCTAssertEqual(coinList.first!.name, "valid")
        })

        callerMock.resolve()
    }

    func test_coin_price() {
        let ex = self.expectation(description: "Fetching succeeds")

        let actualObservable = service.price(currency: Coin(id: "BTC", name: "BTC"), targets: [RealCurrency(name: "EUR")])
        _ = actualObservable.subscribe(onNext: { priceData in
            print(priceData)
            XCTAssertNotNil(priceData["EUR"])
            ex.fulfill()
        })


        self.wait(for: [ex], timeout: 2.0)
    }

    func test_coin_multiprice() {
        let ex = self.expectation(description: "Fetching succeeds")

        let actualObservable = service.multiprice(sources: [Coin(id: "BTC", name: "BTC"), RealCurrency(name: "EUR")], targets: [RealCurrency(name: "USD"), RealCurrency(name: "EUR")])
        _ = actualObservable.subscribe(onNext: { priceData in
            print(priceData)
            XCTAssertNotNil(priceData["EUR"])
            XCTAssertNotNil(priceData["EUR"]!["USD"])
            XCTAssertNotNil(priceData["EUR"]!["EUR"])
            XCTAssertEqual(priceData["EUR"]!["EUR"]!, 1.0)
            XCTAssertNotNil(priceData["BTC"]!["EUR"])
            XCTAssertNotNil(priceData["BTC"]!["USD"])
            ex.fulfill()
        })


        self.wait(for: [ex], timeout: 2.0)
    }

    fileprivate class RestCallerMock: RestCallerService {
        private let subject: BehaviorSubject<JSONDictionary>

        init(jsonResponseStub jsonString: String) {
            let jsonDictionary: JSONDictionary?? = try? JSONSerialization.jsonObject(with: jsonString.data(using: String.Encoding.utf8)!) as? JSONDictionary
            self.subject = BehaviorSubject(value: jsonDictionary!!)
        }

        func resolve() {
            self.subject.on(.completed)
        }

        override func callJsonRESTAsync(url: String) -> Observable<JSONDictionary> {
            return subject
        }
    }

}
