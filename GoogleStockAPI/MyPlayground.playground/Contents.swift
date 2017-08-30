//: Playground - noun: a place where people can play

import Foundation
import UIKit
import RealmSwift

class Prices: Object {
    
    dynamic var ticker = ""
    dynamic var last = ""
    dynamic var time = ""
}


// ViewController.swift
//let realm = try! Realm()
//var priceList: Results<Prices> {
//    get {
//        return realm.objects(Prices)  //self.
//    }
//}

//let prices = Prices()
//
//prices.ticker = "AAPL"
//prices.last = "160.05"
//prices.time = "12:00 AM"


//try! realm.write ({
//    realm.add(prices)
//})



//---------------------------
class TodoItem: Object {
    dynamic var detail = ""
    dynamic var status = 0
}

// ViewController.swift
let realm = try! Realm()
var todoList: Results<TodoItem> {
    get {
        return realm.objects(TodoItem)  //self.
    }
}

// add action
//let todoItem = TodoItem()
//todoItem.detail = "A New Todo"
//todoItem.status = 0
//
//try! realm.write({                  // self.
//    realm.add(todoItem)        //self.
//    //self.tableView.insertRows(at: [IndexPath.init(row: self.todoList.count-1, section: 0)], with: .automatic)
//})

// for tableview
todoList.count

for  thing in todoList {
    print( "\(thing.detail) \(thing.status)")
}
