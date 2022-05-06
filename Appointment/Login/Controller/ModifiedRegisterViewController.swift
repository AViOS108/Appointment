//
//  ModifiedRegisterViewController.swift
//  Resume
//
//  Created by Manu Gupta on 28/08/17.
//  Copyright © 2017 VM User. All rights reserved.
//

import UIKit
import TTTAttributedLabel
import SwiftyJSON

class ModifiedRegisterViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var emailContainerView: UIView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var nameContainerView: UIView!
    @IBOutlet weak var passwordContainerView: UIView!
    @IBOutlet weak var passwordTextField: CustomUITextField!
    @IBOutlet weak var suggestedCommunity: UILabel!
    var activityIndicator: ActivityIndicatorView?
    @IBOutlet weak var termsLabels: TTTAttributedLabel!
    var errorView: ErrorView?
    
    // status fields
    var email: String!
    var name: String!
    var provider: String!
    var link: String = ""
    var nameRequired = false
    var passwordRequired = false
    var emailRequired = false
    
    var socialParams: Dictionary<String,AnyObject>!
    var socialHeader: Dictionary<String,String>!
    
    // Three comunity issue
    @IBOutlet weak var alternateCommunityButtonHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var keyboardHeightLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var alternateCommunityName: TTTAttributedLabel!
    var communityName: String = ""
    var community: String = ""
    
    // Vmock Logo
    @IBOutlet weak var communityLogo: UIImageView!
    @IBOutlet weak var communityLogoHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var communityLogoWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var communityNameLabel: UILabel!
    @IBOutlet weak var enclosingView: UIView!
    
    // Password Field
    @IBOutlet weak var passwordFieldHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var passwordTermsLabel: UILabel!
    @IBOutlet weak var nameFieldHeightConstraint: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
        customizeUI()
        let cn = UserDefaultsDataSource(key: "communityName").readData() as! String
        suggestedCommunity.text = "To become a member of \(cn) community, please enter your school email address. Set your password to login using email."
        let emailStatus = (UserDefaultsDataSource(key: "emailAllowed").readData() as? Bool) ?? false
        if emailStatus {
            if community == ""{
                alternateCommunityName.text = "You can also register as Standard user"
                self.addLink(forLabel: self.alternateCommunityName, text: "Standard", link: "https://gaurav.gupta/standardUser")
            }else{
                alternateCommunityName.text = "You can also register on an alternate community of \(communityName) or as a Standard user"
                self.addLink(forLabel: self.alternateCommunityName, text: communityName, link: "https://gaurav.gupta/\(community)")
                self.addLink(forLabel: self.alternateCommunityName, text: "Standard", link: "https://gaurav.gupta/standardUser")
            }
        }else{
            alternateCommunityName.text = ""
        }
        let localLogo = UserDefaultsDataSource(key: "communityLogoLocal").readData()
        let communityLogoName = UserDefaultsDataSource(key: "communityNameLocal").readData()
        CommonFunctions().loadLogo(communityName: communityNameLabel, imageView: communityLogo, enclosingView: enclosingView,logo: localLogo as? String,communityLogoName: communityLogoName as? String)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        GoogleAnalyticsUtility().startScreenTrackingForScreenName("Login & Register: Modified Register")
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardNotification(notification:)), name: UIApplication.keyboardWillChangeFrameNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIApplication.keyboardWillChangeFrameNotification, object: nil)
    }
    
    func customizeUI(){
        scrollView.isScrollEnabled = true
        self.addLink(forLabel: termsLabels, text: "Terms", link: Urls().terms)
        self.addLink(forLabel: termsLabels, text: "Privacy Policy", link: Urls().privacyPolicy)
        if !nameRequired {
            nameFieldHeightConstraint.constant = 0
        }
        
        if !passwordRequired{
            passwordFieldHeightConstraint.constant = 0
            passwordContainerView.clipsToBounds = true
            passwordTermsLabel.text = ""
        }else{
            passwordTermsLabel.text = StringConstants.invalidPasswordError
        }
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func signUpButtonTapped(_ sender: UIButton) {
        let validStatus = passwordTextField.text!.isValidPasword()
        emailTextField.text = emailTextField.text?.trimmingCharacters(in: .whitespaces)
        if emailTextField.text! == "" {
            CommonFunctions().showError(title: "Error", message: StringConstants.emptyEmailError)
            emailContainerView.shake()
        }else if !(emailTextField.text?.isvalidEmailId())!{
            CommonFunctions().showError(title: "Error", message: StringConstants.invalidEmailError)
            emailContainerView.shake()
        }else if passwordRequired, passwordTextField.text! == ""{
            CommonFunctions().showError(title: "Error", message: StringConstants.emptyPasswordError)
            passwordContainerView.shake()
        }else if passwordRequired, !(validStatus.status){
            CommonFunctions().showError(title: "Error", message: (validStatus.message))
        }else{
            var params = ["provider": provider,
                          "link": link] as [String : AnyObject]
            if emailRequired {
                params["email"] = emailTextField.text! as AnyObject
            }
            
            if passwordRequired {
                params["password"] = passwordTextField.text! as AnyObject
            }
            
            if nameRequired {
                params["name"] = nameTextField.text! as AnyObject
            }
            if let referralCode =  UserDefaultsDataSource(key: "referralCode").readData() as? String {
                params["referral_code"] = referralCode as AnyObject
            }
            registerUser(params: params)
        }
    }
    
    func registerUser(params: Dictionary<String,AnyObject>){
        var registerParams = params
        var headers: Dictionary<String,String>
        registerParams["code"] = socialParams["code"]
        registerParams["state"] = socialParams["state"]
        registerParams["redirect_uri"] = socialParams["redirect_uri"]
        headers = self.socialHeader
        activityIndicator = ActivityIndicatorView.showActivity(view: self.navigationController!.view, message: StringConstants.signUpApiLoader)
        RegisterService().resisterUserCall(headerIncluded: true, headers: headers, params: registerParams as Dictionary<String, AnyObject>, { response in
            self.activityIndicator?.hide()
            if response["status"].bool! {
                UserDefaultsDataSource(key: "referralCode").removeData()
                UserDefaultsDataSource(key: "userEmail").writeData(self.emailTextField.text!)
                self.checkEmailStatus(params: self.socialParams, header: self.socialHeader, headerIncluded: true)
            }
        }, failure: {(error,errorCode) in
            self.activityIndicator?.hide()
            CommonFunctions().showError(title: "Error", message: error)
        })
    }
    
    func checkEmailStatus(params: Dictionary<String,AnyObject>,header: Dictionary<String,String>,headerIncluded: Bool){
        activityIndicator = ActivityIndicatorView.showActivity(view: self.navigationController!.view, message: StringConstants.checkEmailStatusApiLoader)
        let header = header
        CheckLoginStatusService().checkLoginStatusCall(headerIncluded: headerIncluded,params: params as Dictionary<String, AnyObject>,header: header, { response in
            GoogleAnalyticsUtility().logEvent(GoogleAnalyticsEvent(category: "Login & Register", action: "Facebook Response", label: "Facebook Success"))
            self.activityIndicator?.hide()
            if response["isVerified"].bool! {
                if response["isApproved"].bool! {
                    if self.provider == "facebook"{
                        GoogleAnalyticsUtility().logEvent(GoogleAnalyticsEvent(category: "Login & Register", action: "Register Response", label: "\(self.provider.capitalized) Success"))
                    }else{
                        GoogleAnalyticsUtility().logEvent(GoogleAnalyticsEvent(category: "Login & Register", action: "Register Response", label: "\(self.provider.capitalized) Success"))
                    }
                    self.loginWithEmail(params: self.socialParams, header: self.socialHeader,headerIncluded: true)
                }else{
                    self.navigationController?.pushViewController(UIStoryboard.waitingApproval(), animated: true)
                }
            }else{
                let verificationPending = UIStoryboard.registerSuccess()
                verificationPending.email = self.emailTextField.text!
                self.navigationController?.pushViewController(verificationPending, animated: true)
            }
        }, failure: {(error,errorCode) in
            self.activityIndicator?.hide()
            if ErrorView.canShowForErrorCode(errorCode){
                self.errorView = ErrorView.showOnView(self.view, forErrorOn: nil, errorCode: errorCode, completion: {
                    self.checkEmailStatus(params: params, header: header, headerIncluded: headerIncluded)
                })
            }else{
                CommonFunctions().showError(title: "Error", message: error)
            }
        })
    }
    
    func loginWithEmail(params: Dictionary<String, AnyObject>,header: Dictionary<String, String>,headerIncluded: Bool){
        self.activityIndicator = ActivityIndicatorView.showActivity(view: self.navigationController!.view, message: StringConstants.loginApiLoader)
        LoginService().loginCall(headerIncluded: headerIncluded,params: params as Dictionary<String, AnyObject>,header: header, { response in
            self.activityIndicator?.hide()
            self.getUserinfo()
        }, failure: { loginError in
            self.activityIndicator?.hide()
            if ErrorView.canShowForErrorCode(loginError.errorCode){
                self.errorView = ErrorView.showOnView(self.view, forErrorOn: nil, errorCode: loginError.errorCode, completion: {
                    self.loginWithEmail(params: params, header: header, headerIncluded: headerIncluded)
                })
            }else{
                CommonFunctions().showError(title: "Error", message: loginError.errorMessage)
            }
        })
    }
    
    func getUserinfo(){
        activityIndicator = ActivityIndicatorView.showActivity(view: self.navigationController!.view, message: StringConstants.userInfoApiLoader)
        LoginService().getUserInfo({ _ in
            self.activityIndicator?.hide()
            self.getUserCustomParams()
        }, failure: {(error,errorCode) in
            self.activityIndicator?.hide()
            self.showError()
            if ErrorView.canShowForErrorCode(errorCode){
                self.errorView = ErrorView.showOnView(self.view, forErrorOn: nil, errorCode: errorCode, completion: {
                    self.getUserinfo()
                })
            }else{
                CommonFunctions().showError(title: "Error", message: error)
            }
        })
    }
    
    func getUserCustomParams(){
        activityIndicator = ActivityIndicatorView.showActivity(view: self.navigationController!.view, message: StringConstants.communityInfoApiLoader)
        LoginService().getCustomizations({ response in
            self.activityIndicator?.hide()
            if let mobileEnabled = response["is_appointments_enabled"].int, mobileEnabled == 1{
                if let detailsRequired = response["are_user_details_required"].int,detailsRequired == 1{
                    UserDefaultsDataSource(key: "areDetailsRequired").writeData(true)
                }else{
                    UserDefaultsDataSource(key: "areDetailsRequired").writeData(false)
                }
                
                if let resumeSurveyEnabled = response["is_resume_survey_enabled"].int,resumeSurveyEnabled == 1{
                    UserDefaultsDataSource(key: "resumeSurveyEnabled").writeData(true)
                }else{
                    UserDefaultsDataSource(key: "resumeSurveyEnabled").writeData(false)
                }
                
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
            self.showError()
            if ErrorView.canShowForErrorCode(errorCode){
                self.errorView = ErrorView.showOnView(self.view, forErrorOn: nil, errorCode: errorCode, completion: {
                    self.getUserCustomParams()
                })
            }else{
                CommonFunctions().showError(title: "Error", message: error)
            }
        })
    }
    
    func showError(){
        let cookieStorage = HTTPCookieStorage.shared
        for each: HTTPCookie in cookieStorage.cookies! {
            cookieStorage.deleteCookie(each)
        }
    }
    
    @IBAction func showPasswordButtonTapped(_ sender: UIButton) {
        if sender.titleLabel?.text == "SHOW"{
            passwordTextField.isSecureTextEntry = false
            sender.setTitle("HIDE", for: .normal)
        }else if sender.titleLabel?.text == "HIDE"{
            passwordTextField.isSecureTextEntry = true
            sender.setTitle("SHOW", for: .normal)
        }
    }
    
    func addLink( forLabel label: TTTAttributedLabel , text : String , link : String) {
        guard let labelText = label.text as? NSString else {return}
        label.delegate = self
        let nsText = labelText
        let range = nsText.range(of: text, options: NSString.CompareOptions.caseInsensitive)
        label.addLink(to: URL(string: link), with: range)
    }
    
    func getProvidersApiDetails(link: String){
        activityIndicator = ActivityIndicatorView.showActivity(view: self.navigationController!.view, message: "Loading Community")
        ProviderServcie().providerServcieCall(link: link,{ response in
            self.activityIndicator?.hide()
            if response["community"] != JSON.null{
                let communityDetails = response["community"]
                UserDefaultsDataSource(key: "communityLogoLocal").writeData(communityDetails["logo"].string)
                UserDefaultsDataSource(key: "communityNameLocal").writeData(communityDetails["communityName"].string)
                UserDefaultsDataSource(key: "communityLocal").writeData(communityDetails["community"].string)
                UserDefaultsDataSource(key: "linkLocal").writeData(communityDetails["community"].string)
               self.sendToRegister(link: communityDetails["community"].string!)
            }
        }, failure: { (error,errorCode) in
            self.activityIndicator?.hide()
            if ErrorView.canShowForErrorCode(errorCode){
                self.errorView = ErrorView.showOnView(self.view, forErrorOn: nil, errorCode: errorCode, completion: {
                    self.getProvidersApiDetails(link: link)
                })
            }else{
                CommonFunctions().showError(title: "Error", message: error)
            }
        })
    }
}

extension ModifiedRegisterViewController : TTTAttributedLabelDelegate{
    
    func attributedLabel(_ label: TTTAttributedLabel!, didSelectLinkWith url: URL!) {
        if url != nil {
            let urlString = url.absoluteString
            if urlString == "https://gaurav.gupta/standardUser"{
                getProvidersApiDetails(link: "")
            }else if urlString == Urls().terms{
                self.sendToWebView(url: urlString)
            }else if urlString == Urls().privacyPolicy{
                self.sendToWebView(url: urlString)
            }else if urlString == "https://gaurav.gupta/\(community)"{
                getProvidersApiDetails(link: community)
            }
        }
    }
    
    func sendToWebView(url: String){
        let wvc = UIStoryboard.webViewer()
        wvc.webUrl = url
        self.navigationController?.pushViewController(wvc, animated: true)
    }
    
    func sendToRegister(link: String){
        let resisterVC = UIStoryboard.register()
        resisterVC.nameRequired = nameRequired
        resisterVC.name = self.name
        resisterVC.captchaRequired = false
        resisterVC.provider = self.provider
        resisterVC.link = link
        resisterVC.email = self.email
        resisterVC.socialHeader = self.socialHeader
        resisterVC.socialParams = self.socialParams
        resisterVC.passwordRequired = self.passwordRequired
        self.navigationController?.pushViewController(resisterVC, animated: true)
    }
}

extension ModifiedRegisterViewController: UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc func keyboardNotification(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let duration:TimeInterval = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIView.AnimationOptions.curveEaseInOut.rawValue
            let animationCurve:UIView.AnimationOptions = UIView.AnimationOptions(rawValue: animationCurveRaw)
            if (endFrame?.origin.y)! >= UIScreen.main.bounds.size.height {
                self.keyboardHeightLayoutConstraint?.constant = 0.0
            } else {
                self.keyboardHeightLayoutConstraint?.constant = endFrame?.size.height ?? 0.0
            }
            UIView.animate(withDuration: duration,
                           delay: TimeInterval(0),
                           options: animationCurve,
                           animations: { self.view.layoutIfNeeded() },
                           completion: nil)
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
}
