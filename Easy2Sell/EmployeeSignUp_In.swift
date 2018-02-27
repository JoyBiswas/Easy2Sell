//
//  EmployeeSignUp_In.swift
//  Easy2Sell
//
//  Created by JOY BISWAS on 1/30/18.
//  Copyright © 2018 MacBook Air. All rights reserved.
//

import UIKit

class EmployeeSignUp_In: UIViewController {
    
    @IBOutlet weak var userNameTF: UITextField!
    
    @IBOutlet weak var emailTF: UITextField!
    
    @IBOutlet weak var employeeKeyTF: UITextField!
    
    @IBOutlet weak var passwordTF: UITextField!
    
    @IBOutlet weak var confirmPasswordTF: UITextField!
    
    @IBOutlet weak var loginBTN: UIButton!
    
    @IBOutlet weak var signUpbtn: UIButton!
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userNameTF.isHidden = true
        emailTF.isHidden = true
        employeeKeyTF.isHidden = true
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
        employeeKeyTF.isHidden = false
        passwordTF.isHidden = false
        confirmPasswordTF.isHidden = false
        signUpbtn.backgroundColor = UIColor.red
        loginBTN.backgroundColor = nil
        
        
        
        
    }
    
    @IBAction func loginSelectionPressed(_ sender: Any) {
        userNameTF.isHidden = true
        emailTF.isHidden = false
        employeeKeyTF.isHidden = false
        passwordTF.isHidden = false
        confirmPasswordTF.isHidden = true
        loginBTN.backgroundColor = UIColor.red
        signUpbtn.backgroundColor = nil

        
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
