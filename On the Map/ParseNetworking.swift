//
//  Networking.swift
//  On the Map
//
//  Created by Sergey Kravtsov on 20.01.17.
//  Copyright © 2017 Sergey Kravtsov. All rights reserved.
//

import Foundation

extension ParseClient {

//    func getStudentLocations(_ completionHandlerForStudentLocations: @escaping (_ result: [StudentLocation]?, _ error: NSError?) -> Void) {
//
//        let request = NSMutableURLRequest(url: URL(string: "https://parse.udacity.com/parse/classes/StudentLocation")!)
//        request.addValue(ParseParameterValues.appID, forHTTPHeaderField: HTTPHeaderField.parseAppID)
//        request.addValue(ParseParameterValues.apiKey, forHTTPHeaderField: HTTPHeaderField.parseRestApiKey)
//
//        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
//
//            guard (error == nil) else {
//                print("There was an error with your request: \(error)")
//                return
//            }
//
//            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
//                print("Your request returned a status code other than 2xx!")
//                return
//            }
//
//            guard let data = data else {
//                print("No data was returned by the request!")
//                return
//            }
//
//            let parsedResult: [String:AnyObject]!
//            do {
//                parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:AnyObject]
//            } catch {
//                print("Could not parse the data as JSON: '\(data)'")
//                return
//            }
//
//            if let results = parsedResult[JSONResponseKeys.results] as? [[String:AnyObject]] {
//                let locations = StudentLocation.locationsFromResults(results)
//                completionHandlerForStudentLocations(locations, nil)
//            } else {
//                completionHandlerForStudentLocations(nil, NSError(domain: "getStudentLocations parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse getStudentLocations"]))
//            }
//        }
//        task.resume()
//    }

    func getStudentLocations(withUserID: String?, completionHandlerForGETStudentLocations: @escaping(_ results: AnyObject?,_ error: NSError?) -> Void) {
        var userID: String?
        if withUserID != nil {
            userID = withUserID
        } else {
            userID = nil
        }

        _ = taskForGetStudentLocations(withUserID: userID) {(results, error) in

            if error != nil {
                completionHandlerForGETStudentLocations(nil, error)
            } else {
                if let results = results?[JSONResponseKeys.results] {
                    print(results)
                    let studentLocations = StudentLocation.locationsFromResults(results as! [[String : AnyObject]])
                    completionHandlerForGETStudentLocations(studentLocations as AnyObject?,nil)
                } else {
                    completionHandlerForGETStudentLocations(nil, NSError(domain: "getStudentLocations parsing", code: 1, userInfo: [NSLocalizedDescriptionKey: "Could not parse the data"]))
                }
            }
        }
    }


    func PostSession(userName: String, password: String, completionHandlerForSessionID:@escaping(_ result:AnyObject?,_ error:NSError?)-> Void) {
        let dictionary = [JSONBodyKeys.userNameKey: userName,
                          JSONBodyKeys.passwordKey: password]
        
        _ = taskToPOSTSession(jsonBody: dictionary) {(results, error) in
            if error != nil {
                completionHandlerForSessionID(nil, error)
            } else {
                if let sessionResults = results as? [String:AnyObject] {
                    if let accounts = sessionResults[JSONResponseKeys.account] as? [String:AnyObject] {
                        if let userKey = accounts[JSONResponseKeys.key] as? String {
                            ParseClient.sharedInstance.userID = userKey
                        }
                    }
                    
                    if let session = sessionResults[JSONResponseKeys.session] as? [String:AnyObject] {
                        if let sessionID = session[JSONResponseKeys.sessionId] as? String {
                            ParseClient.sharedInstance.sessionID = sessionID
                        }
                    }
                    
                    completionHandlerForSessionID(sessionResults as AnyObject,nil)
                } else {
                    completionHandlerForSessionID(nil,NSError(domain: "getSessionID", code:1, userInfo: [NSLocalizedDescriptionKey: "Could not parse the data"]))
                }
            }
        }
    }
    
    //FIXME: возвращает error other than 2xx!
    func PostSessionFacebook(completionHandlerForFacebookSessionID:@escaping(_ result:AnyObject?,_ error:NSError?)-> Void) {
        let dictionary = [JSONBodyKeys.facebookMobile: String(describing: FBSDKAccessToken.current())]
        
        _ = taskToPOSTSessionFacebook(jsonBody: dictionary) {(results, error) in
            if error != nil {
                completionHandlerForFacebookSessionID(nil, error)
            } else {
                if let sessionResults = results as? [String:AnyObject] {
                    if let accounts = sessionResults[JSONResponseKeys.account] as? [String:AnyObject] {
                        if let userKey = accounts[JSONResponseKeys.key] as? String {
                            ParseClient.sharedInstance.userID = userKey
                        }
                    }
                    
                    if let session = sessionResults[JSONResponseKeys.session] as? [String:AnyObject] {
                        if let sessionID = session[JSONResponseKeys.sessionId] as? String {
                            ParseClient.sharedInstance.sessionID = sessionID
                        }
                    }
                    
                    completionHandlerForFacebookSessionID(sessionResults as AnyObject, nil)
                } else {
                    completionHandlerForFacebookSessionID(nil, NSError(domain: "getSessionID", code:1, userInfo: [NSLocalizedDescriptionKey: "Could not parse the data"]))
                }
            }
        }
    }

    func DeleteSession(completionHandlerForDeleteSession: @escaping(_ results: AnyObject?,_ error: NSError?) -> Void) {

        let methodString = Methods.session

        _ = taskToDeleteSession(methodString) { (results, error) in

            if error != nil {
                completionHandlerForDeleteSession(nil, error)
            } else {
                if let results = results {
                    completionHandlerForDeleteSession(results, nil)
                } else {
                    completionHandlerForDeleteSession(nil, NSError(domain: "DeletingSession", code: 1, userInfo: [NSLocalizedDescriptionKey: "Couldn't parse the data"]))
                }
            }
        }
    }
    
    func GetPublicUserData() {
        
        let request = NSMutableURLRequest(url: URL(string: "https://www.udacity.com/api/users/3903878747")!)
        
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






