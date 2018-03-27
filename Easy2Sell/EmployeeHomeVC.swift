//
//  EmployeeHomeVC.swift
//  Easy2Sell
//
//  Created by JOY BISWAS on 2/28/18.
//  Copyright © 2018 MacBook Air. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class EmployeeHomeVC: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITableViewDelegate,UITableViewDataSource {
        var menuShow = false
        var imageSelected = false
        var products = [AddProductModel]()
    
    static var imageCache:NSCache<NSString, UIImage> = NSCache()
    
    var imagePicker:UIImagePickerController!

    var selectedIndexPath: NSIndexPath = NSIndexPath()
    
    
    @IBOutlet weak var employeeProfileImg: CircleView!
    
    @IBOutlet weak var productTable: UITableView!
    
    

    override func viewDidLoad() {
        
        setupMenubar()
        menuLeadingConstraint.constant = 0
        
        guard let username = Auth.auth().currentUser?.displayName else { return }
        
        //successLbl.text = "Hello \(username)"
        navigationItem.title = username
        
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        
        // calling employee profile pic
        
        let user = Auth.auth().currentUser
        
        func getDataFromUrl(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
            URLSession.shared.dataTask(with: url) { data, response, error in
                completion(data, response, error)
                }.resume()
        }
        
        func downloadImage(url: URL) {
            print("Download Started")
            getDataFromUrl(url: url) { data, response, error in
                guard let data = data, error == nil else { return }
                print(response?.suggestedFilename ?? url.lastPathComponent)
                print("Download Finished")
                DispatchQueue.main.async() {
                    self.employeeProfileImg.image = UIImage(data: data)
                }
            }
        }
        
        
        if Auth.auth().currentUser != nil {
            
            if let url = user?.photoURL {
                
                
                downloadImage(url: url)
                
                
            }
            
            
        }
        
        
        //products from database
        
        
        DataService.ds.REF_Products.observe(.value, with: { (snapshot) in
            
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
                for snap in snapshot {
                    print("SNAP: \(snap)")
                    if let productDict = snap.value as? Dictionary<String, AnyObject> {
                        //                        let productName = productDict["productName"]
                        let key = snap.key
                        let product = AddProductModel(productKey: key, productData: productDict)
                        self.products.append(product)
                        
                        //                        self.produtsArray.append(productName as! String)
                        //                        print(self.produtsArray)
                    }
                    
                }
                self.productTable.reloadData()
            }
            
            
        })
        
        

        
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
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            employeeProfileImg.image = image
            
            imageSelected = true
            
            guard let img = employeeProfileImg.image, imageSelected == true else {
                print("JESS: An image must be selected")
                return
            }
            
            if let imgData = UIImageJPEGRepresentation(img, 0.2) {
                
                let imgUid = Auth.auth().currentUser?.email
                let metadata = StorageMetadata()
                metadata.contentType = "image/jpeg"
                
                DataService.ds.Ref_Emp_ProFile_Images.child(imgUid!).putData(imgData, metadata: metadata) { (metadata, error) in
                    if error != nil {
                        print("JESS: Unable to upload image to Firebasee torage")
                    } else {
                        print("JESS: Successfully uploaded image to Firebase storage")
                        let downloadURL = metadata?.downloadURL()?.absoluteString
                        if let url = downloadURL {
                            
                            let user = Auth.auth().currentUser
                            if let user = user {
                                let changeRequest = user.createProfileChangeRequest()
                                
                                changeRequest.photoURL =
                                    NSURL(string: url) as URL?
                                changeRequest.commitChanges { error in
                                    if let error = error {
                                        
                                        AlertController.showAlert(self, title: "Error", message: "\(error.localizedDescription)")
                                        return
                                        
                                    } else {
                                        AlertController.showAlert(self, title: "Profile Picture Set", message: "You can change again")
                                        return
                                    }
                                }
                            }
                        }
                    }
                }
                
                print("what was my image")
                
            }
            
            
        } else {
            print("JESS: A valid image wasn't selected")
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addImageTapped(_ sender: AnyObject) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    
    // table view implementing Start
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let product = products[indexPath.row]
        if let cell = productTable.dequeueReusableCell(withIdentifier: "PlistCell") as? ProductListTableCell {
            
            if let img = EmployeeHomeVC.imageCache.object(forKey: product.productimageUrl as NSString) {
                
                cell.configureCell(product: product, img: img)
            } else {
                cell.configureCell(product: product, img: nil)
            }
            return cell
        } else {
            return ProductListTableCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.selectedIndexPath = indexPath as NSIndexPath
        
        performSegue(withIdentifier: "toAddToChart", sender: nil)
    }
    
    
    
     open override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let indexPath = self.selectedIndexPath
        
        
        
        if (segue.identifier == "toAddToChart") {
            if  let viewController = segue.destination as? AddToOrderVC  {
                
            let product = products[indexPath.row]
               
            viewController.productName = product.productName
            viewController.productCode = product.productCode
            viewController.productType = product.productType
            viewController.productPrice = product.productPrice
            viewController.productDetails = product.productDescription
            viewController.pImageUrl = product.productimageUrl
            
            
            
            
        }
    }
    
    }
    
    
    
    
    @IBAction func onLogoutTapped(_ sender: Any)
    {
        
        do {
            
            
            try Auth.auth().signOut()
          _ = KeychainWrapper.standard.removeObject(forKey: "uid")
            dismiss(animated: true, completion: nil)
            
        } catch {
            print(error)
        }
        
    }
    
    
    @IBAction func tapProductListShow(_ sender: Any) {
        
        menuLeadingConstraint.constant = 0
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }

    }
