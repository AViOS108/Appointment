//
//  SocialLoginViewController.swift
//  Resume
//
//  Created by Manu Gupta on 01/11/17.
//  Copyright © 2017 VM User. All rights reserved.
//

import UIKit
import SwiftyJSON
import WebKit
import AuthenticationServices

class SocialLoginViewController: LoginParentViewController {
    
    @IBOutlet weak var webView: WKWebView!
    
    // Social Login
    var url: URL?
    var provider: String = ""
    var link: String = ""
    var redirectUri: String = ""
    var state: String = ""
    var code: String?

    // Required Fields
    var nameRequired = false
    var emailRequired = false
    var passwordRequired = false
    
    // Hide Status bar
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        webView.delegate = self
        //        webView.loadRequest()
        
        
        let dataStore = WKWebsiteDataStore.default()
               dataStore.fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { (records) in
                   for record in records {
                           dataStore.removeData(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes(), for: [record], completionHandler: {
                               print("Deleted: " + record.displayName);
                           })
                       
                   }
               }
               
               
               let cookieStorage = HTTPCookieStorage.shared
               for each: HTTPCookie in cookieStorage.cookies! {
                   cookieStorage.deleteCookie(each)
               }
        
        
        if self.code != nil
        {
           if #available(iOS 13.0, *) {
                        self.handleAppleIdRequest()
            activityIndicator = ActivityIndicatorView.showActivity(view:view, message: "Redirecting")
                       } else {
                           // Fallback on earlier versions
                       }
            
        }
        else
        {
            activityIndicator = ActivityIndicatorView.showActivity(view:view, message: "Redirecting")
            let request = NSURLRequest(url: url!) as URLRequest
            webView.navigationDelegate = self

            webView.load(request)
        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        
        if self.code != nil
        {
            
            GoogleAnalyticsUtility().startScreenTrackingForScreenName("Login & Register: Apple SignIn")
           
        }
        else
        {
            if provider == "facebook"{
                       GoogleAnalyticsUtility().startScreenTrackingForScreenName("Login & Register: Facebook Webview")
                   }else if provider == "linkedin"{
                       GoogleAnalyticsUtility().startScreenTrackingForScreenName("Login & Register: LinkedIn Webview")
                   }else{
                       GoogleAnalyticsUtility().startScreenTrackingForScreenName("Login & Register: SSO Webview")
                   }
        }
        
       
        
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
       
    }
    
    func replaceControllerInStack(_ vc: UIViewController){
        if var vcs = navigationController?.viewControllers {
            let count = vcs.count
            vcs[count - 1] = vc
            self.navigationController?.setViewControllers(vcs, animated: true)
        }
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    override func errorHandler(error: String, errorCode: Int, params: Dictionary<String, AnyObject>, headerIncluded: Bool, header: Dictionary<String, String>) {
        super.errorHandler(error: error, errorCode: errorCode, params: params, headerIncluded: headerIncluded, header: header)
        if ErrorView.canShowForErrorCode(errorCode){
            self.errorView = ErrorView.showOnView(self.view, forErrorOn: nil, errorCode: errorCode, completion: {
                self.loginCall(params: params, headerIncluded: headerIncluded, header: header)
            })
        }else{
            CommonFunctions().showError(title: "Error", message: error)
        }
    }

    
}

extension SocialLoginViewController: WKNavigationDelegate {
    
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        var action: WKNavigationActionPolicy?
        
       
        self.webView.isHidden = false
        
        guard let url = navigationAction.request.url else {
            decisionHandler(.cancel)
        return }
        print("decidePolicyFor - url: \(url)")
        
