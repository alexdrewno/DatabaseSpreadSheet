//
//  InfoDetailPopoverViewController.swift
//  DatabaseSpreadsheet
//
//  Created by Alex Drewno on 12/24/18.
//  Copyright © 2018 Alex Drewno. All rights reserved.
//

import Foundation
import UIKit

class InfoDetailPopoverViewController: UIViewController {
    var parentVC : InfoDetailViewController!
    override func viewDidLoad() {
        
    }
    
    @IBAction func addSection(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        parentVC.addSection()
    }
    
    @IBAction func markAsCompleted(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        parentVC.markAsCompleted()
    }
    
    @IBAction func exportInfo(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        parentVC.exportInfoData()
    }
    
    @IBAction func editClientInfo(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        parentVC.editClientInfo()
    }
    
}
