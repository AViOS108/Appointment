//
//  LogoutHandler.swift
//  Resume
//
//  Created by Varun Wadhwa on 04/04/19.
//  Copyright © 2019 VM User. All rights reserved.
//

import Foundation
import SwiftyDropbox
import GoogleSignIn

class LogoutHandler {
    //check this
    static var activityIndicatorView: ActivityIndicatorView?
    
    static func shouldLogout(errorCode : Int) -> Bool {
        if errorCode == 401{
            return true
        }
        return false
    }
    
    static func invalidateCurrentUser(){
        var message = StringConstants.sessionExpiredApiLoader
        if let email = UserDefaultsDataSource(key: "userEmail").readData(){
            message = "\(StringConstants.sessionExpiredApiLoader) from \(email)"
        }
        logoutWithMessage(message)
    }
    
    static func logout(removeEmail: Bool){
        var message = StringConstants.logoutApiLoader
        if let email = UserDefaultsDataSource(key: "userEmail").readData(){
            message = "\(StringConstants.logoutApiLoader) from \(email)"
        }
        if removeEmail {
            UserDefaultsDataSource(key: "userEmail").removeData()
        }
        logoutWithMessage(message)
    }
    
    static private func logoutWithMessage(_ message : String) {
        AppDataSync.shared.stopTimer()
        Network.cancelAllRequests()
        AppUtility.lockOrientation(.portrait)
        
        if #available(iOS 13.0, *)
        {
            let mySceneDelegate  = UIApplication.shared.connectedScenes.first
            if let sd : SceneDelegate = (mySceneDelegate?.delegate as? SceneDelegate) {
                activityIndicatorView = ActivityIndicatorView.showActivity(view: sd.window!, message: message)
            }
        }
        else
        {
            if let delegate = UIApplication.shared.delegate as? AppDelegate{
                activityIndicatorView = ActivityIndicatorView.showActivity(view: delegate.window!, message: message)
            }
        }
        
        FileSystemDataSource().clearAllData()
        
        LocalNotificationUtility.cancelAllNotifications()
        
        if DropboxClientsManager.authorizedClient != nil{
            DropboxClientsManager.unlinkClients()
        }
        
        if let googleClient = GIDSignIn.sharedInstance(){
            googleClient.disconnect()
        }
        UserDefaultsHelper.clearAllDefaultsExceptEmail()
        let delayInSeconds = 1.0
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delayInSeconds) {
            let cookieStorage = HTTPCookieStorage.shared
            for each: HTTPCookie in cookieStorage.cookies! {
                cookieStorage.deleteCookie(each)
            }
            
            ManageSingleton.destroyCustomSingleton()
            self.activityIndicatorView?.hide()
            NotificationCenter.default.post(name: Notification.Name("logout"), object: nil)
            self.activityIndicatorView?.hide()
        }
//        AppShortcuts.removeAll()
        KeyChainWrapper(key: "").clear()
    }

}
