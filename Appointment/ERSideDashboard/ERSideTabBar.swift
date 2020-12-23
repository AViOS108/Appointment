//
//  ERSideTabBar.swift
//  Appointment
//
//  Created by Anurag Bhakuni on 10/11/20.
//  Copyright © 2020 Anurag Bhakuni. All rights reserved.
//

import Foundation
import UIKit

class ERSideTabBar : UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        ManageSingleton.destroyCustomSingleton()
        AppUtility.lockOrientation(.all)
        delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UserDefaultsDataSource(key: "timeZoneOffset").writeData(TimeZone.current.identifier)

    }
    
 
    
    
//    @IBAction func unwindToDashboardTabbarController(segue:UIStoryboardSegue) {
//        self.selectedViewController = self.viewControllers?[0]
//    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        NSLog("yaba tabBar")
    }
}

extension ERSideTabBar : UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        return true
    }
}

    
  
    
    
 
