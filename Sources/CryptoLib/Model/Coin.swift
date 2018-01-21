//
// Created by Thomas Burguiere on 21.01.18.
//

import Foundation

class Coin {
    open var id: String
    open var name: String

    public init(id: String, name: String) {
        self.id = id
        self.name = name
    }
}