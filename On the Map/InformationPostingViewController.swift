//
//  InformationPostingViewController.swift
//  On the Map
//
//  Created by Sergey Kravtsov on 13.11.16.
//  Copyright © 2016 Sergey Kravtsov. All rights reserved.
//

import UIKit
import Foundation
import MapKit

fileprivate protocol MapKitProtocol {
    
    func FindLocationByString()
}

///ViewController for posting Student Location
class InformationPostingViewController : UIViewController, UITextFieldDelegate {
    
    //MARK: Outletls
    @IBOutlet weak var firstView: UIView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var centerView: UIView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var firstString: UILabel!
    @IBOutlet weak var secondString: UILabel!
    @IBOutlet weak var thirdString: UILabel!
    @IBOutlet weak var adressTextField: UITextField!
    @IBOutlet weak var findButton: UIButton!
    @IBOutlet weak var secondView: UIView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var websiteTextField: UITextField!
    @IBOutlet weak var secondCancelButton: UIButton!
    @IBOutlet weak var submitButton: UIButton!
    
    //MARK: Properties
    
    var coordinates: CLLocationCoordinate2D!
    
    //MARK: Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        adressTextField.delegate = self
        websiteTextField.delegate = self
        findButton.layer.cornerRadius = CGFloat(ParseClient.Radius.corner)
        submitButton.layer.cornerRadius = CGFloat(ParseClient.Radius.corner)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        secondView.isHidden = true
    }
    
    //MARK: TextFieldDelegate Methods
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        textField.text! = ""
    }
    
    //MARK: Actions
    
    @IBAction func tapCancelButton(_ sender: Any) {
        self.adressTextField.text = ""
        self.websiteTextField.text = ""
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tapSecondCancelButton(_ sender: Any) {
        self.adressTextField.text = ""
        self.websiteTextField.text = ""
        secondView.isHidden = true
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tapFindButton(_ sender: Any) {
        firstView.isHidden = true
        secondView.isHidden = false
        FindLocationByString()
    }
    
    @IBAction func tapSubmitButton(_ sender: Any) {
    }
}

extension InformationPostingViewController: MapKitProtocol {
    
    ///Method for finding location by text address
    func FindLocationByString() {
        if adressTextField.text != nil {
            let location = adressTextField.text
            let geoCoder = CLGeocoder()
            geoCoder.geocodeAddressString(location!) {(placeMarks, error) in
                
                if error != nil {
                    performUIUpdatesOnMain {
                        self.showAlert(title: "Couldn't find location", message: "Please, enter a valid location and try again")
                    }
                }
                
                if let placeMark = placeMarks?.first, let _ = placeMark.location {
                    _ = MKPlacemark(placemark: placeMark)
                    let placemark: CLPlacemark = placeMark
                    let coordinates: CLLocationCoordinate2D = placemark.location!.coordinate
                    let pointAnnotation: MKPointAnnotation = MKPointAnnotation()
                    pointAnnotation.coordinate = coordinates
                    self.mapView?.addAnnotation(pointAnnotation)
                    self.mapView?.centerCoordinate = coordinates
                    self.mapView?.camera.altitude = 20000
                    self.coordinates = coordinates
                    
                }
            }
        }
    }
}
