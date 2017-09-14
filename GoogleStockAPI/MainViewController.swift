//
//  MainViewController.swift
//  GoogleStockAPI
//
//  Created by Warren Hansen on 8/28/17.
//  Copyright © 2017 Warren Hansen. All rights reserved.
//

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
        
        //RealmHelpers().deleteAll()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addTapped))
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableview.reloadData()
    }
    
    
    @IBAction func clearRealm(_ sender: Any) {
        RealmHelpers().deleteAll()
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
            let thisTicker = firstName.uppercased()
            print("Entered: \(String(describing: thisTicker))")
            print("Calling getLastPrice")

            self.dataFeed.getLastPrice(ticker: thisTicker){ ( doneWork ) in
                if doneWork {
                    print("Price data loaded")
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
        cell.priceLabel?.text =  String(priceList[indexPath.row].last )
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
        myVC.chartTicker = priceList[indexPath.row].ticker
        navigationController?.pushViewController(myVC, animated: true)
        
        /*
         a better way to segue
         let myVC = storyboard?.instantiateViewController(withIdentifier: "ChartsVC") as! ChartViewController
         myVC.stringPassed = myLabel.text!
         myVC.intPassed = myInt
         navigationController?.pushViewController(myVC, animated: true)
         */
    }
}


