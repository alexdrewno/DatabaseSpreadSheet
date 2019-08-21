//
//  ProductViewController.swift
//  DatabaseSpreadsheet
//
//  Created by Alex Drewno on 12/20/18.
//  Copyright © 2018 Alex Drewno. All rights reserved.
//

import Foundation
import UIKit

// MARK: - ViewController Properties
class ProductViewController: UIViewController, UITableViewDataSource {
    @IBOutlet weak var productTableView: UITableView!
    var sortedKeys: [String] = []

    override func viewDidLoad() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                                 target: self,
                                                                 action: #selector(self.showProductPopover))
        productTableView.dataSource = self
        DSData.shared.fetchProducts()
        super.viewDidLoad()
    }

}

// MARK: - Tableview Properties
extension ProductViewController {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return DSData.shared.products.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            return productTableView.dequeueReusableCell(withIdentifier: "titleTableViewCell")!
        }

        if DSData.shared.products.count == 0 {
            return productTableView.dequeueReusableCell(withIdentifier: "productTableViewCell")!
        }

        let tableViewCell = productTableView.dequeueReusableCell(withIdentifier: "productTableViewCell")
                            as? ProductTableViewCell ?? ProductTableViewCell()

        tableViewCell.setProduct(product: DSData.shared.products[indexPath.row])

        return tableViewCell
    }
}

// MARK: - Tableview Actions
extension ProductViewController {
    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            DSDataController.shared.viewContext.delete(DSData.shared.products[indexPath.row])
            DSData.shared.fetchProducts()
            self.productTableView.reloadData()

        }
    }
}

// MARK: - Popover View
extension ProductViewController {
    @objc func showProductPopover() {
        performSegue(withIdentifier: "popoverProduct", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "popoverProduct" {
            if let dvc = segue.destination as? ProductPopoverViewController {
                dvc.sendingVC = self
            }
        }
    }
}
