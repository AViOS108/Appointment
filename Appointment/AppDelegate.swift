//
//  AppDelegate.swift
//  Appointment
//
//  Created by Anurag Bhakuni on 08/07/20.
//  Copyright © 2020 Anurag Bhakuni. All rights reserved.
//

import UIKit
import CoreData
import SlideMenuControllerSwift
import Firebase
import Reachability

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var reachability : Reachability?
    var orientationLock = UIInterfaceOrientationMask.portrait

    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        if #available(iOS 13.0, *)
        {
            NotificationCenter.default.addObserver(self, selector: #selector(AppDelegate.checkLoginState), name: Notification.Name("logout"), object: nil)
            
        }
        else{
            
            window?.backgroundColor = UIColor.white
            window?.tintColor = ColorCode.applicationBlue
            #warning ("custom warning : multiple initializeAlertWindow() calls")
            NotificationCenter.default.addObserver(self, selector: #selector(AppDelegate.checkLoginState), name: Notification.Name("logout"), object: nil)
            window = UIWindow.init(frame: UIScreen.main.bounds)
            
            if let notification = launchOptions?[UIApplication.LaunchOptionsKey.localNotification] as? UILocalNotification {
                if !ManageNotifications.sharedInstance().handleLocalNotification(notification) {
                    launchAppWithLaunchingOptions(launchOptions)
                }
            } else {
                launchAppWithLaunchingOptions(launchOptions)
            }
        }
        //        FirebaseApp.configure()
        
        
        
        
        
        do {
            reachability = try Reachability()
            //            NotificationCenter.default.addObserver(self, selector:#selector(self.checkForReachability), name: NSNotification.Name.reachabilityChanged, object: nil)
            
            try reachability!.startNotifier()
        }
        catch(let error) {
            print("Error occured while starting reachability notifications : \(error.localizedDescription)")
        }
        
        return true
    }
    
    
   class func getDelegate() -> AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    
    func launchAppWithLaunchingOptions(_ launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        checkLoginState()
    }
    
    func changeRootVC(_ controller : UIViewController) {
          
          if #available(iOS 13.0, *)
          {
              let mySceneDelegate  = UIApplication.shared.connectedScenes.first
              if let sd : SceneDelegate = (mySceneDelegate?.delegate as? SceneDelegate) {
              clearWindow()
                  sd.window?.makeKeyAndVisible()
                  sd.window?.rootViewController = controller
              }
          }
          else{
              
              clearWindow()
              window?.makeKeyAndVisible()
              window?.rootViewController = controller
              
          }
          
      }
    
    
    
    @objc func checkLoginState(){
        
        if #available(iOS 13.0, *)
        {
            let mySceneDelegate  = UIApplication.shared.connectedScenes.first
            if let sd : SceneDelegate = (mySceneDelegate?.delegate as? SceneDelegate) {
                sd.checkLoginState(windowS: nil)
            }
        }
        else
        {
            clearWindow()
            let loggedInStatus = (UserDefaultsDataSource(key: "loggedIn").readData() as? Bool) ?? false
            if loggedInStatus {
                let viewcontrollerHome = BaseTabBarViewController()
                let navigationController = UINavigationController.init(rootViewController: viewcontrollerHome)
                
                let viewcontrollerSlider = SliderViewController.init(nibName: "SliderViewController", bundle: nil);
                let navigationControllerS = UINavigationController.init(rootViewController: viewcontrollerSlider)
                
                let v1 = SlideMenuController(mainViewController: navigationController, leftMenuViewController: navigationControllerS);
                
                SlideMenuOptions.contentViewScale = 1.0
                window?.backgroundColor = .clear
                window?.rootViewController = navigationController
                window?.makeKeyAndVisible()
            }else{
                let viewUserType = SelectUserTypeViewController.init(nibName: "SelectUserTypeViewController", bundle: nil);
                let navigationControllerS = UINavigationController.init(rootViewController: viewUserType)
                window?.backgroundColor = .clear
                window?.rootViewController = navigationControllerS
                window?.makeKeyAndVisible()
                
            }
            
        }
    }
    
    func clearWindow() {
        
        if #available(iOS 13.0, *)
        {
            let mySceneDelegate  = UIApplication.shared.connectedScenes.first
            if let sd : SceneDelegate = (mySceneDelegate?.delegate as? SceneDelegate) {
                sd.window?.rootViewController = nil
                if let subviews = sd.window?.subviews {
                    for view in subviews {
                        view.removeFromSuperview()
                    }
                }
            }
        }
        else{
            window?.rootViewController = nil
            if let subviews = window?.subviews {
                for view in subviews {
                    view.removeFromSuperview()
                }
            }
            
        }
        
        
    }
    
    
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    // MARK: - Core Data stack
    
    lazy var applicationDocumentsDirectory: URL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.cadiridris.coreDataTemplate" in the application's documents Application Support directory.
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1]
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = Bundle.main.url(forResource: "Appointment", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.appendingPathComponent("Appointment.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            let options = [ NSInferMappingModelAutomaticallyOption : true,
                            NSMigratePersistentStoresAutomaticallyOption : true]
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: options)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject?
            dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject?
            
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "Resume", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            
            FileSystemDataSource().clearAllData()
            //               if self.persistentStoreFailureCounter > 0 {
            //                   abort()
            //               } else {
            //                   self.checkLoginState()
            //               }
            
        }
        
        return coordinator
    }()
    
    lazy var notesManagedObjectContext: NSManagedObjectContext = {
        let moc = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        moc.parent = self.managedObjectContext
        return moc
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        managedObjectContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return managedObjectContext
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }
}



struct AppUtility {
    // This method will force you to use base on how you configure.
    static func lockOrientation(_ orientation: UIInterfaceOrientationMask) {
        
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            delegate.orientationLock = orientation
        }
    }
    
    // This method done pretty well where we can use this for best user experience.
    static func lockOrientation(_ orientation: UIInterfaceOrientationMask, andRotateTo rotateOrientation:UIInterfaceOrientation) {
        
        self.lockOrientation(orientation)
        
        UIDevice.current.setValue(rotateOrientation.rawValue, forKey: "orientation")
    }
}
