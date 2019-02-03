//
//  CompletedViewController.swift
//  DatabaseSpreadsheet
//
//  Created by Alex Drewno on 1/26/19.
//  Copyright © 2019 Alex Drewno. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase

//MARK: - ViewController Properties
class CompletedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var completeTableView: UITableView!
    var ref : DatabaseReference!
    var invoices : [NSDictionary] = []
    var sectionsToSend : [String: [NSDictionary]] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupDatabase()
        getDatabaseInfo()
        completeTableView.dataSource = self
        completeTableView.delegate = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let dvc = segue.destination as! InfoDetailViewController
        if segue.identifier == "completedDetail" {
            var sectionsToSet = [(name: String, sectionProducts: [InfoProduct])]()
            for section in sectionsToSend {
                let name = section.key
                var sectionProducts: [InfoProduct] = []
                
                for row in section.value {
                    let newProduct = InfoProduct(key: row["key"] as! String, description: row["description"] as! String, unitPrice: row["unitPrice"] as! String, estimateQTY: row["estimateQTY"] as! String, estimateTotal: row["estimateTotal"] as! String, asBuiltQTY: row["asBuiltQTY"] as! String, asBuiltTotal: row["asBuiltTotal"] as! String)
                    
                    sectionProducts.append(newProduct)
                }
                
                sectionsToSet.append((name:name, sectionProducts: sectionProducts))
                dvc.sections = sectionsToSet
            }
        }
    }
    
}


//MARK: - TableView Properties
extension CompletedViewController {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.invoices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let completedCell = completeTableView.dequeueReusableCell(withIdentifier: "completedCell") as! InvoiceTableViewCell
        
        if invoices.count > 0 {
            completedCell.dateLabel.text = invoices[indexPath.row]["date"] as! String
            completedCell.descriptionLabel.text = invoices[indexPath.row]["jobDescription"] as! String
            completedCell.clientLabel.text = invoices[indexPath.row]["client"] as! String
            completedCell.invoiceLabel.text = "\(indexPath.row)"
            
        }
        
        return completedCell
    }
}

//MARK: - TableView Actions
extension CompletedViewController {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        sectionsToSend = self.invoices[indexPath.row]["sections"] as? [String: [NSDictionary]] ?? [:]
        performSegue(withIdentifier: "completedDetail", sender: nil)
    }
}

//MARK: - Database
extension CompletedViewController {
    func setupDatabase() {
        ref = Database.database().reference()
    }
    
    func getDatabaseInfo() {
        ref.child("invoices").observe(DataEventType.value) { (snapshot:DataSnapshot) in
            self.invoices = (snapshot.value as? [NSDictionary] ?? [])
            self.completeTableView.reloadData()
        }
    }
}

