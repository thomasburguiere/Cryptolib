//
// Created by Thomas Burguiere on 02.02.18.
//

import Foundation

public class PriceDataPoint: JSONDecodable, CustomStringConvertible {
    let timestamp: Int
    let close: Double
    let high: Double
    let low: Double
    let open: Double

    public var description: String {
        return """
        {timestamp: \(timestamp), close: \(close), high: \(high), low: \(low), open: \(open)}
        """
    }

    required public init?(dictionary: JSONDictionary) {
        guard let timestamp = dictionary["time"] as? Int,
            let close = (dictionary["close"] as AnyObject).doubleValue,
            let high = (dictionary["high"] as AnyObject).doubleValue,
            let low =  (dictionary["low"] as AnyObject).doubleValue,
            let open = (dictionary["open"] as AnyObject).doubleValue
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
