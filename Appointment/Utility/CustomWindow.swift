//
//  CustomWindow.swift
//  Resume
//
//  Created by Gaurav Gupta on 01/11/17.
//  Copyright © 2017 VM User. All rights reserved.
//

import UIKit

class CustomWindow: UIWindow {
    var isShowing = false
    
    func show() {
        isHidden = false
        makeKeyAndVisible()
        isShowing = true
        if let vc = rootViewController as? SplashWithLoaderViewControllerViewController {
            vc.start()
        }
    }
    
    func hide() {
        isShowing = false
        isHidden = true
        if let vc = rootViewController as? SplashWithLoaderViewControllerViewController {
            vc.stop()
        }
    }

}
