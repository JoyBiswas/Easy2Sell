//
//  EmployeeHomeVC.swift
//  Easy2Sell
//
//  Created by JOY BISWAS on 2/28/18.
//  Copyright © 2018 MacBook Air. All rights reserved.
//

import UIKit
import Firebase
//import SwiftKeychainWrapper
import MapKit

class EmployeeHomeVC: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate,MKMapViewDelegate,UISearchBarDelegate {
    var menuShow = false
    var imageSelected = false
    var products = [AddProductModel]()
    var filteredObject:[AddProductModel]?
    
    var productType = [String]()
    var productPrice = [String]()
    let locationManager = CLLocationManager()
    var nearestPlace:String = ""
    var inSearchMode = false
    
    
    static var imageCache:NSCache<NSString, UIImage> = NSCache()
    
    var imagePicker:UIImagePickerController!
    
    var selectedIndexPath: NSIndexPath = NSIndexPath()
    
    
    @IBOutlet weak var employeeProfileImg: CircleView!
    
    @IBOutlet weak var segment: UISegmentedControl!
    
    @IBOutlet weak var productTable: UITableView!
    
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
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        productTable.delegate = self
        productTable.delegate = self
        
        
        attemptFetch()
        
        setupMenubar()
        
        menuLeadingConstraint.constant = 0
        
        guard let username = Auth.auth().currentUser?.displayName else { return }
        
        navigationItem.title = username
        
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        
        // calling employee profile pic
        
        let user = Auth.auth().currentUser
        
        func getDataFromUrl(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
            URLSession.shared.dataTask(with: url) { data, response, error in
                completion(data, response, error)
                }.resume()
        }
        
        func downloadImage(url: URL) {
            getDataFromUrl(url: url) { data, response, error in
                guard let data = data, error == nil else { return }
                
                DispatchQueue.main.async() {
                    self.employeeProfileImg.image = UIImage(data: data)
                }
            }
        }
        
        
        if Auth.auth().currentUser != nil {
            
            if let url = user?.photoURL {
                
                downloadImage(url: url)
                
            }
            
        }
        
        
        //products from database
        
        
        if Auth.auth().currentUser?.photoURL == nil {
            
            let userName =  Auth.auth().currentUser?.displayName
            let alertController = UIAlertController(title: "Set Profile Pictures", message: "Mr: \(userName!) please set your profile picture to go", preferredStyle: .alert)
            alertController.view.backgroundColor = UIColor.red// change background color
            alertController.view.layer.cornerRadius = 25
            let confirmAction = UIAlertAction(title: "Ok", style: .default, handler: { (_) in
                
                self.setP()
                
                
            })
            alertController.addAction(confirmAction)
            
            present(alertController, animated: true, completion: nil)
            
            return
        }
        

        
        
