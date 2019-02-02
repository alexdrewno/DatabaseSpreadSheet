//
//  InProgressViewController.swift
//  DatabaseSpreadsheet
//
//  Created by Alex Drewno on 1/15/19.
//  Copyright © 2019 Alex Drewno. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase

class InProgressViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var inProgressTableView: UITableView!
    var ref : DatabaseReference!
    var invoices : [NSDictionary] = []
    var sectionsToSend : [String: [NSDictionary]] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDatabase()
        getDatabaseInfo()
        inProgressTableView.dataSource = self
        inProgressTableView.delegate = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return invoices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let inProgressCell = inProgressTableView.dequeueReusableCell(withIdentifier: "inProgressCell") as! InvoiceTableViewCell
        
        if invoices.count > 0 {
            inProgressCell.dateLabel.text = invoices[indexPath.row]["date"] as! String
            inProgressCell.descriptionLabel.text = invoices[indexPath.row]["jobDescription"] as! String
            inProgressCell.clientLabel.text = invoices[indexPath.row]["client"] as! String
            inProgressCell.invoiceLabel.text = "\(indexPath.row)"
        
        }
        return inProgressCell
    }
    
    func setupDatabase() {
        ref = Database.database().reference()
    }
    
    func getDatabaseInfo() {
        ref.child("invoices").observe(DataEventType.value) { (snapshot:DataSnapshot) in
            self.invoices = (snapshot.value as? [NSDictionary] ?? [])
            self.inProgressTableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        sectionsToSend = self.invoices[indexPath.row]["sections"] as? [String: [NSDictionary]] ?? [:]
        performSegue(withIdentifier: "inProgressDetail", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let dvc = segue.destination as! InfoDetailViewController
        if segue.identifier == "inProgressDetail" {
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