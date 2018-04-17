//
//  ProductRequestVC.swift
//  Easy2Sell
//
//  Created by JOY BISWAS on 3/17/18.
//  Copyright © 2018 MacBook Air. All rights reserved.
//

import UIKit
import Firebase

var tapOnDeliveryMark:Bool = false

class ProductRequestVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var currentRow = 0;
    @IBOutlet weak var requestedProductTable: UITableView!
    
    var refProductOrderRequest:DatabaseReference?
    
    var requestedProduct = [OrderProductRequset]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        DataService.ds.REf_ORDER_REQUEST_LIST.queryOrdered(byChild: "orderDate").observe(DataEventType.value, with: { (snapshot) in
            
            //if the reference have some values
            if snapshot.childrenCount > 0 {
                
                //clearing the list
                self.requestedProduct.removeAll()
                
                //iterating through all the values
                for productOrder in snapshot.children.allObjects as! [DataSnapshot] {
                    
                    //getting values
                    
                    let productOrderObject = productOrder.value as? [String: AnyObject]
                    let productName  = productOrderObject?["productName"]
                    let productId  = productOrderObject?["id"]
                    let productCode = productOrderObject?["productCode"]
                    let productPrice = productOrderObject?["productPrice"]
                    let orderDate = productOrderObject?["orderDate"]
                    let deliveryDate = productOrderObject?["productDeliveryDate"]
                    let toCompany = productOrderObject?["productOrderFrom"]
                    let quantityPerPrice = productOrderObject?["quantityPerPrice"]
                    let totalPrice = productOrderObject?["productTotalPrice"]
                    let ordererPhn = productOrderObject?["productOrdererPhn"]
                    let productOrdererAdress = productOrderObject?["productOrdererAdress"]
                    let productOrderBy = productOrderObject?["productOrderBy"]
                    let productQuantity = productOrderObject?["productQuantity"]
                    //let productType = productOrderObject?["productType"]
                    
                    
                    
                    let productPricewithQunt = "\(String(describing: productPrice!))\(String(describing: quantityPerPrice!))"
                    
                    
                    
                    //creating artist object with model and fetched values
                    let orderProduct = OrderProductRequset(id: productId as? String, productName: productName as? String, productCode: productCode as? String, productPrice: productPricewithQunt , toCompany: (toCompany as? String)!, totalPrice: totalPrice as? String, orderDate: orderDate as? String, productQuantity: productQuantity as? String, productOrderBy: productOrderBy as? String, productOrdererAdress: productOrdererAdress as? String, productOrdererPhn: ordererPhn as? String, productDeliveryDate:deliveryDate as? String)
                    
                    //appending it to list
                    self.requestedProduct.insert(orderProduct, at: 0)
                    
                    
                    
                }
                
                //reloading the tableview
                self.requestedProductTable.reloadData()
            }
        })
        
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return requestedProduct.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        let cell = requestedProductTable.dequeueReusableCell(withIdentifier: "PreqCell") as! ProductRequestTableCell
        let orderProduct:OrderProductRequset!
        orderProduct = requestedProduct[indexPath.row]
        
        cell.productName.text = orderProduct.productName
        cell.productCode.text = orderProduct.productCode
        cell.productQuantity.text = orderProduct.productQuantity
        cell.productPrice.text = orderProduct.productPrice
        cell.orderBy.text = orderProduct.productOrderBy
        cell.orderFrom.text = orderProduct.tocompany
        cell.orderAdress.text = orderProduct.productOrdererAdress
        cell.orderPhnNumber.text = orderProduct.productOrdererPhn
        cell.totalPrice.text = orderProduct.totalPrice
        cell.orderDate.text = orderProduct.orderDate
        cell.deliberyDate.text = orderProduct.productDeliveryDate
        
        
        
        if indexPath.row == currentRow {
            if tapOnDeliveryMark == true {
                
                cell.deliveyMarkImg.image = UIImage(named: "fillTicMark")
                
                tapOnDeliveryMark = false
            } else {
                cell.deliveyMarkImg.image = UIImage(named: "ticMark")
                
                tapOnDeliveryMark = true
            }
        }
        
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedRowIndex = indexPath
        currentRow = selectedRowIndex.row
        requestedProductTable.reloadData()
    }
    
    
    
}
