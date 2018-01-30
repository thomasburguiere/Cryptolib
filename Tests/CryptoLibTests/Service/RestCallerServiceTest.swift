//
// Created by Thomas Burguiere on 21.01.18.
//

import XCTest
import RxSwift

@testable import CryptoLib


class RestCallerServiceTest: XCTestCase {

    func test_call_works() {
        let service = RestCallerService()

        let actualObservable: Observable<JSONDictionary> = service.callJsonRESTAsync(url: "https://api.nasa.gov/planetary/apod?api_key=DEMO_KEY")

        let ex = self.expectation(description: "Fetching succeeds")
        _ = actualObservable.subscribe(
                onNext: { jsonData in
                    XCTAssertNotNil(jsonData)
                    let explanation = jsonData["explanation"]
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

        self.wait(for: [ex], timeout: 5.0)
    }
}
