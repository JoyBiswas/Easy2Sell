//
//  AddEmployeeVC.swift
//  Easy2Sell
//
//  Created by JOY BISWAS on 3/17/18.
//  Copyright © 2018 MacBook Air. All rights reserved.
//

import UIKit
import Firebase

class AddEmployeeVC: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate {
    
    
    
    @IBOutlet weak var employeeTableView: UITableView!
    
    @IBOutlet weak var employeeName: FancyField!
    
    @IBOutlet weak var employeeKey: FancyField!
    
    @IBOutlet weak var employeeEmail: FancyField!
    
    @IBOutlet weak var employeeCon_No: FancyField!
    
    
    var refemployee: DatabaseReference!
    
    
    var employeeList = [AddEmployeeModel]()
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return employeeList.count
    }
    
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        //creating a cell using the custom class
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! AddEmployeeTableCell
        
        //the artist object
        let employees: AddEmployeeModel
        
        //getting the artist of selected position
        employees = employeeList[indexPath.row]
        
        //adding values to labels
        cell.employeeName.text = employees.name
        cell.employeeKey.text = employees.key
        cell.employeeEmail.text = employees.email
        cell.employeePhn.text = employees.phn
        cell.lblKey.text = "Key"
        cell.lblName.text = "Name"
        cell.emaillbl.text = "Email"
        cell.phnlbl.text = "Phn:"
        
        //returning cell
        return cell
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refemployee = Database.database().reference().child("employees");
        
        refemployee.observe(DataEventType.value, with: { (snapshot) in
            
            //if the reference have some values
            if snapshot.childrenCount > 0 {
                
                //clearing the list
                self.employeeList.removeAll()
                
                //iterating through all the values
                for employees in snapshot.children.allObjects as! [DataSnapshot] {
                    //getting values
                    let employeeObject = employees.value as? [String: AnyObject]
                    let employeeName  = employeeObject?["employeeName"]
                    let employeeId  = employeeObject?["id"]
                    let employeeKey = employeeObject?["employeeKey"]
                    let employeeEmail = employeeObject?["employeeEmail"]
                    let employeeCon_No = employeeObject?["employeeCon_No"]
                    
                    //creating artist object with model and fetched values
                    let employee = AddEmployeeModel(id: employeeId as! String?, name: employeeName as! String?, key: employeeKey as! String?, email: employeeEmail as! String?, phn: employeeCon_No as! String?)
                    
                    //appending it to list
                    self.employeeList.insert(employee, at: 0)
                    
                }
                
                //reloading the tableview
                self.employeeTableView.reloadData()
            }
        })
        
        
    }
    
    
    func addemployees(){
        //generating a new key inside artists node
        //and also getting the generated key
        let key = refemployee.childByAutoId().key
        
        
        guard  employeeKey.text != "",employeeName.text != "",employeeEmail.text != "",employeeCon_No.text != "" else{
            
            AlertController.showAlert(self, title: "Missing InFo", message: "Please fill up your field")
            return
            
        }
        
        let employee = ["id":key,
                        "employeeName": employeeName.text! as String,
                        "employeeKey": employeeKey.text! as String,"employeeEmail":employeeEmail.text! as String,"employeeCon_No":employeeCon_No.text! as String]
        
        //adding the artist inside the generated unique key
        refemployee.child(key).setValue(employee)
        
        self.employeeName.text = ""
        self.employeeKey.text = ""
        self.employeeEmail.text = ""
        self.employeeCon_No.text = ""
        
        AlertController.showAlert(self, title: "Employee Added", message: "Your employee are in list you can edit also")
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //getting the selected artist
        let employee  = employeeList[indexPath.row]
        
        //building an alert
        let alertController = UIAlertController(title: employee.name, message: "Give new values to update ", preferredStyle: .alert)
        
        //the confirm action taking the inputs
        let confirmAction = UIAlertAction(title: "Save", style: .default) { (_) in
            
            //getting artist id
            let id = employee.id
            
            //getting new values
            let name = alertController.textFields?[0].text
            let key = alertController.textFields?[1].text
            let email = alertController.textFields?[2].text
            let phn_no = alertController.textFields?[3].text
            
            
            //calling the update method to update artist
            self.updateemployee(id: id!, name: name!, key: key!, email: email!, phn: phn_no!)
        }
        
        //the cancel action doing nothing
        let cancelAction = UIAlertAction(title: "Delete", style: .cancel) { (_) in
            self.deleteemployee(id: employee.id!)
            
        }
        
        //adding two textfields to alert
        alertController.addTextField { (textField) in
            textField.text = employee.name
        }
        alertController.addTextField { (textField) in
            textField.text = employee.key
        }
        alertController.addTextField { (textField) in
            
            textField.text = employee.email
        }
        alertController.addTextField { (textField) in
            
            textField.text = employee.phn
        }
        
        //adding action
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        //presenting dialog
        present(alertController, animated: true, completion: nil)
        
    }
    
    func updateemployee(id:String, name:String, key:String,email:String,phn:String){
        //creating artist with the new given values
        let employee = ["id":id,
                        "employeeName": name,
                        "employeeKey": key,
                        "employeeEmail":email,
                        "employeeCon_No":phn
        ]
        
        //updating the artist using the key of the artist
        refemployee.child(id).setValue(employee)
        
        AlertController.showAlert(self, title: "Employee Added", message: "Your employee are in list you can edit also")
        
    }
    
    func deleteemployee(id:String){
        refemployee.child(id).setValue(nil)
        
        
        //displaying message
        AlertController.showAlert(self, title: "Employee are Removed", message: "Your employee are in list you can edit also")
    }
    
    @IBAction func employeeSave(_ sender: UIButton) {
        addemployees()
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
        
    }
    
    
}
