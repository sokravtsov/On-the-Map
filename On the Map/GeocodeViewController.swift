//
//  GeocodeViewController.swift
//  On the Map
//
//  Created by Sergey Kravtsov on 14.11.16.
//  Copyright © 2016 Sergey Kravtsov. All rights reserved.
//

import UIKit
import MapKit


class GeocodeViewController : UIViewController, MKMapViewDelegate {
    
    var location: StudentLocation?
    
    // MARK: Variables
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var submitButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        submitButton.layer.cornerRadius = 5
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //FIXME: Перенести метод в LoginVC
        ParseClient.sharedInstance().PostSession()
    }
    
    ///Method to create a new student location
    @IBAction func postStudentLocation() {
        ParseClient.sharedInstance().PostStudentLocation() /*{ (statusCode, error) in
            if let error = error {
                print(error)
            } else {
                if statusCode == 1 || statusCode == 12 || statusCode == 13 {
                    performUIUpdatesOnMain {
                        print ("WTF???")
                    }
                } else {
                    print("Unexpected status code \(statusCode)")
                }
            }
        }*/
    }
}
