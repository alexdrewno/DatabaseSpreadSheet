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

// MARK: - ViewController Properties
class InfoDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate,
                                UITextFieldDelegate, UIPopoverPresentationControllerDelegate {
    @IBOutlet weak var infoTableView: UITableView!
    @IBOutlet weak var totalCostLabel: UILabel!
    @IBOutlet weak var estimateCostLabel: UILabel!
    var estimateTotal: Double = 0
    var actualTotal: Double = 0
    var new: Bool = false
    var infoSpreadsheet: InfoSpreadsheet?
    var curNum: Int = 0 {
        didSet {
            self.title = "Invoice #\(curNum)"
        }
    }

    override func viewDidLoad() {
        infoTableView.dataSource = self
        infoTableView.delegate = self
        setupUI()
        super.viewDidLoad()
    }

    func updateTotalLabels() {
        estimateTotal = 0
        actualTotal = 0

        for sectionRow in infoSpreadsheet?.sections?.array as? [InfoProductSection] ?? [] {
            for infoProduct in sectionRow.infoProducts?.array as? [InfoProduct] ?? [] {
                estimateTotal += infoProduct.estimateTotal
                actualTotal += infoProduct.asBuiltTotal
            }
        }

        estimateCostLabel.text = "Estimate Cost: $\(estimateTotal)"
        totalCostLabel.text = "Total Cost: $\(actualTotal)"
    }
}

