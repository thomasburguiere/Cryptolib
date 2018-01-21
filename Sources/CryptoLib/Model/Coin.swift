//
// Created by Thomas Burguiere on 21.01.18.
//

import Foundation

public class Coin: Currency {
    open var id: String?
    open var name: String

    public init(id: String, name: String) {
        self.id = id
        self.name = name
    }

    public init(name: String) {
        self.name = name
    }
}