//
//  AddToOrderVC.swift
//  Easy2Sell
//
//  Created by JOY BISWAS on 3/23/18.
//  Copyright © 2018 MacBook Air. All rights reserved.
//

import UIKit
import Firebase


class AddToOrderVC: UIViewController,UITextFieldDelegate {
    
    
    
    var pImageUrl: String = String()
    var productName: String = String()
    var productCode: String = String()
    var productType: String = String()
    var productPrice: String = String()
    var productDetails: String = String()
    var quantityPerPrice:String = String()
    var apropriatePrice:Double!
    
    
    @IBOutlet weak var orderProductImage: UIImageView!
    
    @IBOutlet weak var orderProductName: UILabel!
    
    @IBOutlet weak var orderProductCode: UILabel!
    

    @IBOutlet weak var orderProductType: UILabel!
    
    @IBOutlet weak var orderProductPrice: UILabel!
    
    @IBOutlet weak var orderProductDetails: UITextView!
    
    @IBOutlet weak var productCodeToOrder: FancyField!
    
    @IBOutlet weak var productQntToOrder: FancyField!
    
    
    @IBOutlet weak var totalPriceToOrder: FancyField!
    
 
    @IBOutlet weak var OrderFrom: FancyField!
    

    @IBOutlet weak var ordererPhn: FancyField!
    
    @IBOutlet weak var ordererAddress: FancyField!
    
    @IBOutlet weak var productDeliveryDate: FancyField!
    
    @IBOutlet weak var quantityPrice: UILabel!
    
    var orderBy:String!
    var orderName:String!
    
    
    var refProductAddByEMployee:DatabaseReference!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.orderProductName.text = productName
        self.orderProductCode.text = productCode
        self.orderProductType.text = productType
        self.orderProductPrice.text = productPrice
        self.orderProductDetails.text = productDetails
        self.quantityPrice.text = quantityPerPrice
        
        if productPrice != " " {
            
            let dataString = productPrice.components(separatedBy: "T")
            
            if dataString.count > 0 {
                
                self.apropriatePrice = Double(dataString[0])
                print(self.apropriatePrice)
                
            }
        }
        
        
        let ref = Storage.storage().reference(forURL: self.pImageUrl)
        ref.getData(maxSize: 2*1024*1024, completion: { (data, error) in
            
            if error != nil {
                print("JESS: Unable to download image from Firebase storage")
                print(error!)
            } else {
                print("JESS: Image downloaded from Firebase storage")
                if let imgData = data {
                    if let img = UIImage(data: imgData) {
                        self.orderProductImage.image = img
                        
                    }
                }
            }
        })
        
        
        self.productCodeToOrder.text =  productCode
        
        
        if Auth.auth().currentUser != nil {
            
            if let currentUser = Auth.auth().currentUser {
                
                let userVisitedCompany = currentUser.uid+"ProductAddByEMployee"
                
                self.orderBy = currentUser.email
                self.orderName = currentUser.displayName
                self.refProductAddByEMployee = Database.database().reference().child(userVisitedCompany)
                
            }
        }
        
        
        
        
    }
    
    
    
    @IBAction func provideTotalPrice(_ sender: FancyField) {
        
        if apropriatePrice != nil && productQntToOrder.text != "" {
            
            if let productQuantity = Double(productQntToOrder.text!) {
                
               let totalprice = productQuantity*apropriatePrice
                
                self.totalPriceToOrder.text = "\(totalprice)Tk"
                
                
            }
            
            
        }
        
        
    }
    
    func addProductToOrder(){
        //generating a new key inside artists node
        //and also getting the generated key
        let key = refProductAddByEMployee.childByAutoId().key
        
        
        guard  orderProductName.text != "",orderProductType.text != "",productCodeToOrder.text != "",orderProductPrice.text != "",orderProductType.text != "",productQntToOrder.text != "",totalPriceToOrder.text != "",orderBy != "",OrderFrom.text != "",ordererPhn.text != "",ordererAddress.text != "",productDeliveryDate.text != "", quantityPerPrice != ""
         else{
            
            let alertController = UIAlertController(title: "Missing info", message: "Mr: \(self.orderName!) please check each and every fields clearly.", preferredStyle: .alert)
            alertController.view.backgroundColor = UIColor.red// change background color
            alertController.view.layer.cornerRadius = 25
            let confirmAction = UIAlertAction(title: "Ok", style: .default, handler: { (_) in
                
                
            })
            alertController.addAction(confirmAction)

            present(alertController, animated: true, completion: nil)

            return
            
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy HH:mm"
        let dateInFormat = dateFormatter.string(from: Date())
        
        let ProductAddByEMployee = ["id":key,
                              "productName": orderProductName.text! as String,
                              "productType": orderProductType.text! as String,
                              "productCode":productCodeToOrder.text! as String,
                              "productPrice":orderProductPrice.text! as String,
                              "productQuantity":productQntToOrder.text! as String,
                              "productTotalPrice":totalPriceToOrder.text! as String,
                              "productOrderBy":self.orderBy as String,
                              "productOrderFrom":OrderFrom.text! as String,
                              "productOrdererAdress":ordererAddress.text! as String,
                              "productOrdererPhn":ordererPhn.text! as String,
                              "quantityPerPrice":quantityPerPrice as String,
                              "productDeliveryDate":productDeliveryDate.text! as String,
                              "orderDate":dateInFormat] as [String : Any]
        
        
        //adding the artist inside the generated unique key
        refProductAddByEMployee.child(key).setValue(ProductAddByEMployee)
        DataService.ds.REf_ORDER_REQUEST_LIST.child(key).setValue(ProductAddByEMployee)
        
        
        
       let alertController = UIAlertController(title: orderProductName.text, message: "Product are added to the orderList", preferredStyle: .alert)
        
        
        alertController.view.backgroundColor = UIColor.orange// change background color
        alertController.view.layer.cornerRadius = 25
        let confirmAction = UIAlertAction(title: "Ok", style: .default, handler: { (_) in
            
            
        })
        alertController.addAction(confirmAction)
        
        present(alertController, animated: true, completion: nil)
        

      productCodeToOrder.text = ""
        
      productQntToOrder.text = ""
        
      totalPriceToOrder.text = ""
        
        
      OrderFrom.text = ""
        
        
      ordererPhn.text = ""
      ordererAddress.text = ""
    productDeliveryDate.text = ""
        
    }

    
    
    
 
    
    @IBAction func addToOrderListProduct(_ sender: Any) {
        
        addProductToOrder()
        
        
    }
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
        
    }


    

}
