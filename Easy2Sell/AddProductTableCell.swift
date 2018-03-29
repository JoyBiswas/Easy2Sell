//
//  AddProductTableCell.swift
//  Easy2Sell
//
//  Created by JOY BISWAS on 3/21/18.
//  Copyright © 2018 MacBook Air. All rights reserved.
//

import UIKit
import Firebase

class AddProductTableCell: UITableViewCell {
    
    @IBOutlet weak var productImg: UIImageView!
    
    @IBOutlet weak var productName: UILabel!
    
    @IBOutlet weak var productCode: UILabel!
    
    
    @IBOutlet weak var productType: UILabel!
    
    @IBOutlet weak var productPrice: UILabel!
    
    
    @IBOutlet weak var pricePerQuantity: UILabel!
    
    @IBOutlet weak var productDescription: UITextView!
    
    var product:AddProductModel!
    
    

    func configureCell(product:AddProductModel ,img:UIImage?) {
        self.product = product

        self.productName.text = product.productName
        self.productCode.text = product.productCode
        self.productType.text = product.productType
        self.productPrice.text =  String(product.productPrice)
        self.pricePerQuantity.text = String(product.pricePerQuantity)
        self.productDescription.text = product.productDescription
        if img != nil {
            self.productImg.image = img
        } else {
            let ref = Storage.storage().reference(forURL: product.productimageUrl)
            ref.getData(maxSize: 2*1024*1024, completion: { (data, error) in
                
                if error != nil {
                    print("JESS: Unable to download image from Firebase storage")
                    print(error!)
                } else {
                    print("JESS: Image downloaded from Firebase storage")
                    if let imgData = data {
                        if let img = UIImage(data: imgData) {
                            self.productImg.image = img
                            AddProductVC.imageCache.setObject(img, forKey: product.productimageUrl as NSString )
                        }
                    }
                }
            })
        }
    }
    
    
    
    
    
    
    
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    
    
    

    }
