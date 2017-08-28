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
//  create ui to enter ticker

//  persist in realm
//  load tableview from realm
//  update with button and every 60 mins




import UIKit

class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let marketData = MarketData()
    
    @IBOutlet weak var tableview: UITableView!
    
    let titleArray = ["AAPL", "GOOG", "MSFT", "SPY"]
    let priceArray = ["151.90", "861.20", "45.01", "240.01"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addTapped))

    }
    
    //TODO: - Subclass inside Google Client
    func addTapped() {
        
        print("tapped add")
        let alert = UIAlertController(title: "Search", message: "Please enter a ticker", preferredStyle: UIAlertControllerStyle.alert)
        let action = UIAlertAction(title: "Done", style: .default) { (alertAction) in
            let textField = alert.textFields![0] as UITextField
            guard let firstName = textField.text, firstName != "" else {
                print("ticker is empty")
                //TODO: - alert textfield empty
                return
            }
            print("Entered: \(String(describing: firstName))")
            self.marketData.getStockData(ticker: textField.text!)
        }
        alert.addTextField { (textField) in
            textField.placeholder = "AAPL"
        }
        alert.addAction(action)
        self.present(alert, animated:true, completion: nil)
        
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


