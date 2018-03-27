//
//  MyVisitedComVC.swift
//  Easy2Sell
//
//  Created by JOY BISWAS on 3/17/18.
//  Copyright © 2018 MacBook Air. All rights reserved.
//

import UIKit
import Firebase

class MyVisitedComVC: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet weak var visitedCompanyTable: UITableView!
    

    @IBOutlet weak var companyName: UITextField!
    
    @IBOutlet weak var companyAdress: UITextField!
    
    
    @IBOutlet weak var companyContact: UITextField!
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = visitedCompanyTable.dequeueReusableCell(withIdentifier:"ComCell")
        return cell!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func tappedVisitedComSave(_ sender: Any) {
    }
    
   }
