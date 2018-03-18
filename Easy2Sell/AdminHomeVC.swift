//
//  AdminHomeVC.swift
//  Easy2Sell
//
//  Created by JOY BISWAS on 2/28/18.
//  Copyright © 2018 MacBook Air. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class AdminHomeVC: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet weak var activeEmployeeBtn: UIButton!
    var menuShow = false
    var imagePicker:UIImagePickerController!
    
    @IBOutlet weak var adminProfileImg: CircleView!
   
    override func viewDidLoad() {
        
        setupMenubar()
        menuLeadingConstraint.constant = 0
        
        guard let username = Auth.auth().currentUser?.email else { return }
        
        //successLbl.text = "Hello \(username)"
        navigationItem.title = username
         //_ = KeychainWrapper.standard.removeObject(forKey: "adminuid")
        
        activeEmployeeBtn.backgroundColor = UIColor.cyan
        
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        
        
        
    }
    
    func setupMenubar(){
        let barImage = UIImage(named: "menu.png")?.withRenderingMode(.alwaysOriginal)
        let menuBarbutton = UIBarButtonItem(image: barImage, style: .plain, target: self,action: #selector(manuBtn))
        navigationItem.leftBarButtonItems = [menuBarbutton]
        
    }
    @IBOutlet weak var menuLeadingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var mainView: UIView!
    
    
    
    func manuBtn() {
        
        if(menuShow)
        {
            menuLeadingConstraint.constant = 0
            handelanimation()
            
        }
        else{
            menuLeadingConstraint.constant = 125
            handelanimation()
            
            
        }
        menuShow = !menuShow
    }
    
    func handelanimation()
    {
        UIView.animate(withDuration: 0.9, animations: {
            self.view.layoutIfNeeded()
        })
        mainView.layer.shadowOpacity = 1
        mainView.layer.shadowRadius = 5
        
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            adminProfileImg.image = image
            print("what was my image")
            
        } else {
            print("JESS: A valid image wasn't selected")
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addImageTapped(_ sender: AnyObject) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func onLogoutTapped(_ sender: Any)
    {
        
        do {
            
            
            try Auth.auth().signOut()
          _ = KeychainWrapper.standard.removeObject(forKey: "adminuid")
            dismiss(animated: true, completion: nil)
             
        } catch {
            print(error)
        }
        
    }

    
    @IBAction func adminPImgtBtn(_ sender: Any) {
        print("taped")
    }


}
