//
//  LoginViewController.swift
//  On the Map
//
//  Created by Sergey Kravtsov on 31.10.16.
//  Copyright © 2016 Sergey Kravtsov. All rights reserved.
//

import UIKit

class LoginViewController : UIViewController {
    
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var sigupButton: UIButton!
    @IBOutlet weak var facebookButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        loginButton.layer.cornerRadius = 5
        facebookButton.layer.cornerRadius = 5
    
    }
    
}
