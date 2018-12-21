//
//  ProductViewController.swift
//  DatabaseSpreadsheet
//
//  Created by Alex Drewno on 12/20/18.
//  Copyright © 2018 Alex Drewno. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class ProductViewController: UIViewController, UITableViewDataSource {
    @IBOutlet weak var productTableView: UITableView!
    @IBOutlet weak var addProductPopoverView: UIView!
    
    override func viewDidLoad() {
        showProductPopover()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.showProductPopover))
        productTableView.dataSource = self
        super.viewDidLoad()
    }
    
    @objc func showProductPopover() {
        performSegue(withIdentifier: "popoverProduct", sender: self)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
