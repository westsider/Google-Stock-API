//
//  GoogleClient.swift
//  GoogleStockAPI
//
//  Created by Warren Hansen on 8/28/17.
//  Copyright © 2017 Warren Hansen. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

/*
 Stock API Details
 This is a REST based API. Here is the basic syntax:
 http://finance.google.com/finance/info?client=ig&q=NASDAQ%3A[STOCK TICKERS]
 An example of this:
 http://finance.google.com/finance/info?client=ig&q=NASDAQ%3AAAPL,GOOG
 */

class MarketData {
    
    func getStockData(urlAddress: String) {
        Alamofire.request(urlAddress).responseString{ response in

            switch response.result {
                case .success(var value):
                    value.remove(at: value.startIndex); value.remove(at: value.startIndex); value.remove(at: value.startIndex)
                
                    if let dataFromString = value.data(using: .utf8, allowLossyConversion: false) {
                            let json = JSON(data: dataFromString)
                        print("json \(json)")
                        let ticker = json[0]["t"]
                        let last = json[0]["l"]
                        let time = json[0]["ltt"]
                        print("\(time) \(ticker) \(last)")
                    }

                case .failure(let error):
                    print(error)
            }
        }
    }
    

}

