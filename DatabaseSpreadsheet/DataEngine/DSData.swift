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
    
    func fetchProducts() {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Product")
        do {
            products = try DSDataController.shared.viewContext.fetch(fetchRequest) as! [Product]
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
}
