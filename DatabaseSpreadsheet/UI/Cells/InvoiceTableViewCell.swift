//
//  InProgressTableViewCell.swift
//  DatabaseSpreadsheet
//
//  Created by Alex Drewno on 1/15/19.
//  Copyright © 2019 Alex Drewno. All rights reserved.
//

import Foundation
import UIKit

class InvoiceTableViewCell: UITableViewCell {
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var invoiceLabel: UILabel!
    @IBOutlet weak var clientLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!

    func setInfoSpreadsheet(infoSpreadsheet: InfoSpreadsheet) {
        dateLabel.text = infoSpreadsheet.date
        descriptionLabel.text = infoSpreadsheet.jobDescription
        clientLabel.text = infoSpreadsheet.client
        invoiceLabel.text = "\(infoSpreadsheet.curNum)"
    }

}
