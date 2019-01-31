//
//  Product.swift
//  DatabaseSpreadsheet
//
//  Created by Alex Drewno on 12/21/18.
//  Copyright © 2018 Alex Drewno. All rights reserved.
//

import Foundation
import UIKit

class Product {
    var name: String
    var id: [String]
    var cost: Double
    
    init(name: String, id: [String], cost: Double) {
        self.name = name
        self.id = id
        self.cost = cost
    }
    
    func getJsonData() -> [String: Any] {
        return [
            name: [
                "id": id,
                "cost": cost
            ]
        ]
    }
    
}

