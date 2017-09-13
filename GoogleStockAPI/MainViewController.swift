//
//  MainViewController.swift
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
//  delete rows in tableview
//  didselectrow opens new VC

//  just got access to tradeit api -  no price series func or structure seen

//  add chart to new VC
//  update with button and every 60 mins
//  search NASDAQ and NYSE


import UIKit
import RealmSwift
import Realm

class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let marketData = MarketData()
    
    let dataFeed = DataFeed()
    
    @IBOutlet weak var tableview: UITableView!

    let realm = try! Realm()

    var priceList: Results<Prices> {
        get {
            return realm.objects(Prices.self)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addTapped))
        
        dataFeed.getLastPrice(ticker: "AAPL")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableview.reloadData()
    }
    
    //TODO: - Subclass inside Google Client
    func addTapped() {
        
        print("tapped add")
        let alert = UIAlertController(title: "Search", message: "Please enter a ticker", preferredStyle: UIAlertControllerStyle.alert)
        let action = UIAlertAction(title: "Done", style: .default) { (alertAction) in
            let textField = alert.textFields![0] as UITextField
            guard let firstName = textField.text, firstName != "" else {
                print("ticker is empty")
                return
            }
            print("Entered: \(String(describing: firstName))")
            print("work not done")
            self.marketData.getStockData(ticker: firstName) { ( doneWork ) in
                if doneWork {
                    print("work done")
                    self.tableview.reloadData()
                }
            }
        }
        alert.addTextField { (textField) in
            textField.placeholder = "AAPL"
        }
        alert.addAction(action)
        self.present(alert, animated:true, completion: nil)
        
    }
   
    //MARK: - Tableview
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return priceList.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as!StockTableViewCell
        cell.tickerLabel?.text = priceList[indexPath.row].ticker
        cell.priceLabel?.text = priceList[indexPath.row].last
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if (editingStyle == .delete){
            let item = priceList[indexPath.row]
            try! self.realm.write({
                self.realm.delete(item)
            })
            
            tableView.deleteRows(at:[indexPath], with: .automatic)
            
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let myVC = storyboard?.instantiateViewController(withIdentifier: "ChartsVC") as! ChartViewController
    
        navigationController?.pushViewController(myVC, animated: true)
    }
}


