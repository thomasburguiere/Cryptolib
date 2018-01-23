//
// Created by Thomas Burguiere on 22.01.18.
//

import Foundation

public typealias JSONDictionary = Dictionary<String, Any>

public protocol JSONDecodable {
    init?(dictionary: JSONDictionary)
}
struct JSONUtils {
    static func decode<T: JSONDecodable>(dictionaries: Array<JSONDictionary>) -> Array<T> {
        return dictionaries.flatMap({ (dictionary: JSONDictionary) -> T? in
            return T(dictionary: dictionary)
        })
    }

    static func decode<T: JSONDecodable>(dictionary: JSONDictionary) -> T? {
        return T(dictionary: dictionary)
    }

    static func decode<T: JSONDecodable>(data: Data) -> Array<T>? {
        guard let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []) else {
            return nil
        }

        if let dictionaries = jsonObject as? [JSONDictionary] {
            let objects: Array<T> = decode(dictionaries: dictionaries)
            return objects
        }

        guard let dictionary = jsonObject as? JSONDictionary else{
            return nil
        }

        guard let object: T = decode(dictionary: dictionary) else{
            return nil
        }

        return [object]

    }

}
