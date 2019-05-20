//
//  InProgressViewController.swift
//  DatabaseSpreadsheet
//
//  Created by Alex Drewno on 1/15/19.
//  Copyright © 2019 Alex Drewno. All rights reserved.
//

import Foundation
import UIKit


//MARK: - ViewController Properties
class InProgressViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var inProgressTableView: UITableView!
    var invoices : [NSDictionary] = []
    var sectionsToSend : [String: [NSDictionary]] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        inProgressTableView.dataSource = self
        inProgressTableView.delegate = self
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let dvc = segue.destination as! InfoDetailViewController
        if segue.identifier == "inProgressDetail" {
         
        }
    }
}

//MARK: - TableView Properties
extension InProgressViewController {
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
}

//MARK: - TableView Actions
extension InProgressViewController {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        sectionsToSend = self.invoices[indexPath.row]["sections"] as? [String: [NSDictionary]] ?? [:]
        performSegue(withIdentifier: "inProgressDetail", sender: nil)
    }
}
