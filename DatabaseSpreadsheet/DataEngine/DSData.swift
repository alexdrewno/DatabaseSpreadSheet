//
//  DSData.swift
//  DatabaseSpreadsheet
//
//  Created by Alex Drewno on 7/8/19.
//  Copyright © 2019 Alex Drewno. All rights reserved.
//

import Foundation
import CoreData

class DSData {
    static let shared = DSData()
    
    public var products: [Product] = []
    public var infoSpreadsheets: [InfoSpreadsheet] = []
    public var inProgressSpreadsheets: [InfoSpreadsheet] = []
    public var completedSpreadsheets: [InfoSpreadsheet] = []
    
    func fetchProducts() {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Product")
        do {
            products = try DSDataController.shared.viewContext.fetch(fetchRequest) as! [Product]
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func fetchInfoSpreadsheets() {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "InfoSpreadsheet")
        do {
            infoSpreadsheets = try DSDataController.shared.viewContext.fetch(fetchRequest) as! [InfoSpreadsheet]
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func fetchInProgressInfoSpreadsheets() {
        fetchInfoSpreadsheets()
        inProgressSpreadsheets = infoSpreadsheets.filter({ (infoSpreadsheet) -> Bool in
            infoSpreadsheet.completed == false
        })
    }
    
    func fetchCompletedInfoSpreadsheets() {
        fetchInfoSpreadsheets()
        completedSpreadsheets = infoSpreadsheets.filter({ (infoSpreadsheet) -> Bool in
            infoSpreadsheet.completed == true
        })
    }
}
