//
//  ChartViewController.swift
//  GoogleStockAPI
//
//  Created by Warren Hansen on 8/29/17.
//  Copyright © 2017 Warren Hansen. All rights reserved.
//
//  create a data structure

//  download 1 year of daily data
//  save it to raalm
//  use it in simple line chart
//  convert to make an OHLC

import UIKit
//import Alamofire

class ChartViewController: UIViewController {
    
    let dataFeed = DataFeed()

    override func viewDidLoad() {
        super.viewDidLoad()

        let ticker = "$SPX"
        let startDate = "2017-08-01"
        let endDate = "2017-08-30"
        self.dataFeed.historical(ticker: ticker, start: startDate, end: endDate )
    }
}




