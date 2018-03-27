//
//  AddEmployeeTableCell.swift
//  Easy2Sell
//
//  Created by JOY BISWAS on 3/18/18.
//  Copyright © 2018 MacBook Air. All rights reserved.
//

import UIKit

class AddEmployeeTableCell: UITableViewCell {
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var emaillbl: UILabel!
    @IBOutlet weak var phnlbl: UILabel!
    
    @IBOutlet weak var lblKey: UILabel!
    
    @IBOutlet weak var employeeName: UILabel!
    
    @IBOutlet weak var employeeKey: UILabel!
    
    @IBOutlet weak var employeeEmail: UILabel!
    
    @IBOutlet weak var employeePhn: UILabel!
    
    
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
