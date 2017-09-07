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

//  task: scichart demo
//  add date from string
//  reverse the days
//  take ticker from main vc
//  convert to make an OHLC

import UIKit
import Charts

class ChartViewController: UIViewController {
    
    let dataFeed = DataFeed()
    
    var numbers:[Double] = []
    
    @IBOutlet weak var chtChart: LineChartView!
    
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
            }
        }
    }
    
    func updateGraphCharts() {
        
        var lineChartEntry = [ChartDataEntry]()
        
        for i in 0..<self.dataFeed.priceHistory.count {
          //  print(self.dataFeed.priceHistory[i].date!)
            
            var latitude: String? = ""
            
            latitude = self.dataFeed.priceHistory[i].date!
            
            if let lat = latitude, let doubleLat = Double(lat) {
                print("changed to double: \(doubleLat)")  // doubleLat is of type Double now
            }
            
            
            let value = ChartDataEntry(x: Double(i), y: self.dataFeed.priceHistory[i].close! )
            lineChartEntry.append(value)
        }
        
        let line1 = LineChartDataSet(values: lineChartEntry, label: "Number")
        
        line1.colors = [NSUIColor.blue]
        
        let data = LineChartData()
        
        data.addDataSet(line1)

        chtChart.data = data
        
        chtChart.chartDescription?.text = "My awesome chart"
    }
}




