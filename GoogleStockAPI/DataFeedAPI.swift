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

class PriceHistory {
    
    var ticker: String?
    var date: String?
    var close: Double?
}

class LastPrice {
    
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
    
    // Get realtime close + this also returns last 6 months
    func getLastPrice(ticker: String, enterDoStuff: @escaping (Bool) -> Void ) {
        
        //MARK: - TODO: Completion Handeler
        //MARK: - TODO integrate into tableview
    
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
                
                for data in json["data"].arrayValue {
                
                    let lastPriceObject = LastPrice()
                    
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
//                for item in self.lastPrice {
//                   print("\(ticker) Date: \(String(describing: item.date!))  Close: \(String(describing: item.close!))")
//                }
                
                enterDoStuff(true)
            
            case .failure(let error):
            debugPrint(error)
            }
        }
    
    }
}
