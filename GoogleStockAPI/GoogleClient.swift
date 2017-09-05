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
import UIKit
import RealmSwift

class Prices: Object {
    
    dynamic var ticker = ""
    dynamic var last = ""
    dynamic var time = ""
    dynamic var taskID = NSUUID().uuidString
}

class MarketData {

    func getStockData(ticker: String,enterDoStuff: @escaping (Bool) -> Void) {
        
        enterDoStuff(false)
        
        let urlAddress = "https://finance.google.com/finance/info?client=ig&q=NASDAQ%3A\(ticker)"
        
        Alamofire.request(urlAddress).responseString{ response in

            switch response.result {
                case .success(var value):
                    value.remove(at: value.startIndex); value.remove(at: value.startIndex); value.remove(at: value.startIndex)
                
                    if let dataFromString = value.data(using: .utf8, allowLossyConversion: false) {
                        let json = JSON(data: dataFromString)
                        //print("json \(json)")
                        let ticker = json[0]["t"]
                        let last = json[0]["l"]
                        let time = json[0]["ltt"]
                        
                        let realm = try! Realm()
                        
                        let prices = Prices()
                        
                        prices.ticker = "\(ticker)"
                        prices.last = "\(last)"
                        prices.time = "\(time)"
                        
                        print("Begin Realm Save")
                        
                        try! realm.write({ // [2]
                            realm.add(prices)
                        })
                        
                        print("\(prices.time) \(prices.ticker) \(prices.last)")
                        enterDoStuff(true)
                        print("Finished Realm Save")
                    }

                case .failure(let error):
                    print(error)
            }
        }
        
    }
}
