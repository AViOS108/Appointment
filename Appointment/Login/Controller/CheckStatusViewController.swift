//
//  CheckStatusViewController.swift
//  Resume
//
//  Created by VM User on 08/03/17.
//  Copyright © 2017 VM User. All rights reserved.
//

import UIKit
import SwiftyJSON
import TTTAttributedLabel
import AuthenticationServices

class CheckStatusViewController: CustomizedViewController {
    
    @IBOutlet weak var btnAppleIDSign: UIButton!

    @IBAction func appleSignTapped(_ sender: Any) {
        
        let appleClientId = UserDefaultsDataSource(key: "appleClientId").readData() as? String
        let appleScope = UserDefaultsDataSource(key: "appleScope").readData() as? String
        let appleResponseType = UserDefaultsDataSource(key: "appleResponseType").readData() as? String
        let appleUrl = UserDefaultsDataSource(key: "appleUrl").readData() as? String
        
        if let appleScope = appleScope,let appleClientId = appleClientId,let appleResponseType = appleResponseType,let appleUrl = appleUrl {
            
            
            let url = URL(string: "\(appleUrl)?client_id=\(appleClientId)&&scope=\(appleScope)&&redirect_uri=\(self.redirectURL)?provider=apple&&state=\(self.state)&&response_type=\(appleResponseType)&&auth_type=rerequest")
         
            if #available(iOS 13.0, *) {
                      self.emailTextField.text = ""
                      UserDefaultsDataSource(key: "userEmail").removeData()
                      let social = UIStoryboard.socialLoginView()
                      social.state = self.state
                      social.provider = "apple"
                      social.link =  self.link;
                      social.url = url
                      social.redirectUri = self.redirectURL
                      social.nameRequired = self.nameRequired
                      social.captchaRequired = self.captchRequired
                      social.passwordRequired = true
                      social.code = "apple"
                      self.navigationController?.pushViewController(social, animated: false)
                      
                  } else {
                      // Fallback on earlier versions
                  }
            
            
            
        }

        
        
        
        
        
      
        
    }
    @IBOutlet weak var stackVIew: UIStackView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var emailContainerView: UIView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var facebookButton: UIButton!
    @IBOutlet weak var linkedInButton: UIButton!
    @IBOutlet weak var view_social: UIView!
    @IBOutlet weak var view_sso: UIView!
    var captchRequired = false
    var nameRequired = false
    var passwordRequired = true
    var emailRequired = true
    var provider: String!
    var activityIndicator: ActivityIndicatorView?
    var link: String = ""
    var errorView: ErrorView?
    @IBOutlet weak var otherCommunityLabel: TTTAttributedLabel!
    var communityLabelHeightConstraint: NSLayoutConstraint!
    var response: JSON!
    var tempLink: String!
    
    // SocialLogin
    var state: String = "p63HTSc7gJIbzwgLgXADMpvM9j52CCgsbWXilD63"
    let redirectURL = "https://\(Urls.runningHost)/login/"
  