        if url.host == Urls.runningHost {
            if (url.absoluteString.range(of: "error_reason") != nil){
                let urlParts = url.absoluteString.components(separatedBy: "?")
                let error = urlParts[1].components(separatedBy: "&")[3]
                _ = error.components(separatedBy: "=")[1]
                let cookieStorage = HTTPCookieStorage.shared
                for each: HTTPCookie in cookieStorage.cookies! {
                    cookieStorage.deleteCookie(each)
                }
                self.navigationController?.popToRootViewController(animated: true)
            }else if (url.absoluteString.range(of: "code") != nil){
                if let queryParams = URLComponents(url: url, resolvingAgainstBaseURL: true)?.queryItems, queryParams.count > 0 {
                    var code = ""
                    for item in queryParams where item.name == "code" {
                        if let temp = item.value {
                            code = temp
                            break
                        }
                    }
                    self.activityIndicator?.hide()
                    
                    let params = ["code": code,
                                  "provider": self.provider,
                                  "link": self.link,
                                  "state": self.state,
                                  "redirect_uri": self.redirectUri]
                    
                    self.webView.isHidden = true
                    self.checkEmailStatus(params: params as Dictionary<String, AnyObject>)
                }
            }
        }
        
        if (url.host == "www.vmock.com" )  {
                   print("redirect detected..")
                   decisionHandler(.cancel)
                   return
               }
        
       
        
        if (navigationAction.targetFrame?.isMainFrame ?? false) {
            
            if let activityIndicatorView = self.activityIndicator, activityIndicatorView.isShown {
                       
                   }
           else
            {
               activityIndicator = ActivityIndicatorView.showActivity(view:view, message: "Redirecting")
            }
            
        }
        
       
        decisionHandler(.allow)
    }
    
    func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
         self.activityIndicator?.hide()
    }
    
    
   
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.activityIndicator?.hide()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        activityIndicator?.hide()
        if error._code == -1009 || error._code == -1018 || error._code == -1001{
            self.navigationController?.popViewController(animated: true)
            let cookieStorage = HTTPCookieStorage.shared
            for each: HTTPCookie in cookieStorage.cookies! {
                cookieStorage.deleteCookie(each)
            }
            CommonFunctions().showError(title: "Error", message: error.localizedDescription)
        }
    }
    
    
    
}

extension SocialLoginViewController {
    
    func checkProviderApi(params: Dictionary<String,AnyObject>){
        var parameters = params
        activityIndicator = ActivityIndicatorView.showActivity(view: self.navigationController!.view, message: "Loading Community")
        ProviderServcie().providerServcieCall(link: parameters["link"] as! String,{ response in
            if response["community"] != JSON.null{
                let communityDetails = response["community"]
                UserDefaultsDataSource(key: "communityLogoLocal").writeData(communityDetails["logo"].string)
                UserDefaultsDataSource(key: "communityNameLocal").writeData(communityDetails["communityName"].string)
                UserDefaultsDataSource(key: "communityLocal").writeData(communityDetails["community"].string)
                UserDefaultsDataSource(key: "linkLocal").writeData(communityDetails["community"].string)
                self.link = communityDetails["community"].string!
            }
            let emailAllowed = (UserDefaultsDataSource(key: "emailAllowed").readData() as? Bool) ?? false
            if !emailAllowed{
                let ssoLoginView = UIStoryboard.ssoLogin()
                ssoLoginView.nameRequired = false
                ssoLoginView.passwordRequired = false
                ssoLoginView.captchRequired = false
                self.activityIndicator?.hide()
                self.navigationController?.pushViewController(ssoLoginView, animated: true)
            }else{
                self.activityIndicator?.hide()
                let linkLocal = UserDefaultsDataSource(key: "linkLocal").readData()
                parameters["link"] = linkLocal as AnyObject
                self.checkEmailStatus(params: parameters)
            }
        }, failure: { (error,errorCode) in
            self.activityIndicator?.hide()
            if errorCode == 404{
                (UIApplication.shared.delegate as? AppDelegate)?.checkLoginState()
            }else{
                if ErrorView.canShowForErrorCode(errorCode){
                    self.errorView = ErrorView.showOnView(self.view, forErrorOn: nil, errorCode: errorCode, completion: {
                        self.checkProviderApi(params: parameters)
                    })
                }else{
                    CommonFunctions().showError(title: "Error", message: error)
                }
            }
        })
    }
    
