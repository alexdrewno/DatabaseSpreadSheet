//
//  InfoViewController.swift
//  DatabaseSpreadsheet
//
//  Created by Alex Drewno on 12/23/18.
//  Copyright © 2018 Alex Drewno. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase

//TODO : Fix bug with invoice number

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
    
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        numberTitleLabel.text = "Invoice #\(getCurrentInvoiceNumber())"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "infoDetailSegue") {
            let dvc = segue.destination as! InfoDetailViewController
            
            dvc.infoSpreadsheet = InfoSpreadsheet()
            
            dvc.infoSpreadsheet.client = clientTextField.text ?? ""
            dvc.infoSpreadsheet.date = dateTextField.text ?? ""
            dvc.infoSpreadsheet.telephone = telephoneTextField.text ?? ""
            dvc.infoSpreadsheet.email = emailTextField.text ?? ""
            dvc.infoSpreadsheet.jobDescription = jobDescriptionTextView.text ?? ""
            dvc.curNum = self.curNum
            
        }
    }
    
    func getCurrentInvoiceNumber() {
        
        ref.child("invoices").observe(.value) { (snapshot: DataSnapshot) in
            self.curNum = Int(snapshot.childrenCount)
        }
    }
}
