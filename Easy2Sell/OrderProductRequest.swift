//
//  OrderProductRequest.swift
//  Easy2Sell
//
//  Created by JOY BISWAS on 4/3/18.
//  Copyright © 2018 MacBook Air. All rights reserved.
//

import Foundation

class OrderProductRequset {
    
             

    
    var id: String?
    var productName: String?
    var productCode: String?
    var productPrice:String?
    var productQuantity:String?
    var tocompany:String?
    var totalPrice:String?
    var orderDate:String?
    var productType:String?
    var productOrderBy:String?
    var productOrdererAdress:String?
    var productOrdererPhn:String?
    var productDeliveryDate:String?
    
    
    
    init(id: String?, productName: String?, productCode: String?, productPrice:String?,toCompany:String, totalPrice:String?,orderDate:String?,productQuantity:String?,productOrderBy:String?,productOrdererAdress:String?,productOrdererPhn:String?,productDeliveryDate:String?){
    self.id = id
    self.productName = productName
    self.productCode = productCode
    self.productPrice = productPrice
    self.tocompany = toCompany
    self.totalPrice = totalPrice
    self.orderDate = orderDate
    self.productQuantity = productQuantity
    self.productOrderBy = productOrderBy
    self.productOrdererAdress = productOrdererAdress
    self.productOrdererPhn = productOrdererPhn
    self.productDeliveryDate = productDeliveryDate
    
    
    }
    
}
