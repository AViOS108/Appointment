//
//  KeyChainWrapper.swift
//  Resume
//
//  Created by Varun Wadhwa on 08/04/19.
//  Copyright © 2019 VM User. All rights reserved.
//

import Foundation
import KeychainSwift

class KeyChainWrapper {
    private let key : String
    private let defaultKeyChain = KeychainSwift()
    
    init(key : String) {
        self.key = key
    }
    
    func set(value : String) {
        defaultKeyChain.set(value, forKey: key)
    }
    
    func set(value : Bool) {
        defaultKeyChain.set(value, forKey: key)
    }
    
    func getString() -> String? {
        return defaultKeyChain.get(key)
    }
    
    func getBool() -> Bool? {
        return defaultKeyChain.getBool(key)
    }
    
    func delete() {
        defaultKeyChain.delete(key)
    }
    
    func clear() {
        defaultKeyChain.clear()
    }
    
}

