//
//  DeepLinkingHandler.swift
//  Resume
//
//  Created by Gaurav Gupta on 18/08/17.
//  Copyright © 2017 VM User. All rights reserved.
//

import UIKit

class DeepLinkingHandler: NSObject {

    static var instance : DeepLinkingHandler = DeepLinkingHandler()
    
    class func sharedInstance() -> DeepLinkingHandler{
        return instance
    }
    
    var urlComponents : URLComponents?
    
    func handleUserActivity(_ userActivity : NSUserActivity ) -> Bool {
        
        guard userActivity.activityType == NSUserActivityTypeBrowsingWeb,
            let url = userActivity.webpageURL else {
                return false
        }
        return handleUrl(url)
    }
    
    func handleReferralUrl(_ url : URL) -> Bool {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            return false
        }
        if let code = components.path.components(separatedBy: "r/").last {
            UserDefaultsDataSource(key: "referralCode").writeData(code)
        }
        if CommonFunctions.checkIfAlreadyLogin() {
            openPostDeeplinkoptionsVC(option: .referral)
        }
        else {
            UserDefaultsDataSource(key: "link").writeData("default")
            (UIApplication.shared.delegate as? AppDelegate)?.checkLoginState()
        }
        
        return true
    }
    
    func handleUrl(_ url : URL) -> Bool {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            return false
        }
        
        urlComponents = components
        if components.path.contains("appstore")||components.path.contains("playstore"){
            return true
        }else if components.path.contains("password/reset"){
            openResetPasswordVC()
            return true
        }
        else if components.path.contains("email/verify") {            
            openVerifyVC()
            return true
        }else{
            let localUrl = components.path.components(separatedBy: "/")
            if localUrl.count > 1{
                let link = localUrl[1]
                if CommonFunctions.checkIfAlreadyLogin() {
                    let vc = PostDeeplinkingOptionsViewController()
                    vc.option = PostDeeplinkingOptions.community
                    vc.info["link"] = link
                    vc.info["url"] = url
                    changeRootVC(vc)
                }
                else {
                    let vc = LoginNavigationViewController.getLoginNavigationViewController(link: link)
                    self.changeRootVC(vc)
                }
            }else{
                (UIApplication.shared.delegate as? AppDelegate)?.checkLoginState()
            }
            
            return true
        }
        
        let webpageUrl = URL(string: "https://www.amazon.com/")!
        UIApplication.shared.openURL(webpageUrl)
        urlComponents = nil
        return false
    }
    
    func openPostDeeplinkoptionsVC(option : PostDeeplinkingOptions){
        let vc = PostDeeplinkingOptionsViewController()
        vc.option = option
        
        changeRootVC(vc)
    }
    
    
    func openVerifyVC(){
        guard let urlComponents = urlComponents else {
            return
        }
        let vc = UIStoryboard.verifyUser()
        CommonFunctions().changeLinkLocalToGlobal()
        var temp = urlComponents.path.components(separatedBy: "verify/")
        if temp.count >= 2 {
            temp = temp[1].components(separatedBy: "/")
            if temp.count >= 2 {
                vc.verificationId = temp[0]
                vc.verificationCode = temp[1]
                changeRootVC(vc)
            }
        }
        changeRootVC(vc)
    }
    
    func openResetPasswordVC(){
        guard let urlComponents = urlComponents else {
            return
        }
        let vc = UIStoryboard.resetPassword()
        var temp = urlComponents.path.components(separatedBy: "reset/")
        if temp.count >= 2 {
            temp = temp[1].components(separatedBy: "/")
            if temp.count >= 2 {
                vc.passwordResetId = temp[0]
                vc.passwordResetToken = temp[1]
                changeRootVC(vc)
            }
        }
    }
    
    func changeRootVC(_ controller : UIViewController) {
        (UIApplication.shared.delegate as? AppDelegate)?.changeRootVC(controller)
    }
}
