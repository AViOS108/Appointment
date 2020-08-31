//
//  LocalNotificationUtility.swift
//  Resume
//
//  Created by Gaurav Gupta on 05/09/17.
//  Copyright © 2017 VM User. All rights reserved.
//

import UIKit

enum LocalNotificationUtilityCategory : String {
    case noteReminder = "noteReminder"
}

class LocalNotificationUtility: NSObject {
    
    
    class func setupNotificationSettings() {
        if UIApplication.shared.currentUserNotificationSettings != nil{
            // Specify the notification actions.
            let markAsDone = UIMutableUserNotificationAction()
            markAsDone.identifier = "done"
            markAsDone.title = "Mark as done"
            markAsDone.activationMode = UIUserNotificationActivationMode.background
            markAsDone.isDestructive = false
            markAsDone.isAuthenticationRequired = false

            
            // Specify the category related to the above actions.
            let noteReminderCategory = UIMutableUserNotificationCategory()
            noteReminderCategory.identifier = LocalNotificationUtilityCategory.noteReminder.rawValue
            
            let categoriesForSettings = Set(arrayLiteral: noteReminderCategory)
            
            // Register the notification settings.
            let newNotificationSettings = UIUserNotificationSettings(types: [.alert,.sound], categories: categoriesForSettings)
            UIApplication.shared.registerUserNotificationSettings(newNotificationSettings)
        }
    }
    
    class func scheduleLocalNotification(body : String?, category : LocalNotificationUtilityCategory, date : Date, objectId : String? ) -> UILocalNotification  {
        setupNotificationSettings()
        let localNotification = UILocalNotification()
        switch category {
        case .noteReminder:
            localNotification.objectId = objectId
            localNotification.category = category.rawValue
        }
        localNotification.configure()
        localNotification.fireDate = date.fixNotificationDate()
        localNotification.alertBody = body
        UIApplication.shared.scheduleLocalNotification(localNotification)
        return localNotification
    }
    
    class func cancelLocalNotificationForIdentifier(_ identifier : String) {
        if let notification = getLocalNotificationForIdentifier(identifier) {
            UIApplication.shared.cancelLocalNotification(notification)
        }
    }
    
    class func getLocalNotificationForIdentifier(_ identifier : String) -> UILocalNotification? {
        if let localNotifications = UIApplication.shared.scheduledLocalNotifications {
            for notification in localNotifications {
                if let temp = notification.identifier, temp == identifier {
                    return notification
                }
            }
        }
        return nil
    }
    
    class func cancelAllNotifications() {
        if let localNotifications = UIApplication.shared.scheduledLocalNotifications {
            for notification in localNotifications {
                UIApplication.shared.cancelLocalNotification(notification)
            }
        }
    }
    
}

extension UILocalNotification {
    var objectId : String? {
        set {
            if let newValue = newValue {
                if var userInfo = userInfo {
                    userInfo["objectId"] = newValue
                    self.userInfo = userInfo
                } else {
                    userInfo = ["objectId" : newValue]
                }
            } else {
                if var userInfo = userInfo {
                    userInfo["objectId"] = nil
                }
            }
        }
        get {
            if let userInfo = userInfo, let temp = userInfo["objectId"] as? String {
                return temp
            }else {
                return nil
            }
        }
    }
    
    
    var identifier : String? {
        set {
            if let newValue = newValue {
                if var userInfo = userInfo {
                    userInfo["localIdentifier"] = newValue
                    self.userInfo = userInfo
                } else {
                    userInfo = ["localIdentifier" : newValue]
                }
            } else {
                if var userInfo = userInfo {
                    userInfo["localIdentifier"] = nil
                }
            }
        }
        get {
            if let userInfo = userInfo, let temp = userInfo["localIdentifier"] as? String {
                return temp
            } else {
                return nil
            }
        }
    }
    
    func configure() {
        identifier = NSUUID().uuidString
    }
    
    
    
}
