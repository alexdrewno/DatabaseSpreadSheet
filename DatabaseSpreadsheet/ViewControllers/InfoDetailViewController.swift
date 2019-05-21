//
//  InfoDetailViewController.swift
//  DatabaseSpreadsheet
//
//  Created by Alex Drewno on 12/23/18.
//  Copyright © 2018 Alex Drewno. All rights reserved.
//

import Foundation
import UIKit
import CoreData


//TODO : Deletion from TableView
//TODO : Test Export on actual device

//MARK: - ViewController Properties
class InfoDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UIPopoverPresentationControllerDelegate {
    @IBOutlet weak var infoTableView: UITableView!
    @IBOutlet weak var totalCostLabel: UILabel!
    @IBOutlet weak var estimateCostLabel: UILabel!
    var estimateTotal : Double = 0
    var actualTotal : Double = 0
    var sections = [InfoProductSection]()
    var products:[String:Any] =  [:]
    var productsLoaded: Bool = false
    var infoSpreadsheet: InfoSpreadsheet = InfoSpreadsheet()
    var curNum : Int = 0 {
        didSet {
            self.title = "Invoice #\(curNum)"
        }
    }
    
    override func viewDidLoad() {
        infoTableView.dataSource = self
        infoTableView.delegate = self
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.showPopoutView))
        self.setupDatabase()
        super.viewDidLoad()
       
    }
    
    
    func updateTotalLabels() {
        estimateTotal = 0
        actualTotal = 0
        
//        for section in sections {
//            for sectionProduct in section.sectionProducts {
//                if let estimateAmount = Double(sectionProduct.estimateTotal) {
//                    estimateTotal += estimateAmount
//                }
//
//                if let actualAmount = Double(sectionProduct.asBuiltTotal) {
//                    actualTotal += actualAmount
//                }
//            }
//        }
        
        estimateCostLabel.text = "Estimate Cost: $\(estimateTotal)"
        totalCostLabel.text = "Total Cost: $\(actualTotal)"
    }
}

//MARK: - TableView Properties
extension InfoDetailViewController {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 40))
        headerView.backgroundColor = UIColor.lightGray
        let sectionLabel = UILabel(frame: CGRect(x: headerView.center.x, y: headerView.center.y, width: self.view.bounds.width, height: 40))
        sectionLabel.textAlignment = NSTextAlignment.center
        sectionLabel.center = headerView.center
        sectionLabel.text = "\(sections[section].name)"
        sectionLabel.font = UIFont.boldSystemFont(ofSize: 24)
        sectionLabel.textColor = UIColor.black
        
        headerView.addSubview(sectionLabel)
        return headerView
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //TODO :- Fix this
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.section == 0 && indexPath.row == 0) {
            estimateTotal = 0
            actualTotal = 0
        }
        
        var tableViewCell = UITableViewCell()
        if (count > indexPath.row) {
//            tableViewCell = (infoTableView.dequeueReusableCell(withIdentifier: "infoCell") as! InfoDetailTableViewCell)
//
//            (tableViewCell as! InfoDetailTableViewCell).keyTextField.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
//            (tableViewCell as! InfoDetailTableViewCell).descriptionTextField.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
//            (tableViewCell as! InfoDetailTableViewCell).unitPriceTextField.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
//            (tableViewCell as! InfoDetailTableViewCell).estimateQTYTextField.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
//            (tableViewCell as! InfoDetailTableViewCell).estimateTotalTextField.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
//            (tableViewCell as! InfoDetailTableViewCell).asBuildQTYTextField.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
//            (tableViewCell as! InfoDetailTableViewCell).asBuildTotalTextField.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
//
//
//            (tableViewCell as! InfoDetailTableViewCell).keyTextField.text = sections[indexPath.section].sectionProducts[indexPath.row].key
//            (tableViewCell as! InfoDetailTableViewCell).descriptionTextField.text = sections[indexPath.section].sectionProducts[indexPath.row].description
//            (tableViewCell as! InfoDetailTableViewCell).unitPriceTextField.text = sections[indexPath.section].sectionProducts[indexPath.row].unitPrice
//            (tableViewCell as! InfoDetailTableViewCell).estimateQTYTextField.text = sections[indexPath.section].sectionProducts[indexPath.row].estimateQTY
//            (tableViewCell as! InfoDetailTableViewCell).estimateTotalTextField.text = sections[indexPath.section].sectionProducts[indexPath.row].estimateTotal
//            (tableViewCell as! InfoDetailTableViewCell).asBuildQTYTextField.text = sections[indexPath.section].sectionProducts[indexPath.row].asBuiltQTY
//            (tableViewCell as! InfoDetailTableViewCell).asBuildTotalTextField.text = sections[indexPath.section].sectionProducts[indexPath.row].asBuiltTotal
//
//            (tableViewCell as! InfoDetailTableViewCell).keyTextField.tag = 1
//            (tableViewCell as! InfoDetailTableViewCell).descriptionTextField.tag = 2
//            (tableViewCell as! InfoDetailTableViewCell).unitPriceTextField.tag = 3
//            (tableViewCell as! InfoDetailTableViewCell).estimateQTYTextField.tag = 4
//            (tableViewCell as! InfoDetailTableViewCell).estimateTotalTextField.tag = 5
//            (tableViewCell as! InfoDetailTableViewCell).asBuildQTYTextField.tag = 6
//            (tableViewCell as! InfoDetailTableViewCell).asBuildTotalTextField.tag = 7
//
//
//            if let key = (tableViewCell as! InfoDetailTableViewCell).keyTextField.text {
//                let foundProduct: [String: String] = checkForProduct(with: key)
//                if foundProduct.count > 0 &&
//                    ((tableViewCell as! InfoDetailTableViewCell).descriptionTextField.text != foundProduct["description"] &&
//                        ((tableViewCell as! InfoDetailTableViewCell).unitPriceTextField.text != foundProduct["cost"])) {
//                    (tableViewCell as! InfoDetailTableViewCell).descriptionTextField.text = foundProduct["description"]
//                    (tableViewCell as! InfoDetailTableViewCell).unitPriceTextField.text = foundProduct["cost"]
//                    sections[indexPath.section].sectionProducts[indexPath.row].description = foundProduct["description"] ?? ""
//                    sections[indexPath.section].sectionProducts[indexPath.row].unitPrice = foundProduct["cost"] ?? ""
//                    self.infoTableView.reloadData()
//                }
//            }
//
//            if let estimateQTY = Double(sections[indexPath.section].sectionProducts[indexPath.row].estimateQTY),
//                let unitPrice = Double(sections[indexPath.section].sectionProducts[indexPath.row].unitPrice) {
//                sections[indexPath.section].sectionProducts[indexPath.row].estimateTotal = "\(estimateQTY * unitPrice)"
//                (tableViewCell as! InfoDetailTableViewCell).estimateTotalTextField.text = sections[indexPath.section].sectionProducts[indexPath.row].estimateTotal
//            }
//
//            if let actualQTY = Double(sections[indexPath.section].sectionProducts[indexPath.row].asBuiltQTY),
//                let unitPrice = Double(sections[indexPath.section].sectionProducts[indexPath.row].unitPrice) {
//                sections[indexPath.section].sectionProducts[indexPath.row].asBuiltTotal = "\(actualQTY * unitPrice)"
//                (tableViewCell as! InfoDetailTableViewCell).asBuildTotalTextField.text = sections[indexPath.section].sectionProducts[indexPath.row].asBuiltTotal
//            }
//
            
        } else {
            tableViewCell = infoTableView.dequeueReusableCell(withIdentifier: "addCell")!
        }
        
        
        return tableViewCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

