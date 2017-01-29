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
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.UdacityTableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ParseClient.sharedInstance.studentLocations.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! TableViewCell
        let studentLocation = ParseClient.sharedInstance.studentLocations[(indexPath as NSIndexPath).row] as StudentLocation
        if studentLocation.firstName == "" && studentLocation.lastName == "" {
            cell.nameLabel.text = "Anonymous"
        } else {
            cell.nameLabel.text = "\(studentLocation.firstName ?? "") \(studentLocation.lastName ?? "")"
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let studentLocation = ParseClient.sharedInstance.studentLocations[(indexPath as NSIndexPath).row] as StudentLocation
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
        ParseClient.sharedInstance.studentLocations.removeAll()
        getStudentLocations()
    }
    
    @IBAction func addPin(_ sender: Any) {
    }
    
    @IBAction func logOut(_ sender: Any) {
    }
    
    
}

//MARK: - UdacityProtocol
extension TableViewController: UdacityProtocol {
    
    func getStudentLocations() {
        
        ParseClient.sharedInstance.getStudentLocations { (locations, error) in
            
            if let result = locations {
                ParseClient.sharedInstance.studentLocations = result
                print (result)
                performUIUpdatesOnMain {
                    self.UdacityTableView.reloadData()
                }
                
            } else {
                print(error)
            }
        }
        
    }
}

