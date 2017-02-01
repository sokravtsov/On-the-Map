//
//  TableViewController.swift
//  On the Map
//
//  Created by Sergey Kravtsov on 01.11.16.
//  Copyright © 2016 Sergey Kravtsov. All rights reserved.
//

import UIKit

fileprivate protocol UdacityProtocol {
    func getStudentLocations()
}

///TableViewController for perform students locations in table view
class TableViewController: UITableViewController {
    
    //MARK: - Outlets
    @IBOutlet var UdacityTableView: UITableView!
    @IBOutlet weak var logoutButton: UIBarButtonItem!
    @IBOutlet weak var pinButton: UIBarButtonItem!
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    
    //MARK: - Life Cycle

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.UdacityTableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StudentLocations.sharedInstance.studentLocations.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! TableViewCell
        let studentLocation = StudentLocations.sharedInstance.studentLocations[(indexPath as NSIndexPath).row] as StudentInformation
        if studentLocation.firstName == "" && studentLocation.lastName == "" {
            cell.nameLabel.text = "Anonymous"
        } else {
            cell.nameLabel.text = "\(studentLocation.firstName ?? "") \(studentLocation.lastName ?? "")"
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let studentLocation = StudentLocations.sharedInstance.studentLocations[(indexPath as NSIndexPath).row] as StudentInformation
        let urlString = studentLocation.mediaURL!
        let app = UIApplication.shared
        if urlString != "" {
            app.open(URL(string: urlString)!, options: [:], completionHandler: nil)
        } else {
            let alertController = UIAlertController(title: "Empty website string", message: "", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (UIAlertAction) in
            }
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    //MARK: - Actions
    
    @IBAction func refreshTableView(_ sender: Any) {
        if Reachability.isConnectedToNetwork() {
            StudentLocations.sharedInstance.studentLocations.removeAll()
            getStudentLocations()
        } else {
            self.showAlert(title: ParseClient.Str.noConnection, message: ParseClient.Str.checkConnection)
        }
    }
    
    @IBAction func addPin(_ sender: Any) {
        if Reachability.isConnectedToNetwork() {
            ParseClient.sharedInstance.getStudentLocations(withUniqueKey: ParseClient.sharedInstance.uniqueKey) {(results,error) in
                if error != nil {
                    print (error!)
                }
            }
            if ParseClient.sharedInstance.objectID == nil {
                self.performSegue(withIdentifier: "addPinFromMap", sender: self)
            } else {
                self.showAlertWithActionFromTable()
            }
        } else {
            self.showAlert(title: ParseClient.Str.noConnection, message: ParseClient.Str.checkConnection)
        }
    }
    
    @IBAction func logOut(_ sender: Any) {
        if Reachability.isConnectedToNetwork() {
            ParseClient.sharedInstance.DeleteSession() { (results, error) in
                if error == nil {
                    self.showActivityIndicator()
                    ParseClient.sharedInstance.userID = nil
                    performUIUpdatesOnMain {
                        self.dismiss(animated: true, completion: nil)
                        print ("Session deleled")
                    }
                }
            }
        } else {
            self.showAlert(title: ParseClient.Str.noConnection, message: ParseClient.Str.checkConnection)
            
        }
    }
}

//MARK: - UdacityProtocol
extension TableViewController: UdacityProtocol {
    func getStudentLocations() {
        if Reachability.isConnectedToNetwork() {
            ParseClient.sharedInstance.getStudentLocations(withUniqueKey: nil) { (results, error) in
                if let results = results {
                    StudentLocations.sharedInstance.studentLocations = results as! [StudentInformation]
                    print (results)
                    performUIUpdatesOnMain {
                        self.UdacityTableView.reloadData()
                    }
                } else if error != nil {
                    print(error!)
                    self.showAlert(title: "Server is Unavailable", message: "Failed to download the location of students")
                }
            }
        } else {
            self.showAlert(title: ParseClient.Str.noConnection, message: ParseClient.Str.checkConnection)
        }
    }
}

