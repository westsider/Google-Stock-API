//
//  ViewController.swift
//  GoogleStockAPI
//
//  Created by Warren Hansen on 8/28/17.
//  Copyright © 2017 Warren Hansen. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let marketData = MarketData()
    let urlRequest = "https://finance.google.com/finance/info?client=ig&q=NASDAQ%3AAAPL"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        marketData.getStockData(urlAddress: urlRequest)
    }

    /*
     Stock API Details
     This is a REST based API. Here is the basic syntax:
     http://finance.google.com/finance/info?client=ig&q=NASDAQ%3A[STOCK TICKERS]
     An example of this:
     http://finance.google.com/finance/info?client=ig&q=NASDAQ%3AAAPL,GOOG
     */


}

class Starship {
    
    var prefix: String?
    
    var name: String
    
    init(name: String, prefix: String? = nil)
    {
        self.name = name
        self.prefix = prefix
    }
    
    var fullName: String {
        return (prefix != nil ? prefix! + " " : "") + name
    }
    
    func identify() {
        print(fullName)
    }
}

var ncc1701 = Starship(name: "Enterprise", prefix: "USS")

let fullname =  ncc1701.fullName //"USS Enterprise"

let id = ncc1701.identify
