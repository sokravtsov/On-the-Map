//
//  InformationPostingViewController.swift
//  On the Map
//
//  Created by Sergey Kravtsov on 13.11.16.
//  Copyright © 2016 Sergey Kravtsov. All rights reserved.
//

import UIKit

class InformationPostingViewController : UIViewController {
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var centerView: UIView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var firstString: UILabel!
    @IBOutlet weak var secondString: UILabel!
    @IBOutlet weak var thirdString: UILabel!
    @IBOutlet weak var adressTextField: UITextField!
    @IBOutlet weak var findButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        findButton.layer.cornerRadius = CGFloat(Radius.corner)
    }
    
}
