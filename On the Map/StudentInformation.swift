//
//  StudentInformation.swift
//  On the Map
//
//  Created by Sergey Kravtsov on 17.11.16.
//  Copyright © 2016 Sergey Kravtsov. All rights reserved.
//

import Foundation

struct StudentInformation {
    
    // MARK: Properties
    
    ///Object ID
    let objectId: String?
    
    ///Unique key
    let uniqueKey: String?
    
    ///Student's First Name
    let firstName: String?
    
    ///Student's Last Name
    let lastName: String?
    
    ///Student's location string
    let mapString: String?
    
    ///Student's media URL
    let mediaURL: String?
    
    ///Student's Latitude
    let latitude: Double?
    
    ///Student's Longitude
    let longitude: Double?
    
    ///Data when created location post
    let createdAt: String?
    
    ///Data when update self location
    let updatedAt: String?
    
    // MARK: Initializers
    
    init(dictionary: [String:AnyObject]) {
        objectId = dictionary[ParseClient.JSONResponseKeys.objectID] != nil ? dictionary[ParseClient.JSONResponseKeys.objectID] as? String : ""
        uniqueKey = dictionary[ParseClient.JSONResponseKeys.uniqueKey] != nil ? dictionary[ParseClient.JSONResponseKeys.uniqueKey] as? String : ""
        firstName = dictionary[ParseClient.JSONResponseKeys.firstName] != nil ? dictionary[ParseClient.JSONResponseKeys.firstName] as? String : ""
        lastName = dictionary[ParseClient.JSONResponseKeys.lastName] != nil ? dictionary[ParseClient.JSONResponseKeys.lastName] as? String : ""
        mapString = dictionary[ParseClient.JSONResponseKeys.mapString] != nil ? dictionary[ParseClient.JSONResponseKeys.mapString] as? String : ""
        mediaURL = dictionary[ParseClient.JSONResponseKeys.mediaURL] != nil ? dictionary[ParseClient.JSONResponseKeys.mediaURL] as? String : ""
        latitude = dictionary[ParseClient.JSONResponseKeys.latitude] != nil ? dictionary[ParseClient.JSONResponseKeys.latitude] as? Double : 0
        longitude = dictionary[ParseClient.JSONResponseKeys.longitude] != nil ? dictionary[ParseClient.JSONResponseKeys.longitude] as? Double : 0
        createdAt = dictionary[ParseClient.JSONResponseKeys.createdAt] != nil ? dictionary[ParseClient.JSONResponseKeys.createdAt] as? String : ""
        updatedAt = dictionary[ParseClient.JSONResponseKeys.updatedAt] != nil ? dictionary[ParseClient.JSONResponseKeys.updatedAt] as? String : ""
    }
    
    static func locationsFromResults(_ results: [[String:AnyObject]]) -> [StudentInformation] {
        
        for result in results {
            StudentLocations.sharedInstance.studentLocations.append(StudentInformation(dictionary: result))
        }
        return StudentLocations.sharedInstance.studentLocations
    }
}
