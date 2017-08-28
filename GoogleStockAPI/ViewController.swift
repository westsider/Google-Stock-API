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

//  create ui to enter ticker, show results on tableview,  ask for update
//  persist in realm




import UIKit

class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let marketData = MarketData()
    
    @IBOutlet weak var tableview: UITableView!
    
   // let search = UISearchBar() // Create your search bar
    //controller.navigationController.navigationItem.titleView = search

    override func viewDidLoad() {
        super.viewDidLoad()
        
        marketData.getStockData(ticker: "AAPL")
    }
    

    /* Create a tableview
    
    drag tableview to VC add constraints
    +1 prototype cell
    Control Click on TableViewCell and set identifier to Cell
    create outlet  @IBOutlet weak var tableView: UITableView!
     
    Control Click drag to center = datasource + delegate OR
    tableview.delegate = self
    tableview.datasource = self
     
    REQUIRED DELEGATES = UITableViewDataSource, UITableViewDelegate
    */
    
    let titleArray = ["AAPL", "GOOG", "MSFT", "SPY"]
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArray.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "Cell")
        
        cell.textLabel?.text = titleArray[indexPath.row]
        
        return cell
    }

 
}


