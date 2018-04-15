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


class AdminHomeVC: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITableViewDelegate,UITableViewDataSource{

    @IBOutlet weak var activeEmployeeBtn: UIButton!
    var menuShow = false
    var imagePicker:UIImagePickerController!
    static var imageCache:NSCache<NSString, UIImage> = NSCache()
    
    @IBOutlet weak var adminProfileImg: CircleView!
    
    @IBOutlet weak var addemployeeBtn: FancyBtn!
    
    @IBOutlet weak var addProductBtn: FancyBtn!
    
    
    @IBOutlet weak var productReguestBtn: FancyBtn!
    
   // @IBOutlet weak var mapView: MKMapView!
    
    
    //let locationManager = CLLocationManager()
    
    
    var imageSelected = false
    
    var activeRepresentative = [ActiveRepresentativeModel]()
    
    @IBOutlet weak var activeRepresentativeTable: UITableView!
    
    
    
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        
//        let annotation = MKPointAnnotation()
//        let location = locations[0]
//        
//        
//        let span:MKCoordinateSpan = MKCoordinateSpanMake(0.01, 0.01)
//        let myLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
//        
//        let region:MKCoordinateRegion = MKCoordinateRegionMake(myLocation, span)
//        mapView.setRegion(region, animated: true)
//        
//        
//        
//        annotation.coordinate = myLocation
//        annotation.title = "joys home"
//        mapView.addAnnotation(annotation)
//        
//        
//        self.mapView.showsUserLocation = true
//        
//        
//        
//        
//        
//    }

   
    override func viewDidLoad() {
        
        
//       locationManager.delegate = self
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        locationManager.requestWhenInUseAuthorization()
//       locationManager.startUpdatingLocation()
//        
//        
//        
        DataService.ds.REF_USER_LOCATION.queryOrdered(byChild: "employeeName").observe(DataEventType.value, with: { (snapshot) in
            
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
                    
                   
                    self.activeRepresentative.insert(repLocation, at: 0)
                    
                    
                }
                
                //reloading the tableview
                self.activeRepresentativeTable.reloadData()
            }
        })

        
        
        //DataService.ds.REF_USER_LOCATION.child("54kMhLd1e7WBkSSv2KvmIVVIfR53").observe(.value, with: { (snapshot) in
//            
//           
//                
//                
//                
//            
//                    
//                    //getting values
//            if  let locationObject = snapshot.value as? [String: AnyObject] {
//
//                    print(locationLatitude!)
//                    
//                    
//                
//            }
//
//            
//            
//            
//        })
        
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
            print("Download Started")
            getDataFromUrl(url: url) { data, response, error in
                guard let data = data, error == nil else { return }
                print(response?.suggestedFilename ?? url.lastPathComponent)
                print("Download Finished")
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
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return activeRepresentative.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let representative = activeRepresentative.reversed()[indexPath.row]
        
        if let cell = activeRepresentativeTable.dequeueReusableCell(withIdentifier: "ActiveCell") as? ActiveRepresentativesCell {
            
            
            if let img = AdminHomeVC.imageCache.object(forKey:representative.profileimageUrl  as NSString) {
                
                cell.configureCell(representative: representative, img: img)
            } else {
                cell.configureCell(representative: representative, img: nil)
            }
            
           
            
            return cell
            
        }
        
        return ActiveRepresentativesCell()

    }
    
    
    
    
    
    
    
    func setupMenubar(){
        let barImage = UIImage(named: "menu.png")?.withRenderingMode(.alwaysOriginal)
        let menuBarbutton = UIBarButtonItem(image: barImage, style: .plain, target: self,action: #selector(manuBtn))
        navigationItem.leftBarButtonItems = [menuBarbutton]
        
    }
    @IBOutlet weak var menuLeadingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var mainView: UIView!
    
    
    
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
    
     func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            adminProfileImg.image = image
            
            imageSelected = true
            
            guard let img = adminProfileImg.image, imageSelected == true else {
                print("JESS: An image must be selected")
                return
            }
            
            if let imgData = UIImageJPEGRepresentation(img, 0.2) {
                
                let imgUid = Auth.auth().currentUser?.email
                let metadata = StorageMetadata()
                metadata.contentType = "image/jpeg"
                
                DataService.ds.Ref_Emp_ProFile_Images.child(imgUid!).putData(imgData, metadata: metadata) { (metadata, error) in
                    if error != nil {
                        print("JESS: Unable to upload image to Firebasee torage")
                    } else {
                        print("JESS: Successfully uploaded image to Firebase storage")
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

            print("what was my image")
            
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

    
  
}
