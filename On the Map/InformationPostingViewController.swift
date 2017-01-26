//
//  InformationPostingViewController.swift
//  On the Map
//
//  Created by Sergey Kravtsov on 13.11.16.
//  Copyright © 2016 Sergey Kravtsov. All rights reserved.
//

import UIKit
import Foundation

class InformationPostingViewController : UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var centerView: UIView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var firstString: UILabel!
    @IBOutlet weak var secondString: UILabel!
    @IBOutlet weak var thirdString: UILabel!
    @IBOutlet weak var adressTextField: UITextField!
    @IBOutlet weak var findButton: UIButton!

    var locationString: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        adressTextField.delegate = self
        findButton.layer.cornerRadius = CGFloat(ParseClient.Radius.corner)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.text! == "Enter Your Location Here" {
            textField.text! = ""
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text != "" {
            self.locationString = textField.text!
        }
    }
    
    
}
