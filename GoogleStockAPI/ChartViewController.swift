//
//  ChartViewController.swift
//  GoogleStockAPI
//
//  Created by Warren Hansen on 8/29/17.
//  Copyright © 2017 Warren Hansen. All rights reserved.
//
//  create a data structure
//  download 1 year of daily data
//  save it to object
//  use completion handler to get the price history before creating chart
//  use stock data in simple line chart

//  add date from string
//  reverse the days
//  take ticker from main vc
//  convert to make an OHLC

import UIKit
import SciChart

class ChartViewController: UIViewController {
    
    let dataFeed = DataFeed()
    
    var sciChartSurface: SCIChartSurface?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let ticker = "$SPX"
        let startDate = "2017-08-01"
        let endDate = "2017-09-05"
     
        self.dataFeed.historical(ticker: ticker, start: startDate, end: endDate ) { ( doneWork ) in
            if doneWork {
                for thing in self.dataFeed.priceHistory {
                    print(thing.ticker! + " " + thing.date! +  " \(thing.close!)")
                }
                //self.updateGraphCharts()
                self.setUpChartUI()
            }
        }
    }
    
    func setUpChartUI() {
        
        sciChartSurface = SCIChartSurface(frame: self.view.bounds)
        sciChartSurface?.translatesAutoresizingMaskIntoConstraints = true
        self.view.addSubview(sciChartSurface!)
        
        // create axis
        sciChartSurface?.xAxes.add(SCINumericAxis())
        sciChartSurface?.yAxes.add(SCINumericAxis())
        
    }

}




