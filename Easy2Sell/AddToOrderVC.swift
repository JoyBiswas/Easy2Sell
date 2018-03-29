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
    var apropriatePrice:Double!
    
    
    @IBOutlet weak var orderProductImage: UIImageView!
    
    @IBOutlet weak var orderProductName: UILabel!
    
    @IBOutlet weak var orderProductCode: UILabel!
    

    @IBOutlet weak var orderProductType: UILabel!
    
    @IBOutlet weak var orderProductPrice: UILabel!
    
    @IBOutlet weak var orderProductDetails: UITextView!
    
    @IBOutlet weak var productCodeToOrder: FancyField!
    
    @IBOutlet weak var productQntToOrder: FancyField!
    
    
    @IBOutlet weak var totalPriceToOrder: FancyField!
    
 
    @IBOutlet weak var OrderFrom: FancyField!
    

    @IBOutlet weak var ordererPhn: FancyField!
    
    @IBOutlet weak var ordererAddress: FancyField!
    
    @IBOutlet weak var productDeliveryDate: FancyField!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.orderProductName.text = productName
        self.orderProductCode.text = productCode
        self.orderProductType.text = productType
        self.orderProductPrice.text = productPrice
        self.orderProductDetails.text = productDetails
        
        if productPrice != " " {
            
            let dataString = productPrice.components(separatedBy: "T")
            
            if dataString.count > 0 {
                
                self.apropriatePrice = Double(dataString[0])
                print(self.apropriatePrice)
                
            }
        }
        
        
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
        
        
        self.productCodeToOrder.text =  productCode
        
        
        
        
        
        
        
    }
    
    
    
    @IBAction func provideTotalPrice(_ sender: FancyField) {
        
        if apropriatePrice != nil && productQntToOrder.text != "" {
            
            if let productQuantity = Double(productQntToOrder.text!) {
                
               let totalprice = productQuantity*apropriatePrice
                
                self.totalPriceToOrder.text = "\(totalprice)Tk"
                
                
            }
            
            
        }
        
        
    }
    
    
    
 
    
    @IBAction func addToOrderListProduct(_ sender: Any) {
        
        
        
        
    }
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    

}
