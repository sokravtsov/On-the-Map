//
//  LoginViewController.swift
//  On the Map
//
//  Created by Sergey Kravtsov on 31.10.16.
//  Copyright © 2016 Sergey Kravtsov. All rights reserved.
//

import UIKit
import Foundation

///Class for login via Udacity or Facebook account
class LoginViewController : UIViewController, UITextFieldDelegate, FBSDKLoginButtonDelegate {
    
    var appDelegate: AppDelegate!

    //MARK: UI Variables
    
    ///Email textField outlet
    @IBOutlet weak var emailTextField: UITextField!
    
    ///Password textField outlet
    @IBOutlet weak var passwordTextField: UITextField!
    
    ///Login button outlet
    @IBOutlet weak var loginButton: UIButton!
    
    ///Singup button outlet
    @IBOutlet weak var sigupButton: UIButton!
    
    ///Facebook login button outlet
    @IBOutlet weak var facebookButton: FBSDKLoginButton!
    
    // MARK : Variables
    
    ///Udacity sing up URL
    let url = URL(string: "https://auth.udacity.com/sign-up?next=https%3A%2F%2Fclassroom.udacity.com%2Fauthenticated")!
    
    ///MARK: Methods
    
    ///Override of **viewDidLoad()** method
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        facebookSettings()
        appDelegate = UIApplication.shared.delegate as! AppDelegate

    }
    
    ///Method textField should return
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    ///Method textField did begin editing
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if ((textField.text == ParseClient.Placeholder.email) || (textField.text == ParseClient.Placeholder.password)) {
            textField.text = ""
        }
    }
    
    ///Method textField did end editing
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text == "" {
            if textField == emailTextField {
                textField.text = ParseClient.Placeholder.email
            } else if textField == passwordTextField {
                textField.text = ParseClient.Placeholder.password
            }
        }
    }
    
    ///Override of **viewWillAppear()** method
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeKeyboardNotifications()
    }
    
    /// Observe keyboard notifications
    func subscribeKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    ///Override of **viewWillDisappear()** method
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    ///Method that called when keyboard appeared
    func keyboardWillShow(_ notification: NSNotification) {
        if passwordTextField.isFirstResponder {
            view.frame.origin.y =  getKeyboardHeight(notification: notification) * -1
        }
    }
    
    ///Method that called when keyboard disappeared
    func keyboardWillHide(_ notification: NSNotification) {
        if passwordTextField.isFirstResponder {
            view.frame.origin.y = 0
        }
    }
    
    /// get keyboard height
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    /// Remove keyboard notifications
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    ///Action for sing up to Udacity
    @IBAction func openUdacitySite(_ sender: AnyObject) {
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    // Facebook Delegate Methods
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        print("User Logged In")
        self.performSegue(withIdentifier: "Login", sender: self)
        
        if ((error) != nil) {
            // Process error
        } else if result.isCancelled {
            // Handle cancellations
        } else {
            // If you ask for multiple permissions at once, you
            // should check if specific permissions missing
            if result.grantedPermissions.contains("email") {
                // Do work
            }
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("User Logged Out")
    }
    
    func returnUserData() {
        
    }
    
    private func configureUI() {
        loginButton.layer.cornerRadius = CGFloat(ParseClient.Radius.corner)
        facebookButton.layer.cornerRadius = CGFloat(ParseClient.Radius.corner)
        emailTextField.delegate = self
        passwordTextField.delegate = self
        emailTextField.placeholder = ParseClient.Placeholder.email
        passwordTextField.placeholder = ParseClient.Placeholder.password
        passwordTextField.isSecureTextEntry = true
    }
    
    private func facebookSettings() {
        if (FBSDKAccessToken.current() != nil) {
            self.performSegue(withIdentifier: "Login", sender: self)
        } else {
            facebookButton.readPermissions = ["public_profile", "email", "user_friends"]
            facebookButton.delegate = self
        }
    }
    
}
