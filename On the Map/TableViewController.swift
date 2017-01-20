//
//  TableViewController.swift
//  On the Map
//
//  Created by Sergey Kravtsov on 01.11.16.
//  Copyright © 2016 Sergey Kravtsov. All rights reserved.
//

import UIKit

class TableViewController: UIViewController {
    
    @IBOutlet weak var logoutButton: UIBarButtonItem!
    @IBOutlet weak var pinButton: UIBarButtonItem!
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //FIXME: переместить в выход из приложения
        ParseClient.sharedInstance().DeleteSession()
    }
}
