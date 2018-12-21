//
//  ProductPopoverViewController.swift
//  DatabaseSpreadsheet
//
//  Created by Alex Drewno on 12/21/18.
//  Copyright © 2018 Alex Drewno. All rights reserved.
//

import Foundation
import UIKit

class ProductPopoverViewController: UIViewController {
    @IBOutlet weak var addProductButton: UIButton!
    
    
    
    @IBAction func cancelTouchUpInside(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
