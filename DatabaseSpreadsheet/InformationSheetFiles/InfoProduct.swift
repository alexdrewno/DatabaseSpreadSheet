//
//  InfoProduct.swift
//  DatabaseSpreadsheet
//
//  Created by Alex Drewno on 12/27/18.
//  Copyright © 2018 Alex Drewno. All rights reserved.
//

import Foundation
import UIKit

class InfoProduct {
    
    var key: String
    var description: String
    var unitPrice: String
    var estimateQTY: String
    var estimateTotal: String
    var asBuiltQTY: String
    var asBuiltTotal: String
    
    init(key: String, description: String, unitPrice: String, estimateQTY: String, estimateTotal: String, asBuiltQTY:String, asBuiltTotal:String) {
        self.key = key
        self.description = description
        self.unitPrice = unitPrice
        self.estimateQTY = estimateQTY
        self.estimateTotal = estimateTotal
        self.asBuiltQTY = asBuiltQTY
        self.asBuiltTotal = asBuiltTotal
    }
}
