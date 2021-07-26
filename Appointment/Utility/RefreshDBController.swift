//
//  RefreshDBController.swift
//  Resume
//
//  Created by Varun Wadhwa on 05/03/19.
//  Copyright © 2019 VM User. All rights reserved.
//

import Foundation

protocol AppVersionStoreProtocol {
    func getLastAppVersion() -> String?
    func saveCurrentVersion()
    func getCurrentVersion() -> String?
}

class AppVersionStore : AppVersionStoreProtocol {
    private let appLastVersionKey = "appLastVersion"
    func getLastAppVersion() -> String? {
        return UserDefaults.standard.value(forKey: appLastVersionKey) as? String
    }
    func saveCurrentVersion() {
        UserDefaults.standard.set(getCurrentVersion(), forKey: appLastVersionKey)
    }
    func getCurrentVersion() -> String? {
        return CommonFunctions.getAppVersion()
    }
}

class RefreshDBController {
     // added for future changes
     var baseVersion = "1.1.8"
     var appVersionStore : AppVersionStoreProtocol?
    
     init(appVersionStore : AppVersionStoreProtocol? =  AppVersionStore()) {
        self.appVersionStore = appVersionStore
     }
    
     func needRefresh() -> Bool {
        //Either app is updated from 1.1.7(or below) or fresh install
        guard appVersionStore?.getLastAppVersion() == nil else {
            //no need to refresh update call refreshComplete()
            refreshComplete()
            return false
        }
        return true
     }
    
     func refreshComplete() {
        appVersionStore?.saveCurrentVersion()
     }
}

