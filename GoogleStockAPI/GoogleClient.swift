//
//  GoogleClient.swift
//  GoogleStockAPI
//
//  Created by Warren Hansen on 8/28/17.
//  Copyright © 2017 Warren Hansen. All rights reserved.
//

import Foundation
import Alamofire

/*
 Stock API Details
 This is a REST based API. Here is the basic syntax:
 http://finance.google.com/finance/info?client=ig&q=NASDAQ%3A[STOCK TICKERS]
 An example of this:
 http://finance.google.com/finance/info?client=ig&q=NASDAQ%3AAAPL,GOOG
 */

class Starship {
    
    /*
     
     Github set up
     1. Create repository with space in name,  NO README, copy link
     2. Config, remotes. +, add remote no spaces in name, commit, push
     
     Add images to git readme
     Issues > new issue > drop in an image > copy the link > paste into my readme
     
     Github Markup  for commits
     type: subject
     body
     Footer
     
     feat: a new feature
     fix: a bug fix
     docs: changes to documentation
     style: formatting, missing semi colons, etc; no code change
     refactor: refactoring production code
     test: adding tests, refactoring test; no production code change
     chore: updating build tasks, package manager configs, etc; no production code change    */
    
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

let id = ncc1701.identify()
