//
// Created by Thomas Burguiere on 21.01.18.
//

import XCTest
import RxSwift
import Logging
import RxRestCaller

@testable import CryptoLib


private let printLogger = PrintLogger()
class CoinService_CryptoCompareMockedTest: XCTestCase {
    

    func test__mocked__list_returns_empty_array_if_no_Data_entry_in_json() throws {

        let callerMock = RestCallerMock(jsonResponseStub: """
        {"test": "aaa"}
        """)
        let service = CoinRestService_CryptoCompare(caller: callerMock, logger: printLogger)

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
        let service = CoinRestService_CryptoCompare(caller: callerMock, logger: printLogger)

        _ = service.list().subscribe(onNext: { coinList in
            XCTAssertFalse(coinList.isEmpty)
            XCTAssertEqual(coinList.count, 1)
            XCTAssertEqual(coinList.first!.name, "valid")
        })

        callerMock.resolve()
    }

    fileprivate class RestCallerMock: RxRestCaller {
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
        
        override func get(url: String) -> Observable<JSONDictionary> {
            return subject
        }
    }

}
