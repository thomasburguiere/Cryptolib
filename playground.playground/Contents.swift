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


//////////////////// updades

let FIELDS = [
    "T"            : 0x0  // hex for binary 0, it is a special case of fields that are always there TYPE
    , "M"          : 0x0  // hex for binary 0, it is a special case of fields that are always there MARKET
    , "FSYM"       : 0x0  // hex for binary 0, it is a special case of fields that are always there FROM SYMBOL
    , "TSYM"       : 0x0  // hex for binary 0, it is a special case of fields that are always there TO SYMBOL
    , "F"          : 0x0  // hex for binary 0, it is a special case of fields that are always there FLAGS
    , "ID"         : 0x1  // hex for binary 1                                                       ID
    , "TS"         : 0x2  // hex for binary 10                                                      TIMESTAMP
    , "Q"          : 0x4  // hex for binary 100                                                     QUANTITY
    , "P"          : 0x8  // hex for binary 1000                                                    PRICE
    , "TOTAL"      : 0x10 // hex for binary 10000                                                   TOTAL
];

func unpack(tradeString: String) -> Dictionary<String, Any> {
    var valuesArray = tradeString.split(separator: "~");
    let mask = valuesArray.last!;
    let maskInt = Int(mask, radix: 16);
    var unpackedCurrent = Dictionary<String, Any>();
    var currentField = 0;
    
    
    
    for property in FIELDS.keys {
        if FIELDS[property] == 0 {
            unpackedCurrent[property] = valuesArray[currentField];
            currentField += 1;
        }
        else if(maskInt != nil && FIELDS[property] != nil) {
            //i know this is a hack, for cccagg, future code please don't hate me:(, i did this to avoid
            //subscribing to trades as well in order to show the last market
            if property == "LASTMARKET"{
                unpackedCurrent[property] = valuesArray[currentField];
            } else {
                unpackedCurrent[property] = Double(valuesArray[currentField]);
            }
            currentField += 1;
        }
    }
    
    return unpackedCurrent;
}

let updateResponse = "5~CCCAGG~BTC~USD~4~1517441113~0.00088366~8.8585942974~2905510661~119684.06513938117~1204555739.1975193~118320.2693874718~1190868665.3976107~10112.27~10398.87~9683.61~Gemini~78fe8"

unpack(tradeString: updateResponse)









