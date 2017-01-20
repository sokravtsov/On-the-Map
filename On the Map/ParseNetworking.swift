//
//  Networking.swift
//  On the Map
//
//  Created by Sergey Kravtsov on 20.01.17.
//  Copyright © 2017 Sergey Kravtsov. All rights reserved.
//

import Foundation

extension ParseClient {
    
    //MARK: GET Students Locations
    
    func getStudentLocations(_ completionHandlerForStudentLocations: @escaping (_ result: [StudentLocation]?, _ error: NSError?) -> Void) {
        ///Get sudent locations
        //        let methodParameters = [
        //            Constants.ParseParameterKeys.Limit: Constants.ParseParameterValues.Limit,
        //            Constants.ParseParameterKeys.Skip: Constants.ParseParameterValues.Skip,
        //            Constants.ParseParameterKeys.Order: Constants.ParseParameterValues.Order
        //            ] as [String : Any]
        
        //        let request = NSMutableURLRequest(url: appDelegate.parseURLFromParameters(methodParameters as [String : AnyObject]))
        let request = NSMutableURLRequest(url: URL(string: "https://parse.udacity.com/parse/classes/StudentLocation")!)
        request.addValue(ParseParameterValues.AppID, forHTTPHeaderField: HTTPHeaderField.parseAppID)
        request.addValue(ParseParameterValues.ApiKey, forHTTPHeaderField: HTTPHeaderField.parseRestApiKey)
        
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            guard (error == nil) else {
                print("There was an error with your request: \(error)")
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                print("Your request returned a status code other than 2xx!")
                return
            }
            
            guard let data = data else {
                print("No data was returned by the request!")
                return
            }
            
            let parsedResult: [String:AnyObject]!
            do {
                parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:AnyObject]
            } catch {
                print("Could not parse the data as JSON: '\(data)'")
                return
            }
            
            if let results = parsedResult[JSONResponseKeys.Results] as? [[String:AnyObject]] {
                let locations = StudentLocation.locationsFromResults(results)
                completionHandlerForStudentLocations(locations, nil)
            } else {
                completionHandlerForStudentLocations(nil, NSError(domain: "getStudentLocations parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse getStudentLocations"]))
            }
        }
        task.resume()
    }
    
    func PostStudentLocation(/*completionHandlerForPostStudentLocation: @escaping (_ result: Int?, _ error: NSError?) -> Void*/) {
        let mutableMethod: String = Methods.StudentLocations
        let jsonBody = "{\"\(JSONResponseKeys.UniqueKey)\": \"1234\", \"\(JSONResponseKeys.FirstName)\": \"John\", \"\(JSONResponseKeys.LastName)\": \"Doe\",\"\(JSONResponseKeys.MapString)\": \"Mountain View, CA\", \"\(JSONResponseKeys.MediaURL)\": \"https://udacity.com\",\"\(JSONResponseKeys.Latitude)\": 37.386052, \"\(JSONResponseKeys.Longitude)\": -122.083851}"
        let _ = taskForPOSTMethod(mutableMethod, jsonBody: jsonBody) { (results, error) in
//            if let error = error {
//                completionHandlerForPostStudentLocation(nil, error)
//            } else {
//                if let results = results?[JSONResponseKeys.StatusCode] as? Int {
//                    completionHandlerForPostStudentLocation(results, nil)
//
//                } else {
//                    completionHandlerForPostStudentLocation(nil, NSError(domain: "postStudentLocation parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse postStudentLocation"]))
//                }
//            }
        }
    }
    
    func PostSession() {
        let request = NSMutableURLRequest(url: URL(string: "https://www.udacity.com/api/session")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"udacity\": {\"username\": \"kravtsov@happimess.ru\", \"password\": \"1505407juve\"}}".data(using: String.Encoding.utf8)
        
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            guard (error == nil) else {
                print("There was an error with your request: \(error)")
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                print("Your request returned a status code other than 2xx!")
                return
            }
            
            guard let data = data else {
                print ("No data was returned by the request!")
                return
            }
            
            let range = Range(uncheckedBounds: (5, data.count - 5))
            let newData = data.subdata(in: range) /* subset response data! */

            print(NSString(data: newData, encoding: String.Encoding.utf8.rawValue)!)
        }
        
        task.resume()
    }
    
    func DeleteSession() {
        
        let request = NSMutableURLRequest(url: URL(string: "https://www.udacity.com/api/session")!)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
        
            guard (error == nil) else {
                print("There was an error with your request: \(error)")
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                print("Your request returned a status code other than 2xx!")
                return
            }
            
            guard let data = data else {
                print ("No data was returned by the request!")
                return
            }
            
            let range = Range(uncheckedBounds: (5, data.count - 5))
            let newData = data.subdata(in: range) /* subset response data! */
            print(NSString(data: newData, encoding: String.Encoding.utf8.rawValue)!)
            
        }
        
        task.resume()
    }
    
}






