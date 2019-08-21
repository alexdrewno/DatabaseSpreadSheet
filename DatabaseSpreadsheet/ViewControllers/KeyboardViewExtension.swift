//
//  KeyboardViewExtension.swift
//  DatabaseSpreadsheet
//
//  Created by Alex Drewno on 8/20/19.
//  Copyright © 2019 Alex Drewno. All rights reserved.
//

import Foundation
import UIKit

// CODE USED FROM https://stackoverflow.com/questions/29951979/uiviewcontroller-extension-not-allowing-to-override-view-related-functions-in-sw

extension UIViewController {
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey]
            as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height/2
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
}
