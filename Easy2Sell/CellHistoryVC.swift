//
//  CellHistoryVC.swift
//  Easy2Sell
//
//  Created by JOY BISWAS on 3/17/18.
//  Copyright © 2018 MacBook Air. All rights reserved.
//

import UIKit
import Firebase
class CellHistoryVC: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate{
    
    @IBOutlet weak var cellProductTable: UITableView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    
    var refProductAddByEMployee:DatabaseReference!
    
    var productListOrderByMe = [MySellHistory]()
    var filteredObject:[MySellHistory]?
    var inSearchMode:Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        cellProductTable.delegate = self
        cellProductTable.dataSource = self
        
        
        if Auth.auth().currentUser != nil {
            
            if let currentUser = Auth.auth().currentUser {
                
                let userVisitedCompany = currentUser.uid+"ProductAddByEMployee"
                self.refProductAddByEMployee = Database.database().reference().child(userVisitedCompany)
                
            }
        }
        
        
        
        refProductAddByEMployee.queryOrdered(byChild: "orderDate").observe(DataEventType.value, with: { (snapshot) in
            
            //if the reference have some values
            if snapshot.childrenCount > 0 {
                
                //clearing the list
                self.productListOrderByMe.removeAll()
                
                //iterating through all the values
                for productOrder in snapshot.children.allObjects as! [DataSnapshot] {
                    
                    //getting values
                    
                    
                    let productOrderObject = productOrder.value as? [String: AnyObject]
                    let productName  = productOrderObject?["productName"]
                    let productId  = productOrderObject?["id"]
                    let productCode = productOrderObject?["productCode"]
                    let productPrice = productOrderObject?["productPrice"]
                    let orderDate = productOrderObject?["orderDate"]
                    let toCompany = productOrderObject?["productOrderFrom"]
                    let quantityPerPrice = productOrderObject?["quantityPerPrice"]
                    let totalPrice = productOrderObject?["productTotalPrice"]
                    
                    let productPricewithQunt = "\(String(describing: productPrice!))\(String(describing: quantityPerPrice!))"
                    
                    
                    
                    //creating artist object with model and fetched values
                    let orderProduct = MySellHistory(id: productId as? String, productName: productName as? String, productCode: productCode as? String, productPrice: productPricewithQunt, toCompany: (toCompany as? String)!, totalPrice: totalPrice as? String, orderDate: orderDate as? String)
                    
                    //appending it to list
                    self.productListOrderByMe.insert(orderProduct, at: 0)
                    
                    
                }
                
                self.cellProductTable.reloadData()
            }
        })
        
        
    }
    
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        
        if searchBar.text == nil || searchBar.text == "" {
            
            inSearchMode = false
            self.cellProductTable.reloadData()
            view.endEditing(true)
            
        } else {
            
            inSearchMode = true
            let lowerCase = searchBar.text!.lowercased()
            
            
            filteredObject = productListOrderByMe.filter({($0.orderDate!.lowercased().hasPrefix(lowerCase)) })
            self.cellProductTable.reloadData()
            
            
            
            
        }
        
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if inSearchMode {
            return (filteredObject?.count)!
        }
        
        return productListOrderByMe.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let fill: MySellHistory!
        
        if let cell = cellProductTable.dequeueReusableCell(withIdentifier: "CellHistory", for: indexPath) as? CellHistoryTableCell {
            
            
            
            
            if inSearchMode {
                
                
                fill = filteredObject?[indexPath.row]
                
                
            } else {
                
                
                
                
                fill = productListOrderByMe.reversed()[indexPath.row]
                
            }
            
            //adding values to labels
            
            cell.ProductName.text = fill.productName
            cell.productCode.text = fill.productCode
            cell.productPrice.text = fill.productPrice
            cell.toCompanyDeliverd.text = fill.tocompany
            cell.totalPrice.text = fill.totalPrice
            cell.deliverdDate.text = fill.orderDate
            
            
            
            //returning cell
            return cell
            
            
            
        }else {
            return CellHistoryTableCell()
            
        }
        
        
    }
  
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.searchBar.endEditing(true)
    }
    
}
