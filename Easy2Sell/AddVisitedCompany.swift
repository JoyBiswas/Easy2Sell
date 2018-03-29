//
//  AddVisitedCompany.swift
//  Easy2Sell
//
//  Created by JOY BISWAS on 3/28/18.
//  Copyright © 2018 MacBook Air. All rights reserved.
//

import Foundation

class AddVisitedcompany {
    
    var id: String?
    var companyName: String?
    var companyAddress: String?
    var companyContact:String?
    var visitedDate:String?
    
    
    
    init(id: String?, companyName: String?, companyAddress: String?, companyContact:String?,date:String){
        self.id = id
        self.companyName = companyName
        self.companyAddress = companyAddress
        self.companyContact = companyContact
        self.visitedDate = date
        
    
    }
    
}
