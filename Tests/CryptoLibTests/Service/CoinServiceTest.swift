import XCTest
@testable import CryptoLib

class CoinServiceTest: XCTestCase {
    func testList_returns_bitcoin() {
        let service = CoinService()
        let actual: Array<Coin> = service.list()

        XCTAssertFalse(actual.isEmpty)

        let bitcoin: Coin? = actual.first(where: { (coin: Coin) -> Bool in
            return coin.name == "BTC"
        })
        XCTAssertNotNil(bitcoin)
    }
}