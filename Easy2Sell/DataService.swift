//
//  DataService.swift
//  Social Network
//
//  Created by JOY BISWAS on 3/6/18.
//  Copyright © 2018 MacBook Air. All rights reserved.
//

import Foundation

import Firebase
import SwiftKeychainWrapper

let DB_BASE = Database.database().reference()
let STORAGE_BASE = Storage.storage().reference()

class DataService {
    
    static let ds = DataService()
    
    // DB references
    private var _REF_BASE = DB_BASE
    private var _REF_Products = DB_BASE.child("Products")
    private var _REF_USERS = DB_BASE.child("users")
    
    private var _REf_ORDER_REQUEST_LIST = DB_BASE.child("productOrderReqList")
    
    // Storage references
    private var _Ref_Emp_ProFile_Images = STORAGE_BASE.child("AdMinprofile-Pics")
    private var _Ref_Product_Images = STORAGE_BASE.child("ProductsImages")
    
    var REF_BASE: DatabaseReference {
        return _REF_BASE
    }
    
    var REF_Products: DatabaseReference {
        return _REF_Products
    }
    
    var REF_USERS: DatabaseReference {
        return _REF_USERS
    }
    
    var REF_USER_CURRENT: DatabaseReference {
        let uid = KeychainWrapper.standard.string(forKey: KEY_UID)
        let user = REF_USERS.child(uid!)
        return user
    }
    
    var Ref_Emp_ProFile_Images: StorageReference {
        return _Ref_Emp_ProFile_Images
    }
    
    var Ref_Product_Images:StorageReference {
        
        return _Ref_Product_Images
    }
    
    var REf_ORDER_REQUEST_LIST:DatabaseReference {
        
        return _REf_ORDER_REQUEST_LIST
    }
    
    
    func createFirbaseDBUser(uid: String, userData: Dictionary<String, String>) {
        REF_USERS.child(uid).updateChildValues(userData)
    }
    
}

