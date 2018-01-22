//
// Created by Thomas Burguiere on 21.01.18.
//

import Foundation

public class RealCurrency: Currency, JSONDecodable {
    public let name: String

    public init(name: String) {
        self.name = name
    }

    required public init?(dictionary: JSONDictionary) {
        guard let name = dictionary["Name"] as? String
                else {
            return nil
        }
        self.name = name
    }
}
