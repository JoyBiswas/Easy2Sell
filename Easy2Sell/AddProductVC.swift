//
//  AddProductVC.swift
//  Easy2Sell
//
//  Created by JOY BISWAS on 3/17/18.
//  Copyright © 2018 MacBook Air. All rights reserved.
//

import UIKit
import Firebase

class AddProductVC: UIViewController,UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    
    @IBOutlet weak var addproductImg: CornerRadiousView!
    
    @IBOutlet weak var productNameTF: FancyField!
    
    @IBOutlet weak var productCodeTF: FancyField!
    
    @IBOutlet weak var productTypeTF: FancyField!
    
    @IBOutlet weak var productPriceTF: FancyField!
    
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
            
//            if tableView == resultController.tableView {
//                let produc = produtsArray[indexPath.row]
//                
//                cell.textLabel?.text = produc
//                
//            }
            
            
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
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            addproductImg.image = image
            
            imageSelected = true
            
            guard let img = addproductImg.image, imageSelected == true else {
                print("JESS: An image must be selected")
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
                        print("JESS: Successfully uploaded image to Firebase storage")
                        let downloadURL = metadata?.downloadURL()?.absoluteString
                        if let url = downloadURL {
                            
                         self.productImagesUrl = url
                          print(self.productImagesUrl!)
                        }
                    }
                }
                
                print("what was my image")
                
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
        
        
        guard let productName = productNameTF.text, productName != "",let productCode = productCodeTF.text, productCode != "",let productType = productTypeTF.text, productType != "", let productPrice = productPriceTF.text, productPrice != "",let productDescription = productDescriptionTF.text, productDescription != "" else {
            
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
            "productDescription":productDescriptionTF.text! as AnyObject
        ]
        
        let firebasePost = DataService.ds.REF_Products.childByAutoId()
        firebasePost.setValue(product)
        imageSelected = false
        
        productNameTF.text = ""
        productCodeTF.text = ""
        productTypeTF.text = ""
        productPriceTF.text = ""
        productDescriptionTF.text = ""
        

    }
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        
        
//        searchController = UISearchController(searchResultsController: resultController)
//        productTable.tableHeaderView = searchController.searchBar
        
//        searchController.searchResultsUpdater = self
//        resultController.tableView.delegate = self
//        resultController.tableView.dataSource = self
//        
        
        
        
        
        DataService.ds.REF_Products.observe(.value, with: { (snapshot) in
            
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
                for snap in snapshot {
                    print("SNAP: \(snap)")
                    if let productDict = snap.value as? Dictionary<String, AnyObject> {
                       // let productName = productDict["productName"]
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
    
//    func updateSearchResults(for searchController: UISearchController) {
//        
//         filterdArray = produtsArray.filter({ (array:String) -> Bool in
//            
//            if produtsArray.contains(searchController.searchBar.text!) {
//                
//                return true
//            }else {
//                
//                return false
//            }
//            
//        })
//        resultController.tableView.reloadData()
//        
//        
//    }
//
    
}
