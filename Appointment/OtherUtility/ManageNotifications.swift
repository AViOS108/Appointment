//
//  ManageNotifications.swift
//  Resume
//
//  Created by Gaurav Gupta on 08/09/17.
//  Copyright © 2017 VM User. All rights reserved.
//

import UIKit

class ManageNotifications: NSObject {
    
    var managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
    
    func saveContext(){
        do {
            try managedObjectContext.save()
        } catch let error as NSError {
            debugPrint("Could not save \(error), \(error.userInfo)")
        }
    }
    
    static var instance : ManageNotifications = ManageNotifications()
    
    var reminderQueue = [UILocalNotification]()
    var isShowingAlert = false
    
    class func sharedInstance() -> ManageNotifications
    {
        return instance
    }
    
    func handleLocalNotification(_ notification : UILocalNotification) -> Bool {
        
        if let category = notification.category {
            switch category {
            case LocalNotificationUtilityCategory.noteReminder.rawValue:
                return handleNoteReminderNotification(notification)
            default : break
            }
        }
        return false
    }
    
    private func handleNoteReminderNotification(_ notification : UILocalNotification) -> Bool {
        print(UIApplication.shared.applicationState.rawValue)
        guard UserDefaults.standard.bool(forKey: "loggedIn"), !UserDefaults.standard.bool(forKey: "areDetailsRequired") else {
            return false
        }
        guard let objectId = notification.objectId else {
            return false
        }
//        guard let note = NoteServices().getNoteForUid(objectId, orId: nil, inContext: managedObjectContext) else {
//            NSLog("YabaHandle 1")
//            return false
//        }
        
//        NoteReminder().deletePastReminderForNote(note, save: true)
        
//        if let appDelegate = UIApplication.shared.delegate as? AppDelegate, let root = appDelegate.window?.rootViewController as? DashboardTabBarViewController {
//            NSLog("YabaHandle 2")
//
//            let openNoteVC = {
//                let noteVC = UIStoryboard.createNote()
//                noteVC.note = note
//                if root.presentedViewController == nil {
//                    root.present(UINavigationController(rootViewController: noteVC), animated: true, completion: nil)
//                }else{
//                    root.dismiss(animated: false, completion: {
//                        root.present(UINavigationController(rootViewController: noteVC), animated: true, completion: nil)
//                    })
//                }
//            }
//
//            let alert = ReminderAlertController(title: "Reminder", message: notification.alertBody, preferredStyle: .alert)
//            let viewNoteAction = UIAlertAction(title: "View note", style: .default, handler: { (_) in
//                self.hideTutorials()
//                openNoteVC()
//                self.isShowingAlert = false
//                UIAlertController.makeAppWindowVisible()
//                self.handleQueuedNotifications()
//            })
//            let dismissAction = UIAlertAction(title: "Dismiss", style: .cancel, handler: { (_) in
//                self.isShowingAlert = false
//                UIAlertController.makeAppWindowVisible()
//                self.handleQueuedNotifications()
//            })
//            let dash = root
//            if let nav = dash.selectedViewController as? UINavigationController, nav.viewControllers.count == 2, let vc = nav.viewControllers[1] as? CreateNoteViewController, let vcNote = vc.note, vcNote == note {
//                vc.handleNotification()
//                if UIApplication.shared.applicationState != .active, (UIApplication.shared.delegate as! AppDelegate).willBecomeActive {
//                    return true
//                }
//            }
//            else {
//                if UIApplication.shared.applicationState != .active, (UIApplication.shared.delegate as! AppDelegate).willBecomeActive {
//                    hideTutorials()
//                    openNoteVC()
//                    UIAlertController.makeAppWindowVisible()
//                    return true
//                }
//                alert.addAction(viewNoteAction)
//            }
//            alert.addAction(dismissAction)
//            if isShowingAlert {
//                reminderQueue.append(notification)
//            }
//            else {
//                presentNotificationAlert(alert)
//            }
//
//        }
//        else {
//            // No Root
//
//            NSLog("YabaHandle 3")
//            let noteVC = UIStoryboard.createNote()
//            noteVC.note = note
//            (UIApplication.shared.delegate as? AppDelegate)?.changeRootVC(UINavigationController(rootViewController: noteVC))
//            return true
//        }
        return true
    }
    
    func presentNotificationAlert(_ alert : UIAlertController) {
        alert.presentOnAlertWindow(animated: true)
        isShowingAlert = true
    }
    
    func handleQueuedNotifications() {
        guard reminderQueue.count > 0 else {
            return
        }
        let notification = reminderQueue[0]
        reminderQueue.remove(at: 0)
        
//        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate, let root = appDelegate.window?.rootViewController as? DashboardTabBarViewController else {
//            return
//        }
//        guard let objectId = notification.objectId, let note = NoteServices().getNoteForUid(objectId, orId: nil, inContext: managedObjectContext) else {
//            handleQueuedNotifications()
//            return
//        }
        
//        let openNoteVC = {
//            let noteVC = UIStoryboard.createNote()
//            noteVC.note = note
//            if root.presentedViewController == nil {
//                root.present(UINavigationController(rootViewController: noteVC), animated: true, completion: nil)
//            }else{
//                root.dismiss(animated: false, completion: {
//                    root.present(UINavigationController(rootViewController: noteVC), animated: true, completion: nil)
//                })
//            }
//        }
        
        let alert = ReminderAlertController(title: "Reminder", message: notification.alertBody, preferredStyle: .alert)
        let viewNoteAction = UIAlertAction(title: "View note", style: .default, handler: { (_) in
            self.hideTutorials()
//            openNoteVC()
            self.isShowingAlert = false
            UIAlertController.makeAppWindowVisible()
            self.handleQueuedNotifications()
        })
        let dismissAction = UIAlertAction(title: "Dismiss", style: .cancel, handler: { (_) in
            self.isShowingAlert = false
            UIAlertController.makeAppWindowVisible()
            self.handleQueuedNotifications()
        })
        alert.addAction(viewNoteAction)
        alert.addAction(dismissAction)
        presentNotificationAlert(alert)
    }
    
    func hideTutorials() {
//        HomeTutorial.sharedInstance().dismiss()
//        BulletFeedbackTutorial.sharedInstance().dismiss()
//        SystemFeedbackTutorial.sharedInstance().dismiss()
    }
    
}


class ReminderAlertController: UIAlertController {
    
}
