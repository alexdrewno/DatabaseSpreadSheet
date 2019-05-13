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

    override func viewDidLoad() {
       
    }
    
    @IBAction func cancelTouchUpInside(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addProductTouchUpInside(_ sender: Any) {
        
        if let cost = costTextField.text{
            if let name = nameTextField.text,
            let id = idTextField.text,
            let costDouble = Double(cost) {
                let newProduct = Product()
                newProduct.cost = costDouble
                newProduct.id = id
                newProduct.name = name
            }
        }
        
        dismiss(animated: true, completion: nil)
    }
    
}