// MARK: - TableView Properties
extension InfoDetailViewController {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 40))
        headerView.backgroundColor = UIColor(red: 249/255, green: 249/255, blue: 249/255, alpha: 1)
        headerView.layer.borderWidth = 1.5
        headerView.layer.borderColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1).cgColor
        let sectionLabel = UILabel(frame: CGRect(x: headerView.center.x,
                                                y: headerView.center.y,
                                                width: self.view.bounds.width,
                                                height: 40))
        sectionLabel.textAlignment = NSTextAlignment.center
        sectionLabel.center = headerView.center
        var objectArray: [InfoProductSection] = infoSpreadsheet?.sections?.array as? [InfoProductSection] ?? []
        sectionLabel.text = "\(objectArray[section].name ?? "")"
        sectionLabel.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.medium)
        sectionLabel.textColor = UIColor.black

        headerView.addSubview(sectionLabel)
        return headerView
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return infoSpreadsheet?.sections?.count ?? 0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let objectArray = infoSpreadsheet?.sections?.array as? [InfoProductSection] ?? []
        if objectArray == [] {
            return 1
        }
        return ((objectArray[section].infoProducts?.count) ?? 0 ) + 1
    }

    func checkAndUpdateWithKey(_ tableViewCell: InfoDetailTableViewCell, _ indexPath: IndexPath) {
        if let product = checkForProduct(with: tableViewCell.keyTextField.text ?? "") {
            if let infoProduct = getInfoProduct(for: indexPath) {
                infoProduct.name = product.name
                infoProduct.cost = product.cost
                saveProductContext()
            }
        }
    }

    fileprivate func addTableViewCellTextTargets(_ tableViewCell: InfoDetailTableViewCell) {
        tableViewCell.keyTextField.addTarget(self,
                                             action: #selector(textFieldDidChange(textField:)),
                                             for: .editingChanged)
        tableViewCell.keyTextField.addTarget(self,
                                             action: #selector(textFieldEndEditing(textField:)),
                                             for: .editingDidEnd)
        tableViewCell.descriptionTextField.addTarget(self,
                                                     action: #selector(textFieldDidChange(textField:)),
                                                     for: .editingChanged)
        tableViewCell.unitPriceTextField.addTarget(self,
                                                   action: #selector(textFieldDidChange(textField:)),
                                                   for: .editingChanged)
        tableViewCell.unitPriceTextField.addTarget(self,
                                                   action: #selector(textFieldEndEditing(textField:)),
                                                   for: .editingDidEnd)
        tableViewCell.estimateQTYTextField.addTarget(self,
                                                     action: #selector(textFieldDidChange(textField:)),
                                                     for: .editingChanged)
        tableViewCell.estimateQTYTextField.addTarget(self,
                                                     action: #selector(textFieldEndEditing(textField:)),
                                                     for: .editingDidEnd)
        tableViewCell.estimateTotalTextField.addTarget(self,
                                                       action: #selector(textFieldDidChange(textField:)),
                                                       for: .editingChanged)
        tableViewCell.asBuildQTYTextField.addTarget(self,
                                                    action: #selector(textFieldDidChange(textField:)),
                                                    for: .editingChanged)
        tableViewCell.asBuildQTYTextField.addTarget(self,
                                                    action: #selector(textFieldEndEditing(textField:)),
                                                    for: .editingDidEnd)
        tableViewCell.asBuildTotalTextField.addTarget(self,
                                                      action: #selector(textFieldDidChange(textField:)),
                                                      for: .editingChanged)
    }

    fileprivate func setTableViewCellTextFieldTags(_ tableViewCell: InfoDetailTableViewCell) {
        tableViewCell.keyTextField.tag = 1
        tableViewCell.descriptionTextField.tag = 2
        tableViewCell.unitPriceTextField.tag = 3
        tableViewCell.estimateQTYTextField.tag = 4
        tableViewCell.estimateTotalTextField.tag = 5
        tableViewCell.asBuildQTYTextField.tag = 6
        tableViewCell.asBuildTotalTextField.tag = 7
        tableViewCell.asBuildTotalTextField.isUserInteractionEnabled = false
        tableViewCell.estimateTotalTextField.isUserInteractionEnabled = false
    }

    fileprivate func updateTotalTextFields(_ indexPath: IndexPath) {
        if let infoProduct = getInfoProduct(for: indexPath) {
            infoProduct.estimateTotal = Double(round(100 * Double(infoProduct.estimateQTY) * infoProduct.cost) / 100)
            infoProduct.asBuiltTotal = Double(round(100 * Double(infoProduct.asBuiltQTY) * infoProduct.cost) / 100)
            saveProductContext()
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if indexPath.section == 0 && indexPath.row == 0 {
            estimateTotal = 0
            actualTotal = 0
        }

        let sectionArray: [InfoProductSection] = infoSpreadsheet?.sections?.array as? [InfoProductSection] ?? []

        var tableViewCell = UITableViewCell()
        if sectionArray[indexPath.section].infoProducts?.count ?? 0 > indexPath.row {
            if let tableViewCell =
                infoTableView.dequeueReusableCell(withIdentifier: "infoCell") as? InfoDetailTableViewCell {

                addTableViewCellTextTargets(tableViewCell)

                if let infoProduct: InfoProduct =
                    sectionArray[indexPath.section].infoProducts?[indexPath.row] as? InfoProduct {

                    tableViewCell.keyTextField.text = infoProduct.id
                    checkAndUpdateWithKey(tableViewCell, indexPath)
                    updateTotalTextFields(indexPath)

                    tableViewCell.descriptionTextField.text = infoProduct.name
                    tableViewCell.unitPriceTextField.text = "\(infoProduct.cost)"
                    tableViewCell.estimateQTYTextField.text = "\(infoProduct.estimateQTY)"
                    tableViewCell.estimateTotalTextField.text = "\(infoProduct.estimateTotal)"
                    tableViewCell.asBuildQTYTextField.text = "\(infoProduct.asBuiltQTY)"
                    tableViewCell.asBuildTotalTextField.text = "\(infoProduct.asBuiltTotal)"
                }

                setTableViewCellTextFieldTags(tableViewCell)
                updateTotalLabels()
            }
        } else {
            tableViewCell = infoTableView.dequeueReusableCell(withIdentifier: "addCell")!
        }

        return tableViewCell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

// MARK: - TableView Actions
extension InfoDetailViewController {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var sectionArray: [InfoProductSection] = infoSpreadsheet?.sections?.array as? [InfoProductSection] ?? []

        if sectionArray[indexPath.section].infoProducts?.count ?? (indexPath.row + 1) <= indexPath.row {
            let entity = NSEntityDescription.entity(forEntityName: "InfoProduct",
                                                    in: DSDataController.shared.viewContext)!
            let infoProduct = NSManagedObject(entity: entity,
                                              insertInto: DSDataController.shared.viewContext) as? InfoProduct ?? InfoProduct()
            infoProduct.setValue(0, forKey: "asBuiltQTY")
            infoProduct.setValue(0, forKey: "asBuiltTotal")
            infoProduct.setValue(0, forKey: "estimateQTY")
            infoProduct.setValue(0, forKey: "estimateTotal")
            sectionArray[indexPath.section].addToInfoProducts(infoProduct)
            saveProductContext()
            infoTableView.reloadData()
        }
    }

    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        let sectionArray: [InfoProductSection] = infoSpreadsheet?.sections?.array as? [InfoProductSection] ?? []
        if editingStyle == .delete {
            if let infoProduct = sectionArray[indexPath.section].infoProducts?[indexPath.row] as? InfoProduct {
                DSDataController.shared.viewContext.delete(infoProduct)
                saveProductContext()
            }
            tableView.reloadData()
        }
    }
}

