//
//  Redirections.swift
//  Resume
//
//  Created by Varun Wadhwa on 10/12/18.
//  Copyright © 2018 VM User. All rights reserved.
//

import UIKit

class Redirections {
    
    
    static func appWindow() -> UIWindow? {
        guard  let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return nil
        }
        return appDelegate.window
    }
    
    static func changeRootVC(_ controller : UIViewController) {
        (UIApplication.shared.delegate as? AppDelegate)?.changeRootVC(controller)
    }

//    static func toHomeScreen() -> HomeViewController? {
//        let rootVC = UIStoryboard.dashboardTabBar()
//        changeRootVC(rootVC)
//        if let window = appWindow() {
//            if let vc = window.rootViewController as? UITabBarController  {
//                vc.selectedIndex = 0
//                if let navController = vc.selectedViewController as? UINavigationController , let homeVC = navController.viewControllers.first as? HomeViewController {
//                    navController.popToRootViewController(animated: true)
//                    return homeVC
//                }
//            }
//        }
//        return nil
//    }
    
//    static func toNetworkFeedback() -> NetworkFeedbackViewController? {
//        let rootVC = UIStoryboard.dashboardTabBar()
//        changeRootVC(rootVC)
//        if let window = appWindow() {
//            if let vc = window.rootViewController as? UITabBarController  {
//                vc.selectedIndex = 1
//                if let navController = vc.selectedViewController as? UINavigationController , let nfVC = navController.viewControllers.first as? NetworkFeedbackViewController {
//                    navController.popToRootViewController(animated: true)
//                    return nfVC
//                }
//            }
//        }
//        return nil
//    }
}
