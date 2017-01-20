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
    
    var appDelegate: AppDelegate!
    var locations: [StudentLocation] = [StudentLocation]()


    // MARK: UI Variables
    
    ///Apple Map View
    @IBOutlet weak var mapView: MKMapView!
    
    ///Logout Button
    @IBOutlet weak var logoutButton: UIBarButtonItem!
    
    ///Pin Button
    @IBOutlet weak var pinButton: UIBarButtonItem!
    
    ///Button for update data from server
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    
    // MARK: Variables
    
    ///Create LocationManager
    var locationManager = CLLocationManager()
    
    // MARK: Methods
    
    ///Override of **viewDidLoad()** method
    override func viewDidLoad() {
        super.viewDidLoad()
        setMapSettings()
        appDelegate = UIApplication.shared.delegate as! AppDelegate
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        ParseClient.sharedInstance().getStudentLocations { (locations, error) in
            if let locations = locations {
                self.locations = locations
                performUIUpdatesOnMain {
                    print (locations)
                }
            } else {
                print(error)
            }
        }
    }
    
    ///Method for update location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations.last
        
        let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1))
        
        self.mapView.setRegion(region, animated: true)
        
        self.locationManager.stopUpdatingLocation()
    }
    
    ///Method for checking errors
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print ("Errors: " + error.localizedDescription)
    }    
    
    private func setMapSettings() {
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        self.mapView.showsUserLocation = true
    }
}
