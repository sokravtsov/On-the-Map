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
        if Reachability.isConnectedToNetwork() {
            performUIUpdatesOnMain {
                self.mapView.removeAnnotations(ParseClient.sharedInstance.annotations)
                StudentLocations.sharedInstance.studentLocations.removeAll()
                ParseClient.sharedInstance.annotations.removeAll()
                self.setupPinOnMap()
            }
        } else {
            self.showAlert(title: ParseClient.Str.noConnection, message: ParseClient.Str.checkConnection)
        }
    }
    
    @IBAction func addPinOnMap(_ sender: Any) {
        
        if Reachability.isConnectedToNetwork() {

            if ParseClient.sharedInstance.objectID == nil {
                self.performSegue(withIdentifier: "addPinFromMap", sender: self)
            } else {
                self.showAlertWithAction()
            }
        } else {
            self.showAlert(title: ParseClient.Str.noConnection, message: ParseClient.Str.checkConnection)
        }
    }
    
    @IBAction func logOut(_ sender: Any) {
        if Reachability.isConnectedToNetwork() {
            self.showActivityIndicator()
            ParseClient.sharedInstance.DeleteSession() { (results, error) in
                if error == nil {
                    ParseClient.sharedInstance.userID = nil
                    performUIUpdatesOnMain {
                        self.dismiss(animated: true, completion: nil)
                        print ("Session deleled")
                    }
                }
            }
        } else {
            self.showAlert(title: ParseClient.Str.noConnection, message: ParseClient.Str.checkConnection)
        }
        
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
    }
    
    func setupPinOnMap() {
        
        if Reachability.isConnectedToNetwork() {
            ParseClient.sharedInstance.getStudentLocations { (result, error) in
                performUIUpdatesOnMain {
                    if let studentLocations = result {
                        StudentLocations.sharedInstance.studentLocations = studentLocations
                    } else {
                        print(error!)
                        self.showAlert(title: "Server is Unavailable", message: "Failed to download the location of students")
                    }
                }
                
                var annotations = [MKPointAnnotation]()
                
                for student in StudentLocations.sharedInstance.studentLocations {

                    guard student.latitude != nil && student.longitude != nil else {
                        continue
                    }
                    
                    let lat = CLLocationDegrees(student.latitude!)
                    let long = CLLocationDegrees(student.longitude!)
                    
                    let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                    
                    guard student.firstName != nil && student.lastName != nil && student.mediaURL != nil else {
                        continue
                    }

                    let first = student.firstName!
                    let last = student.lastName!
                    let mediaURL = student.mediaURL!
                    
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = coordinate
                    annotation.title = "\(first) \(last)"
                    annotation.subtitle = mediaURL
                    
                    annotations.append(annotation)
                }
                
                self.mapView.addAnnotations(annotations)
            }
        } else {
            
        self.showAlert(title: ParseClient.Str.noConnection, message: ParseClient.Str.checkConnection)
        }
        
        needToUpdateMap = false
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
