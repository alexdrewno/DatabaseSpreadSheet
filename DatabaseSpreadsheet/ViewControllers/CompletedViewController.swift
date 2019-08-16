//
//  CompletedViewController.swift
//  DatabaseSpreadsheet
//
//  Created by Alex Drewno on 1/26/19.
//  Copyright © 2019 Alex Drewno. All rights reserved.
//

import Foundation
import UIKit

//MARK: - ViewController Properties
class CompletedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var completeTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DSData.shared.fetchCompletedInfoSpreadsheets()

        completeTableView.dataSource = self
        completeTableView.delegate = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        _ = segue.destination as! InfoDetailViewController
        if segue.identifier == "completedDetail" {
            
        }
    }
    
}


//MARK: - TableView Properties
extension CompletedViewController {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DSData.shared.completedSpreadsheets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let completedCell = completeTableView.dequeueReusableCell(withIdentifier: "completedCell") as! InvoiceTableViewCell
        
        return completedCell
    }
}

//MARK: - TableView Actions
extension CompletedViewController {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           performSegue(withIdentifier: "completedDetail", sender: nil)
    }
}

