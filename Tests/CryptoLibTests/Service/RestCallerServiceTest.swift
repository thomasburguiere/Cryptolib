//
// Created by Thomas Burguiere on 21.01.18.
//

import XCTest
import RxSwift
import RxTest

@testable import CryptoLib


class RestCallerServiceTest: XCTestCase {

    func test_call_works() {
        let service = RestCallerService()

        let actualObservable: Observable<Dictionary<String, Any>?> = service.callJsonRESTAsync(url: "https://api.nasa.gov/planetary/apod?api_key=DEMO_KEY")

        let ex = self.expectation(description: "Fetching suecceds")
        actualObservable.subscribe(
                onNext: { jsonData in
                    XCTAssertNotNil(jsonData)
                    let explanation = jsonData!["explanation"]
                    XCTAssertNotNil(explanation)
                    print(explanation!)
                    ex.fulfill()
                },
                onError: { error in
                    XCTFail()
                },
                onCompleted: nil,
                onDisposed: nil
        )

        self.wait(for: [ex], timeout: 1.0)
    }

    func test_list_coins() {
        let service = CryptoCompareRestCallerService()

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


        self.wait(for: [ex], timeout: 5.0)
    }

}