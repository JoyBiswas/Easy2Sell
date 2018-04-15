//
//  ActiveRepModel.swift
//  Easy2Sell
//
//  Created by JOY BISWAS on 4/15/18.
//  Copyright © 2018 MacBook Air. All rights reserved.
//

import Foundation

class ActiveRepresentativeModel {
    
    
    
    
    
    
    private var _profileName: String!
    private var _profileimageUrl: String!
    private var _profileEmail: String!
    private var _repLocationLat:Double!
    private var _repLocationLong:Double!
    private var _repLocationPlace:String!
    private var _repCurrentTime:String!
    
    
    var profileName: String {
        
        return _profileName
        
    }
    var profileEmail: String {
        
        return _profileEmail
        
    }
    
    var profileimageUrl: String {
        return _profileimageUrl
    }
    
    var repLocationPlace: String {
        return _repLocationPlace
    }
    
    var repLocationLat: Double {
        
        return _repLocationLat
    }
    
    var repLocationLong: Double {
        
        return _repLocationLong
    }
    var repCurrentTime: String {
        
        return _repCurrentTime
    }
    
 
    
    init(profileName: String, profileimageUrl: String, profileEmail:String, repLocationPlace:String, repLocationLat:Double, repLocationLong:Double,repCurrentTime:String) {
        self._profileName = profileName
        self._profileimageUrl = profileimageUrl
        self._profileEmail = profileEmail
        self._repLocationPlace = repLocationPlace
        self._repLocationLat = repLocationLat
        self._repLocationLong = repLocationLong
        self._repCurrentTime = repCurrentTime
        
    }
    
    
    

}
