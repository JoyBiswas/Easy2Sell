//
//  AddProductModel.swift
//  Easy2Sell
//
//  Created by JOY BISWAS on 3/22/18.
//  Copyright © 2018 MacBook Air. All rights reserved.
//

import Foundation
import Firebase

class AddProductModel {
    private var _productName: String!
    private var _productimageUrl: String!
    private var _productCode: String!
    private var _productType:String!
    private var _productPrice:String!
    private var _productDescription:String!
    private var _productKey: String!
    private var _pricePerQuantity:String!
    private var _productRef: DatabaseReference!
    
    var productName: String {
        
        return _productName
        
    }
    var pricePerQuantity: String {
        
        return _pricePerQuantity
        
    }
    
    var productimageUrl: String {
        return _productimageUrl
    }
    
    var productCode: String {
        return _productCode
    }
    
    var productType: String {
        
        return _productType
    }
    
    var productPrice: String {
        
        return _productPrice
    }
    
    var productDescription:String {
        
        return _productDescription
    }
    
    var productKey: String {
        return _productKey
    }
    
    init(productName: String, productimageUrl: String, productCode:String, productType:String, productPrice:String, productDescription:String,pricePerQuantity: String) {
        self._productName = productName
        self._productimageUrl = productimageUrl
        self._productCode = productCode
        self._productType = productType
        self._productPrice = productPrice
        self._productDescription = productDescription
        self._pricePerQuantity = pricePerQuantity
    }
    
    init(productKey: String, productData: Dictionary<String, AnyObject>) {
        self._productKey = productKey
        
        if let productName = productData["productName"] as? String {
            self._productName = productName
        }
        
        if let productimageUrl = productData["productimageUrl"] as? String {
            self._productimageUrl = productimageUrl
        }
        
        if let productCode = productData["productCode"] as? String {
            self._productCode = productCode
        }
        
        if let productType = productData["productType"] as? String {
            self._productType = productType
        }
        if let productPrice = productData["productPrice"] as? String {
            self._productPrice = productPrice
        }
        
        if let pricePerQuantity = productData["pricePerQuantity"] as? String {
            self._pricePerQuantity = pricePerQuantity
        }
        
        
        
        if let productDescription = productData["productDescription"] as? String {
            self._productDescription = productDescription
        }
        
        
        
        
        _productRef = DataService.ds.REF_Products.child(_productKey)
        
}
    

}
