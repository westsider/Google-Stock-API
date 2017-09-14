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
import RealmSwift

class PriceHistory {
    
    var ticker: String?
    var date: String?
    var close: Double?
}

class LastPrice {
    var ticker: String?
    var date: String?
    var open: Double?
    var high: Double?
    var low: Double?
    var close: Double?
    var volume: Double?
}

class DataFeed {
    
    var priceHistory = [PriceHistory]()
    
    var lastPrice = [LastPrice]()
    
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
    
    // Get realtime ohlc + this also returns last 6 months
    func getLastPrice(ticker: String, saveIt: Bool, enterDoStuff: @escaping (Bool) -> Void ) {
    
        print("looking for \(ticker)...")
        enterDoStuff(false)
        // get last price from intrio
        let prices = "https://api.intrinio.com/prices?identifier=\(ticker)"
        let user = "d7e969c0309ff3b9ced6ed36d75e6d0d"
        let password = "e6cf8f921bb621f398240e315ab79068"
    
        
        Alamofire.request("\(prices)")
            .authenticate(user: user, password: password)
            .responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                //print("JSON: \(json)")
                
                self.lastPrice.removeAll()
                
                for data in json["data"].arrayValue {
                    
                    let lastPriceObject = LastPrice()
                    
                    lastPriceObject.ticker = ticker
                    
                    if let date = data["date"].string {
                        lastPriceObject.date = date
                    }
                    
                    if let open = data["open"].double {
                        lastPriceObject.open = open
                    }
                    
                    if let high = data["high"].double {
                        lastPriceObject.high = high
                    }
                    if let low = data["low"].double {
                        lastPriceObject.low = low
                    }
                    
                    if let close = data["close"].double {
                        lastPriceObject.close = close
                    }
                    
                    self.lastPrice.append(lastPriceObject)
                    
                }

                let item = self.lastPrice.first
                
                if (saveIt) { RealmHelpers().saveToRealm(ticker: (item?.ticker)!, last: (item?.close)!, date: (item?.date)!) }
                
                enterDoStuff(true)
            
            case .failure(let error):
            debugPrint(error)
            }
        }
    }
    
    //    func stringToNSDate(theDate: String)-> NSDate {
    //
    //        let dateFormatter = DateFormatter()
    //        dateFormatter.dateFormat = "yyyy-MM-dd"  // "LL/dd/yyyy" //
    //
    //        return dateFormatter.date(from: theDate)! as NSDate //as NSDate
    //    }
}
