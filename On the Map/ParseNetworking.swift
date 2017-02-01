//
//  Networking.swift
//  On the Map
//
//  Created by Sergey Kravtsov on 20.01.17.
//  Copyright © 2017 Sergey Kravtsov. All rights reserved.
//

import Foundation

extension ParseClient {
    
    ///Method for get Student Location with User ID, if userID = nil -> for 100 Student Locations
    func getStudentLocations(withUniqueKey: String?, completionHandlerForGETStudentLocations: @escaping(_ results: AnyObject?,_ error: NSError?) -> Void) {

        _ = taskForGetStudentLocations(withUniqueKey: ParseClient.sharedInstance.uniqueKey) {(results, error) in

            if error != nil {
                completionHandlerForGETStudentLocations(nil, error)
            } else {
                if let results = results?[JSONResponseKeys.results] as? [String:AnyObject] {
                    if let objectID = results[JSONResponseKeys.objectID] as? String {
                        ParseClient.sharedInstance.objectID = objectID
                        print ("Object ID = \(objectID)")
                    }
                    print(results)
                    let studentLocations = StudentInformation.locationsFromResults([results])
                    completionHandlerForGETStudentLocations(studentLocations as AnyObject?, nil)
                } else {
                    completionHandlerForGETStudentLocations(nil, NSError(domain: "getStudentLocations parsing", code: 1, userInfo: [NSLocalizedDescriptionKey: "Could not parse the data"]))
                }
            }
        }
    }

    ///Method for posting session to server
    func PostSession(userName: String, password: String, completionHandlerForSessionID:@escaping(_ success: Bool, _ result:AnyObject?,_ error:NSError?)-> Void) {
        let dictionary = [JSONBodyKeys.userNameKey: userName,
                          JSONBodyKeys.passwordKey: password]
        
        _ = taskForPOSTSession(jsonBody: dictionary) {(results, error) in
            if error != nil {
                completionHandlerForSessionID(false, nil, error)
            } else {
                if let sessionResults = results as? [String:AnyObject] {
                    if let accounts = sessionResults[JSONResponseKeys.account] as? [String:AnyObject] {
                        if let userID = accounts[JSONResponseKeys.key] as? String {
                            ParseClient.sharedInstance.userID = userID
//                            print ("UserID = \(userID)")
                        }
                    }
                    
                    if let session = sessionResults[JSONResponseKeys.session] as? [String:AnyObject] {
                        if let sessionID = session[JSONResponseKeys.sessionId] as? String {
                            ParseClient.sharedInstance.sessionID = sessionID
//                            print ("Session ID = \(sessionID)")
                        }
                    }
                    
                    completionHandlerForSessionID(true, sessionResults as AnyObject,nil)
                } else {
                    completionHandlerForSessionID(false, nil, NSError(domain: "getSessionID", code:1, userInfo: [NSLocalizedDescriptionKey: "Could not parse the data"]))
                }
            }
        }
    }
    
    ///Method for posting session to server via Facebook auth
    func PostSessionFacebook(completionHandlerForFacebookSessionID:@escaping(_ result:AnyObject?,_ error:NSError?)-> Void) {
        let dictionary = [JSONBodyKeys.accessToken : String(describing: FBSDKAccessToken.current())]
        
        _ = taskForPOSTSessionFacebook(jsonBody: dictionary) {(results, error) in
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

    ///Method for deleting session ID when logout
    func DeleteSession(completionHandlerForDeleteSession: @escaping(_ results: AnyObject?,_ error: NSError?) -> Void) {

        let methodString = Methods.session

        _ = taskForDeleteSession(methodString) { (results, error) in

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
    
    func PostStudentLocation(json: [String:AnyObject],completionHandlerForPostingStudentLocation:@escaping(_ results: AnyObject?,_ error: NSError?) -> Void) {
        
        let httpBody = json
        
        _ = taskForPOSTStudentLocation(jsonBody: httpBody) {(results, error) in
            
            if error != nil {
                completionHandlerForPostingStudentLocation(nil, error)
            } else {
                if let results = results as? [String:AnyObject] {
                    if let objectID = results[JSONResponseKeys.objectID] as? String {
                        ParseClient.sharedInstance.objectID = objectID
                        print ("Object ID = \(objectID)")
                    }
                    completionHandlerForPostingStudentLocation(results as AnyObject?, nil)
                } else {
                    completionHandlerForPostingStudentLocation(nil, NSError(domain: "postStudentLocation parsing", code: 1, userInfo:[NSLocalizedDescriptionKey: "Could not parse the data"]))
                }
            }
        }
    }
    
    ///Method for getting public user's data
    func GetPublicUserData(completionHandlerForUserData: @escaping(_ results: AnyObject?,_ error:NSError?) -> Void) {
        
        taskForGETUsersData() {(results,error) in
            
            if error != nil {
                completionHandlerForUserData(nil, error)
            } else {
                if let resultDictionary = results as? [String : AnyObject] {
                    if let userDictionary = resultDictionary["user"] as? [String : AnyObject] {
                        
                        if let firstName = userDictionary["nickname"] as? String {
                            ParseClient.sharedInstance.firstName = firstName
                        }
                        if let lastName = userDictionary["last_name"] as? String {
                            ParseClient.sharedInstance.lastName = lastName
                        }
                        
                        completionHandlerForUserData(results, nil)
                    }
                } else {
                    completionHandlerForUserData(nil, NSError(domain: "UserInfo", code: 1, userInfo:[NSLocalizedDescriptionKey:"Could not parse the data"]))
                }
            }
        }
    }
    
    func OverwriteStudentLocation(json: [String:AnyObject], completionHandlerForOverwritingStudentLocation: @escaping(_ results:AnyObject?,_ error: NSError?) -> Void) {
        let methodString = "/\(ParseClient.sharedInstance.objectID)"
        
        let httpBody = json
        
        _ = taskForPUTStudentLocation(jsonBody: httpBody, method: methodString) {(results,error) in
            
            if error != nil {
                completionHandlerForOverwritingStudentLocation(nil, error)
            } else {
                if let results = results {
                    completionHandlerForOverwritingStudentLocation(results, nil)
                } else {
                    completionHandlerForOverwritingStudentLocation(nil, NSError(domain: "overwriteStudentLocation", code: 1, userInfo: [NSLocalizedDescriptionKey: "Cannot parse the data"]))
                }
            }
        }
    }
}
