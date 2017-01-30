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
    var requestToken: String? = nil
    var objectID: String? = nil
    var sessionID: String? = nil
    var userID: String? = nil
    var uniqueKey: String? = nil
    var firstName: String? = nil
    var lastName: String? = nil
    var studentLocations = [StudentInformation]()
    var annotations = [MKPointAnnotation]()
    
    
    override init() {
        super.init()
    }
    
    func taskForPOSTSession(jsonBody:[String:String], completionHandlerForSessionID:@escaping(_ result:AnyObject?,_ error:NSError?)-> Void) -> URLSessionDataTask {
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
    
    func taskForPOSTSessionFacebook(jsonBody:[String:String], completionHandlerForFacebookSessionID:@escaping(_ result:AnyObject?, _ error:NSError?)-> Void) -> URLSessionDataTask {
        
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
    
    func taskForGetStudentLocations(withUniqueKey: String?, completionHandlerForGetStudentLocation: @escaping(_ results: AnyObject?,_ error: NSError?) -> Void) -> URLSessionDataTask {
        var request:NSMutableURLRequest!
        let parametersMethod:[String : AnyObject] = [ParseParameterKeys.limit : ParseParameterValues.limit as AnyObject,
                                                     ParseParameterKeys.order : ParseParameterValues.order as AnyObject]
        if withUniqueKey != nil {
            request = NSMutableURLRequest(url: URL(string: "https://parse.udacity.com/parse/classes/StudentLocation?where=%7B%22uniqueKey%22%3A%22\(withUniqueKey)%22%7D")!)
        } else {
            request = NSMutableURLRequest(url: parseURLFromParameters(parametersMethod, withPathExtension: nil))
            
        }
        request.addValue(HTTPHeaderField.parseAppID, forHTTPHeaderField: ParseParameterValues.apiKey)
        request.addValue(HTTPHeaderField.parseRestApiKey, forHTTPHeaderField: ParseParameterValues.appID)
        
        let task = session.dataTask(with: request as URLRequest) {(data, response, error) in
            
            if error != nil {
                completionHandlerForGetStudentLocation(nil, NSError(domain: "taskForGEtStudentLocation", code: 1, userInfo: [NSLocalizedDescriptionKey: error!]))
            }
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
                print("The status code is not in order of 2xx")
                return
            }
            
            print(statusCode)
            guard let data = data else {
                print("Cannot find the data")
                return
            }
            let range = Range(uncheckedBounds: (0,data.count))
            let newData = data.subdata(in: range)
            self.convertData(newData, completionHandlerForConvertData:completionHandlerForGetStudentLocation)
            
        }
        
        task.resume()
        return task
    }
    
    func taskForDeleteSession(_ method: String, completionHandlerToDeleteSession: @escaping (_ results: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        let urlString = Constants.getSessionURL + method
        let url = URL(string: urlString)
        let request = NSMutableURLRequest(url: url!)
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
            if error != nil {
                let userInfo = [NSLocalizedDescriptionKey: error]
                completionHandlerToDeleteSession(nil, NSError(domain: "DeleteSession", code: 1, userInfo: userInfo))
            }
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                print("The status code is not in order of 2xx")
                return
            }
            
            print (statusCode)
            
            guard let data = data else {
                print("Cannot find the data")
                return
            }
            
            let range = Range(uncheckedBounds: (5, data.count))
            let newData = data.subdata(in: range)
            print(NSString(data: newData, encoding: String.Encoding.utf8.rawValue)!)
            self.convertData(newData, completionHandlerForConvertData: completionHandlerToDeleteSession)
        }
        
        task.resume()
        return task
    }
    
    func taskForPOSTStudentLocation(jsonBody:[String:AnyObject], completionHandlerForPOSTStudentLocation:@escaping(_ results: AnyObject?,_ error:NSError?) -> Void) -> URLSessionDataTask {
        
        let userInfo = jsonBody
        var info: Data!
        do{
            info = try JSONSerialization.data(withJSONObject: userInfo, options: JSONSerialization.WritingOptions.prettyPrinted)
        } catch {
            print("Cannot encode the data")
        }
        
        let request = NSMutableURLRequest(url: parseURLFromParameters([:],withPathExtension: nil))
        request.httpMethod = "POST"
        request.addValue(HTTPHeaderField.parseAppID, forHTTPHeaderField: ParseParameterValues.apiKey)
        request.addValue(HTTPHeaderField.parseRestApiKey, forHTTPHeaderField:ParseParameterValues.appID)
        request.addValue(Constants.applicationJSON, forHTTPHeaderField: HTTPHeaderField.contentType)
        request.httpBody = info
        
        let task = session.dataTask(with: request as URLRequest) {(data,response,error) in
            
            if error != nil {
                let userInfo = [NSLocalizedDescriptionKey:error]
                completionHandlerForPOSTStudentLocation(nil, NSError(domain: "taskForPOSTStudentLocation", code: 1, userInfo: userInfo))
            }
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                print("The status code is not in order of 2xx")
                return
            }
            
            print(statusCode)
            guard let data = data else {
                print("Could not find the data")
                return
            }
            
            let range = Range(uncheckedBounds: (5, data.count))
            let newData = data.subdata(in: range)
            self.convertData(newData, completionHandlerForConvertData: completionHandlerForPOSTStudentLocation)
            
        }
        task.resume()
        return task
    }
    
    func taskForGETUsersData(completionHandler: @escaping (_ result: AnyObject?, _ error:NSError?) -> Void) {
        
        let urlString = Constants.getSessionURL+Methods.users+"/\(userID)"
        let url = URL(string: urlString)
        let request = URLRequest(url: url!)
        let task = session.dataTask(with: request) {(data,response,error) in
            
            if error != nil {
                print("There was an error with the request")
                let userInfo = [NSLocalizedDescriptionKey: error]
                completionHandler(nil, NSError(domain:"deleteSessionID", code: 1,userInfo: userInfo))
            } else {
                guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                    print("The status code is not in order of 2xx")
                    return
                }
                
                print(statusCode)
                guard let data = data else {
                    print("Cannot find the user's data")
                    return
                }
                
                let range = Range(uncheckedBounds: (5,data.count))
                let newData = data.subdata(in: range)
                print(NSString(data:newData, encoding:String.Encoding.utf8.rawValue)!)
                self.convertData(newData, completionHandlerForConvertData: completionHandler)
            }
        }
        task.resume()
    }
    
    func taskForPUTStudentLocation(jsonBody:[String:AnyObject], method:String, completionHandlerForPUTStudentLocation: @escaping(_ results:AnyObject?,_ error:NSError?) -> Void) -> URLSessionDataTask {
    
        let request = NSMutableURLRequest(url: parseURLFromParameters([:], withPathExtension: method))
        request.httpMethod = "PUT"
        let userInfo = jsonBody
        var info: Data!
        do{
            info = try JSONSerialization.data(withJSONObject: userInfo, options: JSONSerialization.WritingOptions.prettyPrinted)
        } catch {
            print("Cannot encode the data")
        }
        
        request.addValue(HTTPHeaderField.parseAppID, forHTTPHeaderField: ParseParameterValues.apiKey)
        request.addValue(HTTPHeaderField.parseRestApiKey, forHTTPHeaderField: ParseParameterValues.appID)
        request.addValue(Constants.applicationJSON, forHTTPHeaderField: HTTPHeaderField.contentType)
        request.httpBody = info
        
        let task = session.dataTask(with: request as URLRequest) {(data, response, error) in
            
            if error != nil {
                completionHandlerForPUTStudentLocation(nil, NSError(domain:"taskForPUTStudentLocation", code: 1,userInfo:[NSLocalizedDescriptionKey: error!]))
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                print("The status code is not in order of 2xx")
                return
            }
            
            print(statusCode)
            guard let data = data else {
                print("Cannot find the data")
                return
            }
            
            let range = Range(uncheckedBounds: (5,data.count))
            let newData = data.subdata(in: range)
            completionHandlerForPUTStudentLocation(newData as AnyObject,nil)
            self.convertData(newData, completionHandlerForConvertData: completionHandlerForPUTStudentLocation)
        }
        
        task.resume()
        return task
    }
    
    func parseURLFromParameters(_ parameters: [String: AnyObject], withPathExtension:String? = nil) -> URL {
        
        var components = URLComponents()
        components.scheme = Constants.apiScheme
        components.host = Constants.apiHost
        components.path = Constants.apiPath + (withPathExtension ?? "")
        components.queryItems = [URLQueryItem]()
        
        for (key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        
        print(components.url!)
        return components.url!
    }
    
    private func convertData(_ data: Data, completionHandlerForConvertData: (_ result:AnyObject?,_ error: NSError?) -> Void) {
        var parsedData:AnyObject!
        do {
            parsedData = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
            if JSONSerialization.isValidJSONObject(parsedData) {
                completionHandlerForConvertData(parsedData, nil)
            }
        } catch {
            let userInfo = [NSLocalizedDescriptionKey: "Cannot parse the \(data) into json Format"]
            completionHandlerForConvertData(nil,NSError(domain:"convertDataWithCompletionHandler", code:1,userInfo: userInfo))
        }
        completionHandlerForConvertData(parsedData,nil)
    }
    
}
