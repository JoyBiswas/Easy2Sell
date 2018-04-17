//
//  AddProductVC.swift
//  Easy2Sell
//
//  Created by JOY BISWAS on 3/17/18.
//  Copyright © 2018 MacBook Air. All rights reserved.
//

import UIKit
import Firebase

class AddProductVC: UIViewController,UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate{
    
    
    @IBOutlet weak var addproductImg: CornerRadiousView!
    
    @IBOutlet weak var productNameTF: FancyField!
    
    @IBOutlet weak var productCodeTF: FancyField!
    
    @IBOutlet weak var productTypeTF: FancyField!
    
    @IBOutlet weak var productPriceTF: FancyField!
    
    
    @IBOutlet weak var pricePerQuantity: FancyField!
    
    @IBOutlet weak var productDescriptionTF: FancyField!
    
    @IBOutlet weak var productTable: UITableView!
    
    var searchController = UISearchController()
    var resultController = UITableViewController()
    var imagePicker:UIImagePickerController!
    var imageSelected = false
    var productImagesUrl:String!
    
    var products = [AddProductModel]()
    
    var produtsArray = [String]()
    var filterdArray = [String]()
    
    static var imageCache:NSCache<NSString, UIImage> = NSCache()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        
        
        DataService.ds.REF_Products.observe(.value, with: { (snapshot) in
            
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
                self.products.removeAll()
                for snap in snapshot {
                    if let productDict = snap.value as? Dictionary<String, AnyObject> {
                        // let productName = productDict["productName"]
                        let key = snap.key
                        let product = AddProductModel(productKey: key, productData: productDict)
                        self.products.insert(product, at: 0)
                        
                        
                    }
                    
                }
                self.productTable.reloadData()
            }
            
            
        })
        
    }
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == resultController.tableView {
            
            return produtsArray.count
        }
        else {
            
            return products.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let product = products[indexPath.row]
        
        
        if let cell = productTable.dequeueReusableCell(withIdentifier: "ProductCell") as? AddProductTableCell {
            
            
            
            
            if let img = AddProductVC.imageCache.object(forKey: product.productimageUrl as NSString) {
                
                cell.configureCell(product: product, img: img)
            } else {
                cell.configureCell(product: product, img: nil)
            }
            return cell
        } else {
            return AddProductTableCell()
        }
    }
    
    
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //getting the selected artist
        let product  = products[indexPath.row]
        
        //building an alert
        let alertController = UIAlertController(title: product.productName, message: "Give new values to update ", preferredStyle: .alert)
        
        alertController.view.tintColor = UIColor.brown  // change text color of the buttons
        alertController.view.backgroundColor = UIColor.cyan  // change background color
        alertController.view.layer.cornerRadius = 25
        
        //the confirm action taking the inputs
        let confirmAction = UIAlertAction(title: "Save", style: .default) { (_) in
            
            //getting artist id
            let id = product.productKey
            let imageUrl = product.productimageUrl
            
            //getting new values
            let productName = alertController.textFields?[0].text
            let productCode = alertController.textFields?[1].text
            let productType = alertController.textFields?[2].text
            let productprice = alertController.textFields?[3].text
            let productDescription = alertController.textFields?[4].text
            let productQuantityPrice = alertController.textFields?[5].text
            
            
            //calling the update method to update artist
            self.updateecompany(id: id, productName: productName!, productCode: productCode!, productPrice: productprice!, productImgUrl: imageUrl, productType: productType!, ProductDescription: productDescription!, productQuantityPrice: productQuantityPrice!)
        }
        
        //the cancel action doing nothing
        let cancelAction = UIAlertAction(title: "Delete", style: .cancel) { (_) in
            self.deleteeCompany(id: product.productKey)
            
        }
        
        //adding two textfields to alert
        alertController.addTextField { (textField) in
            textField.text = product.productName
            
            textField.keyboardAppearance = .dark
            textField.placeholder = "Type product name"
            textField.textColor = UIColor.blue
            textField.font = UIFont(name: "AmericanTypewriter", size: 14)
            
        }
        
        alertController.addTextField { (textField) in
            textField.text = product.productCode
            textField.keyboardAppearance = .dark
            textField.placeholder = "Type product Code"
            textField.textColor = UIColor.red
            textField.font = UIFont(name: "AmericanTypewriter", size: 14)
            
        }
        
        alertController.addTextField { (textField) in
            
            textField.text = product.productType
            
            textField.keyboardAppearance = .dark
            textField.placeholder = "Type product Type"
            textField.textColor = UIColor.brown
            textField.font = UIFont(name: "AmericanTypewriter", size: 14)
        }
        
        alertController.addTextField { (textField) in
            
            textField.text = product.productPrice
            
            textField.keyboardAppearance = .dark
            textField.placeholder = "Type product price"
            textField.textColor = UIColor.green
            textField.font = UIFont(name: "AmericanTypewriter", size: 14)
        }
        alertController.addTextField { (textField) in
            
            textField.text = product.productDescription
            textField.keyboardAppearance = .dark
            textField.placeholder = "Type product Description"
            textField.textColor = UIColor.blue
            textField.font = UIFont(name: "AmericanTypewriter", size: 10)
        }
        alertController.addTextField { (textField) in
            
            textField.text = product.pricePerQuantity
            textField.keyboardAppearance = .dark
            textField.placeholder = "Type product pricePerQuantity"
            textField.textColor = UIColor.red
            textField.font = UIFont(name: "AmericanTypewriter", size: 14)
        }
        
        
        
        //adding action
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        //presenting dialog
        present(alertController, animated: true, completion: nil)
        
    }
    
    func updateecompany(id:String, productName:String, productCode:String,productPrice:String,productImgUrl:String,productType:String,ProductDescription:String,productQuantityPrice:String){
        //creating artist with the new given values
        let product: Dictionary<String, AnyObject> = [
            "productName": productName as AnyObject,
            "productimageUrl": productImgUrl as AnyObject,
            "productCode": productCode as AnyObject,
            "productType": productType as AnyObject,
            "productPrice":productPrice as AnyObject,
            "productDescription":ProductDescription as AnyObject,
            "pricePerQuantity":productQuantityPrice as AnyObject
        ]
        
        //updating the artist using the key of the artist
        DataService.ds.REF_Products.child(id).setValue(product)
        
        
        AlertController.showAlert(self, title: "Product Added", message: "Your product are in list you can edit also")
        
    }
    
    func deleteeCompany(id:String){
        DataService.ds.REF_Products.child(id).setValue(nil)
        
        
        //displaying message
        AlertController.showAlert(self, title: "Product are Removed", message: "Your Product are in list you can edit also")
    }
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            addproductImg.image = image
            
            imageSelected = true
            
            guard let img = addproductImg.image, imageSelected == true else {
                
                return
            }
            
            if let imgData = UIImageJPEGRepresentation(img, 0.2) {
                
                let imgUid = NSUUID().uuidString
                let metadata = StorageMetadata()
                metadata.contentType = "image/jpeg"
                
                DataService.ds.Ref_Product_Images.child(imgUid).putData(imgData, metadata: metadata) { (metadata, error) in
                    if error != nil {
                        print("JESS: Unable to upload image to Firebasee torage")
                    } else {
                        
                        let downloadURL = metadata?.downloadURL()?.absoluteString
                        if let url = downloadURL {
                            
                            self.productImagesUrl = url
                            print(self.productImagesUrl!)
                        }
                    }
                }
                
                
                
            } else {
                print("JESS: A valid image wasn't selected")
            }
            imagePicker.dismiss(animated: true, completion: nil)
        }
    }
    
    
    
    @IBAction func tappedOnProductImg(_ sender: AnyObject) {
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    
    
    @IBAction func tappedAddProductSave(_ sender: Any) {
        
        
        guard let productName = productNameTF.text, productName != "",let productCode = productCodeTF.text, productCode != "",let productType = productTypeTF.text, productType != "", let productPrice = productPriceTF.text, productPrice != "",let productDescription = productDescriptionTF.text, productDescription != "",let pricePerQuantity = pricePerQuantity.text, pricePerQuantity != "" else {
            
            return
        }
        guard addproductImg.image != nil, imageSelected == true, let imageUrl = productImagesUrl, imageUrl != "" else {
            print("JESS: An image must be selected")
            return
        }
        
        
        addProductToFirebase(imgUrl: imageUrl)
        
        
        
    }
    
    
    func addProductToFirebase(imgUrl: String) {
        let product: Dictionary<String, AnyObject> = [
            "productName": productNameTF.text! as AnyObject,
            "productimageUrl": imgUrl as AnyObject,
            "productCode": productCodeTF.text! as AnyObject,
            "productType": productTypeTF.text! as AnyObject,
            "productPrice":productPriceTF.text! as AnyObject,
            "productDescription":productDescriptionTF.text! as AnyObject,
            "pricePerQuantity":pricePerQuantity.text! as AnyObject
        ]
        
        let firebasePost = DataService.ds.REF_Products.childByAutoId()
        firebasePost.setValue(product)
        imageSelected = false
        
        productNameTF.text = ""
        productCodeTF.text = ""
        productTypeTF.text = ""
        productPriceTF.text = ""
        productDescriptionTF.text = ""
        pricePerQuantity.text = ""
        
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
        
    }
    
    
    
}
