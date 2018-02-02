//
// Created by Thomas Burguiere on 02.02.18.
//

import Foundation

public class PriceDataPoint: JSONDecodable, CustomStringConvertible {
    let timestamp: Int
    let close: Float
    let high: Float
    let low: Float
    let open: Float

    public var description: String {
        return """
        {timestamp: \(timestamp), close: \(close), high: \(high), low: \(low), open: \(open)}
        """
    }

    required public init?(dictionary: JSONDictionary) {
        guard let timestamp = dictionary["time"] as? Int,
              let close = dictionary["close"] as? Float,
              let high = dictionary["high"] as? Float,
              let low = dictionary["low"] as? Float,
              let open = dictionary["open"] as? Float
                else {
            return nil
        }
        self.timestamp = timestamp
        self.close = close
        self.high = high
        self.low = low
        self.open = open
    }
}
