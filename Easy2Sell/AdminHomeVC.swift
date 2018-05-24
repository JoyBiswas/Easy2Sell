//
//  AdminHomeVC.swift
//  Easy2Sell
//
//  Created by JOY BISWAS on 2/28/18.
//  Copyright © 2018 MacBook Air. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper


class AdminHomeVC: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate{
    
    var menuShow = false
    var imagePicker:UIImagePickerController!
    static var imageCache:NSCache<NSString, UIImage> = NSCache()
    var selectedIndexPath: NSIndexPath = NSIndexPath()
    
    var imageSelected = false
    var inSearchMode = false
    
    
    var activeRepresentative = [ActiveRepresentativeModel]()
    
    var filteredObject:[ActiveRepresentativeModel]?
    
    @IBOutlet weak var activeEmployeeBtn: UIButton!
    
    @IBOutlet weak var adminProfileImg: CircleView!
    
    @IBOutlet weak var addemployeeBtn: FancyBtn!
    
    @IBOutlet weak var addProductBtn: FancyBtn!
    
    @IBOutlet weak var productReguestBtn: FancyBtn!
    
    @IBOutlet weak var activeRepresentativeNumber: UILabel!
    
    @IBOutlet weak var activeRepresentativeTable: UITableView!
    
    @IBOutlet weak var menuLeadingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var mainView: UIView!
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    override func viewDidLoad() {
        
        searchBar.delegate = self
        
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(AdminHomeVC.swiped(gesture:)))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(AdminHomeVC.swiped(gesture:)))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        self.view.addGestureRecognizer(swipeLeft)
        
        DataService.ds.REF_USER_LOCATION.queryOrdered(byChild: "visitedDate").observe(DataEventType.value, with: { (snapshot) in
            
            //if the reference have some values
            if snapshot.childrenCount > 0 {
                
                //clearing the list
                self.activeRepresentative.removeAll()
                
                //iterating through all the values
                for location in snapshot.children.allObjects as! [DataSnapshot] {
                    
                    //getting values
                    
                    
                    let locationObject = location.value as? [String: AnyObject]
                    let employeeName  = locationObject?["employeeName"]
                    let locationId  = locationObject?["id"]
                    let employeeAddress = locationObject?["employeeAddress"]
                    let locationLatitude = locationObject?["locationlatitute"]
                    let locationLongitude = locationObject?["locationLongitute"]
                    let nearestPlaceLocation = locationObject?["employeeNearestPlace"]
                    let profileImageUrl = locationObject?["employeePhotoUrl"]
                    let visitedDate = locationObject?["visitedDate"]
                    
                    
                    let repLocation = ActiveRepresentativeModel(profileName: employeeName as! String, profileimageUrl: profileImageUrl as! String, profileEmail: employeeAddress as! String, repLocationPlace: nearestPlaceLocation as! String, repLocationLat: locationLatitude as! Double, repLocationLong: locationLongitude as! Double, repCurrentTime: visitedDate as! String)
                    
                    
                    self.activeRepresentative.append(repLocation)
                    
                    
                }
                
                //reloading the tableview
                self.activeRepresentativeTable.reloadData()
            }
        })
        
        
        
        setupMenubar()
        menuLeadingConstraint.constant = 0
        
        guard let username = Auth.auth().currentUser?.displayName else { return }
        
        
        navigationItem.title = username
        //_ = KeychainWrapper.standard.removeObject(forKey: "adminuid")
        
        //activeEmployeeBtn.backgroundColor = UIColor.cyan
        
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        
        
        
        // profile picture calling
        
        let user = Auth.auth().currentUser
        
        func getDataFromUrl(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
            URLSession.shared.dataTask(with: url) { data, response, error in
                completion(data, response, error)
                }.resume()
        }
        
        func downloadImage(url: URL) {
            
            getDataFromUrl(url: url) { data, response, error in
                guard let data = data, error == nil else { return }
                print(response?.suggestedFilename ?? url.lastPathComponent)
                DispatchQueue.main.async() {
                    self.adminProfileImg.image = UIImage(data: data)
                }
            }
        }
        
        
        if Auth.auth().currentUser != nil {
            
            if let url = user?.photoURL {
                
                
                downloadImage(url: url)
                
                
            }
            
            
        }
        
        
        
    }
    
    
    
    
    func setupMenubar(){
        let barImage = UIImage(named: "menu.png")?.withRenderingMode(.alwaysOriginal)
        let menuBarbutton = UIBarButtonItem(image: barImage, style: .plain, target: self,action: #selector(manuBtn))
        navigationItem.leftBarButtonItems = [menuBarbutton]
        
    }
    
    
    
    func manuBtn() {
        
        if(menuShow)
        {
            menuLeadingConstraint.constant = 0
            handelanimation()
            
        }
        else{
            menuLeadingConstraint.constant = 125
            handelanimation()
            
            
        }
        menuShow = !menuShow
    }
    
    func handelanimation()
    {
        UIView.animate(withDuration: 0.9, animations: {
            self.view.layoutIfNeeded()
        })
        mainView.layer.shadowOpacity = 1
        mainView.layer.shadowRadius = 5
        
        
    }
    
    func swiped(gesture: UIGestureRecognizer) {
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            
            switch swipeGesture.direction {
                
            case UISwipeGestureRecognizerDirection.right:
                menuLeadingConstraint.constant = 125
                
                UIView.animate(withDuration:
                0.1) {
                    
                    self.view.layoutIfNeeded()
                }
                menuShow = !menuShow
                
                
            case UISwipeGestureRecognizerDirection.left:
                menuLeadingConstraint.constant = 0
                
                UIView.animate(withDuration:
                0.1) {
                    
                    self.view.layoutIfNeeded()
                }
                menuShow = !menuShow
                
            default:
                break
                
            }
            
            
        }
        
        
    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.searchBar.endEditing(true)
    }
    
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text == nil || searchBar.text == "" {
            
            inSearchMode = false
            self.activeRepresentativeTable.reloadData()
            view.endEditing(true)
            
        } else {
            
            inSearchMode = true
            let lowerCase = searchBar.text!.lowercased()
            filteredObject = activeRepresentative.filter({$0.profileName.lowercased().hasPrefix(lowerCase) })
            self.activeRepresentativeTable.reloadData()
            
            
        }
        
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        self.activeRepresentativeNumber.text = "Active Representatives( \(activeRepresentative.count) )"
        
        if inSearchMode {
            
            return filteredObject!.count
            
        }
        
        return activeRepresentative.count
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ActiveCell", for: indexPath) as? ActiveRepresentativesCell {
            
            let fill: ActiveRepresentativeModel!
            let img:UIImage!
            if inSearchMode {
                
                
                fill = filteredObject?[indexPath.row]
                img = AdminHomeVC.imageCache.object(forKey:fill.profileimageUrl  as NSString)
                
            } else {
                
                
                fill = activeRepresentative.reversed()[indexPath.row]
                img = AdminHomeVC.imageCache.object(forKey:fill.profileimageUrl  as NSString)
            }
            if img != nil {
                cell.configureCell(representative: fill, img: img)
            }else {
                cell.configureCell(representative: fill, img: nil)
            }
            return cell
            
        }else {
            return ActiveRepresentativesCell()
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.selectedIndexPath = indexPath as NSIndexPath
        
        performSegue(withIdentifier: "toMapView", sender: nil)
    }
    
    
    
    open override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let indexPath = self.selectedIndexPath
        
        
        if (segue.identifier == "toMapView") {
            if  let viewController = segue.destination as? MapViewForLocationVC  {
                
                if inSearchMode {
                    let representative = filteredObject?[indexPath.row]
                    
                    viewController.representativeName = (representative?.profileName)!
                    viewController.representativeEmail = (representative?.profileEmail)!
                    viewController.representativeLocation = (representative?.repLocationPlace)!
                    viewController.representativeCurrentTime = (representative?.repCurrentTime)!
                    viewController.representativeLat = (representative?.repLocationLat)!
                    viewController.representativeLong = (representative?.repLocationLong)!
                    
                }else {
                    
                    let representative = activeRepresentative.reversed()[indexPath.row]
                    
                    viewController.representativeName = representative.profileName
                    viewController.representativeEmail = representative.profileEmail
                    viewController.representativeLocation = representative.repLocationPlace
                    viewController.representativeCurrentTime = representative.repCurrentTime
                    viewController.representativeLat = representative.repLocationLat
                    viewController.representativeLong = representative.repLocationLong
                    
                }
                
                
            }
        }
        
        
        
    }
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            adminProfileImg.image = image
            
            imageSelected = true
            
            guard let img = adminProfileImg.image, imageSelected == true else {
                
                return
            }
            
            if let imgData = UIImageJPEGRepresentation(img, 0.2) {
                
                let imgUid = Auth.auth().currentUser?.email
                let metadata = StorageMetadata()
                metadata.contentType = "image/jpeg"
                
                DataService.ds.Ref_Emp_ProFile_Images.child(imgUid!).putData(imgData, metadata: metadata) { (metadata, error) in
                    if error != nil {
                        
                    } else {
                        
                        let downloadURL = metadata?.downloadURL()?.absoluteString
                        if let url = downloadURL {
                            
                            let user = Auth.auth().currentUser
                            if let user = user {
                                let changeRequest = user.createProfileChangeRequest()
                                
                                changeRequest.photoURL =
                                    NSURL(string: url) as URL?
                                changeRequest.commitChanges { error in
                                    if let error = error {
                                        
                                        AlertController.showAlert(self, title: "Error", message: "\(error.localizedDescription)")
                                        return
                                        
                                    } else {
                                        AlertController.showAlert(self, title: "Profile Picture Set", message: "You can change again")
                                        return
                                    }
                                }
                            }
                        }
                    }
                }
                
                
                
            } else {
                print("JESS: A valid image wasn't selected")
            }
            imagePicker.dismiss(animated: true, completion: nil)
        }
    }
    @IBAction func addImageTapped(_ sender: AnyObject) {
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    
    
    @IBAction func tappedActiveEmployee(_ sender: Any) {
        
        menuLeadingConstraint.constant = 0
        
        UIView.animate(withDuration:
        0.3) {
            
            self.view.layoutIfNeeded()
        }
        menuShow = !menuShow
        
        
    }
    
    @IBAction func onLogoutTapped(_ sender: Any)
    {
        
        do {
            
            
            try Auth.auth().signOut()
            _ = KeychainWrapper.standard.removeObject(forKey: "adminuid")
            dismiss(animated: true, completion: nil)
            
        } catch {
            print(error)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.activeRepresentativeTable.reloadData()
    }
    
    
}
