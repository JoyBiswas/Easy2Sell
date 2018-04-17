//
//  MapViewForLocationVC.swift
//  Easy2Sell
//
//  Created by JOY BISWAS on 4/16/18.
//  Copyright © 2018 MacBook Air. All rights reserved.
//

import UIKit
import MapKit

class MapViewForLocationVC: UIViewController,MKMapViewDelegate,CLLocationManagerDelegate {
    
    var representativeName:String = String()
    var representativeEmail:String = String()
    var representativeLocation:String = String()
    var representativeLat:Double = Double()
    var representativeLong:Double = Double()
    var representativeCurrentTime:String = String()
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let latitute:CLLocationDegrees = CLLocationDegrees(representativeLat)
        
        let longitute:CLLocationDegrees = CLLocationDegrees(representativeLong)
        
        let latDelta:CLLocationDegrees = 0.05
        
        let lonDelta:CLLocationDegrees = 0.05
        
        let span = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: lonDelta)
        
        let cordinates = CLLocationCoordinate2D(latitude: latitute, longitude: longitute)
        
        let region = MKCoordinateRegion(center: cordinates, span: span)
        
        
        mapView.setRegion(region, animated: true)
        
        
        // user annotation adding
        
        let annotation = MKPointAnnotation()
        
        annotation.title = "(\(self.representativeName))\(self.representativeEmail)"
        annotation.subtitle = "\(self.representativeCurrentTime) \(self.representativeLocation)"
        annotation.coordinate = cordinates
        
        mapView.addAnnotation(annotation)
        
        
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
        
        
        
        
    }
    
}
