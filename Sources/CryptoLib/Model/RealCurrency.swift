//
// Created by Thomas Burguiere on 21.01.18.
//

import Foundation

public class RealCurrency: Currency, JSONDecodable {
    public let name: String

    public init(_ name: String) {
        self.name = name
    }

    public var description: String { return "\(self.name)" }

    required public init?(dictionary: JSONDictionary) {
        guard let name = dictionary["Name"] as? String
                else {
            return nil
        }
        self.name = name
    }
}
