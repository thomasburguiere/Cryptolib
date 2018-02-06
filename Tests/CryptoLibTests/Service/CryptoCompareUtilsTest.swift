//
// Created by Thomas Burguiere on 21.01.18.
//

import XCTest

@testable import CryptoLib


class CryptoCompareUtilsTest: XCTestCase {


    private let response1 = "5~CCCAGG~BTC~USD~1~7297.99~1517844556~1.59258343~11659.940324402~187372512~151340.61056165057~1185162567.5865831~232723.41565274488~1855970075.362615~fe9"

    private let response2 = "5~CCCAGG~BTC~USD~2~7297.94~1517844557~0.02239538~163.963295594~187372553~151351.85894286056~1185243952.2064326~232734.66403395488~1856051459.9824646~fe9"

    private let response4 = "5~CCCAGG~BTC~USD~4~7297~1517844555~0.1288158~942.8028402000001~187372503~151337.52627822058~1185139983.8338788~232720.33136931487~1855947491.6099107~8217.6~8391.29~7221.14~8418.1~8600.04~7207.29~Bitfinex~7ffe9"

    func test_update_data_is_unpacked_correctly() {
        let actual1 = CryptoCompareUtils.unpackCurrent(tradeString: response1)
        XCTAssertEqual(actual1["TOSYMBOL"] as! Substring, "USD")
        XCTAssertEqual(actual1["FROMSYMBOL"] as! Substring, "BTC")
        XCTAssertEqual(actual1["FLAGS"] as! Substring, "1")
        XCTAssertEqual(actual1["MARKET"] as! Substring, "CCCAGG")
        XCTAssertNil(actual1["LASTMARKET"])

        print(actual1)


        let actual2 = CryptoCompareUtils.unpackCurrent(tradeString: response2)
        XCTAssertEqual(actual2["TOSYMBOL"] as! Substring, "USD")
        XCTAssertEqual(actual2["FROMSYMBOL"] as! Substring, "BTC")
        XCTAssertEqual(actual2["FLAGS"] as! Substring, "2")
        XCTAssertEqual(actual2["MARKET"] as! Substring, "CCCAGG")
        XCTAssertNil(actual2["LASTMARKET"])

        print(actual2)


        let actual4 = CryptoCompareUtils.unpackCurrent(tradeString: response4)
        XCTAssertEqual(actual4["TOSYMBOL"] as! Substring, "USD")
        XCTAssertEqual(actual4["FROMSYMBOL"] as! Substring, "BTC")
        XCTAssertEqual(actual4["FLAGS"] as! Substring, "4")
        XCTAssertEqual(actual4["MARKET"] as! Substring, "CCCAGG")
        XCTAssertNotNil(actual4["LASTMARKET"])

        print(actual4)

    }


}
