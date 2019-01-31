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
    
    static func createCSVStringFromInfo(data : [(String, [InfoProduct])], estimateNum : Int, curViewController: UIViewController) {
        let fileName = "Tasks.csv"
        let path = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(fileName)
        var csvText = ""
        csvText += createHeader(estimateNum: estimateNum)
        
        do {
            try csvText.write(to: path!, atomically: true, encoding: String.Encoding.utf8)
            let vc = UIActivityViewController(activityItems: [path], applicationActivities: [])
            curViewController.present(vc, animated: true, completion: nil)
        } catch {
            print("Failed to create file")
            print("\(error)")
        }
    }
    
    static func createHeader(estimateNum : Int) -> String {
        var headerString = ""
        
        headerString += "R Drewno Electric Inc, , , Estimate, #\(estimateNum), Date:, 10/28/1998\n"
        headerString += "1216 S. Summit St\n"
        headerString += "Barrington IL 60010, , Service ordered by: , COMPANY NAME\n"
        headerString += "Tel. 847-791-6368, , , telephone:\n"
        headerString += "Email: RDrewnoElectric@sbcglobal.net, , , email:\n\n"
        headerString += "Job Description: , , JOB DESCRIPTION GOES HERE\n\n"
        headerString += " , , , , ESTIMATE, , AS BUILT\n"
        headerString += "Room, , Description, Unit Price, QTY, Total, QTY, Total\n"

        return headerString
    }
    
    static func createBody(data : [(String, Int)]) -> String {
        var csvString = ""
        
        return csvString
    }
    
}
