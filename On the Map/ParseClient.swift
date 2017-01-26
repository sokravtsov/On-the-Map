//
//  ParseClient.swift
//  On the Map
//
//  Created by Sergey Kravtsov on 20.01.17.
//  Copyright © 2017 Sergey Kravtsov. All rights reserved.
//

import Foundation
import MapKit

class ParseClient: NSObject {
    
    static let sharedInstance = ParseClient()
    
    var session = URLSession.shared
    var requestToken = ""
    var sessionID = ""
    var userID = ""
    var firstName = ""
    var lastName = ""
    
    var studentLocations = [StudentLocation]()
    var annotations = [MKPointAnnotation]()

    
    override init() {
        super.init()
    }
    
    //FIXME: Uncomment parametrs
    func taskForPOSTMethod(_ method: String, /*parameters: [String:AnyObject],*/ jsonBody: String, completionHandlerForPOST: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        //FIXME: uncomment after logining
        //        var parametersWithApiKey = parameters
        //        parametersWithApiKey[ParameterKeys.ApiKey] = Constants.ApiKey as AnyObject?
        
        let request = NSMutableURLRequest(url: URL(string: "https://parse.udacity.com/parse/classes/StudentLocation")!)
        request.httpMethod = "POST"
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonBody.data(using: String.Encoding.utf8)
        
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForPOST(nil, NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
            }
            
            guard (error == nil) else {
                sendError("There was an error with your request: \(error)")
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForPOST)
            print(NSString(data: data, encoding: String.Encoding.utf8.rawValue)!)
        }
        
        task.resume()
        
        return task
    }
    
    
    // substitute the key for the value that is contained within the method name
    func substituteKeyInMethod(_ method: String, key: String, value: String) -> String? {
        if method.range(of: "{\(key)}") != nil {
            return method.replacingOccurrences(of: "{\(key)}", with: value)
        } else {
            return nil
        }
    }
    
    // given raw JSON, return a usable Foundation object
    private func convertDataWithCompletionHandler(_ data: Data, completionHandlerForConvertData: (_ result: AnyObject?, _ error: NSError?) -> Void) {
        
        var parsedResult: AnyObject! = nil
        do {
            parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            completionHandlerForConvertData(nil, NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        
        completionHandlerForConvertData(parsedResult, nil)
    }
    
    func parseURLFromParameters(_ parameters: [String: AnyObject]) -> URL {
        
        var components = URLComponents()
        components.scheme = Constants.apiScheme
        components.host = Constants.apiHost
        components.path = Constants.apiPath
        components.queryItems = [URLQueryItem]()
        
        for (key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        
        return components.url!
    }
    
    func taskToPOSTSession(jsonBody:[String:String], completionHandlerForSessionID:@escaping(_ result:AnyObject?,_ error:NSError?)-> Void) -> URLSessionDataTask {
        let userInfo = [JSONBodyKeys.udacityKey:jsonBody]
        var info: Data!
        do{
            info = try JSONSerialization.data(withJSONObject: userInfo, options: JSONSerialization.WritingOptions.prettyPrinted)
        } catch {
            print("Cannot encode the data")
        }
        
        let method = Methods.session
        let urlString = Constants.getSessionURL + method
        let sessionURL = URL(string: urlString)
        let request = NSMutableURLRequest(url:sessionURL!)
        request.httpMethod = "POST"
        request.addValue(Constants.applicationJSON, forHTTPHeaderField: HTTPHeaderField.acceptField)
        request.addValue(Constants.applicationJSON, forHTTPHeaderField: HTTPHeaderField.contentType)
        request.httpBody = info /*jsonBody.data(using: String.Encoding.utf8)*/
        
        let task = session.dataTask(with: request as URLRequest) {(data,response,error) in
            
            if error != nil{
                let userInfo = [NSLocalizedDescriptionKey: error]
                completionHandlerForSessionID(nil,NSError(domain:"taskToPOSTSession", code: 1, userInfo:userInfo))
            }
            
            guard let data = data else {
                print("Could not find the data")
                return
            }
            
            let range = Range(uncheckedBounds: (5, data.count))
            let newData = data.subdata(in: range)
            print(NSString(data: newData, encoding: String.Encoding.utf8.rawValue)!)
            self.convertData(newData, completionHandlerForConvertData: completionHandlerForSessionID)
            
        }
        
        task.resume()
        return task
    }
    
    func taskToPOSTSessionFacebook(jsonBody:[String:String], completionHandlerForFacebookSessionID:@escaping(_ result:AnyObject?, _ error:NSError?)-> Void) -> URLSessionDataTask {
        
        let userInfo = [JSONBodyKeys.facebookMobile:jsonBody]
        var info: Data!
        do{
            info = try JSONSerialization.data(withJSONObject: userInfo, options: JSONSerialization.WritingOptions.prettyPrinted)
        } catch {
            print("Cannot encode the data")
        }
        let method = Methods.session
        let urlString = Constants.getSessionURL + method
        let sessionURL = URL(string: urlString)
        let request = NSMutableURLRequest(url:sessionURL!)
        request.httpMethod = "POST"
        request.addValue(Constants.applicationJSON, forHTTPHeaderField: HTTPHeaderField.acceptField)
        request.addValue(Constants.applicationJSON, forHTTPHeaderField: HTTPHeaderField.contentType)
        request.httpBody = info

        let task = session.dataTask(with: request as URLRequest) {(data,response,error) in
            if error != nil{
                let userInfo = [NSLocalizedDescriptionKey: error]
                completionHandlerForFacebookSessionID(nil,NSError(domain:"taskToPOSTSessionFacabook", code: 1, userInfo:userInfo))
            }
            
            guard let data = data else {
                print("Could not find the data")
                return
            }
            
            let range = Range(uncheckedBounds: (5, data.count))
            let newData = data.subdata(in: range)
            print(NSString(data: newData, encoding: String.Encoding.utf8.rawValue)!)
            self.convertData(newData, completionHandlerForConvertData: completionHandlerForFacebookSessionID)

            
        }

        task.resume()
        return task
    }
    
    private func convertData(_ data: Data, completionHandlerForConvertData: (_ result:AnyObject?,_ error: NSError?) -> Void) {
        var parsedData:AnyObject!
        do {
            parsedData = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
            if JSONSerialization.isValidJSONObject(parsedData) {
                completionHandlerForConvertData(parsedData,nil)
            }
        } catch {
            let userInfo = [NSLocalizedDescriptionKey: "Cannot parse the \(data) into json Format"]
            completionHandlerForConvertData(nil,NSError(domain:"convertDataWithCompletionHandler", code:1,userInfo: userInfo))
        }
        completionHandlerForConvertData(parsedData,nil)
    }
}
