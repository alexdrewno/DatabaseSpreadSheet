//
//  ProductTableViewCell.swift
//  DatabaseSpreadsheet
//
//  Created by Alex Drewno on 12/21/18.
//  Copyright © 2018 Alex Drewno. All rights reserved.
//

import Foundation
import UIKit

class ProductTableViewCell: UITableViewCell {

    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var unitPriceLabel: UILabel!

    func setProduct(product: Product) {
        idLabel.text = product.id
        nameLabel.text = product.name
        unitPriceLabel.text = "\(product.cost)"
    }
}
