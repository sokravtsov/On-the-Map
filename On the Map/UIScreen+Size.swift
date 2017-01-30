//
//  UIScreen+Size.swift
//  On the Map
//
//  Created by Sergey Kravtsov on 30.01.17.
//  Copyright © 2017 Sergey Kravtsov. All rights reserved.
//

import Foundation
import UIKit

extension UIScreen {
    static func screenBounds() -> CGRect {
        return UIScreen.main.bounds
    }
    
    static func screenWidth() -> CGFloat {
        return UIScreen.main.bounds.width
    }
    
    static func screenHeight() -> CGFloat {
        return UIScreen.main.bounds.height
    }
}
