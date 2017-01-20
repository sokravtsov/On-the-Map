//
//  Constants.swift
//  On the Map
//
//  Created by Sergey Kravtsov on 02.01.17.
//  Copyright © 2017 Sergey Kravtsov. All rights reserved.
//


extension ParseClient {
    
    struct Constants {
        
        static let ApiScheme = "https"
        static let ApiHost = "parse.udacity.com"
        static let ApiPath = "/parse/classes"
        static let ApplicationJSON = "application/json"
    }
    
    
    struct ParseParameterKeys {
        static let Limit = "limit"
        static let Skip = "skip"
        static let Order = "order"
    }
    
    struct ParseParameterValues {
        static let ApiKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        static let AppID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let Limit = 100
        static let Skip = 400
        static let Order = "-updatedAt"
    }
    
    struct Methods {
        
        static let StudentLocations = "/StudentLocation"
    }
    
    struct Placeholder {
        
        static let email = "Email"
        static let password = "Password"
    }
    
    struct Radius {
        
        static let corner = 5
    }
    
    struct HTTPHeaderField {
        
        static let parseAppID = "X-Parse-Application-Id"
        static let parseRestApiKey = "X-Parse-REST-API-Key"
        static let contentType = "Content-Type"
    }
    
    struct Segue {
        
        static let informationPosting = "InformationPosting"
    }
    
    struct JSONResponseKeys {
        
        static let ObjectID = "objectId"
        static let UniqueKey = "uniqueKey"
        static let FirstName = "firstName"
        static let LastName = "lastName"
        static let MapString = "mapString"
        static let MediaURL = "mediaURL"
        static let Latitude = "latitude"
        static let Longitude = "longitude"
        static let CreatedAt = "createdAt"
        static let UpdatedAt = "updatedAt"
        static let ACL = "ACL"
        
        
        static let Results = "results"
        static let StatusCode = "status_code"
    }
}
