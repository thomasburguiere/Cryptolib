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

        let actual: Coin? = JSONUtils.decode(dictionary: dict)
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

        let actual: Array<Coin> = JSONUtils.decode(dictionaries: dicts)
        XCTAssertNotNil(actual)
        XCTAssertEqual(actual[0].name, "BTC")
    }

    func test_decode_data_json_array() {
        let data: Data = "[{ \"Name\": \"BTC\", \"Id\": \"123\"}]".data(using: String.Encoding.utf8)!

        let actual: Array<Coin>? = JSONUtils.decode(data: data)

        XCTAssertNotNil(actual)
        XCTAssertEqual(actual![0].name, "BTC")
    }

    func test_decode_data_json_object() {
        let data: Data = "{ \"Name\": \"BTC\", \"Id\": \"123\"}".data(using: String.Encoding.utf8)!

        let actual: Array<Coin>? = JSONUtils.decode(data: data)

        XCTAssertNotNil(actual)
        XCTAssertEqual(actual![0].name, "BTC")
    }
}
