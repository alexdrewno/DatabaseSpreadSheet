//
//  InfoSpreadsheet.swift
//  DatabaseSpreadsheet
//
//  Created by Alex Drewno on 1/15/19.
//  Copyright © 2019 Alex Drewno. All rights reserved.
//

import Foundation
import UIKit

class InfoSpreadsheet {
    
    var client: String
    var date: String
    var telephone: String
    var email: String
    var jobDescription: String
    var sections: [(name: String, sectionProducts:[InfoProduct])]
    
    init() {
        client = ""
        date = ""
        telephone = ""
        email = ""
        jobDescription = ""
        sections = []
    }
    
    init(client: String, date: String, telephone: String, email: String, jobDescription: String, sections: [(name:String, sectionProducts:[InfoProduct])]) {
        self.client = client
        self.date = date
        self.telephone = telephone
        self.email = email
        self.jobDescription = jobDescription
        self.sections = sections
    }
    
    func toJson() -> Any {
        return [
            "client": client,
            "date": date,
            "telephone": telephone,
            "email": email,
            "jobDescription": jobDescription,
            "sections": sectionsToJson(),
        ]
    }
    
    func sectionsToJson() -> Any {
        var sectionsJson = [String: [NSDictionary]]()
        for section in sections {
            var sectionProductsJson : [NSDictionary] = []
            for sectionProduct in section.sectionProducts {
                sectionProductsJson.append(sectionProduct.toJson() as! NSDictionary)
                print(sectionProductsJson)
            }
            print("SECTION NAME \(section.name)")
            sectionsJson[section.name] = sectionProductsJson
        }
        
        return sectionsJson
    }
    
    
}
