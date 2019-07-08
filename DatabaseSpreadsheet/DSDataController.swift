//
//  DSCoreDataController.swift
//  DatabaseSpreadsheet
//
//  Created by Alex Drewno on 7/8/19.
//  Copyright © 2019 Alex Drewno. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class DSDataController {
    static let shared = DSDataController()
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "DatabaseSpreadsheet")
        return container
    }()
    
    public var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
}
