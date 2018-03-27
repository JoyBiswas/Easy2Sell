//
//  ProductRequestTableCell.swift
//  Easy2Sell
//
//  Created by JOY BISWAS on 3/23/18.
//  Copyright © 2018 MacBook Air. All rights reserved.
//

import UIKit

class ProductRequestTableCell: UITableViewCell {
    
    @IBOutlet weak var productName: UITextView!
    
    @IBOutlet weak var productCode: UITextView!
    
    @IBOutlet weak var productQuantity: UITextView!
    
    @IBOutlet weak var productPrice: UITextView!
    
    
    @IBOutlet weak var totalPrice: UITextView!
    
    
    @IBOutlet weak var orderBy: UITextView!
    
    
    @IBOutlet weak var orderFrom: UITextView!
    
    @IBOutlet weak var deliberyDate: UITextView!
    
    @IBOutlet weak var deliveyMarkImg: UIImageView!

    @IBOutlet weak var orderPhnNumber: UITextView!
    
    @IBOutlet weak var orderAdress: UITextView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
