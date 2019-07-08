//
//  InfoViewController.swift
//  DatabaseSpreadsheet
//
//  Created by Alex Drewno on 12/23/18.
//  Copyright © 2018 Alex Drewno. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class InfoViewController: UIViewController {
    @IBOutlet weak var numberTitleLabel: UILabel!
    @IBOutlet weak var clientTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var telephoneTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var jobDescriptionTextView: UITextView!
    var curNum : Int = 0 {
        didSet {
            numberTitleLabel.text = "Invoice #\(curNum)"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DSData.shared.fetchInfoSpreadsheets()
        numberTitleLabel.text = "Invoice #\(getCurrentInvoiceNumber())"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "infoDetailSegue") {
            let entity = NSEntityDescription.entity(forEntityName: "InfoSpreadsheet", in: DSDataController.shared.viewContext)!
            let infoSpreadsheet = NSManagedObject(entity: entity, insertInto: DSDataController.shared.viewContext) as! InfoSpreadsheet
            infoSpreadsheet.setValue(clientTextField.text ?? "", forKey: "client")
            infoSpreadsheet.setValue(dateTextField.text ?? "", forKey: "date")
            infoSpreadsheet.setValue(telephoneTextField.text ?? "", forKey: "telephone")
            infoSpreadsheet.setValue(emailTextField.text ?? "", forKey: "email")
            infoSpreadsheet.setValue(jobDescriptionTextView.text ?? "", forKey: "jobDescription")
            infoSpreadsheet.setValue(self.curNum, forKey: "curNum")
            self.saveContext(infoSpreadsheet: infoSpreadsheet)
            
            let dvc = segue.destination as! InfoDetailViewController
            
            dvc.infoSpreadsheet = infoSpreadsheet
        }
    }
    
    func getCurrentInvoiceNumber() -> Int {
        return DSData.shared.infoSpreadsheets.count + 1
    }
    
    func saveContext(infoSpreadsheet: InfoSpreadsheet) {
        do {
            try DSDataController.shared.viewContext.save()
            DSData.shared.infoSpreadsheets.append(infoSpreadsheet)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
}