//MARK: - TableView Actions
extension InfoDetailViewController {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (sections[indexPath.section] <= indexPath.row) {
            sections[indexPath.section].sectionProducts.append(InfoProduct(key: "", description: "", unitPrice: "", estimateQTY: "", estimateTotal: "", asBuiltQTY: "", asBuiltTotal: ""))
            infoTableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            sections[indexPath.section].sectionProducts.remove(at: indexPath.row)
            tableView.reloadData()
        }
    }
}


//MARK: - Popout View
extension InfoDetailViewController {
    @objc func showPopoutView() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "detailInfoPopover") as! InfoDetailPopoverViewController
        vc.parentVC = self
        vc.modalPresentationStyle = .popover
        vc.preferredContentSize = CGSize(width: 200, height: 200)
        
        
        let popover = vc.popoverPresentationController
        popover?.delegate = self as! UIPopoverPresentationControllerDelegate
        popover?.barButtonItem = self.navigationItem.rightBarButtonItem
        
        present(vc, animated: false, completion: nil)
    }
}

//MARK: - Textfield Delegation
extension InfoDetailViewController {
    @objc func textFieldDidChange(textField: UITextField) {
        let cell: UITableViewCell = textField.superview?.superview as! UITableViewCell
        let table: UITableView = cell.superview as! UITableView
        if let textFieldIndexPath = table.indexPath(for: cell) {
            switch textField.tag {
            case 1:
                sections[textFieldIndexPath.section].sectionProducts[textFieldIndexPath.row].key = textField.text!
                let foundProduct: [String: String] = checkForProduct(with: textField.text ?? "")
                if foundProduct.count > 0 {
                    self.infoTableView.reloadData()
                }
            case 2:
                sections[textFieldIndexPath.section].sectionProducts[textFieldIndexPath.row].description = textField.text!
            case 3:
                sections[textFieldIndexPath.section].sectionProducts[textFieldIndexPath.row].unitPrice = textField.text!
            case 4:
                sections[textFieldIndexPath.section].sectionProducts[textFieldIndexPath.row].estimateQTY = textField.text!
            case 5:
                sections[textFieldIndexPath.section].sectionProducts[textFieldIndexPath.row].estimateTotal = textField.text!
            case 6:
                sections[textFieldIndexPath.section].sectionProducts[textFieldIndexPath.row].asBuiltQTY = textField.text!
            case 7:
                sections[textFieldIndexPath.section].sectionProducts[textFieldIndexPath.row].asBuiltTotal = textField.text!
            default:
                print("TEXTFIELDNOTFONUD???????????")
            }
        }
        
        updateTotalLabels()
    }
}

//MARK: - Product Manipulation
extension InfoDetailViewController {
    func addSection() {
        let alert = UIAlertController(title: "Add New Section", message: nil, preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "Add", style: .default) { (_) in
            if let txtField = alert.textFields?.first, let text = txtField.text {
                self.sections.append((text,[]))
                self.infoTableView.reloadData()
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        alert.addTextField { (textField) in
            textField.placeholder = "Section Name"
        }
        alert.addAction(confirmAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    func exportInfoData() {
        CSVFile.createCSVStringFromInfo(data: sections, estimateNum: 0, curViewController: self)
    }
    
    func checkForProduct(with key:String) -> Dictionary<String, String> {
        if productsLoaded {
            for (name,product) in products {
                let idArray: Array = (product as! [String: Any])["id"]! as! [String]
                for id in idArray {
                    if (id == key) {
                        var tuple: [String: String] = [:]
                        tuple["description"] = name
                        tuple["cost"] = "\((product as! [String: Any])["cost"] as! Double)"
                        return tuple
                    }
                }
            }
        }
        return [:]
    }
}