    func checkEmailStatus(params: Dictionary<String,AnyObject>){
        var parameters = params
        activityIndicator = ActivityIndicatorView.showActivity(view: self.navigationController!.view, message: StringConstants.checkEmailStatusApiLoader)
        let header = ["Cookie":"state=\(self.state)"]
        CheckLoginStatusService().checkLoginStatusCall(headerIncluded: true,params: params as Dictionary<String, AnyObject>,header: header, { response in
            GoogleAnalyticsUtility().logEvent(GoogleAnalyticsEvent(category: "Login & Register", action: "\(self.provider.capitalized) Response", label: "\(self.provider.capitalized) Success"))
            self.activityIndicator?.hide()
            if response["exists"].bool!{
                if response["isVerified"].bool! {
                    if response["isApproved"].bool! {
                        self.loginCall(params: params as Dictionary<String, AnyObject>,headerIncluded: true, header: header)
                    }else{
                        let approvalScreen = UIStoryboard.waitingApproval()
                        approvalScreen.message = "This email address has not been verified by the community admin. Please contact the community admin."
                        self.replaceControllerInStack(approvalScreen)
                    }
                }else{
                    let verificationPending = UIStoryboard.registerSuccess()
                    if let email = response["user"]["emailCommunity"].string{
                        verificationPending.email = email
                    }else{
                        if let email = response["user"]["email"].string{
                            verificationPending.email = email
                            UserDefaultsDataSource(key: "userEmail").writeData(email)
                        }
                    }
                    self.replaceControllerInStack(verificationPending)
                }
            }else{
                var name = ""
                if let firstName = response["user"]["firstName"].string{
                    name = firstName
                }
                
                if let lastName = response["user"]["lastName"].string{
                    if name == ""{
                        name = name + "\(lastName)"
                    }else{
                        name = name + " \(lastName)"
                    }
                }
                if response["required"].count > 0 {
                    self.captchaRequired = false
                    for index in 0 ... response["required"].count - 1{
                        if response["required"][index] == "captcha"{
                            self.captchaRequired = true
                        }else if response["required"][index] == "name"{
                            self.nameRequired = true
                        }else if response["required"][index] == "password"{
                            self.passwordRequired = true
                        }else if response["required"][index] == "email"{
                            self.emailRequired = true
                        }
                    }
                }
                
                if response["canRegister"].bool!{
                    var localLink = ""
                    
                    let selectCommunityVC = UIStoryboard.selectCommunity()
                    let registerVC = UIStoryboard.register()
                    
                    if response["canRegisterOn"] != JSON.null{
                        if response["user"]["community"] != JSON.null && response["user"]["community"].string != "default"{
                            localLink = response["user"]["community"].string!
                            registerVC.email = response["user"]["email"].string
                            registerVC.provider = self.provider
                            registerVC.name = name
                            registerVC.socialParams = params
                            registerVC.socialHeader = header
                            registerVC.link = localLink
                            registerVC.nameRequired = self.nameRequired
                            registerVC.passwordRequired = self.passwordRequired
                            registerVC.emailRequired = self.emailRequired
                            if localLink == self.link{
                                self.replaceControllerInStack(registerVC)
                            }else{
                                parameters["link"] = localLink as AnyObject
                                self.checkProviderApi(params: parameters)
                            }
                        }else{
                            localLink = response["canRegisterOn"]["community"].string!
                            selectCommunityVC.community = response["canRegisterOn"]["community"].string!
                            selectCommunityVC.email = response["user"]["email"].string
                            selectCommunityVC.provider = self.provider
                            selectCommunityVC.communityName = response["canRegisterOn"]["communityName"].string!
                            selectCommunityVC.socialParams = params
                            selectCommunityVC.socialHeader = header
                            selectCommunityVC.name = name
                            selectCommunityVC.passwordRequired = self.passwordRequired
                            selectCommunityVC.emailRequired = self.emailRequired
                            self.replaceControllerInStack(selectCommunityVC)
                        }
                    }else{
                        if response["user"]["community"] != JSON.null {
                            localLink = response["user"]["community"].string!
                        }
                        registerVC.email = response["user"]["email"].string
                        registerVC.provider = self.provider
                        registerVC.name = name
                        registerVC.socialParams = params
                        registerVC.socialHeader = header
                        registerVC.link = localLink
                        registerVC.nameRequired = self.nameRequired
                        registerVC.emailRequired = self.nameRequired
                        registerVC.passwordRequired = self.passwordRequired
                        if localLink == self.link{
                            self.replaceControllerInStack(registerVC)
                        }else{
                            parameters["link"] = localLink as AnyObject
                            self.checkProviderApi(params: parameters)
                        }
                    }
                }else{
                    var community = ""
                    var communityName = ""
                    if response["canRegisterOn"] != JSON.null {
                        community = response["canRegisterOn"]["community"].string!
                        communityName = response["canRegisterOn"]["communityName"].string!
                    }
                    
                    if response["canProceed"].bool!,self.link != ""{
                        let mobifiedRegisterVC = UIStoryboard.modifiedRegister()
                        mobifiedRegisterVC.email = response["user"]["email"].string
                        mobifiedRegisterVC.name = name
                        mobifiedRegisterVC.provider = self.provider
                        mobifiedRegisterVC.socialParams = params
                        mobifiedRegisterVC.socialHeader = header
                        mobifiedRegisterVC.link = self.link
                        mobifiedRegisterVC.community = community
                        mobifiedRegisterVC.communityName = communityName
                        mobifiedRegisterVC.nameRequired = self.nameRequired
                        mobifiedRegisterVC.passwordRequired = self.passwordRequired
                        mobifiedRegisterVC.emailRequired = self.emailRequired
                        self.replaceControllerInStack(mobifiedRegisterVC)
                    }
                }
            }
        }, failure: {(error,errorCode) in
            self.activityIndicator?.hide()
            self.navigationController?.popViewController(animated: true)
            let cookieStorage = HTTPCookieStorage.shared
            for each: HTTPCookie in cookieStorage.cookies! {
                cookieStorage.deleteCookie(each)
            }
            if error == "USER_SHIBBO_NOT_ALLOWED"{
                CommonFunctions().showError(title: "Error", message: "You are not allowed to access this community. Please contact your community admin.")
            }else{
                CommonFunctions().showError(title: "Error", message: error)
            }
        })
    }
    
}

