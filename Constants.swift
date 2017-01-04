//
//  Constants.swift
//  On the Map
//
//  Created by Sergey Kravtsov on 02.01.17.
//  Copyright © 2017 Sergey Kravtsov. All rights reserved.
//

import Foundation

struct DataLoader {
    ///Base API URL string
    static let mainBaseURL = "https://parse.udacity.com/parse/classes"
    ///Base URL part of **StudentLocation** method
    static let baseURLforStudentLocation = "/StudentLocation"
    ///Parse Application ID
    static let parseAppID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
    ///REST API Key
    static let RestAPIKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
    
    static let applicationJSON = "application/json"
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

struct HTTPMethod {
    static let post = "POST"
}