        DataService.ds.REF_Products.observe(.value, with: { (snapshot) in
            
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
                self.products.removeAll()
                for snap in snapshot {
                    if let productDict = snap.value as? Dictionary<String, AnyObject> {
                        
                        let key = snap.key
                        let product = AddProductModel(productKey: key, productData: productDict)
                        self.products.insert(product, at: 0)
                        
                        
                    }
                    
                }
                self.productTable.reloadData()
            }
            
            
        })
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        
        self.productTable.reloadData()
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
    
    func setupMenubar(){
        let barImage = UIImage(named: "menu.png")?.withRenderingMode(.alwaysOriginal)
        let menuBarbutton = UIBarButtonItem(image: barImage, style: .plain, target: self,action: #selector(manuBtn))
        navigationItem.leftBarButtonItems = [menuBarbutton]
        
    }
    
    
    func swiped(gesture: UIGestureRecognizer) {
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            
            switch swipeGesture.direction {
                
            case UISwipeGestureRecognizerDirection.right:
                menuLeadingConstraint.constant = 124
                
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
    

    
    
    //location integriting
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations[0]
        
        
        if Auth.auth().currentUser != nil {
            
            if let currentUser = Auth.auth().currentUser {
                
                let name = currentUser.displayName!
                let email = currentUser.email!
                let uid = currentUser.uid
                if let photoUrl:String = (currentUser.photoURL?.absoluteString),name != "",email != "",uid != "" {
                    
                    
                    
                    
                    CLGeocoder().reverseGeocodeLocation(location) { (placemarks, error) in
                        
                        if error != nil {
                            print(error!)
                        }else {
                            if (placemarks?[0]) != nil {
                                
                                let placemark = placemarks?[0]
                                var adress = ""
                                
                                if placemark?.subThoroughfare != nil {
                                    
                                    adress += (placemark?.subThoroughfare)! + " "
                                }
                                if placemark?.thoroughfare != nil {
                                    
                                    adress += (placemark?.thoroughfare)! + "\n"
                                }
                                if placemark?.subLocality != nil {
                                    
                                    adress += (placemark?.subLocality)! + "\n"
                                }
                                if placemark?.subAdministrativeArea != nil {
                                    
                                    adress += (placemark?.subAdministrativeArea)! + "\n"
                                }
                                if placemark?.postalCode != nil {
                                    
                                    adress += (placemark?.postalCode)! + "\n"
                                }
                                if placemark?.country != nil {
                                    
                                    adress += (placemark?.country)! + "\n"
                                }
                                
                                self.nearestPlace = adress
                                
                                
                            }
                            
                        }
                    }
                    
                    
                    
                    self.employeeLocationUpdate(employeeUid: uid, employeeName: name, employeeEmail: email, employeePhotoUrl: photoUrl, employeeNearestPlace: nearestPlace, locationLatitude: location.coordinate.latitude,locationLongitude: location.coordinate.longitude)
                }
            }
            
            
        }
        
    }
    
    
    func employeeLocationUpdate(employeeUid:String,employeeName:String,employeeEmail:String,employeePhotoUrl:String,employeeNearestPlace:String,locationLatitude:Double,locationLongitude:Double) {
        
        let key = DataService.ds.REF_USER_LOCATION.child(employeeUid).key
        
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy HH:mm"
        let dateInFormat = dateFormatter.string(from: Date())
        
        
        let employeeLocation = ["id":key,
                                "employeeName": employeeName,
                                "employeeAddress":employeeEmail,
                                "locationlatitute":locationLatitude,
                                "locationLongitute":locationLongitude,
                                "employeePhotoUrl":employeePhotoUrl,
                                "employeeNearestPlace":employeeNearestPlace,
                                "visitedDate":dateInFormat] as [String : Any]
        
        
        
        DataService.ds.REF_USER_LOCATION.child(employeeUid).setValue(employeeLocation)
        
        
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            employeeProfileImg.image = image
            
            imageSelected = true
            
            guard let img = employeeProfileImg.image, imageSelected == true else {
                
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
                
                
            }
            
            
        } else {
            
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func addImageTapped(_ sender: AnyObject) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    func setP()  {
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    // table view implementing Start
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.searchBar.endEditing(true)
        
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text == nil || searchBar.text == "" {
            
            inSearchMode = false
            self.productTable.reloadData()
            view.endEditing(true)
            
        } else {
            
            inSearchMode = true
            let lowerCase = searchBar.text!.lowercased()
            
            if segment.selectedSegmentIndex == 0 {
                filteredObject = products.filter({$0.productName.lowercased().hasPrefix(lowerCase) })
                self.productTable.reloadData()
            }else  if segment.selectedSegmentIndex == 1{
                
                searchBar.keyboardType = UIKeyboardType.numberPad
                
                if let doubleLowercase = lowerCase.doubleValue{
                    
                    
                
                filteredObject = products.filter({(Double($0.productPrice)?.isLessThanOrEqualTo(Double(doubleLowercase) ))!})
                self.productTable.reloadData()
                
                }
            }else  if segment.selectedSegmentIndex == 2{
                
                filteredObject = products.filter({$0.productType.lowercased().hasPrefix(lowerCase) })
                self.productTable.reloadData()
                
                
            }
            
            
            
        }
        
    }
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if inSearchMode {
            
            return (filteredObject?.count)!
        }
        
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if  let cell = tableView.dequeueReusableCell(withIdentifier: "PlistCell", for: indexPath) as? ProductListTableCell {
            
            
            let fill: AddProductModel!
            let img:UIImage!
            if inSearchMode {
                
                
                fill = filteredObject?[indexPath.row]
                img = AdminHomeVC.imageCache.object(forKey:fill.productimageUrl  as NSString)
                
            } else {
                
                
                
                
                fill = products.reversed()[indexPath.row]
                img = AdminHomeVC.imageCache.object(forKey:fill.productimageUrl  as NSString)
            }
            if img != nil {
                cell.configureCell(product: fill, img: img)
            }else {
                cell.configureCell(product: fill, img: nil)
            }
            return cell
            
        }else {
            return ProductListTableCell()
            
        }
        
        
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.selectedIndexPath = indexPath as NSIndexPath
        
        performSegue(withIdentifier: "toAddToChart", sender: nil)
    }
    
    
    
    open override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let indexPath = self.selectedIndexPath
        
        
        
        if (segue.identifier == "toAddToChart") {
            if  let viewController = segue.destination as? AddToOrderVC  {
                
                
                if inSearchMode {
                    let product = filteredObject?[indexPath.row]
                    viewController.productName = (product?.productName)!
                    viewController.productCode = (product?.productCode)!
                    viewController.productType = (product?.productType)!
                    viewController.productPrice = (product?.productPrice)!
                    viewController.productDetails = (product?.productDescription)!
                    viewController.pImageUrl = (product?.productimageUrl)!
                    viewController.quantityPerPrice = (product?.pricePerQuantity)!
                }else {
                    
                    let product = products.reversed()[indexPath.row]
                    
                    viewController.productName = product.productName
                    viewController.productCode = product.productCode
                    viewController.productType = product.productType
                    viewController.productPrice = product.productPrice
                    viewController.productDetails = product.productDescription
                    viewController.pImageUrl = product.productimageUrl
                    viewController.quantityPerPrice = product.pricePerQuantity
                }
                
            }
        }
        
    }
    
    
    
    
    @IBAction func onLogoutTapped(_ sender: Any)
    {
        
        if Auth.auth().currentUser != nil {
            
            let employeeUid = Auth.auth().currentUser?.uid
            DataService.ds.REF_USER_LOCATION.child(employeeUid!).setValue(nil)
            
        }
        
        
        do {
            
            
            try Auth.auth().signOut()
            _ = KeychainWrapper.standard.removeObject(forKey: "uid")
            dismiss(animated: true, completion: nil)
            
        } catch {
            print(error)
        }
        
        
        
    }
    
    
    @IBAction func tapProductListShow(_ sender: Any) {
        
        menuLeadingConstraint.constant = 0
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
        
        menuShow = !menuShow
    }
    
    
    func attemptFetch() {
        
        
        
        if segment.selectedSegmentIndex == 0 {
            searchBar.keyboardType = UIKeyboardType.alphabet
            
            DataService.ds.REF_Products.observe(.value, with: { (snapshot) in
                
                if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
                    self.products.removeAll()
                    for snap in snapshot {
                        
                        if let productDict = snap.value as? Dictionary<String, AnyObject> {
                            
                            let key = snap.key
                            let product = AddProductModel(productKey: key, productData: productDict)
                            self.products.append(product)
                            
                        }
                        
                    }
                    
                }
                self.productTable.reloadData()
                
            })
            
            
            
            self.productTable.reloadData()
            
            
        } else if segment.selectedSegmentIndex == 1 {
            
            searchBar.keyboardType = UIKeyboardType.numberPad

            
            DataService.ds.REF_Products.queryOrdered(byChild: "productPrice").observe(.value, with: { (snapshot) in
                
                if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
                    self.products.removeAll()
                    
                    for snap in snapshot {
                        
                        if let productDict = snap.value as? Dictionary<String, AnyObject> {
                            
                            let key = snap.key
                            let product = AddProductModel(productKey: key, productData: productDict)
                            self.products.insert(product , at: 0)
                            
                            
                        }
                        
                    }
                    
                }
                self.productTable.reloadData()
                
            })
            
            self.viewDidAppear(true)
            
        } else if segment.selectedSegmentIndex == 2 {
            
            searchBar.keyboardType = UIKeyboardType.alphabet
            
            
            
            DataService.ds.REF_Products.queryOrdered(byChild: "productType").observe(.value, with: { (snapshot) in
                
                if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
                    self.products.removeAll()
                    
                    for snap in snapshot {
                        
                        if let productDict = snap.value as? Dictionary<String, AnyObject> {
                            
                            let key = snap.key
                            let product = AddProductModel(productKey: key, productData: productDict)
                            self.products.insert(product , at: 0)
                            
                            
                            
                        }
                        
                    }
                    
                }
                self.productTable.reloadData()
                
            })
            
            
        }
        
    }
    
    @IBAction func segmentedControllerSHifted(_ sender: Any) {
        
        attemptFetch()
        
    }
    
}
