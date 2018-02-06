//
// Created by Thomas Burguiere on 01.02.18.
//

import Foundation

let TRADE_FIELDS = [
    "T": 0x0, // hex for binary 0, it is a special case of fields that are always there TYPE
    "M": 0x0, // hex for binary 0, it is a special case of fields that are always there MARKET
    "FSYM": 0x0, // hex for binary 0, it is a special case of fields that are always there FROM SYMBOL
    "TSYM": 0x0, // hex for binary 0, it is a special case of fields that are always there TO SYMBOL
    "F": 0x0, // hex for binary 0, it is a special case of fields that are always there FLAGS
    "ID": 0x1, // hex for binary 1                                                       ID
    "TS": 0x2, // hex for binary 10                                                      TIMESTAMP
    "Q": 0x4, // hex for binary 100                                                     QUANTITY
    "P": 0x8, // hex for binary 1000                                                    PRICE
    "TOTAL": 0x10, // hex for binary 10000                                                   TOTAL
];

struct Field {
    let name: String
    let value: Int

    init(_ name: String, _ value: Int) {
        self.name = name
        self.value = value
    }
}

let CURRENT_FIELDS: [Field] = [
    Field("TYPE", 0x0), // hex for binary 0, it is a special case of fields that are always there
    Field("MARKET", 0x0), // hex for binary 0, it is a special case of fields that are always there
    Field("FROMSYMBOL", 0x0), // hex for binary 0, it is a special case of fields that are always there
    Field("TOSYMBOL", 0x0), // hex for binary 0, it is a special case of fields that are always there
    Field("FLAGS", 0x0), // hex for binary 0, it is a special case of fields that are always there
    Field("PRICE", 0x1), // hex for binary 1
    Field("BID", 0x2), // hex for binary 10
    Field("OFFER", 0x4), // hex for binary 100
    Field("LASTUPDATE", 0x8), // hex for binary 1000
    Field("AVG", 0x10), // hex for binary 10000
    Field("LASTVOLUME", 0x20), // hex for binary 100000
    Field("LASTVOLUMETO", 0x40), // hex for binary 1000000
    Field("LASTTRADEID", 0x80), // hex for binary 10000000
    Field("VOLUMEHOUR", 0x100), // hex for binary 100000000
    Field("VOLUMEHOURTO", 0x200), // hex for binary 1000000000
    Field("VOLUME24HOUR", 0x400), // hex for binary 10000000000
    Field("VOLUME24HOURTO", 0x800), // hex for binary 100000000000
    Field("OPENHOUR", 0x1000), // hex for binary 1000000000000
    Field("HIGHHOUR", 0x2000), // hex for binary 10000000000000
    Field("LOWHOUR", 0x4000), // hex for binary 100000000000000
    Field("OPEN24HOUR", 0x8000), // hex for binary 1000000000000000
    Field("HIGH24HOUR", 0x10000), // hex for binary 10000000000000000
    Field("LOW24HOUR", 0x20000), // hex for binary 100000000000000000
    Field("LASTMARKET", 0x40000)// hex for binary 1000000000000000000, this is a special case and will only appear on CCCAGG messages

]

struct CryptoCompareUtils {

    static func unpackCurrent(tradeString: String) -> Dictionary<String, Any> {
        var valuesArray: Array<Substring> = tradeString.split(separator: "~");
        let mask = valuesArray.last!;
        let maskInt: Int? = Int(mask, radix: 16);
        var unpackedCurrent = Dictionary<String, Any>();
        var currentFieldIndex = 0;

        // TODO : manage to have CURRENT_FIELDS as an ordered dictionary
        for field in CURRENT_FIELDS {

            if field.value == 0 {
                unpackedCurrent[field.name] = valuesArray[currentFieldIndex];
                currentFieldIndex += 1;
            } else if maskInt != nil && (maskInt! & field.value != 0) {
                //i know this is a hack, for cccagg, future code please don't hate me:(, i did this to avoid
                //subscribing to trades as well in order to show the last market
                if field.name == "LASTMARKET" {
                    unpackedCurrent[field.name] = valuesArray[currentFieldIndex];
                } else {
                    unpackedCurrent[field.name] = Float(valuesArray[currentFieldIndex]);
                }
                currentFieldIndex += 1;
            }
        }

        return unpackedCurrent;
    }
}