// MARK: - UI
extension InfoDetailViewController {
    @objc func showPopoutView() {
        if let pvc = self.storyboard?.instantiateViewController(withIdentifier: "detailInfoPopover")
                    as? InfoDetailPopoverViewController {

            pvc.parentVC = self
            pvc.modalPresentationStyle = .popover
            pvc.preferredContentSize = CGSize(width: 200, height: 200)

            let popover = pvc.popoverPresentationController
            popover?.delegate = self as UIPopoverPresentationControllerDelegate
            popover?.barButtonItem = self.navigationItem.rightBarButtonItem

            present(pvc, animated: false, completion: nil)
        }
    }

    func showDeleteSectionPopoutView() {
        if let pvc = self.storyboard?.instantiateViewController(withIdentifier: "detailInfoDeleteSectionPopover")
            as? DeleteSectionPopoverViewController {

            pvc.modalPresentationStyle = .overCurrentContext
            pvc.modalTransitionStyle = .crossDissolve

            present(pvc, animated: true, completion: nil)
        }
    }

    func setupUI() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Actions",
                                                                 style: .plain,
                                                                 target: self,
                                                                 action: #selector(self.showPopoutView))

        if new {
            self.navigationItem.hidesBackButton = true
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Home",
                                                                    style: .plain,
                                                                    target: self,
                                                                    action: #selector(self.showHomeView))

        }
    }

    @objc func showHomeView() {
        navigationController?.popToRootViewController(animated: true)
    }
}

// MARK: - Textfield Delegation
extension InfoDetailViewController {
    @objc func textFieldDidChange(textField: UITextField) {
        if let cell: UITableViewCell = textField.superview?.superview as? UITableViewCell,
            let table: UITableView = cell.superview as? UITableView {

            if let textFieldIndexPath = table.indexPath(for: cell) {
                switch textField.tag {
                case 1:
                    if let infoProduct = getInfoProduct(for: textFieldIndexPath) {
                        infoProduct.id = textField.text!
                        saveProductContext()
                    }
                case 2:
                    if let infoProduct = getInfoProduct(for: textFieldIndexPath) {
                        infoProduct.name = textField.text!
                        saveProductContext()
                    }
                case 3:
                    if let infoProduct = getInfoProduct(for: textFieldIndexPath) {
                        infoProduct.cost = Double(textField.text!) ?? 0
                        saveProductContext()
                    }
                case 4:
                    if let infoProduct = getInfoProduct(for: textFieldIndexPath) {
                        infoProduct.estimateQTY = Int32(textField.text!) ?? 0
                        saveProductContext()
                    }
                case 5:
                    if let infoProduct = getInfoProduct(for: textFieldIndexPath) {
                        infoProduct.estimateTotal = Double(textField.text!) ?? 0
                        saveProductContext()
                    }
                case 6:
                    if let infoProduct = getInfoProduct(for: textFieldIndexPath) {
                        infoProduct.asBuiltQTY = Int32(textField.text!) ?? 0
                        saveProductContext()
                    }
                case 7:
                    if let infoProduct = getInfoProduct(for: textFieldIndexPath) {
                        infoProduct.asBuiltTotal = Double(textField.text!) ?? 0
                        saveProductContext()
                    }
                default:
                    print("Textfield Tag Not Found")
                }
            }
        }

        updateTotalLabels()
    }

