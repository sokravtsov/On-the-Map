//
//  StudentLocation.swift
//  On the Map
//
//  Created by Sergey Kravtsov on 17.11.16.
//  Copyright © 2016 Sergey Kravtsov. All rights reserved.
//

import Foundation

struct StudentLocation {
    
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
    let latitude: Float?
    
    ///Student's Longitude
    let longitude: Float?
    
    ///Data when created location post
    let createdAt: String?
    
    ///Data when update self location
    let updatedAt: String?
    
    ///the Parse access and control list (ACL), i.e. permissions, for this StudentLocation entry
    let ACL: String?
    
    // MARK: Initializers
    
    init(dictionary: [String:AnyObject]) {
        objectId = dictionary[ParseClient.JSONResponseKeys.ObjectID] as? String
        uniqueKey = dictionary[ParseClient.JSONResponseKeys.UniqueKey] as? String
        firstName = dictionary[ParseClient.JSONResponseKeys.FirstName] as? String
        lastName = dictionary[ParseClient.JSONResponseKeys.LastName] as? String
        mapString = dictionary[ParseClient.JSONResponseKeys.MapString] as? String
        mediaURL = dictionary[ParseClient.JSONResponseKeys.MediaURL] as? String
        latitude = dictionary[ParseClient.JSONResponseKeys.Latitude] as? Float
        longitude = dictionary[ParseClient.JSONResponseKeys.Longitude] as? Float
        createdAt = dictionary[ParseClient.JSONResponseKeys.CreatedAt] as? String
        updatedAt = dictionary[ParseClient.JSONResponseKeys.UpdatedAt] as? String
        ACL = dictionary[ParseClient.JSONResponseKeys.ACL] as? String
    }
    
    static func locationsFromResults(_ results: [[String:AnyObject]]) -> [StudentLocation] {
        
        var locations = [StudentLocation]()
        
        // iterate through array of dictionaries, each Movie is a dictionary
        for result in results {
            locations.append(StudentLocation(dictionary: result))
        }
        
        return locations
    }
}

//extension StudentLocation: Equatable {}
//
//func ==(lhs: StudentLocation, rhs: StudentLocation) -> Bool {
//    return lhs.objectId == rhs.objectId
//}
