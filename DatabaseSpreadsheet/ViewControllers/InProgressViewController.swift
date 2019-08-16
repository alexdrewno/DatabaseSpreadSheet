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
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            showConfirmDeletionView(for: indexPath)
        }
    }
}

//MARK : - Data Manipulation
extension InProgressViewController {
    func showConfirmDeletionView(for indexPath: IndexPath) {
        let spreadsheetNum = DSData.shared.inProgressSpreadsheets[indexPath.row].curNum
        
        let alertView = UIAlertController(title: "Delete", message: "You are about to delete invoice #\(spreadsheetNum) permanently. Delete?", preferredStyle: .alert)

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        let deleteAction = UIAlertAction(title: "Delete", style: .default) { (_) in
            let spreadsheetToDelete = DSData.shared.inProgressSpreadsheets.remove(at: indexPath.row)
            DSDataController.shared.viewContext.delete(spreadsheetToDelete)
            self.saveProductContext()
            DSData.shared.fetchInProgressInfoSpreadsheets()
            self.inProgressTableView.reloadData()
        }

        alertView.addAction(cancelAction)
        alertView.addAction(deleteAction)
        
        present(alertView, animated: true, completion: nil)
    }
    
    func saveProductContext() {
        do {
            try DSDataController.shared.viewContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
}
