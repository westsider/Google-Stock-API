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

    func getStockData(ticker: String) {
        
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
                        
                        try! realm.write({ // [2]
                            realm.add(prices)
                            //self.tableview.insertRows(at: [IndexPath.init(row: self.todoList.count-1, section: 0)], with: .automatic)
                        })
                        
                        print("\(prices.time) \(prices.ticker) \(prices.last)")
                    }

                case .failure(let error):
                    print(error)
            }
        }
    }
}

final class PricesList: Object {
    
    dynamic var id = NSUUID().uuidString
    let items = List<Prices>()
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
