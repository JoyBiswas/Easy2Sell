//
//  MySellHistory.swift
//  Easy2Sell
//
//  Created by JOY BISWAS on 4/3/18.
//  Copyright © 2018 MacBook Air. All rights reserved.
//

import Foundation

class MySellHistory {
    
    
    
    
    var id: String?
    var productName: String?
    var productCode: String?
    var productPrice:String?
    var tocompany:String?
    var totalPrice:String?
    var orderDate:String?
    
    
    
    init(id: String?, productName: String?, productCode: String?, productPrice:String?,toCompany:String, totalPrice:String?,orderDate:String?){
        self.id = id
        self.productName = productName
        self.productCode = productCode
        self.productPrice = productPrice
        self.tocompany = toCompany
        self.totalPrice = totalPrice
        self.orderDate = orderDate
        
        
    }
    

    
    
    
    
    
}
