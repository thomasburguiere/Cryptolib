//
// Created by Thomas Burguiere on 21.01.18.
//

import XCTest

@testable import CryptoLib


class JSONTest: XCTestCase {

    func test_decode_JSONDictionary() {
        let dict: JSONDictionary = [
            "Id": "123",
            "Name": "BTC"
        ]

        let actual: Coin? = decode(dictionary: dict)
        XCTAssertNotNil(actual)
        XCTAssertEqual(actual?.name, "BTC")
    }

    func test_decode_JSONDictionary_array() {
        let dicts: [JSONDictionary] = [
            [
                "Id": "123",
                "Name": "BTC"
            ],
            [
                "Id": "456",
                "Name": "XRP"
            ]
        ]

        let actual: Array<Coin> = decode(dictionaries: dicts)
        XCTAssertNotNil(actual)
        XCTAssertEqual(actual[0].name, "BTC")
    }
}
