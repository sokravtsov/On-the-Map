//
//  MapViewController.swift
//  On the Map
//
//  Created by Sergey Kravtsov on 01.11.16.
//  Copyright © 2016 Sergey Kravtsov. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController : UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    // MARK: Variables
    
    ///Apple Map View
    @IBOutlet weak var mapView: MKMapView!
    
    ///Logout Button
    @IBOutlet weak var logoutButton: UIBarButtonItem!
    
    ///Pin Button
    @IBOutlet weak var pinButton: UIBarButtonItem!
    
    ///Button for update data from server
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    
    ///Create LocationManager
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.locationManager.delegate = self

        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        self.locationManager.requestWhenInUseAuthorization()
        
        self.locationManager.startUpdatingLocation()
        
        self.mapView.showsUserLocation = true
        

    }
    
    // MARK: Location Delegate Methods
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations.last
        
        let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1))
        
        self.mapView.setRegion(region, animated: true)
        
        self.locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print ("Errors: " + error.localizedDescription)
    }
    
    ///Method to get multiple student locations 
    func getStudentLocations() {
        let request = NSMutableURLRequest(url: URL(string: "\(DataLoader.mainBaseURL)+\(DataLoader.baseURLforStudentLocation)")!)
        request.addValue("\(DataLoader.parseAppID)", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("\(DataLoader.RestAPIKey)", forHTTPHeaderField: "X-Parse-REST-API-Key")
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) {data, responce, error in
            if error != nil {
                return
            }
            print(NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!)
        }
        task.resume()
    }
    
    ///Method to get a single student location
    func getStudentLocation() {
        let request = NSMutableURLRequest(url: URL(string: "\(DataLoader.mainBaseURL)+\(DataLoader.baseURLforStudentLocation)")!)
        request.addValue("\(DataLoader.parseAppID)", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("\(DataLoader.RestAPIKey)", forHTTPHeaderField: "X-Parse-REST-API-Key")
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            if error != nil {
                return
            }
            print(NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!)
        }
        task.resume()

    }
    
    
    
    
    
    
    
    
    
    
    
    
}
