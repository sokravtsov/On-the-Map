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
    func showAlertWithAction()
    func showAlertWithActionFromTable()
}

extension UIViewController: Alerts {
    
    func showAlert(title: String, message : String?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default) { (UIAlertAction) in }
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showAlertWithAction() {
        let alertController = UIAlertController(title: "", message: "You Have Already Posted a Student Location. Would You Like to Overwrite Your Current Location?", preferredStyle: .alert)
        let overwriteAction = UIAlertAction(title: "Overwrite", style: .default) { action -> Void in
            self.performSegue(withIdentifier: "addPinFromMap", sender: self)
        }
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
            print("Cancel Selected")
        }
        alertController.addAction(overwriteAction)
        alertController.addAction(cancelButton)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showAlertWithActionFromTable() {
        let alertController = UIAlertController(title: "", message: "You Have Already Posted a Student Location. Would You Like to Overwrite Your Current Location?", preferredStyle: .alert)
        let overwriteAction = UIAlertAction(title: "Overwrite", style: .default) { action -> Void in
            self.performSegue(withIdentifier: "addPinFromTable", sender: self)
        }
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
            print("Cancel Selected")
        }
        alertController.addAction(overwriteAction)
        alertController.addAction(cancelButton)
        self.present(alertController, animated: true, completion: nil)
    }
    
    
}
