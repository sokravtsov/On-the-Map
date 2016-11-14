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
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var submitButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        submitButton.layer.cornerRadius = 5
    }
}
