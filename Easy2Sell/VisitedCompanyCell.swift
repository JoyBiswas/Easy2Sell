//
//  VisitedCompanyCell.swift
//  Easy2Sell
//
//  Created by JOY BISWAS on 3/22/18.
//  Copyright © 2018 MacBook Air. All rights reserved.
//

import UIKit

class VisitedCompanyCell: UITableViewCell {
    
    @IBOutlet weak var companyName: UILabel!
    
    @IBOutlet weak var companyAdress: UILabel!
    
    @IBOutlet weak var companyCellNo: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
