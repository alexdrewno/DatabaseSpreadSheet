//
//  CSVFile.swift
//  DatabaseSpreadsheet
//
//  Created by Alex Drewno on 1/7/19.
//  Copyright © 2019 Alex Drewno. All rights reserved.
//

import Foundation
import UIKit

class CSVFile {
    
    static func createCSVStringFromInfo(infoSpreadsheet: InfoSpreadsheet, curViewController: UIViewController) {
        let fileName = "\(infoSpreadsheet.client ?? "RD")_INVOICE.csv"
        let path = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(fileName)
        var csvText = ""

        csvText += createHeader(infoSpreadsheet: infoSpreadsheet)
        csvText += createBody(infoSpreadsheet: infoSpreadsheet)
        csvText += createEnd(infoSpreadsheet: infoSpreadsheet)
        
        do {
            try csvText.write(to: path!, atomically: true, encoding: String.Encoding.utf8)
            if path != nil {
                let avc = UIActivityViewController(activityItems: [path!], applicationActivities: [])
                avc.popoverPresentationController?.sourceView = curViewController.navigationController?.navigationBar
                curViewController.present(avc, animated: true, completion: nil)
            }
        } catch {
            print("Failed to create file")
            print("\(error)")
        }
    }

    static func createHeader(infoSpreadsheet: InfoSpreadsheet) -> String {
        var headerString = ""

        headerString += "R Drewno Electric Inc, , , Estimate, #\(infoSpreadsheet.curNum), Date:, \(infoSpreadsheet.date ?? "")\n"
        headerString += "1216 S. Summit St\n"
        headerString += "Barrington IL 60010, , , Service ordered by: , \(infoSpreadsheet.client ?? "")\n"
        headerString += "Tel. 847-791-6368, , , telephone:, \(infoSpreadsheet.telephone ?? "") \n"
        headerString += "Email: RDrewnoElectric@sbcglobal.net, , , email:\n\n"
        headerString += "Job Description: , \(infoSpreadsheet.jobDescription ?? "")\n\n"
        headerString += " , , , , ESTIMATE, , AS BUILT\n"
        headerString += "Room, , Description, Unit Price, QTY, Total, QTY, Total\n\n"

        return headerString
    }

    static func createBody(infoSpreadsheet: InfoSpreadsheet) -> String {
        var csvString = ""

        if let sections: [InfoProductSection] = infoSpreadsheet.sections?.array as? [InfoProductSection] {
            for section: InfoProductSection in sections {
                if let products = section.infoProducts?.array as? [InfoProduct] {
                    for product: InfoProduct in products {
                        csvString += "\(section.name ?? ""), , \(product.name ?? ""), \(product.cost), "
                        csvString += "\(product.estimateQTY), \(product.estimateTotal), \(product.asBuiltQTY), \(product.estimateTotal)\n"
                    }
                }
                csvString += "\n"
            }
        }

        return csvString
    }

    static func createEnd(infoSpreadsheet: InfoSpreadsheet) -> String {
        var csvString = ""
        var estimateTotal = 0.0
        var asBuiltTotal = 0.0

        if let sections: [InfoProductSection] = infoSpreadsheet.sections?.array as? [InfoProductSection] {
            for section: InfoProductSection in sections {
                if let products = section.infoProducts?.array as? [InfoProduct] {
                    for product: InfoProduct in products {
                        estimateTotal += product.estimateTotal
                        asBuiltTotal += product.asBuiltTotal
                    }
                }
            }
        }
        csvString += "\n\n\n"
        csvString += " , , , , TOTAL COST, \(estimateTotal), , \(asBuiltTotal)\n\n"

        return csvString
    }

}
