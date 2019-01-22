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

//TODO : InProgressViewController
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
        let inProgressCell = inProgressTableView.dequeueReusableCell(withIdentifier: "inProgressCell") as! InProgressTableViewCell
        
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
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let dvc = segue.destination as! InfoDetailViewController
        if segue.identifier == "inProgressDetail" {
            //dvc.sections = self.sectionsToSend
        }
    }
    
}
