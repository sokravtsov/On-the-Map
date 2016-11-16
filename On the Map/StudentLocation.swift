//
//  StudentLocation.swift
//  On the Map
//
//  Created by Sergey Kravtsov on 17.11.16.
//  Copyright © 2016 Sergey Kravtsov. All rights reserved.
//

import Foundation

class StudentLocation{
    
    // MARK: Variables
    
    ///Data when created location post
    open var createdAt: String?
    
    ///Student's First Name
    open var firstName: String?
    
    ///Student's Last Name
    open var lastName: String?
    
    ///Student's Latitude
    open var latitude: Float?
    
    ///Student's Longitude
    open var longitude: Float?
    
    ///Student's location string
    open var mapString: String?
    
    ///Student's media URL
    open var mediaURL: String?
    
    ///Object ID
    open var objectId: String?
    
    ///Unique key
    open var uniqueKey: String?
    
    ///Data when update self location
    open var updatedAt: String?
    
    // MARK: Initializers
    
    ///Base initializer
    public init (createdAt: String?, firstName: String?, lastName: String?, latitude: Float?, longitude: Float?, mapString: String?, mediaURL: String?, objectId: String?, uniqueKey: String?, updatedAt: String?) {
        
        self.createdAt = createdAt
        self.firstName = firstName
        self.lastName = lastName
        self.latitude = latitude
        self.longitude = longitude
        self.mapString = mapString
        self.mediaURL = mediaURL
        self.objectId = objectId
        self.uniqueKey = uniqueKey
        self.updatedAt = updatedAt
    }
}
