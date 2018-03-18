//
//  EmployeeSignUp_In.swift
//  Easy2Sell
//
//  Created by JOY BISWAS on 1/30/18.
//  Copyright © 2018 MacBook Air. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class EmployeeSignUp_In: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var userNameTF: UITextField!
    
    @IBOutlet weak var emailTF: UITextField!
    
    @IBOutlet weak var employeeKeyTF: UITextField!
    
    @IBOutlet weak var passwordTF: UITextField!
    
    @IBOutlet weak var confirmPasswordTF: UITextField!
    
    @IBOutlet weak var loginBTN: UIButton!
    
    @IBOutlet weak var signUpbtn: UIButton!
    
    @IBOutlet weak var forgetPasswordBtn: UIButton!
    
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    
    var databaseRef:DatabaseReference?
    var datahandel:DatabaseHandle?
    var refemployee:DatabaseReference?
    
    var employeeKey:[String] = []
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        userNameTF.isHidden = true
        emailTF.isHidden = true
        employeeKeyTF.isHidden = true
        passwordTF.isHidden = true
        confirmPasswordTF.isHidden = true
        forgetPasswordBtn.isHidden = true
        

        refemployee = Database.database().reference().child("employees");
        
        refemployee?.observe(DataEventType.value, with: { (snapshot) in
            
            //if the reference have some values
            if snapshot.childrenCount > 0 {
           
                
                //iterating through all the values
                for employees in snapshot.children.allObjects as! [DataSnapshot] {
                    //getting values
                    let employeeObject = employees.value as? [String: AnyObject]
                   
                    if let employeeKey = employeeObject?["employeeKey"] as? String{
                        
                        self.employeeKey.append(employeeKey)
                        
                    }
                    
                   
                    
                }
            }
        })
        
        

        
                if let _ = KeychainWrapper.standard.string(forKey: "uid") {
        Timer.scheduledTimer(withTimeInterval: 2, repeats: false, block: { (timer) in
            
                self.performSegue(withIdentifier: "toEmployeeHome", sender: nil)
            
            
        })
    }
        
      

    }
    override func viewDidAppear(_ animated: Bool) {
        
        self.activityIndicator.stopAnimating()
        
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
        forgetPasswordBtn.isHidden = true
        loginBTN.isHidden = true
        signUpbtn.isHidden = false
        
        
    }
    
    @IBAction func loginSelectionPressed(_ sender: Any) {
        userNameTF.isHidden = true
        emailTF.isHidden = false
        employeeKeyTF.isHidden = false
        passwordTF.isHidden = false
        confirmPasswordTF.isHidden = true
        loginBTN.backgroundColor = UIColor.red
        signUpbtn.backgroundColor = nil
        forgetPasswordBtn.isHidden = false
        signUpbtn.isHidden = true
        loginBTN.isHidden = false

        
    }
    
    
    @IBAction func signUpBtnPressed(_ sender: Any) {
        
        
        if let username=userNameTF.text,username == "",let email = emailTF.text,email == "",let password=passwordTF.text,password == "",let employeekey=employeeKeyTF.text,employeekey == ""  {
            
            AlertController.showAlert(self, title: "Missing InFo", message: "Please fill up your field")
            
            
            
            
            return
        }
        
        
        
        if employeeKey.contains(employeeKeyTF.text!){
            
            if passwordTF.text == confirmPasswordTF.text {
                
                activityIndicator.center = self.view.center
                activityIndicator.hidesWhenStopped = true
                activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
                view.addSubview(activityIndicator)
                activityIndicator.startAnimating()
                
                Auth.auth().createUser(withEmail: emailTF.text!, password: passwordTF.text!, completion: { (user, error) in
                    
                    guard error == nil else {
                        AlertController.showAlert(self, title: "Error", message: error!.localizedDescription)
                        
                        self.activityIndicator.stopAnimating()
                        return
                    }
                    guard let user = user else { return }
                    print(user.email ?? "MISSING EMAIL")
                    print(user.uid)
                    
                    let changeRequest = user.createProfileChangeRequest()
                    changeRequest.displayName = self.userNameTF.text!
                    changeRequest.commitChanges(completion: { (error) in
                        guard error == nil else {
                            AlertController.showAlert(self, title: "Error", message: error!.localizedDescription)
                            self.completeSignIn(id: user.email!)
                            self.activityIndicator.stopAnimating()
                            return
                        }
                        self.completeSignIn(id: user.email!)
                        
                        self.performSegue(withIdentifier: "toEmployeeHome", sender: nil)
                        self.activityIndicator.stopAnimating()
                        
                    })
                    
                    
                    
                })
                
                
                
                
            }
            else {
                
                
                AlertController.showAlert(self, title: "Missing InFo", message: "Password didnt match")
                
                self.activityIndicator.stopAnimating()
                
            }
            
            
        }  else {
            
            
            AlertController.showAlert(self, title: "Missing InFo", message: "Employee key didnt match")
            
            self.activityIndicator.stopAnimating()
            
        }
        
        

    }
    
    @IBAction func loginBTnPressed(_ sender: Any) {
        
        
        if let email = emailTF.text,
            email == "",
            let password = passwordTF.text,
            password == "",let employeekey=employeeKeyTF.text,employeekey == ""
        {
            AlertController.showAlert(self, title: "Missing Info", message: "Please fill out all required fields")
            return
            
            
        }
        if employeeKey.contains(employeeKeyTF.text!){
            
            
            activityIndicator.center = self.view.center
            activityIndicator.hidesWhenStopped = true
            activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
            view.addSubview(activityIndicator)
            activityIndicator.startAnimating()
            
            Auth.auth().signIn(withEmail: emailTF.text!, password: passwordTF.text!, completion: { (user, error) in
                guard error == nil else {
                    AlertController.showAlert(self, title: "Error", message: error!.localizedDescription)
                    self.activityIndicator.stopAnimating()
                
                    return
                }
                self.completeSignIn(id: (user?.email)!)
              
                self.performSegue(withIdentifier: "toEmployeeHome", sender: nil)
              
                
                
            })
            
        }else {
            
            AlertController.showAlert(self, title: "Missing InFo", message: "Employee key didnt match")
            
            self.activityIndicator.stopAnimating()
            
        }
        
    }
    
    
    func completeSignIn(id: String) {
        //DataService.ds.createFirbaseDBUser(uid: id, userData: userData)
        let keychainResult = KeychainWrapper.standard.set(id, forKey: "uid")
        //KeychainWrapper.standard.set("Some String", forKey: "myKey")
        print("JESS: Data saved to keychain \(keychainResult)")
        performSegue(withIdentifier: "toEmployeeHome", sender: nil)
    }
    
    
    
    @IBAction func forgetPasswordPressed(_ sender: Any) {
        
        let alert = UIAlertController(title: "Reset Password", message: "Enter your mail adress for recovery", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Enter Email Here"
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let send = UIAlertAction(title: "Send", style: .default) { _ in
            guard var text = alert.textFields?.first?.text else { return }
            
            if text == "" {
                let alertController = UIAlertController(title: "eaaaak!", message: "Please enter an email.", preferredStyle: .alert)
                
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                
                self.present(alertController, animated: true, completion: nil)
                
            } else {
                Auth.auth().sendPasswordReset(withEmail: text, completion: { (error) in
                    
                    var title = ""
                    var message = ""
                    
                    if error != nil {
                        title = "Error!"
                        message = (error?.localizedDescription)!
                    } else {
                        title = "Success!"
                        message = "Password reset email sent."
                        text = ""
                    }
                    
                    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                })
                
                
                
            }
            
            
            
            
        }
        alert.addAction(cancel)
        alert.addAction(send)
        present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func backBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
        
    }

}
