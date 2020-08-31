//
//  AppSyncData.swift
//  Resume
//
//  Created by Gaurav Gupta on 19/03/19.
//  Copyright © 2019 VM User. All rights reserved.
//

import Foundation


class AppDataSync {
    
    static let shared: AppDataSync = AppDataSync()
    
    var timer: Timer?
    
    private init() {
        
    }
    
    func beginTimer() {
        guard UserDefaults.standard.bool(forKey: "loggedIn")  else {return}
        guard let _ = timer else {
            let temp = Timer(fireAt: Date(), interval: TimeInterval(60*2), target: self, selector: #selector(sync), userInfo: nil, repeats: true)
            RunLoop.current.add(temp, forMode: .default)
            timer = temp
            return
        }
        stopTimer()
        beginTimer()
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    @objc func sync() {
        
        let isStudent = UserDefaultsDataSource(key: "student").readData() as? Bool

        
        if isStudent ?? true
        {
            LoginService().sync({ (_) in
                
            }) { (_, _) in
                
            }
        }
        else
        {
//            ErEventService().extendErLogin({ (_) in
//
//        }) { (_, _) in
//
//            }
            
            
          
            
        }

        
        
        
        
    }
    
}
