//
//  MyVisitedComVC.swift
//  Easy2Sell
//
//  Created by JOY BISWAS on 3/17/18.
//  Copyright © 2018 MacBook Air. All rights reserved.
//

import UIKit
import Firebase

class MyVisitedComVC: UIViewController,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate {
    
    @IBOutlet weak var visitedCompanyTable: UITableView!
    

    @IBOutlet weak var companyName: UITextField!
    
    @IBOutlet weak var companyAdress: UITextField!
    
    
    @IBOutlet weak var companyContact: UITextField!
    
    var refVisitedCompany:DatabaseReference!
    
    var companyList = [AddVisitedcompany]()
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return companyList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = visitedCompanyTable.dequeueReusableCell(withIdentifier:"ComCell") as! VisitedCompanyCell
        
        let companyees:AddVisitedcompany!
        
         companyees = companyList[indexPath.row]
        
        cell.companyName.text = companyees.companyName
        cell.companyAdress.text = companyees.companyAddress
        cell.companyCellNo.text = companyees.companyContact
        cell.visitedDate.text = companyees.visitedDate
        
        
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //getting the selected artist
        let company  = companyList[indexPath.row]
        
        //building an alert
        let alertController = UIAlertController(title: company.companyName, message: "Give new values to update ", preferredStyle: .alert)
        
        //the confirm action taking the inputs
        let confirmAction = UIAlertAction(title: "Save", style: .default) { (_) in
            
            //getting artist id
            let id = company.id
            
            //getting new values
            let companyname = alertController.textFields?[0].text
            let companyAddress = alertController.textFields?[1].text
            let phn_no = alertController.textFields?[2].text
            let date = alertController.textFields?[3].text
            
            
            //calling the update method to update artist
            self.updateecompany(id: id!, companyName: companyname!, companyAddress: companyAddress!, phn: phn_no!, visitedDate: date!)
        }
        
        //the cancel action doing nothing
        let cancelAction = UIAlertAction(title: "Delete", style: .cancel) { (_) in
            self.deleteeCompany(id: company.id!)
            
        }
        
        //adding two textfields to alert
        alertController.addTextField { (textField) in
            textField.text = company.companyName        }
        alertController.addTextField { (textField) in
            textField.text = company.companyAddress
        }
        alertController.addTextField { (textField) in
            
            textField.text = company.companyContact
        }
        alertController.addTextField { (textField) in
            
            textField.text = company.visitedDate
        }
        
        //adding action
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        //presenting dialog
        present(alertController, animated: true, completion: nil)
        
    }
    
    func updateecompany(id:String, companyName:String, companyAddress:String,phn:String,visitedDate:String){
        //creating artist with the new given values
        let company = ["id":id,
                        "companyName": companyName,
                        "companyAddress": companyAddress,
                        "companyContact":phn,
                        "visitedDate":visitedDate
        ]
        
        //updating the artist using the key of the artist
        refVisitedCompany.child(id).setValue(company)
        
        AlertController.showAlert(self, title: "Company Added", message: "Your company are in list you can edit also")
        
    }
    
    func deleteeCompany(id:String){
        refVisitedCompany.child(id).setValue(nil)
        
        
        //displaying message
        AlertController.showAlert(self, title: "Employee are Removed", message: "Your employee are in list you can edit also")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if Auth.auth().currentUser != nil {
            
            if let currentUser = Auth.auth().currentUser {
                
                let userVisitedCompany = currentUser.uid+"VisitedCompany"
        
        
        self.refVisitedCompany = Database.database().reference().child(userVisitedCompany)
            
            }
        }
        
        
        refVisitedCompany.queryOrdered(byChild: "visitedDate").observe(DataEventType.value, with: { (snapshot) in
            
            //if the reference have some values
            if snapshot.childrenCount > 0 {
                
                //clearing the list
                self.companyList.removeAll()
                
                //iterating through all the values
                for company in snapshot.children.allObjects as! [DataSnapshot] {
                    
                    //getting values
                    let companyObject = company.value as? [String: AnyObject]
                    let companyName  = companyObject?["companyName"]
                    let companyId  = companyObject?["id"]
                    let companyAddress = companyObject?["companyAddress"]
                    let companyContact = companyObject?["companyContact"]
                    let visitedDate = companyObject?["visitedDate"]
                    
                    
                    
                    //creating artist object with model and fetched values
                    let company = AddVisitedcompany(id: companyId as? String, companyName: companyName as? String, companyAddress: companyAddress as? String, companyContact: companyContact as? String, date: (visitedDate as? String)! )
                    
                    //appending it to list
                    self.companyList.insert(company , at: 0)
                    
                        
                    
                }
                
                //reloading the tableview
                self.visitedCompanyTable.reloadData()
            }
        })

       
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func addVisitedCompany(){
        //generating a new key inside artists node
        //and also getting the generated key
        let key = refVisitedCompany.childByAutoId().key
        
        
        guard  companyName.text != "",companyAdress.text != "",companyContact.text != "" else{
            
            AlertController.showAlert(self, title: "Missing InFo", message: "Please fill up your field")
            return
            
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy HH:mm"
        let dateInFormat = dateFormatter.string(from: Date())
        
        let visitedCompany = ["id":key,
                        "companyName": companyName.text! as String,
                        "companyAddress": companyAdress.text! as String,"companyContact":companyContact.text! as String,"visitedDate":dateInFormat] as [String : Any]
        
        //adding the artist inside the generated unique key
        refVisitedCompany.child(key).setValue(visitedCompany)
        
        self.companyName.text = ""
        self.companyAdress.text = ""
        self.companyContact.text = ""
                
        AlertController.showAlert(self, title: "Companies Added", message: "Your visited Companies are in list you can edit also")
        
        
    }

    
    
    @IBAction func tappedVisitedComSave(_ sender: Any) {
        
        
        addVisitedCompany()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
        
    }

    
   }
