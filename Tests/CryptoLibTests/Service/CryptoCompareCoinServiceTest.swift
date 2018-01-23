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

    func test__mocked__list_returns_empty_array_if_no_Data_entry_in_json() throws {

        let callerMock = RestCallerMock(returnedJson: """
        {"test": "aaa"}
        """)
        let service = CryptoCompareCoinService(caller: callerMock)

        service.list().subscribe(onNext: { coinList in
            XCTAssertTrue(coinList.isEmpty)
        })

        callerMock.resolve()
    }

    func test__mocked__list_returns_array_containing_only_valid_Coin_entries_in_Data_entry_in_json() {

        let callerMock = RestCallerMock(returnedJson: """
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

        service.list().subscribe(onNext: { coinList in
            XCTAssertFalse(coinList.isEmpty)
            XCTAssertEqual(coinList.count, 1)
            XCTAssertEqual(coinList.first!.name, "valid")
        })

        callerMock.resolve()
    }

    func test_coin_price() {
        let ex = self.expectation(description: "Fetching succeeds")

        let actualObservable = service.price(currency: Coin(id: "BTC", name: "BTC"), targets: [RealCurrency(name: "EUR")])
        actualObservable.subscribe(onNext: { priceData in
            print(priceData)
            XCTAssertNotNil(priceData["EUR"])
            ex.fulfill()
        })


        self.wait(for: [ex], timeout: 2.0)
    }

    fileprivate class RestCallerMock: RestCallerService {
        private let subject: BehaviorSubject<JSONDictionary>

        init(returnedJson jsonString: String) {
            let jsonDictionary = try? JSONSerialization.jsonObject(with: jsonString.data(using: String.Encoding.utf8)!) as? JSONDictionary
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
