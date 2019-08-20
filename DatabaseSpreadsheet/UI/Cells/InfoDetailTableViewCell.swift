//
//  InfoDetailTableViewCell.swift
//  DatabaseSpreadsheet
//
//  Created by Alex Drewno on 12/23/18.
//  Copyright © 2018 Alex Drewno. All rights reserved.
//

import Foundation
import UIKit

@objc
protocol InfoDetailCellDelegate {
    func textFieldDidChange(textField: UITextField)
    func textFieldEndEditing(textField: UITextField)
}

// MARK: - InfoDetailTableViewCell Properties
class InfoDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var keyTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var unitPriceTextField: UITextField!
    @IBOutlet weak var estimateQTYTextField: UITextField!
    @IBOutlet weak var estimateTotalTextField: UITextField!
    @IBOutlet weak var asBuildQTYTextField: UITextField!
    @IBOutlet weak var asBuildTotalTextField: UITextField!

    weak var delegate: InfoDetailCellDelegate?

    func setInfoProduct(infoProduct: InfoProduct) {
        self.descriptionTextField.text = infoProduct.name
        self.unitPriceTextField.text = "\(infoProduct.cost)"
        self.estimateQTYTextField.text = "\(infoProduct.estimateQTY)"
        self.estimateTotalTextField.text = "\(infoProduct.estimateTotal)"
        self.asBuildQTYTextField.text = "\(infoProduct.asBuiltQTY)"
        self.asBuildTotalTextField.text = "\(infoProduct.asBuiltTotal)"
    }

    func setTableViewCellTextFieldTags() {
        self.keyTextField.tag = 1
        self.descriptionTextField.tag = 2
        self.unitPriceTextField.tag = 3
        self.estimateQTYTextField.tag = 4
        self.estimateTotalTextField.tag = 5
        self.asBuildQTYTextField.tag = 6
        self.asBuildTotalTextField.tag = 7
        self.asBuildTotalTextField.isUserInteractionEnabled = false
        self.estimateTotalTextField.isUserInteractionEnabled = false
    }

    func addTableViewCellTextTargets() {
        keyTextField.addTarget(self,
                               action: #selector(InfoDetailCellDelegate.textFieldDidChange(textField:)),
                               for: .editingChanged)
        keyTextField.addTarget(self,
                               action: #selector(InfoDetailCellDelegate.textFieldEndEditing(textField:)),
                               for: .editingDidEnd)
        descriptionTextField.addTarget(self,
                                       action: #selector(InfoDetailCellDelegate.textFieldDidChange(textField:)),
                                       for: .editingChanged)
        unitPriceTextField.addTarget(self,
                                     action: #selector(InfoDetailCellDelegate.textFieldDidChange(textField:)),
                                     for: .editingChanged)
        unitPriceTextField.addTarget(self,
                                     action: #selector(InfoDetailCellDelegate.textFieldEndEditing(textField:)),
                                     for: .editingDidEnd)
        estimateQTYTextField.addTarget(self,
                                       action: #selector(InfoDetailCellDelegate.textFieldDidChange(textField:)),
                                       for: .editingChanged)
        estimateQTYTextField.addTarget(self,
                                       action: #selector(InfoDetailCellDelegate.textFieldEndEditing(textField:)),
                                       for: .editingDidEnd)
        estimateTotalTextField.addTarget(self,
                                         action: #selector(InfoDetailCellDelegate.textFieldDidChange(textField:)),
                                         for: .editingChanged)
        asBuildQTYTextField.addTarget(self,
                                      action: #selector(InfoDetailCellDelegate.textFieldDidChange(textField:)),
                                      for: .editingChanged)
        asBuildQTYTextField.addTarget(self,
                                      action: #selector(InfoDetailCellDelegate.textFieldEndEditing(textField:)),
                                      for: .editingDidEnd)
        asBuildTotalTextField.addTarget(self,
                                        action: #selector(InfoDetailCellDelegate.textFieldDidChange(textField:)),
                                        for: .editingChanged)
    }

}

// MARK: - InfoDetailCellDelegate
extension InfoDetailTableViewCell: InfoDetailCellDelegate {
    func textFieldDidChange(textField: UITextField) {
        delegate?.textFieldDidChange(textField: textField)
    }

    func textFieldEndEditing(textField: UITextField) {
        delegate?.textFieldEndEditing(textField: textField)
    }
}
