//
//  LoginNavigationViewController.swift
//  Resume
//
//  Created by Manu Gupta on 24/08/17.
//  Copyright © 2017 VM User. All rights reserved.
//

import UIKit

class LoginNavigationViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    class func getLoginNavigationViewController(link: String? = UserDefaults.standard.string(forKey: "link")) -> LoginNavigationViewController {
        let nvc = LoginNavigationViewController()
        
        if let link = link {
            let vc = UIStoryboard.prefilledCommunity()
            vc.link = link
            nvc.viewControllers = [vc]
        }
        else {
            let vc = UIStoryboard.prefilledCommunity()
            vc.link = ""
            nvc.viewControllers = [vc]
        }
        
        return nvc
    }
}
