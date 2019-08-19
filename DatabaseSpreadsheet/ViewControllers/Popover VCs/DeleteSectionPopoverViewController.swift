//
//  DeleteSectionPopoverViewController.swift
//  DatabaseSpreadsheet
//
//  Created by Alex Drewno on 8/19/19.
//  Copyright © 2019 Alex Drewno. All rights reserved.
//

import Foundation
import UIKit

// MARK: - View Controller Properties
class DeleteSectionPopoverViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var deleteSectionTableView: UITableView!
    var infoSpreadsheet: InfoSpreadsheet!
    var parentVC: InfoDetailViewController!

    override func viewDidLoad() {
        super.viewDidLoad()

        deleteSectionTableView.dataSource = self
        deleteSectionTableView.delegate = self
    }

    @IBAction func dismissPopover(_ sender: Any) {
        self.modalTransitionStyle = .crossDissolve
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: - TableView Delegate Protocol
extension DeleteSectionPopoverViewController {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sections = infoSpreadsheet.sections?.array as? [InfoProductSection] ?? []

        showDeleteSectionAlertView(section: sections[indexPath.row])
    }
}

// MARK: - TableView Data Source Protocol
extension DeleteSectionPopoverViewController {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sections = infoSpreadsheet.sections?.array as? [InfoProductSection] ?? []
        let tableViewCell = deleteSectionTableView.dequeueReusableCell(withIdentifier: "deleteSectionTableViewCell") as? DeleteSectionsTableViewCell ?? DeleteSectionsTableViewCell()

        tableViewCell.sectionName.text = sections[indexPath.row].name ?? ""

        return tableViewCell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return infoSpreadsheet.sections?.count ?? 0
    }
}

// MARK: - Data Manipulation
extension DeleteSectionPopoverViewController {
    func deleteSection(section: InfoProductSection) {
        infoSpreadsheet.removeFromSections(section)
        DSDataController.shared.saveProductContext()
        self.deleteSectionTableView.reloadData()
        self.parentVC.infoTableView.reloadData()
    }
}

// MARK: - UI
extension DeleteSectionPopoverViewController {
    func showDeleteSectionAlertView(section: InfoProductSection) {
        let alertVC = UIAlertController(title: "Delete Section",
                                        message: "Permanently delete section '\(section.name ?? "")' and all of its product rows?",
                                        preferredStyle: .alert)

        let deleteAction = UIAlertAction(title: "Delete", style: .default) { (_) in
            self.deleteSection(section: section)
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        alertVC.addAction(deleteAction)
        alertVC.addAction(cancelAction)

        present(alertVC, animated: true, completion: nil)
    }
}
