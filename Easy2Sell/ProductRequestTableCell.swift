//
//  ProductRequestTableCell.swift
//  Easy2Sell
//
//  Created by JOY BISWAS on 3/23/18.
//  Copyright © 2018 MacBook Air. All rights reserved.
//

import UIKit
import Firebase

class ProductRequestTableCell: UITableViewCell {
    
    @IBOutlet weak var productName: UITextView!
    
    @IBOutlet weak var productCode: UITextView!
    
    @IBOutlet weak var productQuantity: UITextView!
    
    @IBOutlet weak var productPrice: UITextView!
    
    
    @IBOutlet weak var totalPrice: UITextView!
    
    
    @IBOutlet weak var orderBy: UITextView!
    
    
    @IBOutlet weak var orderFrom: UITextView!
    
    @IBOutlet weak var deliberyDate: UITextView!
    
    
    @IBOutlet weak var orderDate: UITextView!
    
    @IBOutlet weak var deliveyMarkImg: UIImageView!

    @IBOutlet weak var orderPhnNumber: UITextView!
    
    @IBOutlet weak var orderAdress: UITextView!
    
    var productRegVc:ProductRequestVC!
    
    var employeeName:String!
    var employeeContact:String!
    var employeeId:String!
    var employeeEmail:String!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(deliveryMarkTapped))
        tap.numberOfTapsRequired = 3
        deliveyMarkImg.addGestureRecognizer(tap)
        deliveyMarkImg.isUserInteractionEnabled = true
        
        let taponEmail = UITapGestureRecognizer(target: self, action: #selector(showEmailTapped))
        
        taponEmail.numberOfTapsRequired = 1
        
        orderBy.addGestureRecognizer(taponEmail)
        
        orderBy.isUserInteractionEnabled = true
    }
    
    
    func deliveryMarkTapped(sender: UITapGestureRecognizer) {
        tapOnDeliveryMark = true
        
        
        
    }
    
    
    func calll_dataBase(){
        
        
        let  refemployee = Database.database().reference().child("employees");
        let query = refemployee.queryOrdered(byChild: "employeeEmail").queryEqual(toValue: self.orderBy.text)
        query.observeSingleEvent(of: .value) { (snapshot: DataSnapshot) in
            for child in snapshot.children.allObjects as! [DataSnapshot] {
                
                let employeeObject = child.value as? [String: AnyObject]
                
                self.employeeName = employeeObject?["employeeName"] as! String
                self.employeeContact = employeeObject?["employeeCon_No"] as! String
                self.employeeId = employeeObject?["employeeKey"] as! String
                self.employeeEmail = employeeObject?["employeeEmail"] as! String
                
                
            }
        }
    }
    
    func showEmailTapped(sender:UITapGestureRecognizer) {
        
        

        calll_dataBase()
        
        if let employeecon = self.employeeContact,employeecon == "" {
            
            
            
            let alertController = UIAlertController(title: "No InFo", message: "Try Again", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "Ok", style: .default) { action in
                
                
                
            }
            
            alertController.addAction(okAction)
            parentViewController?.present(alertController, animated: true, completion: nil)
            
            
        }else {
            
            
            if let employeecon = self.employeeContact  {
                
                
                let alertController = UIAlertController(title: self.employeeName, message: "\(employeecon)", preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: "Ok", style: .default) { action in
                    
                    
                    self.employeeContact = ""
                    self.employeeName = ""
                    
                    self.calll_dataBase()
                    
                    
                }
                
                alertController.addAction(okAction)
                
                parentViewController?.present(alertController, animated: true, completion: nil)
                
            }
            
            
            
            
            
            
        }
        
        
    
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
    

}

extension UIView {
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if parentResponder is UIViewController {
                return parentResponder as! UIViewController!
            }
        }
        return nil
    }
}
