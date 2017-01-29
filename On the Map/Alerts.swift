//
//  Alerts.swift
//  On the Map
//
//  Created by Sergey Kravtsov on 29.01.17.
//  Copyright © 2017 Sergey Kravtsov. All rights reserved.
//

import Foundation

protocol Alerts {
    func showAlert(title: String, message : String?)
}

extension UIViewController: Alerts {
    
    func showAlert(title: String, message : String?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default) { (UIAlertAction) in }
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
