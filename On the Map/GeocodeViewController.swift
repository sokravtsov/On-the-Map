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
    
    // MARK: Variables
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var submitButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        submitButton.layer.cornerRadius = CGFloat(Radius.corner)
    }
    
    ///Method to create a new student location
    @IBAction func postStudentLocation() {
        let request = NSMutableURLRequest(url: URL(string: "\(DataLoader.mainBaseURL)+\(DataLoader.baseURLforStudentLocation)")!)
        request.httpMethod = HTTPMethod.post
        request.addValue(DataLoader.parseAppID, forHTTPHeaderField: HTTPHeaderField.parseAppID)
        request.addValue(DataLoader.RestAPIKey, forHTTPHeaderField: HTTPHeaderField.parseRestApiKey)
        request.addValue(DataLoader.applicationJSON, forHTTPHeaderField: HTTPHeaderField.contentType)
        request.httpBody = "{\"uniqueKey\": \"1234\", \"firstName\": \"John\", \"lastName\": \"Doe\",\"mapString\": \"Mountain View, CA\", \"mediaURL\": \"https://udacity.com\",\"latitude\": 37.386052, \"longitude\": -122.083851}".data(using: String.Encoding.utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            if error != nil { // Handle error…
                return
            }
            print(NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!)
        }
        task.resume()
    }
}
