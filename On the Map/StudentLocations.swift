//
//  StudentLocations.swift
//  On the Map
//
//  Created by Sergey Kravtsov on 02.02.17.
//  Copyright © 2017 Sergey Kravtsov. All rights reserved.
//

import Foundation

class StudentLocations: NSObject {
    
    var studentLocations = [StudentInformation]()
    static let sharedInstance = StudentLocations()
    
}
