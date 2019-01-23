//
//  ProductViewController.swift
//  DatabaseSpreadsheet
//
//  Created by Alex Drewno on 12/20/18.
//  Copyright © 2018 Alex Drewno. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase


//TODO : Search Function from TableView
//TODO : Delete Items from TableView
class ProductViewController: UIViewController, UITableViewDataSource {
    @IBOutlet weak var productTableView: UITableView!
    var ref: DatabaseReference!
    var jsonData:[String:Any] =  [:]
    
    override func viewDidLoad() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.showProductPopover))
        productTableView.dataSource = self
        setupDatabase()
        
        super.viewDidLoad()
    }
    
    @objc func showProductPopover() {
        performSegue(withIdentifier: "popoverProduct", sender: self)
    }
    
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
        tableViewCell.nameLabel.text = Array(jsonData.keys)[indexPath.row]
        return tableViewCell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {

            jsonData.removeValue(forKey: Array(jsonData.keys)[indexPath.row])
            ref.child("products").setValue(jsonData)
            self.productTableView.reloadData()
            
        }
    }
    
    func setupDatabase() {
        ref = Database.database().reference()
        
        ref.child("products").observe(DataEventType.value) { (snapshot:DataSnapshot) in
            self.jsonData = snapshot.value as? [String:Any] ?? [:]
            self.productTableView.reloadData()
        }
    }
}
