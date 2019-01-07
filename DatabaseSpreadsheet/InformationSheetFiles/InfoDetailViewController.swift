//
//  InfoDetailViewController.swift
//  DatabaseSpreadsheet
//
//  Created by Alex Drewno on 12/23/18.
//  Copyright © 2018 Alex Drewno. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase

class InfoDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    @IBOutlet weak var infoTableView: UITableView!
    @IBOutlet weak var totalCostLabel: UILabel!
    @IBOutlet weak var estimateCostLabel: UILabel!
    var estimateTotal : Double = 0
    var actualTotal : Double = 0
    var sections = [(name: String, sectionProducts: [InfoProduct])]()
    var products:[String:Any] =  [:]
    var ref: DatabaseReference!
    var productsLoaded: Bool = false
    
    override func viewDidLoad() {
        infoTableView.dataSource = self
        infoTableView.delegate = self
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.addSection))
        self.setupDatabase()
        super.viewDidLoad()
       
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].sectionProducts.count + 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.section == 0 && indexPath.row == 0) {
            estimateTotal = 0
            actualTotal = 0
        }
        
        var tableViewCell = UITableViewCell()
        if (sections[indexPath.section].sectionProducts.count > indexPath.row) {
            tableViewCell = infoTableView.dequeueReusableCell(withIdentifier: "infoCell") as! InfoDetailTableViewCell
            (tableViewCell as! InfoDetailTableViewCell).keyTextField.delegate = self
            (tableViewCell as! InfoDetailTableViewCell).descriptionTextField.delegate = self
            (tableViewCell as! InfoDetailTableViewCell).unitPriceTextField.delegate = self
            (tableViewCell as! InfoDetailTableViewCell).estimateQTYTextField.delegate = self
            (tableViewCell as! InfoDetailTableViewCell).estimateTotalTextField.delegate = self
            (tableViewCell as! InfoDetailTableViewCell).asBuildQTYTextField.delegate = self
            (tableViewCell as! InfoDetailTableViewCell).asBuildTotalTextField.delegate = self
            
            
            
            (tableViewCell as! InfoDetailTableViewCell).keyTextField.text = sections[indexPath.section].sectionProducts[indexPath.row].key
            (tableViewCell as! InfoDetailTableViewCell).descriptionTextField.text = sections[indexPath.section].sectionProducts[indexPath.row].description
            (tableViewCell as! InfoDetailTableViewCell).unitPriceTextField.text = sections[indexPath.section].sectionProducts[indexPath.row].unitPrice
            (tableViewCell as! InfoDetailTableViewCell).estimateQTYTextField.text = sections[indexPath.section].sectionProducts[indexPath.row].estimateQTY
            (tableViewCell as! InfoDetailTableViewCell).estimateTotalTextField.text = sections[indexPath.section].sectionProducts[indexPath.row].estimateTotal
            (tableViewCell as! InfoDetailTableViewCell).asBuildQTYTextField.text = sections[indexPath.section].sectionProducts[indexPath.row].asBuiltQTY
            (tableViewCell as! InfoDetailTableViewCell).asBuildTotalTextField.text = sections[indexPath.section].sectionProducts[indexPath.row].asBuiltTotal
            
            (tableViewCell as! InfoDetailTableViewCell).keyTextField.tag = 1
            (tableViewCell as! InfoDetailTableViewCell).descriptionTextField.tag = 2
            (tableViewCell as! InfoDetailTableViewCell).unitPriceTextField.tag = 3
            (tableViewCell as! InfoDetailTableViewCell).estimateQTYTextField.tag = 4
            (tableViewCell as! InfoDetailTableViewCell).estimateTotalTextField.tag = 5
            (tableViewCell as! InfoDetailTableViewCell).asBuildQTYTextField.tag = 6
            (tableViewCell as! InfoDetailTableViewCell).asBuildTotalTextField.tag = 7
            

            if let key = (tableViewCell as! InfoDetailTableViewCell).keyTextField.text {
                let foundProduct: [String: String] = checkForProduct(with: key)
                if foundProduct.count > 0 {
                    (tableViewCell as! InfoDetailTableViewCell).descriptionTextField.text = foundProduct["description"]
                    (tableViewCell as! InfoDetailTableViewCell).unitPriceTextField.text = foundProduct["cost"]
                }
            }
            
            if let estimateQTY = Double(sections[indexPath.section].sectionProducts[indexPath.row].estimateQTY),
                let unitPrice = Double(sections[indexPath.section].sectionProducts[indexPath.row].unitPrice) {
                sections[indexPath.section].sectionProducts[indexPath.row].estimateTotal = "\(estimateQTY * unitPrice)"
                (tableViewCell as! InfoDetailTableViewCell).estimateTotalTextField.text = sections[indexPath.section].sectionProducts[indexPath.row].estimateTotal
            }
            
            if let actualQTY = Double(sections[indexPath.section].sectionProducts[indexPath.row].asBuiltQTY),
                let unitPrice = Double(sections[indexPath.section].sectionProducts[indexPath.row].unitPrice) {
                sections[indexPath.section].sectionProducts[indexPath.row].asBuiltQTY = "\(actualQTY * unitPrice)"
                (tableViewCell as! InfoDetailTableViewCell).asBuildTotalTextField.text = sections[indexPath.section].sectionProducts[indexPath.row].asBuiltTotal
            }

            
        } else {
            tableViewCell = infoTableView.dequeueReusableCell(withIdentifier: "addCell")!
        }
      
        
        return tableViewCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    @objc func addSection() {
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if (sections[indexPath.section].sectionProducts.count <= indexPath.row) {
            sections[indexPath.section].sectionProducts.append(InfoProduct(key: "", description: "", unitPrice: "", estimateQTY: "", estimateTotal: "", asBuiltQTY: "", asBuiltTotal: ""))
            infoTableView.reloadData()
        }
    }
    
    func setupDatabase() {
        let ref = Database.database().reference()
        
        ref.observe(DataEventType.value) { (snapshot:DataSnapshot) in
            self.products = (snapshot.value as? [String:Any] ?? [:])["products"]! as! [String : Any]
            self.productsLoaded = true
            print(self.products)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
       
        let cell: UITableViewCell = textField.superview?.superview as! UITableViewCell
        let table: UITableView = cell.superview as! UITableView
        if let textFieldIndexPath = table.indexPath(for: cell) {
            switch textField.tag {
                case 1:
                    sections[textFieldIndexPath.section].sectionProducts[textFieldIndexPath.row].key = textField.text!
                    print("CALLED1")
                case 2:
                    sections[textFieldIndexPath.section].sectionProducts[textFieldIndexPath.row].description = textField.text!
                                  print("CALLED2")
                case 3:
                    sections[textFieldIndexPath.section].sectionProducts[textFieldIndexPath.row].unitPrice = textField.text!
                                    print("CALLED3")
                case 4:
                    sections[textFieldIndexPath.section].sectionProducts[textFieldIndexPath.row].estimateQTY = textField.text!
                                    print("CALLED4")
                case 5:
                    sections[textFieldIndexPath.section].sectionProducts[textFieldIndexPath.row].estimateTotal = textField.text!
                                    print("CALLED5")
                case 6:
                    sections[textFieldIndexPath.section].sectionProducts[textFieldIndexPath.row].asBuiltQTY = textField.text!
                                    print("CALLED6")
                case 7:
                    sections[textFieldIndexPath.section].sectionProducts[textFieldIndexPath.row].asBuiltTotal = textField.text!
                                    print("CALLED7")
                default:
                    print("TEXTFIELDNOTFONUD???????????")
            }
        }
        
    
        updateTotalLabels()
        self.infoTableView.reloadData()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
       
        
        let cell: UITableViewCell = textField.superview?.superview as! UITableViewCell
        let table: UITableView = cell.superview as! UITableView
        if let textFieldIndexPath = table.indexPath(for: cell) {
            switch textField.tag {
            case 1:
                sections[textFieldIndexPath.section].sectionProducts[textFieldIndexPath.row].key = textField.text!
                print("CALLED1")
            case 2:
                sections[textFieldIndexPath.section].sectionProducts[textFieldIndexPath.row].description = textField.text!
                print("CALLED2")
            case 3:
                sections[textFieldIndexPath.section].sectionProducts[textFieldIndexPath.row].unitPrice = textField.text!
                print("CALLED3")

            case 4:
                sections[textFieldIndexPath.section].sectionProducts[textFieldIndexPath.row].estimateQTY = textField.text!
                print("CALLED4")

            case 5:
                sections[textFieldIndexPath.section].sectionProducts[textFieldIndexPath.row].estimateTotal = textField.text!
                print("CALLED5")

            case 6:
                sections[textFieldIndexPath.section].sectionProducts[textFieldIndexPath.row].asBuiltQTY = textField.text!
                print("CALLED6")

            case 7:
                sections[textFieldIndexPath.section].sectionProducts[textFieldIndexPath.row].asBuiltTotal = textField.text!
                print("CALLED7")

            default:
                print("TEXTFIELDNOTFONUD???????????")
            }
        }
        
        updateTotalLabels()
        self.infoTableView.reloadData()
        return true
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
    
    func updateTotalLabels() {
        estimateTotal = 0
        actualTotal = 0
        
        for section in sections {
            for sectionProduct in section.sectionProducts {
                if let estimateAmount = Double(sectionProduct.estimateTotal) {
                    estimateTotal += estimateAmount
                }
                
                if let actualAmount = Double(sectionProduct.asBuiltTotal) {
                    actualTotal += actualAmount
                }
            }
        }
        
        estimateCostLabel.text = "Estimate Cost: $\(estimateTotal)"
        totalCostLabel.text = "Total Cost: $\(actualTotal)"
    }
    
}
