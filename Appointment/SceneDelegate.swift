//
//  SceneDelegate.swift
//  Appointment
//
//  Created by Anurag Bhakuni on 08/07/20.
//  Copyright © 2020 Anurag Bhakuni. All rights reserved.
//

import UIKit
import SwiftUI
import SlideMenuControllerSwift

@available(iOS 13.0, *)
class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func checkLoginState(windowS : UIWindow?){
        let windowI : UIWindow;
        
        if let window = windowS{
            windowI = window;
        }
        else
        {
            windowI = self.window!;
        }
        
        windowI.rootViewController = nil
        for view in windowI.subviews {
            view.removeFromSuperview()
        }
        let loggedInStatus = (UserDefaultsDataSource(key: "loggedIn").readData() as? Bool) ?? false
        if loggedInStatus {
            //                        let viewcontrollerHome = HomeViewController.init(nibName: "HomeViewController", bundle: nil)
            
            let viewcontrollerHome = BaseTabBarViewController()
            let navigationController = UINavigationController.init(rootViewController: viewcontrollerHome)
            
            let viewcontrollerSlider = SliderViewController.init(nibName: "SliderViewController", bundle: nil);
            let navigationControllerS = UINavigationController.init(rootViewController: viewcontrollerSlider)
            
            let v1 = SlideMenuController(mainViewController: navigationController, leftMenuViewController: navigationControllerS);
            
            SlideMenuOptions.contentViewScale = 1.0
            windowI.backgroundColor = .clear
            windowI.rootViewController = v1
            windowI.makeKeyAndVisible()
        }else{
            let viewUserType = SelectUserTypeViewController.init(nibName: "SelectUserTypeViewController", bundle: nil);
            let navigationControllerS = UINavigationController.init(rootViewController: viewUserType)
            windowI.backgroundColor = .clear
            windowI.rootViewController = navigationControllerS
        }
    }
    
    @available(iOS 13.0, *)
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
            if let windowScene = scene as? UIWindowScene {
                    let window = UIWindow(windowScene: windowScene)
        //             checkLoginState()
        //            window.rootViewController = checkLoginState()
        //            self.window = window
                          let contentView = checkLoginState(windowS: window)
                          self.window = window

                    
                    window.makeKeyAndVisible()
              }    }
    @available(iOS 13.0, *)
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    @available(iOS 13.0, *)
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }
    @available(iOS 13.0, *)
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
    @available(iOS 13.0, *)
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }
    @available(iOS 13.0, *)
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
        
        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }
    
    
}

