//
// Created by Thomas Burguiere on 21.01.18.
//

import Foundation

class CoinService {

    public func list() -> Array<Coin> {
        let request = URLRequest(url: URL(string: "https://min-api.cryptocompare.com/data/all/coinlist")!)

        var coinList = Array<Coin>()

        // Perform the request
        do {
            let response: AutoreleasingUnsafeMutablePointer<URLResponse?>? = nil
            let data: Data
            data = try NSURLConnection.sendSynchronousRequest(request, returning: response)

            // Convert the data to JSON
            let jsonSerialized = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]

            if let json = jsonSerialized, let message = json["Message"] as! String?, let data = json["Data"] as! Dictionary<String, Any>? {
                print(message)
                for coinName: String in data.keys {
                    if let entry = data[coinName] as! Dictionary<String, Any>? {
                        var coin: Coin
                        coin = Coin(id: entry["Id"] as! String, name: entry["Name"] as! String)
                        coinList.append(coin)
                    }
                }
            }
        } catch {
        }
        return coinList
    }
}
