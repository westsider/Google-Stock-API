//
//  ViewController.swift
//  GoogleStockAPI
//
//  Created by Warren Hansen on 8/28/17.
//  Copyright © 2017 Warren Hansen. All rights reserved.
//
/*
 Stock API Details
 This is a REST based API. Here is the basic syntax:
 http://finance.google.com/finance/info?client=ig&q=NASDAQ%3A[STOCK TICKERS]
 An example of this:
 http://finance.google.com/finance/info?client=ig&q=NASDAQ%3AAAPL,GOOG
 */
//  make url request
//  add symbol input
//  find cool ui
//  create ui to show results on tableview

//  create ui to enter ticker, ask for update
//  persist in realm




import UIKit

class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let marketData = MarketData()
    
    @IBOutlet weak var tableview: UITableView!
    
    let titleArray = ["AAPL", "GOOG", "MSFT", "SPY"]
    let priceArray = ["151.90", "861.20", "45.01", "240.01"]
    
    // let search = UISearchBar() // Create your search bar
    //controller.navigationController.navigationItem.titleView = search

    override func viewDidLoad() {
        super.viewDidLoad()
        
        marketData.getStockData(ticker: "AAPL")
    }
    
   
    //MARK: - Tableview
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArray.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as!StockTableViewCell
        
        cell.tickerLabel?.text = titleArray[indexPath.row]
        
        cell.priceLabel?.text = priceArray[indexPath.row]

        return cell
    }

 
}


