//
//  SubscriptionType.swift
//  Resume
//
//  Created by Varun Wadhwa on 30/10/18.
//  Copyright © 2018 VM User. All rights reserved.
//

enum SubscriptionType {
    case premium
    case freemium
}

extension SubscriptionType {
    static let isPremiumKey = "isPremium"
    
    static func get() -> SubscriptionType {
        let isPremium = (UserDefaultsDataSource(key: isPremiumKey).readData() as? Bool) ?? false
        return isPremium ? .premium : .freemium
    }
    
    static func set(value : Bool?) {
        UserDefaultsDataSource(key: isPremiumKey).writeData(value)
    }
}

