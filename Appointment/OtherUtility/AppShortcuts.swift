////
////  AppShortcuts.swift
////  Resume
////
////  Created by Varun Wadhwa on 10/12/18.
////  Copyright © 2018 VM User. All rights reserved.
////
//
//import Foundation
//
//enum Shortcut : String , CaseIterable {
//    case uploadResume = "Upload Resume"
//    case networkFeedback = "Ask for Feedback"
//    
//    init?(fullNameForType: String) {
//        guard let last = fullNameForType.components(separatedBy: ".").last else { return nil }
//        self.init(rawValue: last)
//    }
//    var type: String {
//        return Bundle.main.bundleIdentifier! + ".\(self.rawValue)"
//    }
//}
//
//class AppShortcuts {
//    
//    static func configure() {
//        let item = shortcutItem(shortcutType: Shortcut.uploadResume , subTitle: "", icon: .add)
//        let item2 = shortcutItem(shortcutType: Shortcut.networkFeedback , subTitle: "", icon: .contact)
//        UIApplication.shared.shortcutItems = [item, item2]
//    }
//    
//    static func removeAll() {
//         UIApplication.shared.shortcutItems = []
//    }
//}
//
//extension AppShortcuts {
//    
//    fileprivate static func shortcutItem( shortcutType : Shortcut , subTitle : String , icon : UIApplicationShortcutIcon.IconType) -> UIApplicationShortcutItem {
//        let type = Bundle.main.bundleIdentifier! + ".\(shortcutType.rawValue)"
//        return UIApplicationShortcutItem(type: type, localizedTitle: shortcutType.rawValue, localizedSubtitle: subTitle , icon: UIApplicationShortcutIcon(type: icon), userInfo: nil)
//    }
//    
//    static func handle(item: UIApplicationShortcutItem) -> Bool {
//        guard Shortcut(fullNameForType: item.type) != nil else {return false}
//        guard let shortCutType = item.type as String? else {return false}
//        switch shortCutType {
//            case Shortcut.uploadResume.type:
//                guard let homeVC = Redirections.toHomeScreen() else { return false }
//                homeVC.uploadAction = true
//               return true
//            case Shortcut.networkFeedback.type:
//               guard let nfVC = Redirections.toNetworkFeedback() else { return false }
//               return true
//            default :
//               print("no option")
//        }
//        return false
//    }
//}
//
