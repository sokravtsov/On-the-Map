//
//  UIViewController+ActivityIndicator.swift
//  On the Map
//
//  Created by Sergey Kravtsov on 30.01.17.
//  Copyright © 2017 Sergey Kravtsov. All rights reserved.
//

import Foundation

private var activityIndicator: ActivityIndicator?

protocol activityIndicatorDelegate {
    
}

extension UIViewController: activityIndicatorDelegate {
    internal func showActivityIndicator() {
        if activityIndicator?.superview != nil {
            activityIndicator?.removeFromSuperview()
        }
        activityIndicator = ActivityIndicator(frame: UIScreen.screenBounds())
        activityIndicator?.activityIndicator.startAnimating()
        activityIndicator?.alpha = 1
        self.view.addSubview(activityIndicator!)
    }
    
    internal func showActivityIndicator(topField: CGFloat) {
        if activityIndicator?.superview != nil {
            activityIndicator?.removeFromSuperview()
        }
        activityIndicator = ActivityIndicator(frame: CGRect(x: 0, y: 0 + topField, width: UIScreen.screenWidth(), height: UIScreen.screenHeight() - (0 + topField)))
        activityIndicator?.activityIndicator.startAnimating()
        activityIndicator?.alpha = 1
        self.view.addSubview(activityIndicator!)
    }
    
    internal func hideActivityIndicator() {
        activityIndicator?.activityIndicator.stopAnimating()
        Animations.hide(view: activityIndicator!, alpha: 0)
    }
}
