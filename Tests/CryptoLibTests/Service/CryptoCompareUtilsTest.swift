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
        let actual1 = CryptoCompareUtils.unpackCurrent(response1)
        XCTAssertEqual(actual1["TOSYMBOL"] as! Substring, "USD")
        XCTAssertEqual(actual1["FROMSYMBOL"] as! Substring, "BTC")
        XCTAssertEqual(actual1["FLAGS"] as! Substring, "1")
        XCTAssertEqual(actual1["MARKET"] as! Substring, "CCCAGG")
        XCTAssertNil(actual1["LASTMARKET"])
        XCTAssertEqual(actual1["TYPE"] as! Substring, "5")

        // data obtained by running cryptocompare CCC.CURRENT.unpack(response1) on https://cryptoqween.github.io/streamer/ccc-streamer-utilities.js
        XCTAssertEqual(actual1["PRICE"] as! Float, 7297.99)
        XCTAssertEqual(actual1["LASTUPDATE"] as! Float, 1517844556)
        XCTAssertEqual(actual1["LASTVOLUME"] as! Float, 1.59258343)
        XCTAssertEqual(actual1["LASTVOLUMETO"] as! Float, 11659.940324402)
        XCTAssertEqual(actual1["LASTTRADEID"] as! Float, 187372512)
        XCTAssertEqual(actual1["VOLUMEHOUR"] as! Float, 151340.61056165057)
        XCTAssertEqual(actual1["VOLUMEHOURTO"] as! Float, 1185162567.5865831)
        XCTAssertEqual(actual1["VOLUME24HOUR"] as! Float, 232723.41565274488)
        XCTAssertEqual(actual1["VOLUME24HOURTO"] as! Float, 1855970075.36261)


        let actual2 = CryptoCompareUtils.unpackCurrent(response2)
        XCTAssertEqual(actual2["TOSYMBOL"] as! Substring, "USD")
        XCTAssertEqual(actual2["FROMSYMBOL"] as! Substring, "BTC")
        XCTAssertEqual(actual2["FLAGS"] as! Substring, "2")
        XCTAssertEqual(actual2["MARKET"] as! Substring, "CCCAGG")
        XCTAssertNil(actual2["LASTMARKET"])
        XCTAssertEqual(actual2["TYPE"] as! Substring, "5")

        // data obtained by running cryptocompare CCC.CURRENT.unpack(response2) on https://cryptoqween.github.io/streamer/ccc-streamer-utilities.js
        XCTAssertEqual(actual2["PRICE"] as! Float, 7297.94)
        XCTAssertEqual(actual2["LASTUPDATE"] as! Float, 1517844557)
        XCTAssertEqual(actual2["LASTVOLUME"] as! Float, 0.02239538)
        XCTAssertEqual(actual2["LASTVOLUMETO"] as! Float, 163.963295594)
        XCTAssertEqual(actual2["LASTTRADEID"] as! Float, 187372553)
        XCTAssertEqual(actual2["VOLUMEHOUR"] as! Float, 151351.85894286056)
        XCTAssertEqual(actual2["VOLUMEHOURTO"] as! Float, 1185243952.2064326)
        XCTAssertEqual(actual2["VOLUME24HOUR"] as! Float, 232734.66403395488)
        XCTAssertEqual(actual2["VOLUME24HOURTO"] as! Float, 1856051459.982464)


        let actual4 = CryptoCompareUtils.unpackCurrent(response4)
        XCTAssertEqual(actual4["TOSYMBOL"] as! Substring, "USD")
        XCTAssertEqual(actual4["FROMSYMBOL"] as! Substring, "BTC")
        XCTAssertEqual(actual4["FLAGS"] as! Substring, "4")
        XCTAssertEqual(actual4["MARKET"] as! Substring, "CCCAGG")
        XCTAssertEqual(actual4["TYPE"] as! Substring, "5")
        XCTAssertEqual(actual4["LASTMARKET"] as! Substring, "Bitfinex")

        // data obtained by running cryptocompare CCC.CURRENT.unpack(response4) on https://cryptoqween.github.io/streamer/ccc-streamer-utilities.js
        XCTAssertEqual(actual4["HIGH24HOUR"] as! Float, 8600.04)
        XCTAssertEqual(actual4["HIGHHOUR"] as! Float, 8391.29)
        XCTAssertEqual(actual4["LASTTRADEID"] as! Float, 187372503)
        XCTAssertEqual(actual4["LASTUPDATE"] as! Float, 1517844555)
        XCTAssertEqual(actual4["LASTVOLUME"] as! Float, 0.1288158)
        XCTAssertEqual(actual4["LASTVOLUMETO"] as! Float, 942.8028402000001)
        XCTAssertEqual(actual4["LOW24HOUR"] as! Float, 7207.29)
        XCTAssertEqual(actual4["LOWHOUR"] as! Float, 7221.14)
        XCTAssertEqual(actual4["OPEN24HOUR"] as! Float, 8418.1)
        XCTAssertEqual(actual4["OPENHOUR"] as! Float, 8217.6)
        XCTAssertEqual(actual4["PRICE"] as! Float, 7297)
        XCTAssertEqual(actual4["VOLUME24HOUR"] as! Float, 232720.33136931487)
        XCTAssertEqual(actual4["VOLUME24HOURTO"] as! Float, 1855947491.6099107)
        XCTAssertEqual(actual4["VOLUMEHOUR"] as! Float, 151337.52627822058)
        XCTAssertEqual(actual4["VOLUMEHOURTO"] as! Float, 1185139983.8338788)

    }


}
