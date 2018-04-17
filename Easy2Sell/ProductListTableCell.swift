//
//  ProductListTableCell.swift
//  Easy2Sell
//
//  Created by JOY BISWAS on 3/21/18.
//  Copyright © 2018 MacBook Air. All rights reserved.
//

import UIKit
import Firebase

class ProductListTableCell: UITableViewCell {
    
    
    
    @IBOutlet weak var productImage: CornerRadiousView!
    
    @IBOutlet weak var productNameLbl: UILabel!
    
    @IBOutlet weak var productCodeLbl: UILabel!
    
    @IBOutlet weak var productTypeLbl: UILabel!
    
    @IBOutlet weak var productPriceLbl: UILabel!
    @IBOutlet weak var pricePerQuantity: UILabel!
    
    
    @IBOutlet weak var productDescription: UITextView!
    
    
    
    var product:AddProductModel!
    
    
    
    func configureCell(product:AddProductModel ,img:UIImage?) {
        self.product = product
        
        self.productNameLbl.text = product.productName
        self.productCodeLbl.text = product.productCode
        self.productTypeLbl.text = product.productType
        self.productPriceLbl.text =  String(product.productPrice)
        self.pricePerQuantity.text = product.pricePerQuantity
        self.productDescription.text = product.productDescription
        if img != nil {
            self.productImage.image = img
        } else {
            let ref = Storage.storage().reference(forURL: product.productimageUrl)
            ref.getData(maxSize: 2*1024*1024, completion: { (data, error) in
                
                if error != nil {
                    print("JESS: Unable to download image from Firebase storage")
                    print(error!)
                } else {
                    
                    if let imgData = data {
                        if let img = UIImage(data: imgData) {
                            self.productImage.image = img
                            EmployeeHomeVC.imageCache.setObject(img, forKey: product.productimageUrl as NSString )
                        }
                    }
                }
            })
            
        }
    }
}
