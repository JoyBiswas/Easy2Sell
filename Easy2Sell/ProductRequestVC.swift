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

class ProductRequestVC: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate{
    
    var currentRow = 0;
    @IBOutlet weak var requestedProductTable: UITableView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var refProductOrderRequest:DatabaseReference?
    var inSearchMode:Bool = false
    
    var requestedProduct = [OrderProductRequset]()
    var filteredObject:[OrderProductRequset]?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        
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
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text == nil || searchBar.text == "" {
            
            inSearchMode = false
            self.requestedProductTable.reloadData()
            view.endEditing(true)
            
        } else {
            
            inSearchMode = true
            let lowerCase = searchBar.text!.lowercased()
            filteredObject = requestedProduct.filter({($0.orderDate?.lowercased().hasPrefix(lowerCase))! })
            self.requestedProductTable.reloadData()
            
            
        }
        
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if inSearchMode {
            return (filteredObject?.count)!
        }
        
        return requestedProduct.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        //        let cell = requestedProductTable.dequeueReusableCell(withIdentifier: "PreqCell") as! ProductRequestTableCell
        //        let orderProduct:OrderProductRequset!
        //        orderProduct = requestedProduct[indexPath.row]
        //
        
        //
        
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PreqCell", for: indexPath) as? ProductRequestTableCell {
            
            let fill: OrderProductRequset!
            
            if inSearchMode {
                
                
                fill = filteredObject?[indexPath.row]
                
                
            } else {
                
                
                fill = requestedProduct.reversed()[indexPath.row]
                
            }
            cell.productName.text = fill.productName
            cell.productCode.text = fill.productCode
            cell.productQuantity.text = fill.productQuantity
            cell.productPrice.text = fill.productPrice
            cell.orderBy.text = fill.productOrderBy
            cell.orderFrom.text = fill.tocompany
            cell.orderAdress.text = fill.productOrdererAdress
            cell.orderPhnNumber.text = fill.productOrdererPhn
            cell.totalPrice.text = fill.totalPrice
            cell.orderDate.text = fill.orderDate
            cell.deliberyDate.text = fill.productDeliveryDate
            
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
            
        }else {
            return ActiveRepresentativesCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedRowIndex = indexPath
        currentRow = selectedRowIndex.row
        requestedProductTable.reloadData()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.searchBar.endEditing(true)
    }
    
    
}
