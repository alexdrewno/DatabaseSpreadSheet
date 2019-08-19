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


// MARK: - TableView Data Source Protocol
extension DeleteSectionPopoverViewController {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let sections = DSData.shared.
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
}
