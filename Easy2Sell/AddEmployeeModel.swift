//
//  AddEmployeeModel.swift
//  Easy2Sell
//
//  Created by JOY BISWAS on 3/18/18.
//  Copyright © 2018 MacBook Air. All rights reserved.
//

import Foundation

class AddEmployeeModel {

var id: String?
var name: String?
var key: String?
var email:String?
    var phn:String?
    

    init(id: String?, name: String?, key: String?, email:String?,phn:String?){
    self.id = id
    self.name = name
    self.key = key
    self.email = email
    self.phn = phn
}

}
