//
// Created by Thomas Burguiere on 21.01.18.
//

import Foundation
import RxSwift

public class RestCallerService {

    private let session: URLSession = URLSession(configuration: URLSessionConfiguration.default)

    public func callJsonRESTAsync(url: String) -> Observable<Dictionary<String, Any>?> {
        let url = URL(string: url)

        return Observable.create({ observer in
            let task: URLSessionDataTask = self.session.dataTask(with: url!) { (data, response, error) in
                if let data = data {
                    do {
                        // Convert the data to JSON
                        let jsonSerialized = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                        observer.onNext(jsonSerialized)
                        observer.onCompleted()
                    } catch let error as NSError {
                        print(error.localizedDescription)
                        observer.onError(error)
                    }
                } else if let error = error {
                    print(error.localizedDescription)
                    observer.onError(error)
                }
            }

            task.resume()

            return Disposables.create(with: {
                task.cancel()
            })
        })


    }
}

fileprivate enum urls: String {
    case listCoin = "https://min-api.cryptocompare.com/data/all/coinlist"
}

public class CryptoCompareRestCallerService {

    private static let listUrl = "https://min-api.cryptocompare.com/data/all/coinlist"
    private let caller = RestCallerService()

    public func list() -> Observable<Array<Coin>> {

        return self.caller.callJsonRESTAsync(url: urls.listCoin.rawValue).map({ (jsonData: Dictionary<String, Any>?) -> Array<Coin> in
            var coins = Array<Coin>()

            if let coinData = jsonData!["Data"] as! Dictionary<String, Any>? {
                for jsonEntry in coinData.keys {
                    let coinValue = coinData[jsonEntry]! as! Dictionary<String, Any>

                    if let id = coinValue["Id"] as! String?, let name = coinValue["Name"] as! String? {
                        coins.append(Coin(id: id, name: name))
                    }
                }
            }

            return coins
        })


    }

}
