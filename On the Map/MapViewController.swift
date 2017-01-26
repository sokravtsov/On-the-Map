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

fileprivate protocol Setup {
    
    func setupMapSettings()
    func setupPinOnMap()
}

fileprivate protocol MapViewProtocol {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl)
}

fileprivate protocol LocationManagerProtocol {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
}

///Class for MapKit
class MapViewController : UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    // MARK: Outlets
    
    ///Apple Map View
    @IBOutlet weak var mapView: MKMapView!
    
    ///Logout Button
    @IBOutlet weak var logoutButton: UIBarButtonItem!
    
    ///Pin Button
    @IBOutlet weak var pinButton: UIBarButtonItem!
    
    ///Button for update data from server
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    
    // MARK: Properties
    
    ///Create LocationManager
    var locationManager = CLLocationManager()
    
    ///Variable for checking if need to update annotations on map
    var needToUpdateMap = true
    
    // MARK: Life Cycle
    
    ///Override of **viewDidLoad()** method
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMapSettings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if needToUpdateMap {
          setupPinOnMap()
        }
    }
    
    @IBAction func refreshMap(_ sender: Any) {
        self.mapView.removeAnnotations(ParseClient.sharedInstance.annotations)
        ParseClient.sharedInstance.studentLocations.removeAll()
        ParseClient.sharedInstance.annotations.removeAll()
        setupPinOnMap()
    }
    
    
}

// MARK: - Setup

extension MapViewController: Setup {
    
    func setupMapSettings() {
        
        mapView.delegate = self
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        //self.mapView.showsUserLocation = true
    }
    
    func setupPinOnMap() {
        
        ParseClient.sharedInstance.getStudentLocations { (locations, error) in
            
            if let result = locations {
                ParseClient.sharedInstance.studentLocations = result
                print (result)
                
                for eachLocation in ParseClient.sharedInstance.studentLocations {
                    
                    let lat = CLLocationDegrees(eachLocation.latitude!)
                    let long = CLLocationDegrees(eachLocation.longitude!)
                    
                    let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                    
                    let first = eachLocation.firstName!
                    let last = eachLocation.lastName!
                    let mediaURL = eachLocation.mediaURL!
                    
                    let annotation = MKPointAnnotation()
                    
                    annotation.coordinate = coordinate
                    annotation.title = "\(first) \(last)"
                    annotation.subtitle = mediaURL
                    
                    ParseClient.sharedInstance.annotations.append(annotation)
                }
                performUIUpdatesOnMain {
                    self.mapView.addAnnotations(ParseClient.sharedInstance.annotations)
                }
                
                self.needToUpdateMap = false
                
            } else {
                print(error)
            }
        }
    }
    
    
    
}



// MARK: - MapViewProtocol

extension MapViewController: MapViewProtocol {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView?.animatesDrop = true
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle! {
                app.open(URL(string: toOpen)!, options: [:], completionHandler: nil)
            }
        }
    }
}

//MARK: - LocationManagerProtocol

extension MapViewController: LocationManagerProtocol {
    
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
}
