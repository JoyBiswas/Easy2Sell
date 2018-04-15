//
//  ActiveRepresentativesCell.swift
//  Easy2Sell
//
//  Created by JOY BISWAS on 4/15/18.
//  Copyright © 2018 MacBook Air. All rights reserved.
//

import UIKit
import Firebase

class ActiveRepresentativesCell: UITableViewCell {
    
    @IBOutlet weak var profilePicture: CircleView!
    
    @IBOutlet weak var profileName: UITextView!
    
    @IBOutlet weak var profileEmail: UITextView!
    
    
    @IBOutlet weak var repLocationLatitude: UITextView!
    
    @IBOutlet weak var repLocationLongitude: UITextView!
    
    
    @IBOutlet weak var repLocationPlace: UITextView!
    
    @IBOutlet weak var repCurrentTime: UITextView!
    
    var representative:ActiveRepresentativeModel!
    
    func configureCell(representative:ActiveRepresentativeModel ,img:UIImage?) {
        self.representative = representative
        
        self.profileName.text = representative.profileName
        self.profileEmail.text = representative.profileEmail
        self.repLocationLatitude.text = String(representative.repLocationLat)
        self.repLocationLongitude.text = String(representative.repLocationLong)
        self.repLocationPlace.text = representative.repLocationPlace
        self.repCurrentTime.text = representative.repCurrentTime
       
        if img != nil {
            self.profilePicture.image = img
        } else {
            let ref = Storage.storage().reference(forURL: representative.profileimageUrl)
            ref.getData(maxSize: 2*1024*1024, completion: { (data, error) in
                
                if error != nil {
                    print("JESS: Unable to download image from Firebase storage")
                    print(error!)
                } else {
                    print("JESS: Image downloaded from Firebase storage")
                    if let imgData = data {
                        if let img = UIImage(data: imgData) {
                            self.profilePicture.image = img
                            AdminHomeVC.imageCache.setObject(img, forKey: representative.profileimageUrl as NSString )
                        }
                    }
                }
            })
            
        }
    }

  

}
