//
//  RegisterViewController.swift
//  Resume
//
//  Created by VM User on 30/01/17.
//  Copyright © 2017 VM User. All rights reserved.
//

import UIKit
import TTTAttributedLabel

class RegisterViewController: LoginParentViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var nameContainerView: UIView!
    @IBOutlet weak var passwordContainerView: UIView!
    @IBOutlet weak var passwordTextField: CustomUITextField!
    @IBOutlet weak var signUpButton: UIButton!
    var activeField: UITextField?
    @IBOutlet weak var captchaImageHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var captchaTextFieldHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var captchaReloadButtonHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var captchaImageView: UIImageView!
    @IBOutlet weak var captchaTextField: UITextField!
    var activity = UIActivityIndicatorView()
    @IBOutlet weak var termsLabels: TTTAttributedLabel!
    
    // status fields
    var email: String!
    var nameRequired = false
    var passwordRequired = false
    var emailRequired = true
    var provider: String!
    var link: String = ""
    var socialParams: Dictionary<String,AnyObject>!
    var socialHeader: Dictionary<String,String>!
    var name: String!
    @IBOutlet weak var keyboardHeightLayoutConstraint: NSLayoutConstraint!
    
    // Vmock Logo
    @IBOutlet weak var communityLogo: UIImageView!
    @IBOutlet weak var communityLogoHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var communityLogoWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var communityNameLabel: UILabel!
    @IBOutlet weak var enclosingView: UIView!
    
    // Password Field
    @IBOutlet weak var passwordFieldHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var passwordTermsLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        customizeUI()
        if captchaRequired == true{
            self.getCaptcha()
        }else{
            showHideCaptcha(height: 0)
        }
        
        if name != nil,name != "" {
            nameTextField.text = name
            nameTextField.isEnabled = false
        }else{
            nameTextField.isEnabled = true
        }
        
        if !passwordRequired{
            passwordFieldHeightConstraint.constant = 0
            passwordContainerView.clipsToBounds = true
            passwordTermsLabel.text = ""
        }else{
            passwordTermsLabel.text = StringConstants.invalidPasswordError
        }
        CommonFunctions().loadLogo(communityName: communityNameLabel, imageView: communityLogo, enclosingView: enclosingView,logo: UserDefaultsDataSource(key: "communityLogoLocal").readData() as? String,communityLogoName: UserDefaultsDataSource(key: "communityNameLocal").readData() as? String)
        link = UserDefaultsDataSource(key: "linkLocal").readData() as! String
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func getCaptcha() {
        self.captchaImageView.backgroundColor = UIColor.white
        captchaImageView.addSubview(activity, withCenterConstraints: CGPoint(x: 0, y: 0))
        activity.startAnimating()
        super.getNewCaptcha(success: {
            self.captchaImageView.downloadedFrom(link: self.captchaImageURL! , success : {
                self.activity.removeFromSuperview()
            } , failure : {
                self.activity.removeFromSuperview()
            })
        }, failure: {
            self.activity.removeFromSuperview()
            self.captchaImageView.image = #imageLiteral(resourceName: "error")
            self.captchaImageView.contentMode = .scaleAspectFit
            self.captchaImageView.backgroundColor = UIColor.fromHex(0xeeecec)
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        GoogleAnalyticsUtility().startScreenTrackingForScreenName("Login & Register: Register")
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardNotification(notification:)), name: UIApplication.keyboardWillChangeFrameNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIApplication.keyboardWillChangeFrameNotification, object: nil)
    }
    func customizeUI(){
        emailTextField.text = email
        emailTextField.isUserInteractionEnabled = false
        activity.style = .gray
        activity.tintColor = ColorCode.textColor
        activity.hidesWhenStopped = true
        scrollView.isScrollEnabled = true
        
        self.addLink(forLabel: termsLabels, text: "Terms", link: Urls().terms)
        self.addLink(forLabel: termsLabels, text: "Privacy Policy", link: Urls().privacyPolicy)
    }
    
    
    
    @IBAction func reloadButtonTapped(_ sender:UIButton ){
        captchaImageView.image = nil
        getCaptcha()
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func showHideCaptcha(height: CGFloat){
        captchaImageHeightConstraint.constant = height
        captchaTextFieldHeightConstraint.constant = height
        captchaReloadButtonHeightConstraint.constant = height
        scrollView.layoutIfNeeded()
    }
    
    
    @IBAction func signUpButtonTapped(_ sender: UIButton) {
        let validStatus = passwordTextField.text!.isValidPasword()
        emailTextField.text = emailTextField.text?.trimmingCharacters(in: .whitespaces)
        if nameRequired , nameTextField.text! == "" {
            CommonFunctions().showError(title: "Error", message: StringConstants.emptyNameError)
            nameContainerView.shake()
        }else if passwordRequired, passwordTextField.text! == ""{
            CommonFunctions().showError(title: "Error", message: StringConstants.emptyPasswordError)
            passwordContainerView.shake()
        }else if passwordRequired ,!(validStatus.status){
            CommonFunctions().showError(title: "Error", message: validStatus.message)
        } else if captchaRequired , (captchaTextField.text?.isEmpty)! {
            CommonFunctions().showError(title: "Error", message: StringConstants.emptyCaptchaError)
            captchaTextField.shake()
        }
        else{
            var params = ["provider": provider,
                          "link": link,] as [String : AnyObject]
            if emailRequired {
                params["email"] = emailTextField.text! as AnyObject
            }
            
            if passwordRequired {
                params["password"] = passwordTextField.text! as AnyObject
            }
            if nameRequired{
                params["name"] = nameTextField.text! as AnyObject
            }
            if captchaRequired {
                    params["captcha_id"] = captchaId! as AnyObject
                    params["captcha_token"] = captchaToken! as AnyObject
                    params["captcha_response"] = captchaTextField.text! as AnyObject
            }
            registerUser(params: params)
        }
    }
    
    func registerUser(params: Dictionary<String,AnyObject>){
        var registerParams = params
        var headers: Dictionary<String,String>
        var headerIncluded: Bool!
        
        if provider != "email"{
            registerParams["code"] = socialParams["code"]
            registerParams["state"] = socialParams["state"]
            registerParams["redirect_uri"] = socialParams["redirect_uri"]
            headers = self.socialHeader
            headerIncluded = true
        }else{
            headers = ["":""]
            headerIncluded = false
        }
     
        if let referralCode = UserDefaultsDataSource(key: "referralCode").readData() as? String {
            registerParams["referral_code"] = referralCode as AnyObject            
        }
        
        activityIndicator = ActivityIndicatorView.showActivity(view: self.navigationController!.view, message: StringConstants.signUpApiLoader)
        RegisterService().resisterUserCall(headerIncluded: headerIncluded, headers: headers, params: registerParams as Dictionary<String, AnyObject>, { response in
            self.activityIndicator?.hide()
            GoogleAnalyticsUtility().logEvent(GoogleAnalyticsEvent(category: "Login & Register", action: "Register Response", label: "\(self.provider.capitalized) Success"))
            UserDefaultsDataSource(key: "userEmail").writeData(self.emailTextField.text!)
            if response["status"].bool! {
                UserDefaultsDataSource(key: "link").writeData(self.link)
                UserDefaultsDataSource(key: "referralCode").removeData()
                if self.provider == "email" {
                    let emailParams = ["email": self.emailTextField.text!,
                                       "link": self.link,
                                       "provider":"email"]
                    self.checkEmailStatus(params: emailParams as Dictionary<String, AnyObject>, header: ["":""], headerIncluded: false)
                }else{
                    self.checkEmailStatus(params: self.socialParams, header: self.socialHeader,headerIncluded: true)
                }
            }
        }, failure: {(error,errorCode) in
            GoogleAnalyticsUtility().logEvent(GoogleAnalyticsEvent(category: "Login & Register", action: "Register Response", label: "Failure"))
            self.activityIndicator?.hide()
            CommonFunctions().showError(title: "Error", message: error)
            if self.captchaRequired{
                self.captchaTextField.text = ""
                self.getCaptcha()
            }
        })
    }
    
    func checkEmailStatus(params: Dictionary<String,AnyObject>,header: Dictionary<String,String>,headerIncluded: Bool){
        activityIndicator = ActivityIndicatorView.showActivity(view: self.navigationController!.view, message: StringConstants.checkEmailStatusApiLoader)
        let header = header
        CheckLoginStatusService().checkLoginStatusCall(headerIncluded: headerIncluded,params: params as Dictionary<String, AnyObject>,header: header, { response in
            self.activityIndicator?.hide()
            if response["isVerified"].bool! {
                if response["isApproved"].bool! {
                    if self.provider == "email" {
                        let emailParams = ["email": self.emailTextField.text!,
                                           "password": self.passwordTextField.text!,
                                           "link":self.link,
                                           "provider":"email"]
                        self.loginCall(params: emailParams as Dictionary<String, AnyObject>, headerIncluded: false, header: ["":""])
                    }else{
                        self.loginCall(params: self.socialParams, headerIncluded: true, header: self.socialHeader)
                    }
                }else{
                    UserDefaultsDataSource(key: "userEmail").writeData(self.emailTextField.text!)
                    CommonFunctions().changeLinkLocalToGlobal()
                    let approvalScreen = UIStoryboard.waitingApproval()
                    approvalScreen.message = "We have sent your request to the admin for approval. Please try to login after sometime"                    
                    self.navigationController?.pushViewController(approvalScreen, animated: true)
                }
            }else{
                UserDefaultsDataSource(key: "userEmail").writeData(self.emailTextField.text!)
                CommonFunctions().changeLinkLocalToGlobal()
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
}

extension RegisterViewController : TTTAttributedLabelDelegate{
    
    func attributedLabel(_ label: TTTAttributedLabel!, didSelectLinkWith url: URL!) {
        let wvc = UIStoryboard.webViewer()
        wvc.webUrl = url.absoluteString
        self.navigationController?.pushViewController(wvc, animated: true)
    }
    
}

extension RegisterViewController : UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        activeField = nil
    }
    
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

