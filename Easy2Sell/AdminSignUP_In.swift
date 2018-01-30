//
//  AdminSignUP_In.swift
//  Easy2Sell
//
//  Created by JOY BISWAS on 1/29/18.
//  Copyright © 2018 MacBook Air. All rights reserved.
//

import UIKit

class AdminSignUP_In: UIViewController {
    
    
    @IBOutlet weak var userNameTF: UITextField!
    
    @IBOutlet weak var emailTF: UITextField!
    
    @IBOutlet weak var adminKeyTF: UITextField!
    
    @IBOutlet weak var passwordTF: UITextField!
    
    @IBOutlet weak var confirmPasswordTF: UITextField!
    
    @IBOutlet weak var loginBTN: UIButton!
    
    @IBOutlet weak var signUpbtn: UIButton!
    
    
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

       userNameTF.isHidden = true
        emailTF.isHidden = true
        adminKeyTF.isHidden = true
        passwordTF.isHidden = true
        confirmPasswordTF.isHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func registerSelectionPressed(_ sender: Any) {
        userNameTF.isHidden = false
        emailTF.isHidden = false
        adminKeyTF.isHidden = false
        passwordTF.isHidden = false
        confirmPasswordTF.isHidden = false
        
        
    }
    
    @IBAction func loginSelectionPressed(_ sender: Any) {
        userNameTF.isHidden = true
        emailTF.isHidden = false
        adminKeyTF.isHidden = false
        passwordTF.isHidden = false
        confirmPasswordTF.isHidden = true
       
    }
    
    
    @IBAction func signUpBtnPressed(_ sender: Any) {
    }
    
    @IBAction func loginBTnPressed(_ sender: Any) {
    }
    
    @IBAction func forgetPasswordPressed(_ sender: Any) {
    }
    
    
    @IBAction func backBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    


}