//MARK: APPLE SIGN IN

@available(iOS 13.0, *)
extension SocialLoginViewController : ASAuthorizationControllerDelegate{


    
    @objc func handleAppleIdRequest() {
            
            let appleIDProvider = ASAuthorizationAppleIDProvider()
            let request = appleIDProvider.createRequest()
            request.requestedScopes = [.fullName, .email]
            request.state = self.state
            let authorizationController = ASAuthorizationController(authorizationRequests: [request])
            authorizationController.delegate = self
            authorizationController.performRequests()
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as?  ASAuthorizationAppleIDCredential {
              
            let code = String(data: appleIDCredential.authorizationCode!, encoding: .utf8);
            
            let name = (appleIDCredential.fullName?.givenName ?? "") + " " + (appleIDCredential.fullName?.familyName ?? "")
            
//            if let email = appleIDCredential.email {
//                           if email.contains("@privaterelay.appleid.com"){
//                               CommonFunctions.alertViewLogout(title: "", message: "For best user experience and seamless communication, we suggest you to share your email address", viewController: self, buttons: ["Ok"])
//                              return
//                           }
//                       }
//                       else
//                       {
//                           CommonFunctions.alertViewLogout(title: "", message: "For best user experience and seamless communication, we suggest you to share your email address", viewController: self, buttons: ["Ok"])
//
//                          return
//                       }
            
            if appleIDCredential.fullName != nil
            {
                UserDefaultsDataSource(key: "name").writeData(name)

            }
           
            
            //"name" : UserDefaultsDataSource(key: "name").readData()
            
            let params = ["code": code,
                          "provider": self.provider,
                          "link": self.link,
                          "state": appleIDCredential.state,
                          "redirect_uri": self.redirectUri,
                          "app" : Bundle.main.bundleIdentifier
                           ]
            self.activityIndicator?.hide()
            self.checkEmailStatus(params: params as Dictionary<String, AnyObject>)
            
        }
    }
    
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error.
        print(error)
        self.activityIndicator?.hide()
        self.navigationController?.popViewController(animated: false)
        
        
    }
}

