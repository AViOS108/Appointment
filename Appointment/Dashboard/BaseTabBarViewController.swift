//
//  BaseTabBarViewController.swift
//  Indialends
//
//  Created by IndiaLends on 16/07/19.
//  Copyright © 2019 IndiaLends. All rights reserved.
//

import UIKit

extension UITabBar {
    // Workaround for iOS 11's new UITabBar behavior where on iPad, the UITabBar inside
    // the Master view controller shows the UITabBarItem icon next to the text
    override open var traitCollection: UITraitCollection {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return UITraitCollection(horizontalSizeClass: .compact)
        }
        return super.traitCollection
    }
}

class BaseTabBarViewController: UITabBarController, UITabBarControllerDelegate {
    
    var item1 :HomeViewController? = nil;
   var item2 :HomeViewController? = nil;


    override func viewDidLoad() {
        super.viewDidLoad() 
        item1 = HomeViewController()
        item1?.userTypeHome = .Student
        item2 = HomeViewController()
        item2?.userTypeHome = .StudentMyAppointment

        delegate = self
    }
    

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if Device.IS_IPHONE_X {
            UITabBarItem.appearance().titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -4)

        }
        else if  (Device.IS_IPAD){
            UITabBarItem.appearance().titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -4)
        }
        else {
            UITabBarItem.appearance().titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -4)
        }
        

        self.tabBar.barTintColor =  ILColor.color(index: 8);
//        self.tabBar.backgroundColor =  ILColor.color(index: 8);
//        self.tabBar.itemPositioning = .cent ;
        
        
UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: ILColor.color(index: 3)], for: .selected)
        if let fontDate = UIFont(name: "FontRegular".localized(), size: Device.FONTSIZETYPE13){
            UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: ILColor.color(index: 14),NSAttributedString.Key.font: fontDate],
            
                                                        for: .normal)
            UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: ILColor.color(index: 3),NSAttributedString.Key.font: fontDate], for: .selected)
            
        }
        
        
        let isStudent = UserDefaultsDataSource(key: "student").readData() as? Bool
        if isStudent ?? true {
            let icon1 = UITabBarItem(title: "Schedule", image: UIImage(named: "Scheedule_light"), selectedImage: UIImage(named: "Schedule"))
            let icon2 = UITabBarItem(title: "My Appointments", image: UIImage(named: "My_Appointment"), selectedImage: UIImage(named: "My_Appoinntment_2"))
            
            
            
            icon1.landscapeImagePhone = UIImage.init(named: "Scheedule_light");
            icon2.landscapeImagePhone = UIImage.init(named: "My_Appointment");
            
            item2!.tabBarItem = icon2
            item1!.tabBarItem = icon1
        }
        else{
            let icon1 = UITabBarItem(title: "Schedule", image: UIImage(named: "Scheedule_light"), selectedImage: UIImage(named: "Schedule"))
                      let icon2 = UITabBarItem(title: "My Appointments", image: UIImage(named: "My_Appointment"), selectedImage: UIImage(named: "My_Appoinntment_2"))
               
            item2!.tabBarItem = icon2
            item1!.tabBarItem = icon1
        }
        
        let controllers = [item1,item2]  //array of the root view controllers displayed by the tab bar interface
        self.viewControllers = controllers as? [UIViewController]
      
    }
    
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        _ = tabBar.items?.firstIndex(of: item)
    }
    
    //Delegate methods
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        print("Should select viewController: \(viewController.title ?? "") ?")
        return true
    }
}

// helper for creating an image-only UITabBarItem
extension UITabBarItem {
    func tabBarItemShowingOnlyImage() -> UITabBarItem {
        // offset to center
        return self
    }
    func tabBarItemSetting() -> UITabBarItem {
        // offset to center
        return self
    }
}

extension UITabBar {
    override open func sizeThatFits(_ size: CGSize) -> CGSize {
        var sizeThatFits = super.sizeThatFits(size)
        if Device.IS_IPHONE_X {
            sizeThatFits.height = 90
        }
        else if  (Device.IS_IPAD){
            sizeThatFits.height = 60
        }
        else {
            sizeThatFits.height = 60 // adjust your size here
        }
        return sizeThatFits
    }
}
