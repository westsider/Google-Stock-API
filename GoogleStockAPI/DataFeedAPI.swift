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

class DataFeed {
    
    // call intrino from alamofire
    func historical(ticker: String, start: String, end: String) {
        
        let histData = "https://api.intrinio.com/historical_data?identifier=\(ticker)&item=close_price&start_date=\(start)&end_date=\(end)"
        let user = "d7e969c0309ff3b9ced6ed36d75e6d0d"
        let password = "e6cf8f921bb621f398240e315ab79068"
        
        Alamofire.request("\(histData)\(user)/\(password)")
            .authenticate(user: user, password: password)
            .responseJSON { response in
                debugPrint(response)
        }
    }
}

class PriceHistory {
        var ticker: String
        var date: String
        var close: Double
        //var open: Double
        //var high: Double
        //var low:  Double
        //var volume: Int
    
        init(ticker: String, date: String, open: Double, high: Double, low: Double, close: Double, volume: Int)
        {
            self.ticker = ticker
            self.date = date
            self.close = close
            //self.open = open
            //self.high = high
            //self.low = low
            //self.volume = volume
        }
}
