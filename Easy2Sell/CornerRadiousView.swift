//
//  CornerRadiousView.swift
//  Easy2Sell
//
//  Created by JOY BISWAS on 3/21/18.
//  Copyright © 2018 MacBook Air. All rights reserved.
//

import UIKit

class CornerRadiousView: UIImageView {

    
        
        override func layoutSubviews() {
            layer.cornerRadius = 5.5
            layer.shadowRadius = 0.5
            clipsToBounds = true
        }
}
