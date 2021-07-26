//
//  GoogleAnalyticsUtility.swift
//  Resume
//
//  Created by apple on 28/04/17.
//  Copyright © 2017 VM User. All rights reserved.
//

import UIKit
import GoogleSignIn

struct GoogleAnalyticsEvent {
    let category : String?
    let action : String?
    let label : String?
    
    init(category : String?, action : String?, label : String? ) {
        self.category = category
        self.action = action
        self.label = label
    }
}

class GoogleAnalyticsUtility: NSObject {

    func startScreenTrackingForScreenName(_ screen : String){
//        let tracker = GAI.sharedInstance().defaultTracker
//        tracker?.set(kGAIScreenName, value: screen)
//        if let userId = UserDefaults.standard.object(forKey: "userId") as? Int {
//            tracker?.set(kGAIUserId, value: String(userId))
//            tracker?.set(GAIFields.customDimension(for: 3), value: String(userId))
//        }else{
//            tracker?.set(kGAIUserId, value: nil)
//            tracker?.set(GAIFields.customDimension(for: 3), value: "No User Id")
//        }
//        guard let community = UserDefaults.standard.object(forKey: "communityName") as? String else {
//            tracker?.set(GAIFields.customDimension(for: 1), value: "No Community")
//            tracker?.send(GAIDictionaryBuilder.createScreenView().build() as! [AnyHashable : Any]!)
//            return
//        }
//        tracker?.set(GAIFields.customDimension(for: 1), value: community)
//
//        guard let benchmark = UserDefaults.standard.object(forKey: "benchmark") as? String else {
//            tracker?.set(GAIFields.customDimension(for: 2), value: "No Benchmark")
//            tracker?.send(GAIDictionaryBuilder.createScreenView().build() as! [AnyHashable : Any]!)
//            return
//        }
//        tracker?.set(GAIFields.customDimension(for: 2), value: benchmark)
//        tracker?.send(GAIDictionaryBuilder.createScreenView().build() as! [AnyHashable : Any]!)
    }
    
    func logEvent(_ event : GoogleAnalyticsEvent){
//        guard let tracker = GAI.sharedInstance().defaultTracker else { return }
//        if let userId = UserDefaults.standard.object(forKey: "userId") as? Int {
//            tracker.set(kGAIUserId, value: String(userId))
//            tracker.set(GAIFields.customDimension(for: 3), value: String(userId))
//        }else{
//            tracker.set(kGAIUserId, value: nil)
//            tracker.set(GAIFields.customDimension(for: 3), value: "No User Id")
//        }
//        guard let community = UserDefaults.standard.object(forKey: "communityName") as? String else {
//            tracker.set(GAIFields.customDimension(for: 1), value: "No Community")
//            tracker.send(GAIDictionaryBuilder.createScreenView().build() as! [AnyHashable : Any]!)
//            return
//        }
//        tracker.set(GAIFields.customDimension(for: 1), value: community)
//
//        guard let benchmark = UserDefaults.standard.object(forKey: "benchmark") as? String else {
//            tracker.set(GAIFields.customDimension(for: 2), value: "No Benchmark")
//            tracker.send(GAIDictionaryBuilder.createScreenView().build() as! [AnyHashable : Any]!)
//            return
//        }
//        tracker.set(GAIFields.customDimension(for: 2), value: benchmark)
//
//        var dict  = [String : String]()
//
//        if let category = event.category{
//            dict["category"] = category
//        }
//        if let action = event.action{
//            dict["action"] = action
//        }
//        if let label = event.label{
//            dict["label"] = label
//        }
//
//        let build = GAIDictionaryBuilder.createEvent(withCategory: dict["category"] as String!, action: dict["action"], label: dict["label"], value: nil).build() as [NSObject : AnyObject]
//
//        tracker.send(build)
   }
}
