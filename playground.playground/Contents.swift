//: Playground - noun: a place where people can play

import Foundation

//// (1):
//let pat = "\\b([a-z])\\.([a-z]{2,})@([a-z]+)\\.ac\\.uk\\b"
//// (2):
//let testStr = "x.wu@strath.ac.uk, ak123@hotmail.com     e1s59@oxford.ac.uk, ee123@cooleng.co.uk, a.khan@surrey.ac.uk"
//// (3):
//let regex = try! NSRegularExpression(pattern: pat, options: [])
//// (4):
//let matches = regex.matches(in: testStr, options: [], range: NSRange(location: 0, length: testStr.characters.count))

let aggregate = "5~CCCAGG"

let initialResponse = "5~CCCAGG~BTC~USD~4~10246.13~1517444413~0.003989~40.982986000000004~182622810~1783.8716471273767~18272035.341830652~111021.67711403422~1119500408.880073~10226.86~10277.1~10197.05~9827.28~10401.49~9684.96~Bitfinex~7ffe9"

let updateResponse = "5~CCCAGG~BTC~USD~4~1517441113~0.00088366~8.8585942974~2905510661~119684.06513938117~1204555739.1975193~118320.2693874718~1190868665.3976107~10112.27~10398.87~9683.61~Gemini~78fe8"

let initialResponsePattern = "5~CCCAGG~(...)~(...)~(.*?)~(.*?)~.*"

let regex = try! NSRegularExpression(pattern: initialResponsePattern, options: [])
let matches = regex.matches(in: initialResponse, options: [], range:  NSRange(location: 0, length: initialResponse.count))
print(matches.count)

if let match = matches.first {
    let fromCurrency = (initialResponse as NSString).substring(with: match.range(at: 1))
    let toCurrency = (initialResponse as NSString).substring(with: match.range(at: 2))
    let flag = (initialResponse as NSString).substring(with: match.range(at: 3))
    let price = (initialResponse as NSString).substring(with: match.range(at: 4))
}



