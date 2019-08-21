//
//  ProductPopoverViewController.swift
//  DatabaseSpreadsheet
//
//  Created by Alex Drewno on 12/21/18.
//  Copyright © 2018 Alex Drewno. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class ProductPopoverViewController: UIViewController {

    @IBOutlet weak var addProductButton: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var costTextField: UITextField!
    var sendingVC: ProductViewController!

    override func viewDidLoad() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(UIViewController.keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(UIViewController.keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @IBAction func cancelTouchUpInside(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func addProductTouchUpInside(_ sender: Any) {

        if let cost = costTextField.text {
            if let name = nameTextField.text,
            let idText = idTextField.text,
            let costDouble = Double(cost) {
                let entity = NSEntityDescription.entity(forEntityName: "Product",
                                                        in: DSDataController.shared.viewContext)!
                if let newProduct = NSManagedObject(entity: entity,
                                                    insertInto: DSDataController.shared.viewContext) as? Product {
                    newProduct.setValue(costDouble, forKey: "cost")
                    newProduct.setValue(idText, forKey: "id")
                    newProduct.setValue(name, forKey: "name")
                    self.saveContext(newProduct: newProduct)
                }
            }
        }

        dismiss(animated: true, completion: nil)
    }

    func saveContext(newProduct: Product) {
        do {
            try DSDataController.shared.viewContext.save()
            DSData.shared.products.append(newProduct)
            sendingVC.productTableView.reloadData()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }

}
