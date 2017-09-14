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
//  cool icon

//  convert to make an OHLC



import UIKit
import SciChart
import Accelerate

class ChartViewController: UIViewController {
    
    let dataFeed = DataFeed()
    
    var sciChartSurface: SCIChartSurface?
    
    var chartTicker: String?
    
    // line chart
    var lineDataSeries: SCIXyDataSeries!
    
    var lineRenderableSeries: SCIFastLineRenderableSeries!
    
    var ohlcDataSeries: SCIOhlcDataSeries!
    
    var ohlcRenderableSeries: SCIFastOhlcRenderableSeries!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("We passed in \(String(describing: chartTicker))")

        setUpUI()
        
        //let ticker = "$SPX"
        let startDate = "2017-06-01"
        let endDate = "2017-09-12"
     
        self.dataFeed.historical(ticker: chartTicker!, start: startDate, end: endDate ) { ( doneWork ) in
            if doneWork {
                for thing in self.dataFeed.priceHistory {
                    print(thing.ticker! + " " + thing.date! +  " \(thing.close!)")
                }
                
                self.createLineChart()
                self.createRenderableSeriesLineChart()
            }
        }
    }
    
    func setUpUI() {
        // Create a SCIChartSurface. This is a UIView so can be added directly to the UI
        sciChartSurface = SCIChartSurface(frame: self.view.bounds)
        sciChartSurface?.translatesAutoresizingMaskIntoConstraints = true
        
        // Add the SCIChartSurface as a subview
        self.view.addSubview(sciChartSurface!)
        
        // Create an XAxis and YAxis. This step is mandatory before creating series
        sciChartSurface?.xAxes.add(SCIDateTimeAxis())
        sciChartSurface?.yAxes.add(SCINumericAxis())
    }
    
    //MARK: - Line Chart
    func createLineChart(){
        
        lineDataSeries = SCIXyDataSeries(xType: .dateTime, yType: .double)
        
        lineDataSeries.acceptUnsortedData = true
     
        let items = self.dataFeed.priceHistory
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        for i in 0..<(items.count) - 1 {
            
            let date:Date = dateFormatter.date(from: items[i].date!)!
            print("\(date) \(items[i].close!)")
            lineDataSeries.appendX(SCIGeneric(date), y: SCIGeneric(Double(items[i].close!)))
        }
    }
    
    func createRenderableSeriesLineChart(){
        lineRenderableSeries = SCIFastLineRenderableSeries()
        lineRenderableSeries.dataSeries = lineDataSeries
        sciChartSurface?.renderableSeries.add(lineRenderableSeries)
    }
    
    //MARK: - Bar Chart
    func createBarChart(){
        
        ohlcDataSeries = SCIOhlcDataSeries(xType: .dateTime, yType: .double) //SCIXyDataSeries(xType: .dateTime, yType: .double)
        
        ohlcDataSeries.acceptUnsortedData = true
        
        let items = self.dataFeed.priceHistory
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        for i in 0..<(items.count) - 1 {
            
            let date:Date = dateFormatter.date(from: items[i].date!)!
            print("\(date) \(items[i].close!)")
            //lineDataSeries.appendX(SCIGeneric(date), y: SCIGeneric(Double(items[i].close!)))
            ohlcDataSeries.appendX(<#T##x: SCIGenericType##SCIGenericType#>, open: <#T##SCIGenericType#>, high: <#T##SCIGenericType#>, low: <#T##SCIGenericType#>, close: <#T##SCIGenericType#>)
        }
    }
    
//    func createRenderableSeriesBarChart(){
//        lineRenderableSeries = SCIFastLineRenderableSeries()
//        lineRenderableSeries.dataSeries = lineDataSeries
//        sciChartSurface?.renderableSeries.add(lineRenderableSeries)
//    }
    

}


















