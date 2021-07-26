//
//  CustomizedViewController.swift
//  Resume
//
//  Created by Manu Gupta on 02/11/17.
//  Copyright © 2017 VM User. All rights reserved.
//

import UIKit

class CustomizedViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.backgroundColor = UIColor.clear
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    
}
