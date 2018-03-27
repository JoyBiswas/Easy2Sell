//
//  CellHistoryVC.swift
//  Easy2Sell
//
//  Created by JOY BISWAS on 3/17/18.
//  Copyright © 2018 MacBook Air. All rights reserved.
//

import UIKit
import Firebase
class CellHistoryVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var cellProductTable: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        cellProductTable.delegate = self
        cellProductTable.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 3
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = cellProductTable.dequeueReusableCell(withIdentifier: "CellHistory")
        return cell!
    }
    

}
