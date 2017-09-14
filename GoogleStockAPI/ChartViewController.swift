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
//  convert to candle chart
//  fix rollover
//  add ticker error catches


import Foundation
import SciChart

class ChartViewController: UIViewController {
    
    let dataFeed = DataFeed()
    
    var surface = SCIChartSurface()
    
    var chartTicker: String?
    
    var ohlcDataSeries: SCIOhlcDataSeries!
    
    var ohlcRenderableSeries: SCIFastOhlcRenderableSeries!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.dataFeed.getLastPrice(ticker: chartTicker!, saveIt: false) { ( doneWork ) in
            if doneWork {
                self.addSurface()
                self.addAxis()
                self.addDefaultModifiers()
                self.addDataSeries()
            }
        }
    }
    
    fileprivate func addSurface() {
        surface = SCIChartSurface(frame: self.view.bounds)
        surface.translatesAutoresizingMaskIntoConstraints = true
        surface.frame = self.view.bounds
        surface.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.view.addSubview(surface)
    }

    fileprivate func addAxis() {
        let xAxis = SCIDateTimeAxis()
        xAxis.growBy = SCIDoubleRange(min: SCIGeneric(0.1), max: SCIGeneric(0.1))
        surface.xAxes.add(xAxis)
        
        let yAxis = SCINumericAxis()
        yAxis.growBy = SCIDoubleRange(min: SCIGeneric(0.1), max: SCIGeneric(0.1))
        surface.yAxes.add(yAxis)
    }
    
    fileprivate func addDataSeries() {
        let upBrush = SCISolidBrushStyle(colorCode: 0x9000AA00)
        let downBrush = SCISolidBrushStyle(colorCode: 0x90FF0000)
        let upWickPen = SCISolidPenStyle(colorCode: 0xFF00AA00, withThickness: 0.7)
        let downWickPen = SCISolidPenStyle(colorCode: 0xFFFF0000, withThickness: 0.7)
        
        surface.renderableSeries.add(getCandleRenderSeries(false, upBodyBrush: upBrush, upWickPen: upWickPen, downBodyBrush: downBrush, downWickPen: downWickPen, count: 30))
    }
    
    fileprivate func getCandleRenderSeries(_ isReverse: Bool,
                                           upBodyBrush: SCISolidBrushStyle,
                                           upWickPen: SCISolidPenStyle,
                                           downBodyBrush: SCISolidBrushStyle,
                                           downWickPen: SCISolidPenStyle,
                                           count: Int) -> SCIFastCandlestickRenderableSeries {

        let ohlcDataSeries = SCIOhlcDataSeries(xType: .dateTime, yType: .double)
        
        ohlcDataSeries.acceptUnsortedData = true
        
        let items = self.dataFeed.lastPrice
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy-MM-dd"

        for i in 0..<(items.count) - 1 {
            
            let date:Date = dateFormatter.date(from: items[i].date!)!
            ///print("Date OHLC: \(date) \(items[i].open!) \(items[i].high!) \(items[i].low!) \(items[i].close!)")
            ohlcDataSeries.appendX(SCIGeneric(date),
                                   open: SCIGeneric(items[i].open!),
                                   high: SCIGeneric(items[i].high!),
                                   low: SCIGeneric(items[i].low!),
                                   close: SCIGeneric(items[i].close!))
        }
        
        let candleRendereSeries = SCIFastCandlestickRenderableSeries()
        candleRendereSeries.dataSeries = ohlcDataSeries
        candleRendereSeries.fillUpBrushStyle = upBodyBrush
        candleRendereSeries.fillDownBrushStyle = downBodyBrush
        candleRendereSeries.strokeUpStyle = upWickPen
        candleRendereSeries.strokeDownStyle = downWickPen
        
        return candleRendereSeries
    }
    
    func addDefaultModifiers() {
        
        let xAxisDragmodifier = SCIXAxisDragModifier()
        
        xAxisDragmodifier.dragMode = .scale
        xAxisDragmodifier.clipModeX = .none
        
        let yAxisDragmodifier = SCIYAxisDragModifier()
        yAxisDragmodifier.dragMode = .pan
        
        let extendZoomModifier = SCIZoomExtentsModifier()
        
        let pinchZoomModifier = SCIPinchZoomModifier()
        
        //let rolloverModifier = SCIRolloverModifier()
        //rolloverModifier.style.tooltipSize = CGSize(width: 200, height: CGFloat.nan)

        let groupModifier = SCIChartModifierCollection(childModifiers: [xAxisDragmodifier, yAxisDragmodifier, pinchZoomModifier, extendZoomModifier])  //rolloverModifier
        
        surface.chartModifiers = groupModifier
    }

}


















