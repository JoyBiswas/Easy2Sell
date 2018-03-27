//
//  AddToOrderVC.swift
//  Easy2Sell
//
//  Created by JOY BISWAS on 3/23/18.
//  Copyright © 2018 MacBook Air. All rights reserved.
//

import UIKit
import Firebase


class AddToOrderVC: UIViewController {
    
    
    
    var pImageUrl: String = String()
    var productName: String = String()
    var productCode: String = String()
    var productType: String = String()
    var productPrice: String = String()
    var productDetails: String = String()
    
    
    @IBOutlet weak var orderProductImage: UIImageView!
    
    @IBOutlet weak var orderProductName: UILabel!
    
    @IBOutlet weak var orderProductCode: UILabel!
    

    @IBOutlet weak var orderProductType: UILabel!
    
    @IBOutlet weak var orderProductPrice: UILabel!
    
    @IBOutlet weak var orderProductDetails: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.orderProductName.text = productName
        self.orderProductCode.text = productCode
        self.orderProductType.text = productType
        self.orderProductPrice.text = productPrice
        self.orderProductDetails.text = productDetails
        
        
      
            let ref = Storage.storage().reference(forURL: self.pImageUrl)
            ref.getData(maxSize: 2*1024*1024, completion: { (data, error) in
                
                if error != nil {
                    print("JESS: Unable to download image from Firebase storage")
                    print(error!)
                } else {
                    print("JESS: Image downloaded from Firebase storage")
                    if let imgData = data {
                        if let img = UIImage(data: imgData) {
                            self.orderProductImage.image = img
                            
                        }
                    }
                }
            })
            
       
        
            
        
        
       
        

        
    }
 

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    

}
