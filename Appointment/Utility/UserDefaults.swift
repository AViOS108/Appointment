//
//  UserDefaults.swift
//  Resume
//
//  Created by Varun Wadhwa on 27/03/19.
//  Copyright © 2019 VM User. All rights reserved.
//

import Foundation

protocol DataSource {
    func readData() -> Any?
    func writeData(_ data : Any?)
    func removeData()
    func clearAllData()
}

class UserDefaultsHelper {
    static func clearAllDefaultsExceptEmail(){
        let tempLink = UserDefaultsDataSource(key: "link").readData()
        let tempRefCode = UserDefaultsDataSource(key: "referralCode").readData()
        var tempEmail = UserDefaultsDataSource(key: "userEmail").readData()
        if let newEmail = UserDefaultsDataSource(key: "newUserEmail").readData() {
            tempEmail = newEmail
        }
        UserDefaultsDataSource(key: "").clearAllData()
        UserDefaultsDataSource(key: "link").writeData(tempLink)
        UserDefaultsDataSource(key: "userEmail").writeData(tempEmail)
        UserDefaultsDataSource(key: "referralCode").writeData(tempRefCode)
    }
}

class UserDefaultsDataSource : DataSource {
    private let key : String
    private let standardUserDefaults = UserDefaults.standard
    
    init(key : String) {
        self.key = key
    }
    
    func readData() -> Any? {
        return standardUserDefaults.object(forKey: key)
    }
    
    func writeData(_ data: Any?) {
        standardUserDefaults.set(data, forKey: key)
      // standardUserDefaults.synchronize()
    }
    
    func removeData() {
        standardUserDefaults.removeObject(forKey: key)
      //  standardUserDefaults.synchronize()
    }
    
    func clearAllData() {
        standardUserDefaults.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        standardUserDefaults.synchronize()
    }
}

class DataSourceDecorator: DataSource {
    
    let wrappee: DataSource
    
    init(wrappee: DataSource) {
        self.wrappee = wrappee
    }
    
    func writeData(_ data: Any?) {
        wrappee.writeData(data)
    }
    
    func readData() -> Any? {
        return wrappee.readData()
    }
    
    func clearAllData() {
        wrappee.clearAllData()
    }
    
    func removeData() {
        wrappee.removeData()
    }
}
