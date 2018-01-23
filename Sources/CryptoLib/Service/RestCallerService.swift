//
// Created by Thomas Burguiere on 21.01.18.
//

import Foundation
import RxSwift

public class RestCallerService {

    private let session: URLSession = URLSession(configuration: URLSessionConfiguration.default)

    public func callJsonRESTAsync(url: String) -> Observable<JSONDictionary> {
        let url = URL(string: url)

        return Observable.create({ observer in
            let task: URLSessionDataTask =
                    self.session.dataTask(with: url!) { (data: Data?, response: URLResponse?, error: Error?) in
                        if let data: Data = data {
                            do {
                                // Convert the data to JSON
                                let jsonSerialized = try JSONSerialization.jsonObject(with: data) as? JSONDictionary
                                observer.onNext(jsonSerialized!)
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