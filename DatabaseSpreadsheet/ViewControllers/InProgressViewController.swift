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
    var spreadsheetToSend : InfoSpreadsheet!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DSData.shared.fetchInProgressInfoSpreadsheets()
        inProgressTableView.dataSource = self
        inProgressTableView.delegate = self
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let dvc = segue.destination as! InfoDetailViewController
        if segue.identifier == "inProgressDetail" {
            dvc.infoSpreadsheet = spreadsheetToSend
            dvc.curNum = Int(spreadsheetToSend.curNum)
        }
    }
}

//MARK: - TableView Properties
extension InProgressViewController {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DSData.shared.inProgressSpreadsheets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let inProgressCell = inProgressTableView.dequeueReusableCell(withIdentifier: "inProgressCell") as! InvoiceTableViewCell
        
        if DSData.shared.inProgressSpreadsheets.count > 0 {
            inProgressCell.dateLabel.text = DSData.shared.inProgressSpreadsheets[indexPath.row].date
            inProgressCell.descriptionLabel.text = DSData.shared.inProgressSpreadsheets[indexPath.row].jobDescription
            inProgressCell.clientLabel.text = DSData.shared.inProgressSpreadsheets[indexPath.row].client
            inProgressCell.invoiceLabel.text = "\(DSData.shared.inProgressSpreadsheets[indexPath.row].curNum)"
        }
        
        return inProgressCell
    }
}

//MARK: - TableView Actions
extension InProgressViewController {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //TODO: - There will be a bug here because NSSet != [:]
        spreadsheetToSend = DSData.shared.inProgressSpreadsheets[indexPath.row]
        performSegue(withIdentifier: "inProgressDetail", sender: nil)
    }
}
