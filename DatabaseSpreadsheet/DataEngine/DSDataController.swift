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
        let container = NSPersistentContainer(name: "DatabaseSpreadsheetModel")
        container.persistentStoreDescriptions.first?.shouldMigrateStoreAutomatically = true
        container.persistentStoreDescriptions.first?.shouldInferMappingModelAutomatically = true
        // could be set to true and hidden behind the launching animation + a loading screen if needed
        container.persistentStoreDescriptions.first?.shouldAddStoreAsynchronously = false
        container.persistentStoreDescriptions.first?.isReadOnly = false
        container.loadPersistentStores { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            } else {
                container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
                container.viewContext.automaticallyMergesChangesFromParent = true
            }
        }

        return container
    }()

    public var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    func saveProductContext() {
        do {
            try DSDataController.shared.viewContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
}
