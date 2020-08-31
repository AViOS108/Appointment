//
//  LoginParentViewController.swift
//  Resume
//
//  Created by Manu Gupta on 02/11/17.
//  Copyright © 2017 VM User. All rights reserved.
//

import UIKit

class LoginParentViewController: CustomizedViewController {

    var activityIndicator: ActivityIndicatorView?
    var errorView: ErrorView?
    var captchaRequired : Bool = false
    var captchaId : String?
    var captchaToken : String?
    var captchaImageURL : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()        
    }
    
    func loginCall(params: Dictionary<String,AnyObject>,headerIncluded: Bool,header: Dictionary<String,String>){
        activityIndicator = ActivityIndicatorView.showActivity(view: self.navigationController!.view, message: StringConstants.loginApiLoader)
        LoginService().loginCall(headerIncluded: headerIncluded,params: params as Dictionary<String, AnyObject>,header: header, { response in
            GoogleAnalyticsUtility().logEvent(GoogleAnalyticsEvent(category: "Login & Register", action: "Email Response", label: "Email Success"))
            self.activityIndicator?.hide()
            self.getUserinfo()
        }, failure: { loginError in
            let errCode = loginError.errorCode
            let errMsg = loginError.errorMessage
            if let status = loginError.captchaRequired {
                self.captchaRequired = status
            }
            self.errorHandler(error: errMsg, errorCode: errCode, params: params, headerIncluded: headerIncluded, header: header)
        })
    }
    
    func getUserinfo(){
        activityIndicator = ActivityIndicatorView.showActivity(view:  self.navigationController!.view, message: StringConstants.userInfoApiLoader)
        LoginService().getUserInfo({ infoResponse in
            self.activityIndicator?.hide()
            self.activityIndicator = ActivityIndicatorView.showActivity(view: self.navigationController!.view, message: StringConstants.communityInfoApiLoader)
            self.getCustomization()
        }, failure: {(error,errorCode) in
            self.activityIndicator?.hide()
            if ErrorView.canShowForErrorCode(errorCode){
                self.errorView = ErrorView.showOnView(self.view, forErrorOn: nil, errorCode: errorCode, completion: {
                    self.getUserinfo()
                })
            }else{
                CommonFunctions().showError(title: "Error", message: error)
            }
        })
    }
    
    func getCustomization(){
        LoginService().getCustomizations({ response in
            self.activityIndicator?.hide()
            if let mobileEnabled = response["mobile_is_resume_enabled"].int, mobileEnabled == 1{
                UserDefaultsDataSource(key: "loggedIn").writeData(true)
                AppDataSync.shared.beginTimer()
                (UIApplication.shared.delegate as? AppDelegate)?.checkLoginState()
            }else{
                let cookieStorage = HTTPCookieStorage.shared
                for each: HTTPCookie in cookieStorage.cookies! {
                    cookieStorage.deleteCookie(each)
                }
                self.navigationController?.pushViewController(UIStoryboard.resumeNotEnabled(), animated: true)
            }
        }, failure: {(error,errorCode) in
            self.activityIndicator?.hide()
            if ErrorView.canShowForErrorCode(errorCode){
                self.errorView = ErrorView.showOnView(self.view, forErrorOn: nil, errorCode: errorCode, completion: {
                    self.getUserinfo()
                })
            }else{
                CommonFunctions().showError(title: "Error", message: error)
            }
        })
    }
    
    func errorHandler(error: String,errorCode: Int, params: Dictionary<String,AnyObject>,headerIncluded: Bool,header: Dictionary<String,String>){
        self.activityIndicator?.hide()
        CommonFunctions().showError(title: "Error", message: error)
    }
    
    func getNewCaptcha(success : @escaping ()->() , failure : @escaping ()->() ) {
        CheckLoginStatusService().getNewCaptch({ response in
            self.captchaId = String(response["id"].int!)
            self.captchaToken = response["token"].string!
            self.captchaImageURL = response["image"].string!
            success()
        }, failure: { (error,errorCode) in
            CommonFunctions().showError(title: "Error", message: error)
            failure()
        })
    }
    
}

class CustomUITextField: UITextField {
    override public func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(copy(_:)) || action == #selector(paste(_:)) || action == #selector(cut(_:)) {
            return false
        }
        return super.canPerformAction(action, withSender: sender)
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
           return CGRect(x: bounds.origin.x + 10, y: bounds.origin.y, width: bounds.width, height: bounds.height)
       }

       override func editingRect(forBounds bounds: CGRect) -> CGRect {
           return CGRect(x: bounds.origin.x + 10, y: bounds.origin.y, width: bounds.width, height: bounds.height)
       }

       override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
           return CGRect(x: bounds.origin.x + 10, y: bounds.origin.y, width: bounds.width, height: bounds.height)
       }
    
    
}
