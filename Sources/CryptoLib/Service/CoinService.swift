//
// Created by Thomas Burguiere on 21.01.18.
//

import RxSwift

public protocol CoinService {
    func list() -> Observable<Array<Coin>>
    func price(currency: Currency, targets: Array<Currency>) -> Observable<Dictionary<String, Float>>
}