    @objc func textFieldEndEditing(textField: UITextField) {
        if let cell: UITableViewCell = textField.superview?.superview as? UITableViewCell,
            let table: UITableView = cell.superview as? UITableView {

            if let textFieldIndexPath = table.indexPath(for: cell) {
                switch textField.tag {
                case 1:
                    if let product = checkForProduct(with: textField.text!) {
                        if let infoProduct = getInfoProduct(for: textFieldIndexPath) {
                            infoProduct.name = product.name
                            infoProduct.cost = product.cost
                            saveProductContext()
                            infoTableView.reloadData()
                        }
                    }
                case 3:
                    if let infoProduct = getInfoProduct(for: textFieldIndexPath) {
                        infoProduct.cost = Double(textField.text!) ?? 0
                        saveProductContext()
                    }
                    infoTableView.reloadData()
                case 4:
                    if let infoProduct = getInfoProduct(for: textFieldIndexPath) {
                        infoProduct.estimateQTY = Int32(textField.text!) ?? 0
                        saveProductContext()
                    }
                    infoTableView.reloadData()
                case 6:
                    if let infoProduct = getInfoProduct(for: textFieldIndexPath) {
                        infoProduct.asBuiltQTY = Int32(textField.text!) ?? 0
                        saveProductContext()
                    }
                    infoTableView.reloadData()
                default:
                    print("TEXT FIELD DID END EDITING")
                }
            }
        }
    }
}

// MARK: - Data Manipulation
extension InfoDetailViewController {
    func addSection() {
        let alert = UIAlertController(title: "Add New Section", message: nil, preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "Add", style: .default) { (_) in
            if let txtField = alert.textFields?.first, let text = txtField.text {
                let entity = NSEntityDescription.entity(forEntityName: "InfoProductSection",
                                                        in: DSDataController.shared.viewContext)!

                if let infoProductSection = NSManagedObject(entity: entity,
                                                            insertInto: DSDataController.shared.viewContext) as? InfoProductSection {
                    infoProductSection.name = text
                    self.infoSpreadsheet?.addToSections(infoProductSection)
                    self.saveProductContext()
                    self.infoTableView.reloadData()
                }
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

    func saveProductContext() {
        do {
            try DSDataController.shared.viewContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }

    func getInfoProduct(for indexPath: IndexPath) -> InfoProduct? {
        let sectionArray: [InfoProductSection] = infoSpreadsheet?.sections?.array as? [InfoProductSection] ?? []
        return sectionArray[indexPath.section].infoProducts?[indexPath.row] as? InfoProduct
    }

    func editClientInfo() {
        if let infoViewController =
            storyboard?.instantiateViewController(withIdentifier: "infoViewController") as? InfoViewController {
            infoViewController.editingExisting = true
            infoViewController.infoSpreadsheet = self.infoSpreadsheet
            navigationController?.pushViewController(infoViewController, animated: true)
        }
    }

    func exportInfoData() {
        CSVFile.createCSVStringFromInfo(infoSpreadsheet: infoSpreadsheet!, curViewController: self)
    }

    func markAsCompleted() {
        infoSpreadsheet?.completed = true
        saveProductContext()
    }

    func checkForProduct(with key: String) -> Product? {
        DSData.shared.fetchProducts()
        for product in DSData.shared.products where product.id == key {
                return product
        }
        return nil
    }
}
