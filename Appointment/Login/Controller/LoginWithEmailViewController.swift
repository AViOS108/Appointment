//
//  LoginWithEmailViewController.swift
//  Resume
//
//  Created by VM User on 30/01/17.
//  Copyright © 2017 VM User. All rights reserved.
//

import UIKit
import Foundation

class LoginWithEmailViewController: LoginParentViewController {
    
    @IBOutlet weak var vmockLogoImageView: UIImageView!
    @IBOutlet weak var emailContainerView: UIView!
    @IBOutlet weak var passwordContainerView: UIView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: CustomUITextFieldNoPaste!
    var activeField: UITextField?
    var distanceMoved : CGFloat!
    var email: String!
    var link = ""    
    @IBOutlet weak var showPasswordButton: UIButton!
    // Vmock Logo
    @IBOutlet weak var communityLogo: UIImageView!
    @IBOutlet weak var communityLogoHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var communityLogoWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var communityNameLabel: UILabel!
    @IBOutlet weak var enclosingView: UIView!
    @IBOutlet weak var captchaImageView: UIImageView!
    @IBOutlet weak var captchaCodeTextField: UITextField!
    @IBOutlet weak var reloadCaptchaButton: UIButton!
    @IBOutlet weak var captchaStackView: UIStackView!
    @IBOutlet weak var keyboardLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var captchaTopConstraint: NSLayoutConstraint!
    
    let activity = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customizeUI()
        CommonFunctions().loadLogo(communityName: communityNameLabel, imageView: communityLogo, enclosingView: enclosingView,logo: UserDefaults.standard.object(forKey: "communityLogoLocal") as? String,communityLogoName: UserDefaults.standard.object(forKey: "communityNameLocal") as? String)
        link = UserDefaults.standard.object(forKey: "linkLocal") as! String
        configureCaptcha()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        GoogleAnalyticsUtility().startScreenTrackingForScreenName("Login & Register: Login")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardNotification(notification:)), name: UIApplication.keyboardWillChangeFrameNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIApplication.keyboardWillChangeFrameNotification, object: nil)
    }
    
    func customizeUI(){
        activity.style = .gray
        emailTextField.text = email
        emailTextField.isUserInteractionEnabled = false
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func reloadCaptchButtonTapped(_ sender: Any) {
         reloadCaptcha()
    }
    
    func configureCaptcha() {
      let status = self.captchaRequired
      if status {
         getCaptcha()
         captchaTopConstraint.constant = 20
      } else {
         captchaTopConstraint.constant = 0
      }
      captchaCodeTextField.isHidden = !status
      captchaImageView.isHidden = !status
      reloadCaptchaButton.isHidden = !status
    }
    
    func reloadCaptcha() {
        captchaImageView.image = nil
        captchaCodeTextField.text = ""
        configureCaptcha()
    }
    
    func getCaptcha() {
         self.captchaImageView.backgroundColor = UIColor.white
         captchaImageView.addSubview(activity, withCenterConstraints: CGPoint(x: 0, y: 0))
         activity.startAnimating()
         super.getNewCaptcha(success: {
            self.captchaImageView.downloadedFrom(link: self.captchaImageURL!, success: {
                self.activity.removeFromSuperview()
            }, failure: {
                self.activity.removeFromSuperview()
            })
         }, failure: {
            self.activity.removeFromSuperview()
            self.captchaImageView.image = #imageLiteral(resourceName: "error")
            self.captchaImageView.contentMode = .scaleAspectFit
            self.captchaImageView.backgroundColor = UIColor.fromHex(0xeeecec)
        })
    }
    
    @objc func keyboardNotification(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let duration:TimeInterval = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIView.AnimationOptions.curveEaseInOut.rawValue
            let animationCurve:UIView.AnimationOptions = UIView.AnimationOptions(rawValue: animationCurveRaw)
            if (endFrame?.origin.y)! >= UIScreen.main.bounds.size.height {
                self.keyboardLayoutConstraint?.constant = 0.0
            } else {
                self.keyboardLayoutConstraint?.constant = endFrame?.size.height ?? 0.0
            }
            UIView.animate(withDuration: duration,
                           delay: TimeInterval(0),
                           options: animationCurve,
                           animations: { self.view.layoutIfNeeded() },
                           completion: nil)
        }
    }
    
    @IBAction func forgotPasswordButtonTapped(_ sender: UIButton){
        GoogleAnalyticsUtility().logEvent(GoogleAnalyticsEvent(category: "Login & Register", action: "Reset Password", label: "Reset Password Initiator"))
        let forgotPasswordController = UIStoryboard.forgot()
        forgotPasswordController.email = emailTextField.text!
        forgotPasswordController.providesPresentationContextTransitionStyle = true
        forgotPasswordController.definesPresentationContext = true
        forgotPasswordController.modalPresentationStyle=UIModalPresentationStyle.overFullScreen
        forgotPasswordController.modalTransitionStyle = .crossDissolve
        self.present(forgotPasswordController, animated: true, completion: nil)
    }
    
    @IBAction func loginButtonTapped(_ sender: UIButton){
        if (emailTextField.text?.isEmpty)! || (passwordTextField.text?.isEmpty)!{
            CommonFunctions().showError(title: "Error", message: StringConstants.emptyPasswordError)
            passwordContainerView.shake()
        }else if !(emailTextField.text?.isvalidEmailId())!{
            CommonFunctions().showError(title: "Error", message: StringConstants.invalidEmailError)
            emailContainerView.shake()
        } else if captchaRequired , (captchaCodeTextField.text?.isEmpty)! {
             CommonFunctions().showError(title: "Error", message: StringConstants.emptyCaptchaError)
             captchaCodeTextField.shake()
        }
        else{
            var params = ["email": emailTextField.text!,
                          "password": passwordTextField.text!,
                          "provider":"email",
                          "link":link]
            self.removeActiveField()
            if captchaRequired {
                params["captcha_id"] = captchaId!
                params["captcha_token"] = captchaToken!
                params["captcha_response"] = captchaCodeTextField.text!
            }
            loginCall(params: params as Dictionary<String, AnyObject>, headerIncluded: false,header: ["":""])
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
    
    func  removeActiveField(){
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        captchaCodeTextField.resignFirstResponder()
        
    }
    
    override func errorHandler(error: String, errorCode: Int, params: Dictionary<String, AnyObject>, headerIncluded: Bool, header: Dictionary<String, String>) {
        super.errorHandler(error: error, errorCode: errorCode, params: params, headerIncluded: headerIncluded, header: header)
        self.passwordTextField.text = ""
        self.passwordTextField.resignFirstResponder()
        self.reloadCaptcha()
    }
}

extension LoginWithEmailViewController : UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        activeField = nil
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        removeActiveField()
        return true
    }
}
