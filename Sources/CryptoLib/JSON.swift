//
// Created by Thomas Burguiere on 22.01.18.
//

import Foundation

public typealias JSONDictionary = Dictionary<String, Any>

public protocol JSONDecodable {
    init?(dictionary: JSONDictionary)
}

func decode<T: JSONDecodable>(dictionaries: Array<JSONDictionary>) -> Array<T> {
    return dictionaries.flatMap({ (dictionary: JSONDictionary) -> T? in
        return T(dictionary: dictionary)
    })
}

func decode<T: JSONDecodable>(dictionary: JSONDictionary) -> T? {
    return T(dictionary: dictionary)
}

func decode<T: JSONDecodable>(data: Data) -> Array<T>? {
    guard let jsonObject: Any = try? JSONSerialization.jsonObject(with: data, options: []),
          let dictionaries = jsonObject as? [JSONDictionary] else {
        return nil
    }
    return decode(dictionaries: dictionaries)
}
