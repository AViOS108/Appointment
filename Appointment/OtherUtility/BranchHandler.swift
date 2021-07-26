//
//  BranchHandler.swift
//  Resume
//
//  Created by Gaurav Gupta on 02/11/17.
//  Copyright © 2017 VM User. All rights reserved.
//

import UIKit

class BranchHandler: NSObject {

    static var instance : BranchHandler = BranchHandler()
    
    class func sharedInstance() -> BranchHandler{
        return instance
    }
    
    func handleParams(_ params : [String:Any] )  {
        
        if let feature = params["~feature"] as? String, feature == "referral" {
            if let link = params["$desktop_url"] as? String, let url = URL(string: link) {
                UserDefaultsDataSource(key: "link").writeData("default")
                DeepLinkingHandler.sharedInstance().handleReferralUrl(url)
                return
            }
        }
        
        if let link = params["~referring_link"] as? String, let url = URL(string: link) {
            DeepLinkingHandler.sharedInstance().handleUrl(url)
        }
        else if let link = params["+non_branch_link"] as? String, let url = URL(string: link) {
            DeepLinkingHandler.sharedInstance().handleUrl(url)
        }else if let link = params["+url"] as? String, let url = URL(string: link) {
            DeepLinkingHandler.sharedInstance().handleUrl(url)
        }
    }
    
}
