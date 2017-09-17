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
//  add ticker error catches
//  task: added trade entry line
//  task: convert date text to 01/05/2011, then convert to date, might help scrolling annotaions crash
//  task: reversed index of prices object to stop unsorded data crash
//  style: clean up functions

//  30 min chart
//  study annotations file  SCSAnnotationsView.swift
//  study multipane file to create a line, all the answers are there


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

        self.title = chartTicker
        
        self.dataFeed.getLastPrice(ticker: chartTicker!, saveIt: false) { ( doneWork ) in
            if doneWork {
                self.addSurface()
                self.addAxis()
                self.addDefaultModifiers()
                self.addDataSeries()
                self.addTradeEntry()
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

        let reversed = items.reversed() 
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy/MM/dd"
        
        print("array Size = \(items.count)")

          for things in reversed {
            
            let dashDate = things.date!
            let slashDate = dashDate.replacingOccurrences(of: "-", with: "/")
            
            let date:Date = dateFormatter.date(from: slashDate)!
            
            print("shash: \(slashDate) NSDate: \(date)")
            
            ///print("Date OHLC: \(date) \(items[i].open!) \(items[i].high!) \(items[i].low!) \(items[i].close!)")
            ohlcDataSeries.appendX(SCIGeneric(date),
                                   open: SCIGeneric(things.open!),
                                   high: SCIGeneric(things.high!),
                                   low: SCIGeneric(things.low!),
                                   close: SCIGeneric(things.close!))
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
        
        let rolloverModifier = SCIRolloverModifier()
        rolloverModifier.style.tooltipSize = CGSize(width: 200, height: CGFloat.nan)
        
        let marker = SCIEllipsePointMarker()
        marker.width = 20
        marker.height = 20
        marker.strokeStyle = SCISolidPenStyle(colorCode:0xFF390032,withThickness:0.25)
        marker.fillStyle = SCISolidBrushStyle(colorCode:0xE1245120)
        rolloverModifier.style.pointMarker = marker
        
        let groupModifier = SCIChartModifierCollection(childModifiers: [xAxisDragmodifier, yAxisDragmodifier, pinchZoomModifier, extendZoomModifier, rolloverModifier])
        
        surface.chartModifiers = groupModifier
    }
    
    //MARK: - Trade entry margin line
    func addTradeEntry() {
        
        let annotationGroup = SCIAnnotationCollection()

        let horizontalLine1 = SCIHorizontalLineAnnotation()
        horizontalLine1.coordinateMode = .absolute;
        horizontalLine1.y1 = SCIGeneric(248);
        horizontalLine1.horizontalAlignment = .stretch
        horizontalLine1.add(self.buildLineTextLabel("Sell @ 248", alignment: .axis, backColor: UIColor.red, textColor: UIColor.white))
        horizontalLine1.style.linePen = SCISolidPenStyle.init(color: UIColor.red, withThickness:2)
        annotationGroup.add(horizontalLine1)
        
        surface.annotations = annotationGroup

    }

    private func buildLineTextLabel(_ text: String, alignment: SCILabelPlacement, backColor: UIColor, textColor: UIColor) -> SCILineAnnotationLabel {
        let lineText = SCILineAnnotationLabel()
        lineText.text = text
        lineText.style.labelPlacement = alignment
        lineText.style.backgroundColor = backColor
        lineText.style.textStyle.color = textColor
        return lineText
    }
}


















