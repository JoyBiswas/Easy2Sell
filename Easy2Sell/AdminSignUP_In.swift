//
//  AdminSignUP_In.swift
//  Easy2Sell
//
//  Created by JOY BISWAS on 1/29/18.
//  Copyright © 2018 MacBook Air. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class AdminSignUP_In: UIViewController,UITextFieldDelegate {
    
    
    @IBOutlet weak var userNameTF: UITextField!
    
    @IBOutlet weak var emailTF: UITextField!
    
    @IBOutlet weak var adminKeyTF: UITextField!
    
    @IBOutlet weak var passwordTF: UITextField!
    
    @IBOutlet weak var confirmPasswordTF: UITextField!
    
    @IBOutlet weak var loginBTN: UIButton!
    
    @IBOutlet weak var signUpbtn: UIButton!
    
    
    @IBOutlet weak var forgetPasswordBTn: UIButton!
    
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    
    var databaseRef:DatabaseReference?
    var datahandel:DatabaseHandle?
    
    var adminKey:[String] = []
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
       navigationItem.hidesBackButton = true
       userNameTF.isHidden = true
        emailTF.isHidden = true
        adminKeyTF.isHidden = true
        passwordTF.isHidden = true
        confirmPasswordTF.isHidden = true
        forgetPasswordBTn.isHidden = true
        
        databaseRef=Database.database().reference()
        
        datahandel = databaseRef?.child("adminKey").observe(.childAdded, with: { (snapshot) in
            
            if let item = snapshot.value as? String
            {
                
                self.adminKey.append(item)
                
            }
        })
        
        if let _ = KeychainWrapper.standard.string(forKey: "adminuid") {
            Timer.scheduledTimer(withTimeInterval: 2, repeats: false, block: { (timer) in
                
                print("JESS: ID found in keychain")
                self.performSegue(withIdentifier: "toAdminHome", sender: nil)
                
                
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
        adminKeyTF.isHidden = false
        passwordTF.isHidden = false
        confirmPasswordTF.isHidden = false
        signUpbtn.backgroundColor = UIColor.red
        loginBTN.backgroundColor = nil
        forgetPasswordBTn.isHidden = true
        loginBTN.isHidden = true
        signUpbtn.isHidden = false
        
        
    }
    
    @IBAction func loginSelectionPressed(_ sender: Any) {
        userNameTF.isHidden = true
        emailTF.isHidden = false
        adminKeyTF.isHidden = false
        passwordTF.isHidden = false
        confirmPasswordTF.isHidden = true
        loginBTN.backgroundColor = UIColor.red
        signUpbtn.backgroundColor = nil
        forgetPasswordBTn.isHidden = false
        signUpbtn.isHidden = true
        loginBTN.isHidden = false
       
    }
    
    
    @IBAction func signUpBtnPressed(_ sender: Any) {
        
        if let username=userNameTF.text,username == "",let email = emailTF.text,email == "",let password=passwordTF.text,password == "",let admnkey=adminKeyTF.text,admnkey == ""  {
            
            AlertController.showAlert(self, title: "Missing InFo", message: "Please fill up your field")
            
            
            
            
            return
        }
        
        
        
        if adminKey.contains(adminKeyTF.text!){
            
            if passwordTF.text == confirmPasswordTF.text {
                
                activityIndicator.center = self.view.center
                activityIndicator.hidesWhenStopped = true
                activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
                view.addSubview(activityIndicator)
                activityIndicator.startAnimating()
                
                Auth.auth().createUser(withEmail: emailTF.text!, password: passwordTF.text!, completion: { (user, error) in
                    
                    guard error == nil else {
                        AlertController.showAlert(self, title: "Error", message: error!.localizedDescription)
                     self.completeSignIn(id: (user?.email)!)
                        self.activityIndicator.stopAnimating()
                        return
                    }
                    guard let user = user else { return }
                    
                    let changeRequest = user.createProfileChangeRequest()
                    changeRequest.displayName = self.userNameTF.text!
                    changeRequest.commitChanges(completion: { (error) in
                        guard error == nil else {
                            AlertController.showAlert(self, title: "Error", message: error!.localizedDescription)
                            self.completeSignIn(id: (user.email!))
                            self.activityIndicator.stopAnimating()
                            return
                        }
                        self.completeSignIn(id: (user.email)!)
                        self.performSegue(withIdentifier: "toAdminHome", sender: nil)
                        
                    })
                    
                    print("saved ")
                    
                })
                
                
                
                
                
            }
            else {
                
                
                AlertController.showAlert(self, title: "Missing InFo", message: "Password didnt match")
                
                self.activityIndicator.stopAnimating()
                
            }
            
            
        }  else {
            
            AlertController.showAlert(self, title: "Missing InFo", message: "Admin key didnt match")
            
            self.activityIndicator.stopAnimating()
            
        }

    }
    
    @IBAction func loginBTnPressed(_ sender: Any) {
        
        if let email = emailTF.text,
            email == "",
            let password = passwordTF.text,
            password == "", let admnkey=adminKeyTF.text,admnkey == ""
            {
                AlertController.showAlert(self, title: "Missing Info", message: "Please fill out all required fields")
                return
                
                
        }
        if adminKey.contains(adminKeyTF.text!){
            
            
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
            print("saved")
            self.performSegue(withIdentifier: "toAdminHome", sender: nil)
            
                      })
         
        }else {
            
            AlertController.showAlert(self, title: "Missing InFo", message: "Admin key didnt match")
            
            self.activityIndicator.stopAnimating()
            
        }

    }
    
    func completeSignIn(id: String) {
        
        let keychainResult = KeychainWrapper.standard.set(id, forKey: "adminuid")
        
        print("JESS: Data saved to keychain \(keychainResult)")
        performSegue(withIdentifier: "toAdminHome", sender: nil)
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
