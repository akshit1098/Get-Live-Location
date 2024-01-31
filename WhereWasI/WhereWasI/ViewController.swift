//
//  ViewController.swift
//  WhereWasI
//
//  Created by Akshit Saxena on 1/11/24.
//

import UIKit
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    let locationManager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        if let oldCoords = DataStore().GetLastLocation(){
            let annotation = MKPointAnnotation()
            annotation.coordinate.latitude = Double(oldCoords.latitude)!
            annotation.coordinate.longitude = Double(oldCoords.longitude)!
            
            annotation.title = "I Was Here!!"
            annotation.subtitle = "Remember?"
            mapView.addAnnotation(annotation)
        }
        
        UpdateSavedPin()
    }
    
    @IBAction func SaveButtonClicked(_ sender: Any) {
        
        let coord = locationManager.location?.coordinate
        if let lat = coord?.latitude{
            if let long = coord?.longitude{
                DataStore().storeDataPoint(latitude: String(lat), longitude: String(long))
                UpdateSavedPin()
            }
        }
        
    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        guard status == .authorizedWhenInUse else{
            print("Location not enabled")
            return
        }
        print("Location allowed")
        mapView.showsUserLocation = true
    }
    
    func UpdateSavedPin(){
        if let oldCoords = DataStore().GetLastLocation(){
            let annoRem = mapView.annotations.filter{$0 !== mapView.userLocation}
            mapView.removeAnnotations(annoRem)
        }
    }

}

