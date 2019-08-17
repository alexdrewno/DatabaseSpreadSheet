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
    @IBOutlet weak var scrollView: UIScrollView!
    var editingExisting: Bool = false
    var infoSpreadsheet: InfoSpreadsheet? = nil
    var curNum : Int = 0 {
        didSet {
            numberTitleLabel.text = "Invoice #\(curNum)"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DSData.shared.fetchInfoSpreadsheets()
        setupUI()
        numberTitleLabel.text = "Invoice #\(getCurrentInvoiceNumber())"
    }
}

//MARK: - UI Setup
extension InfoViewController {
    func setupUI() {
        scrollView.contentSize.height = 1000
        jobDescriptionTextView.backgroundColor = .clear
        jobDescriptionTextView.layer.borderColor = UIColor.black.cgColor
        jobDescriptionTextView.layer.borderWidth = 1
        
        if editingExisting {
            setTextFields()
            navigationItem.hidesBackButton = true
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(saveEdit(sender:)))
        } else {
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(performDetailSegue(sender:)))
        }
    }
    
    func setTextFields() {
        if let infoSpreadsheet = self.infoSpreadsheet {
            clientTextField.text = infoSpreadsheet.client
            telephoneTextField.text = infoSpreadsheet.telephone
            jobDescriptionTextView.text = infoSpreadsheet.jobDescription
            emailTextField.text = infoSpreadsheet.email
            dateTextField.text = infoSpreadsheet.date
        }
    }
}

//MARK: - VC Flow
extension InfoViewController {
    @objc func performDetailSegue(sender: UIBarButtonItem) {
        performSegue(withIdentifier: "infoDetailSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "infoDetailSegue") {
            let entity = NSEntityDescription.entity(forEntityName: "InfoSpreadsheet", in: DSDataController.shared.viewContext)!
            let infoSpreadsheet = NSManagedObject(entity: entity, insertInto: DSDataController.shared.viewContext) as! InfoSpreadsheet
            setClientDataForSpreadsheet(infoSpreadsheet: infoSpreadsheet)
            
            self.saveContext(infoSpreadsheet: infoSpreadsheet)
            
            let dvc = segue.destination as! InfoDetailViewController
            
            dvc.new = true
            dvc.infoSpreadsheet = infoSpreadsheet
            dvc.curNum = Int(infoSpreadsheet.curNum)
        }
    }
}

//MARK: - Data
extension InfoViewController {
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
    
    @objc func saveEdit(sender: Any?) {
        setClientDataForSpreadsheet(infoSpreadsheet: self.infoSpreadsheet!)
        saveContext(infoSpreadsheet: infoSpreadsheet!)
        self.navigationController?.popViewController(animated: true)
    }
    
    func setClientDataForSpreadsheet(infoSpreadsheet: InfoSpreadsheet) {
        infoSpreadsheet.setValue(clientTextField.text ?? "", forKey: "client")
        infoSpreadsheet.setValue(dateTextField.text ?? "", forKey: "date")
        infoSpreadsheet.setValue(telephoneTextField.text ?? "", forKey: "telephone")
        infoSpreadsheet.setValue(emailTextField.text ?? "", forKey: "email")
        infoSpreadsheet.setValue(jobDescriptionTextView.text ?? "", forKey: "jobDescription")
        infoSpreadsheet.setValue(Int16(getCurrentInvoiceNumber()), forKey: "curNum")
    }
}
