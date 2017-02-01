//
//  LoginViewController.swift
//  On the Map
//
//  Created by Sergey Kravtsov on 31.10.16.
//  Copyright © 2016 Sergey Kravtsov. All rights reserved.
//

import UIKit
import Foundation

fileprivate protocol KeyboardProtocol {
    func subscribeKeyboardNotifications()
    func keyboardWillShow(_ notification: NSNotification)
    func keyboardWillHide(_ notification: NSNotification)
    func getKeyboardHeight(notification: NSNotification) -> CGFloat
    func unsubscribeFromKeyboardNotifications()
}

fileprivate protocol FacebookProtocol{
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!)
    func facebookSettings()
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!)
}

fileprivate protocol SetupUIProtocol {
    func hideUI()
    func showUI()
    func setupUI(need: Bool)
    func configureUI()
}
///Class for login via Udacity or Facebook account
class LoginViewController : UIViewController, FBSDKLoginButtonDelegate {
    
    //MARK: Outlets
    
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
    
    ///Login label outlet
    @IBOutlet weak var loginLabel: UILabel!
    
    // MARK : Properties
    
    ///Udacity sing up URL
    let url = URL(string: "https://auth.udacity.com/sign-up?next=https%3A%2F%2Fclassroom.udacity.com%2Fauthenticated")!
    
    var activityIndicator = ActivityIndicator()
    
    //MARK: Life Cycle
    
    ///Override of **viewDidLoad()** method
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        facebookSettings()
    }
    
    ///Override of **viewWillAppear()** method
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeKeyboardNotifications()
    }
    
    ///Override of **viewWillDisappear()** method
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    //MARK: Actions
    
    ///Action for sing up to Udacity
    @IBAction func openUdacitySite(_ sender: AnyObject) {
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    @IBAction func tapLogin(_ sender: Any) {
        if Reachability.isConnectedToNetwork() {
            setupUI(need: true)
            self.showActivityIndicator()
            ParseClient.sharedInstance.PostSession(userName: emailTextField.text!, password: passwordTextField.text!) { (success, results, error) in
                if success {
                    performUIUpdatesOnMain {
                        self.setupUI(need: false)
                        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NavViewController") as! UITabBarController
                        self.present(vc, animated: false, completion: nil)
                    }
                } else {
                    performUIUpdatesOnMain {
                        self.hideActivityIndicator()
                        self.setupUI(need: false)
                        self.showAlert(title: "", message: "Wrong Login or Password. Try Again")
                    }
                }
            }
        } else {
            performUIUpdatesOnMain {
                self.showAlert(title: ParseClient.Str.noConnection, message: ParseClient.Str.checkConnection)
            }
        }
    }
}

extension LoginViewController : SetupUIProtocol {
    fileprivate func hideUI() {
        facebookButton.isHidden = true
        emailTextField.isHidden = true
        passwordTextField.isHidden = true
        loginButton.isHidden = true
        sigupButton.isHidden = true
        loginLabel.isHidden = true
    }
    
    fileprivate func showUI() {
        facebookButton.isHidden = false
        emailTextField.isHidden = false
        passwordTextField.isHidden = false
        emailTextField.text = ""
        passwordTextField.text = ""
        loginButton.isHidden = false
        sigupButton.isHidden = false
        loginLabel.isHidden = false
        hideActivityIndicator()
    }
    
    fileprivate func setupUI(need: Bool) {
        need ? hideUI() : showUI()
    }
    
    fileprivate func configureUI() {
        loginButton.layer.cornerRadius = CGFloat(ParseClient.Radius.corner)
        facebookButton.layer.cornerRadius = CGFloat(ParseClient.Radius.corner)
        emailTextField.delegate = self
        passwordTextField.delegate = self
        emailTextField.placeholder = ParseClient.Placeholder.email
        passwordTextField.placeholder = ParseClient.Placeholder.password
        passwordTextField.isSecureTextEntry = true
    }
}

extension LoginViewController: FacebookProtocol {
    
    internal func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("User Logged Out")
    }
    
    fileprivate func facebookSettings() {
        if (FBSDKAccessToken.current() != nil) {
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NavViewController") as! UITabBarController
            self.present(vc, animated: false, completion: nil)
        } else {
            facebookButton.readPermissions = ["public_profile", "email", "user_friends"]
            facebookButton.delegate = self
        }
    }
    
    // Facebook Delegate Methods
    internal func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if Reachability.isConnectedToNetwork() {
            if result != nil {
                setupUI(need: true)
                self.showActivityIndicator()
                ParseClient.sharedInstance.PostSessionFacebook() { (results, error) in
                    if error == nil {
                        performUIUpdatesOnMain {
                            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NavViewController") as! UITabBarController
                            self.present(vc, animated: false, completion: nil)
                            print("User Logged In")
                            
                        }
                    }
                }
            }
        } else {
            performUIUpdatesOnMain {
                self.showAlert(title: ParseClient.Str.noConnection, message: ParseClient.Str.checkConnection)
            }
        }
    }
}

extension LoginViewController: UITextFieldDelegate {
    
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
}

extension LoginViewController: KeyboardProtocol {
    /// Observe keyboard notifications
    func subscribeKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
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
}
