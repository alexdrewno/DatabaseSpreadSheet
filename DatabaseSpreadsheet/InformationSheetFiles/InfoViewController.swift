//
//  InfoViewController.swift
//  DatabaseSpreadsheet
//
//  Created by Alex Drewno on 12/23/18.
//  Copyright © 2018 Alex Drewno. All rights reserved.
//

import Foundation
import UIKit

class InfoViewController: UIViewController {
    @IBOutlet weak var numberTitleLabel: UILabel!
    @IBOutlet weak var clientTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var telephoneTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var jobDescriptionTextView: UITextView!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "infoDetailSegue") {
            let dvc = segue.destination as! InfoDetailViewController
            
            //TODO : Saving drafts / sending information to database(?)
        }
    }
}
