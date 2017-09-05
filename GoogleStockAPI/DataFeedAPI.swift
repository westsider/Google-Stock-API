//
//  DataFeedAPI.swift
//  GoogleStockAPI
//
//  Created by Warren Hansen on 9/4/17.
//  Copyright © 2017 Warren Hansen. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import Realm
import RealmSwift

class PriceHistory {
    
    var ticker: String?
    var date: String?
    var close: Double?
}

class DataFeed {
    
    var priceHistory = [PriceHistory]()
    
    func historical(ticker: String, start: String, end: String, enterDoStuff: @escaping (Bool) -> Void) {
        
        enterDoStuff(false)
        
        let histData = "https://api.intrinio.com/historical_data?identifier=\(ticker)&item=close_price&start_date=\(start)&end_date=\(end)"
        let user = "d7e969c0309ff3b9ced6ed36d75e6d0d"
        let password = "e6cf8f921bb621f398240e315ab79068"

        Alamofire.request("\(histData)\(user)/\(password)")
            .authenticate(user: user, password: password)
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    //print("JSON: \(json)")

                    for data in json["data"].arrayValue {
        
                        let priceObject = PriceHistory()
                        priceObject.ticker = json["identifier"].string
                        
                        if let date = data["date"].string {
                            priceObject.date = date
                        }
                        
                        if let close = data["value"].double {
                            priceObject.close = close
                        }

                        self.priceHistory.append(priceObject)
            
                    }
                    enterDoStuff(true)
                    
                case .failure(let error):
                    debugPrint(error)
                }
        }
    }
}
