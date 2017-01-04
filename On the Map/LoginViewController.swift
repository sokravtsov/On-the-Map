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
        loginButton.layer.cornerRadius = CGFloat(Radius.corner)
        facebookButton.layer.cornerRadius = CGFloat(Radius.corner)
        emailTextField.delegate = self
        passwordTextField.delegate = self
        emailTextField.placeholder = Placeholder.email
        passwordTextField.placeholder = Placeholder.password
        passwordTextField.isSecureTextEntry = true
        
        if (FBSDKAccessToken.current() != nil) {
            // User is already logged in, do work such as go to next view controller.
        } else {
            facebookButton.readPermissions = ["public_profile", "email", "user_friends"]
//            facebookButton.delegate = self
//            let loginView : FBSDKLoginButton = FBSDKLoginButton()
//            self.view.addSubview(loginView)
//            loginView.center = self.view.center
//            loginView.readPermissions = ["public_profile", "email", "user_friends"]
//            loginView.delegate = self
        }
    }
    
    ///Method textField should return
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    ///Method textField did begin editing
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if ((textField.text == Placeholder.email) || (textField.text == Placeholder.password)) {
            textField.text = ""
        }
    }
    
    ///Method textField did end editing
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text == "" {
            if textField == emailTextField {
                textField.text = Placeholder.email
            } else if textField == passwordTextField {
                textField.text = Placeholder.password
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
    
//    func returnUserData() {
//        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: nil)
//        graphRequest.start(completionHandler: { (connection, result, error) -> Void in
//            
//            if ((error) != nil) {
//                // Process error
//                print("Error: \(error)")
//            } else {
//                print("fetched user: \(result)")
//                let userName : NSString = result.valueForKey("name") as! NSString
//                print("User Name is: \(userName)")
//                let userEmail : NSString = result.valueForKey("email") as! NSString
//                print("User Email is: \(userEmail)")
//            }
//        })
//    }
    
}
