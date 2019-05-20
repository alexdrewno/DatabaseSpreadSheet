//
//  ProductViewController.swift
//  DatabaseSpreadsheet
//
//  Created by Alex Drewno on 12/20/18.
//  Copyright © 2018 Alex Drewno. All rights reserved.
//

import Foundation
import UIKit


//MARK: - ViewController Properties
class ProductViewController: UIViewController, UITableViewDataSource {
    @IBOutlet weak var productTableView: UITableView!
    var jsonData:[String:Any] =  [:]
    var sortedKeys:[String] = []
    
    override func viewDidLoad() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.showProductPopover))
        productTableView.dataSource = self
        
        super.viewDidLoad()
    }
    
}

//MARK: - Tableview Properties
extension ProductViewController {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return jsonData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if jsonData.count == 0 {
            return productTableView.dequeueReusableCell(withIdentifier: "productTableViewCell")!
        }
        
        let tableViewCell = productTableView.dequeueReusableCell(withIdentifier: "productTableViewCell") as! ProductTableViewCell
        tableViewCell.nameLabel.text = sortedKeys[indexPath.row]
        return tableViewCell
    }
}

//MARK: - Tableview Actions
extension ProductViewController {
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            jsonData.removeValue(forKey: sortedKeys[indexPath.row])
            self.productTableView.reloadData()
            
        }
    }
}


//MARK: - Popover View
extension ProductViewController {
    @objc func showProductPopover() {
        performSegue(withIdentifier: "popoverProduct", sender: self)
    }
}