//    let redirectURL = "https://dashboard-test.vmock.com/login/"
    
    // Vmock Logo
    @IBOutlet weak var communityLogo: UIImageView!
    @IBOutlet weak var communityName: UILabel!
    @IBOutlet weak var communityLogoHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var communityLogoWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var enclosingView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customizedUI()
        let logo = UserDefaultsDataSource(key: "communityLogo").readData() as? String
        let communityLogoName = UserDefaultsDataSource(key: "communityName").readData() as? String
        CommonFunctions().loadLogo(communityName: communityName, imageView: communityLogo, enclosingView: enclosingView,logo: logo ,communityLogoName: communityLogoName)
    }
    
    func customizedUI(){
        // Global Link
        link =  UserDefaultsDataSource(key: "link").readData() as! String
        communityLabelHeightConstraint = NSLayoutConstraint(item: otherCommunityLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 0)
        otherCommunityLabel.addConstraint(communityLabelHeightConstraint)
        setupViewForProviders()
    }
    
    func setupViewForProviders() {
        let linkedInAllowed = (UserDefaultsDataSource(key: "linkedInAllowed").readData() as? Bool) ?? false
        let facebookAllowed = (UserDefaultsDataSource(key: "facebookAllowed").readData() as? Bool) ?? false
        let appleAllowed = (UserDefaultsDataSource(key: "appleAllowed").readData() as? Bool) ?? false
        linkedInButton.isHidden = !linkedInAllowed
        facebookButton.isHidden = !facebookAllowed
        btnAppleIDSign.isHidden = !appleAllowed
        view_social.isHidden = !(!facebookButton.isHidden || !facebookButton.isHidden || !btnAppleIDSign.isHidden)
        
        view_sso.isHidden = !UserDefaults.standard.bool(forKey: "ssoAllowed")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.link = UserDefaultsDataSource(key: "link").readData() as! String
        GoogleAnalyticsUtility().startScreenTrackingForScreenName("Login & Register: Check Email Status")
        CommonFunctions().changeLinkGlobalToLocal()
        
      
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        GoogleAnalyticsUtility().startScreenTrackingForScreenName("Check Email Screen")
        let userEmail = UserDefaultsDataSource(key: "userEmail").readData() as? String
        if let email =  userEmail {
            emailTextField.text = email
        }
    }
    
    @IBAction func nextButtonTapped(_ sender: Any) {
        self.emailTextField.resignFirstResponder()
        emailTextField.text = emailTextField.text?.trimmingCharacters(in: .whitespaces)
        provider = "email"
        if emailTextField.text == "" {
            CommonFunctions().showError(title: "Error", message: StringConstants.emptyEmailError)
            emailContainerView.shake()
        }else if !(emailTextField.text?.isvalidEmailId())!{
            CommonFunctions().showError(title: "Error", message: StringConstants.invalidEmailError)
            emailContainerView.shake()
        }else{
            checkUserStatusAPI(link: link)
        }
    }
    
    @IBAction func universityIdLoginClicked(_ sender: Any) {
        let provider = UserDefaults.standard.object(forKey: "ssoName") as! String
        let ssoUrl = UserDefaults.standard.object(forKey: "ssoUrl") as! String
        let ssoState = UserDefaults.standard.object(forKey: "ssoState") as! String
        let redirectUri = "https://\(Urls.runningHost)/?next=\(link)&&state=\(ssoState)"
        let encodedRedirectUri = redirectUri.addingPercentEncoding(withAllowedCharacters: .alphanumerics)
        let encodeResult = "?return=\(String(describing: encodedRedirectUri!))".addingPercentEncoding(withAllowedCharacters: .alphanumerics)
        let url = URL(string: ssoUrl + encodeResult!)
        if var localUrl = url{
            localUrl.removeAllCachedResourceValues()
            let sso = UIStoryboard.socialLoginView()
            sso.url = localUrl
            sso.nameRequired = false
            sso.captchaRequired = false
            sso.passwordRequired = false
            sso.state = ssoState
            sso.redirectUri = redirectUri
            sso.provider = provider
            sso.link = link
            self.navigationController?.pushViewController(sso, animated: true)
        }
    }
    
    @IBAction func backbuttonTapped(_sender : UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func checkUserStatusAPI(link: String){
        self.emailTextField.resignFirstResponder()
        let params = ["email": emailTextField.text!,
                      "provider": "email",
                      "link": link]
        activityIndicator = ActivityIndicatorView.showActivity(view: self.navigationController!.view, message: StringConstants.checkEmailStatusApiLoader)
        CheckLoginStatusService().checkLoginStatusCall(headerIncluded: false,params: params as Dictionary<String, AnyObject>,header: ["":""], { response in
            GoogleAnalyticsUtility().logEvent(GoogleAnalyticsEvent(category: "Login & Register", action: "Status Email Check Response", label: "Success"))
            UserDefaultsDataSource(key: "userEmail").writeData(self.emailTextField.text!)
            if response["exists"].bool!{
                if response["user"]["community"].string! == self.link{
                
//               if true{

                    if response["isVerified"].bool!{
                        if response["isApproved"].bool! {
                            // Send to login screen
                            if let arr = response["requiredOnLogin"].array , let val = arr.first , let key = val.string , key == "captcha"  {
                                    self.captchRequired = true
                            } else {
                                    self.captchRequired = false
                            }
                            self.activityIndicator?.hide()
                            self.performSegue(withIdentifier: "loginSegue", sender: self)
                        }else{
                            // Send to approval pending screen
                            CommonFunctions().changeLinkLocalToGlobal()
                            self.activityIndicator?.hide()
                            self.performSegue(withIdentifier: "approvalPendingSegue", sender: self)
                        }
                    }else{
                        // Send to verification pending screen
                        CommonFunctions().changeLinkLocalToGlobal()
                        self.activityIndicator?.hide()
                        self.performSegue(withIdentifier: "verificationSegue", sender: self)
                    }
                }
                
                else{
                    self.activityIndicator?.hide()
                    self.checkProviderApi(localLink : response["user"]["community"].string!)
                }
            }else{
                self.activityIndicator?.hide()
                if response["canRegister"].bool!{
                    self.sendToRegisterScreen(response: response)
                }else{
                    CommonFunctions().showError(title: "Error", message: StringConstants.canRegisterFalse)
                    var communityName = ""
                    var community = ""
                    if response["canRegisterOn"] != JSON.null {
                        communityName = response["canRegisterOn"]["communityName"].string!
                        community = response["canRegisterOn"]["community"].string!
                    }
                    if communityName == ""{
                        communityName = "Standard"
                        community = ""
                    }
                    self.otherCommunityLabel.text = "You can register as a \(communityName) community member."
                    self.addLink(forLabel: self.otherCommunityLabel, text: communityName, link: community)
                    self.otherCommunityLabel.removeConstraint(self.communityLabelHeightConstraint)
                    self.response = response
                }
            }
            self.emailTextField.resignFirstResponder()
        }, failure: { (error,errorCode) in
            self.activityIndicator?.hide()
            CommonFunctions().showError(title: "Error", message: error)
        })
    }
    
    func checkProviderApi(localLink: String){
        activityIndicator = ActivityIndicatorView.showActivity(view: self.navigationController!.view, message: "Loading Community")
        ProviderServcie().providerServcieCall(link: localLink,{ response in
            if response["community"] != JSON.null{
                let communityDetails = response["community"]
                UserDefaultsDataSource(key: "communityLogoLocal").writeData(communityDetails["logo"].string)
                UserDefaultsDataSource(key: "communityNameLocal").writeData(communityDetails["communityName"].string)
                UserDefaultsDataSource(key: "communityLocal").writeData(communityDetails["community"].string)
                UserDefaultsDataSource(key: "linkLocal").writeData(communityDetails["community"].string)
                self.link = communityDetails["community"].string!
            }
            let emailAllowed = (UserDefaultsDataSource(key: "emailAllowed").readData() as? Bool) ?? false
            if !emailAllowed {
                let ssoLoginView = UIStoryboard.ssoLogin()
                ssoLoginView.nameRequired = false
                ssoLoginView.passwordRequired = false
                ssoLoginView.captchRequired = false
                self.activityIndicator?.hide()
                self.navigationController?.pushViewController(ssoLoginView, animated: true)
            }else{
                self.activityIndicator?.hide()
                let localLink = UserDefaultsDataSource(key: "linkLocal").readData() as! String
                self.checkUserStatusAPI(link: localLink)
            }
        }, failure: { (error,errorCode) in
            self.activityIndicator?.hide()
            if errorCode == 404{
                (UIApplication.shared.delegate as? AppDelegate)?.checkLoginState()
            }else{
                if ErrorView.canShowForErrorCode(errorCode){
                    self.errorView = ErrorView.showOnView(self.view, forErrorOn: nil, errorCode: errorCode, completion: {
                        self.checkProviderApi(localLink: localLink)
                    })
                }else{
                    CommonFunctions().showError(title: "Error", message: error)
                }
            }
        })
    }
    
    func sendToRegisterScreen(response: JSON){
        self.captchRequired = false
        for index in 0 ... response["required"].count - 1{
            if response["required"][index] == "captcha"{
                self.captchRequired = true
            }else if response["required"][index] == "name"{
                self.nameRequired = true
            }else if response["required"][index] == "password"{
                self.passwordRequired = true
            }else if response["required"][index] == "email"{
                self.emailRequired = true
            }
        }
        let registerVC = UIStoryboard.register()
        registerVC.captchaRequired = self.captchRequired
        let userEmail = UserDefaultsDataSource(key: "userEmail").readData() as? String
        if let email = userEmail{
            registerVC.email = email
        }
        
        registerVC.nameRequired = self.nameRequired
        registerVC.passwordRequired = self.passwordRequired
        registerVC.emailRequired = self.emailRequired
        registerVC.provider = self.provider
        var localLink: String?
        if response["canRegisterOn"] != JSON.null {
            if response["user"]["community"] != JSON.null && response["user"]["community"].string !=   "default"{
                if response["user"]["community"] != JSON.null {
                    localLink = response["user"]["community"].string!
                }else{
                    localLink = ""
                }
            }else{
                localLink = response["canRegisterOn"]["community"].string!
            }
        }else{
            if response["user"]["community"] != JSON.null {
                localLink = response["user"]["community"].string!
            }else{
                localLink = ""
            }
        }
        
        
        var name = String()
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
        registerVC.name = name
        if localLink == self.link{
            self.navigationController?.pushViewController(registerVC, animated: true)
        }else{
            self.checkProviderApi(localLink: localLink!)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "verificationSegue" {
            let destinationVC = segue.destination as! VerificationPendingViewController
            destinationVC.email = emailTextField.text!
        }else if segue.identifier == "loginSegue"{
            let destinationVC = segue.destination as! LoginWithEmailViewController
            destinationVC.email = emailTextField.text!
            destinationVC.link = link
            destinationVC.captchaRequired=self.captchRequired
        }else if segue.identifier == "approvalPendingSegue"{
            let destinationVC = segue.destination as! WaitingForApprovalViewController
            destinationVC.message = "This email address has not been verified by the community admin. Please contact the community admin."
        }
    }
    
    
    @IBAction func facebookButtonTapped(_ sender: Any) {
        let facebookClientId = UserDefaultsDataSource(key: "facebookClientId").readData() as? String
        let facebookScope = UserDefaultsDataSource(key: "facebookScope").readData() as? String
        let facebookResponseType = UserDefaultsDataSource(key: "facebookResponseType").readData() as? String
        let facebookUrl = UserDefaultsDataSource(key: "facebookUrl").readData() as? String
        
        if let facebookScope = facebookScope,let facebookClientId = facebookClientId,let facebookResponseType = facebookResponseType,let facebookUrl = facebookUrl {
            
            
            let url = URL(string: "\(facebookUrl)?client_id=\(facebookClientId)&&scope=\(facebookScope)&&redirect_uri=\(self.redirectURL)?provider=facebook&&state=\(self.state)&&response_type=\(facebookResponseType)&&auth_type=rerequest")
            if let localUrl = url{
                sendSocialLoginRequest(provider: "facebook",url: localUrl)
            }
        }
    }
    
    @IBAction func linkedInButtonTapped(_ sender: Any) {
        let linkedInClientId = UserDefaultsDataSource(key: "linkedInClientId").readData() as? String
        let linkedInScope = UserDefaultsDataSource(key: "linkedInScope").readData() as? String
        let linkedInResponseType = UserDefaultsDataSource(key: "linkedInResponseType").readData() as? String
        let linkedInUrl = UserDefaultsDataSource(key: "linkedInUrl").readData() as? String
        
        if let linkedInResponseType = linkedInResponseType,let linkedInScope = linkedInScope,let linkedInClientId = linkedInClientId,let linkedInUrl = linkedInUrl{
            var authorizationURL = "\(linkedInUrl)?"
            authorizationURL += "response_type=\(linkedInResponseType)&"
            authorizationURL += "client_id=\(linkedInClientId)&"
            authorizationURL += "redirect_uri=\(self.redirectURL)&"
            authorizationURL += "state=\(self.state)&"
            authorizationURL += "scope=\(linkedInScope)"
            if let url = URL(string: authorizationURL) {
                sendSocialLoginRequest(provider: "linkedin", url: url)
            }
        }
    }
    
    func sendSocialLoginRequest(provider: String,url: URL){
        self.emailTextField.text = ""
        UserDefaultsDataSource(key: "userEmail").removeData()
        
        let social = UIStoryboard.socialLoginView()
        social.provider = provider
        if social.provider == "facebook" {
            social.redirectUri = self.redirectURL + "?provider=facebook"
        }else{
            social.redirectUri = self.redirectURL
        }
        social.state = self.state
        social.link = self.link
        social.url = url
        social.nameRequired = self.nameRequired
        social.captchaRequired = self.captchRequired
        social.passwordRequired = true
        self.navigationController?.pushViewController(social, animated: true)
    }
    
    @IBAction func unwindToLoginScreen(segue:UIStoryboardSegue) {
        debugPrint("Login")
    }
}

extension CheckStatusViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.emailTextField.resignFirstResponder()
        return true
    }
}

extension CheckStatusViewController: TTTAttributedLabelDelegate {
    
    func addLink( forLabel label: TTTAttributedLabel , text : String,link : String) {
        guard let labelText = label.text as? NSString else {return}
        label.delegate = self
        tempLink = link
        let nsText = labelText
        let range = nsText.range(of: text, options: NSString.CompareOptions.caseInsensitive)
        label.addLink(to: URL(string: ""), with: range)
    }
    
    func attributedLabel(_ label: TTTAttributedLabel!, didSelectLinkWith url: URL!) {
        if response != nil{
            if emailTextField.text == "" {
                CommonFunctions().showError(title: "Error", message: StringConstants.emptyEmailError)
                emailContainerView.shake()
            }else if !(emailTextField.text?.isvalidEmailId())!{
                CommonFunctions().showError(title: "Error", message: StringConstants.invalidEmailError)
                emailContainerView.shake()
            }else{
                checkProviderApi(localLink: tempLink)
            }
        }
    }
}



