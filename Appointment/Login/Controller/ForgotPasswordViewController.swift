//
//  ForgotPasswordViewController.swift
//  Resume
//
//  Created by VM User on 30/01/17.
//  Copyright © 2017 VM User. All rights reserved.
//

import UIKit

protocol ForgotPasswordViewControllerDelegate : NSObjectProtocol{
    func forgotPasswordViewControllerDidCompleteSendingLink()
}

class ForgotPasswordViewController: UIViewController {

    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    var activityIndicator: ActivityIndicatorView?
    var email: String?
    @IBOutlet weak var captchaImageView: UIImageView!
    @IBOutlet weak var captchaTextField: UITextField!
    var captchaId: String!
    var captchaToken: String!
    var activeField: UITextField?
    var distanceMoved : CGFloat = 0
    var activity = UIActivityIndicatorView()
    var isFromDeeplink = false
    weak var delegate : ForgotPasswordViewControllerDelegate?

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var constraint_email_bottom: NSLayoutConstraint!
    @IBOutlet weak var constraint_emailHeight: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if isFromDeeplink {
            emailLabel.text = "\(StringConstants.forgotPasswordScreenText) your email"
        }
        else if let email = email{
            emailLabel.text = "\(StringConstants.forgotPasswordScreenText) \(email)"
            constraint_emailHeight.constant = 0
            constraint_email_bottom.constant = 0
        }
        
        captchaTextField.delegate = self
        activity.style = .gray
        activity.tintColor = ColorCode.textColor
        activity.hidesWhenStopped = true
        getCaptcha()
        cancelButton.layer.borderColor = ColorCode.applicationBlue.cgColor
        cancelButton.layer.borderWidth = 1
        CommonFunctions().provideShadow(view: containerView)
        containerView.layer.borderColor = ColorCode.textColor.cgColor
        containerView.layer.borderWidth = 1
         
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        GoogleAnalyticsUtility().startScreenTrackingForScreenName("Login & Register: Forgot Password")
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func getCaptcha(){
        self.captchaImageView.backgroundColor = UIColor.white
        captchaImageView.addSubview(activity, withCenterConstraints: CGPoint(x: 0, y: 0))
        activity.startAnimating()
        CheckLoginStatusService().getNewCaptch({ response in
            self.captchaId = String(response["id"].int!)
            self.captchaToken = response["token"].string!
            self.captchaImageView.downloadedFrom(link: response["image"].string! , success : {
                self.activity.removeFromSuperview()
            } , failure : {
                self.activity.removeFromSuperview()
            })
        }, failure: { (error,errorCode) in
            self.activity.removeFromSuperview()
            CommonFunctions().showError(title: "Error", message: error)
            self.captchaImageView.image = #imageLiteral(resourceName: "error")
            self.captchaImageView.backgroundColor = UIColor.fromHex(0xeeecec)
            self.captchaImageView.contentMode = .scaleAspectFit
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
         
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func dataValidations() -> Bool {
        if email == "" {
            CommonFunctions().showError(title: "Error", message: StringConstants.emptyEmailError)
            emailTextField.shake()
            return false
        }else if !((email?.isvalidEmailId())!){
            CommonFunctions().showError(title: "Error", message: StringConstants.invalidEmailError)
            emailTextField.shake()
            return false
        }else if captchaTextField.text == ""{
            CommonFunctions().showError(title: "Error", message: StringConstants.emptyCaptchaError)
            captchaTextField.shake()
            return false
        }
        return true
    }
    
    @IBAction func submitButtonTapped(_ sender: UIButton){
        if isFromDeeplink {
            email = emailTextField.text
        }
        guard dataValidations() else {
            return
        }
        
        containerView.endEditing(true)
        let params = ["email": email,
                      "captcha_id": captchaId!,
                      "captcha_token": captchaToken!,
                      "captcha_response": captchaTextField.text!]
        activityIndicator = ActivityIndicatorView.showActivity(view: self.view, message: StringConstants.forgotPasswprdApiLoader)
        ForgotPasswordService().forgotPasswordCall(params: params as Dictionary<String, AnyObject>, { response in
            self.captchaImageView.image = nil
            self.getCaptcha()
            self.activityIndicator?.hide()
            CommonFunctions().showSuccess(title: "Success", message: StringConstants.forgotPasswordSuccessText)
            GoogleAnalyticsUtility().logEvent(GoogleAnalyticsEvent(category: "Login & Register", action: "Reset Password", label: "Success"))
            self.delegate?.forgotPasswordViewControllerDidCompleteSendingLink()
            self.dismiss(animated: true, completion: nil)
        }, failure: {(error,errorCode) in
            self.captchaImageView.image = nil
            self.captchaTextField.text = ""
            self.getCaptcha()
            self.activityIndicator?.hide()
            CommonFunctions().showError(title: "Error", message: error)
        })
    }
    
    @IBAction func reloadButtonTapped(_ sender:UIButton ){
        captchaImageView.image = nil
        getCaptcha()
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        if captchaTextField.isFirstResponder { resignFirstResponder() }
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        guard let activeField = self.activeField else { return }
        let absoluteframe: CGRect = (activeField.convert(activeField.frame, to: UIApplication.shared.keyWindow))
        if let userInfo = notification.userInfo,
            let keyboardSize = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size {
            var aRect : CGRect = self.view.frame
            aRect.size.height -= keyboardSize.height
            if self.view.frame.origin.y == 0 {
                distanceMoved = (absoluteframe.origin.y - aRect.size.height)
                if (absoluteframe.origin.y > aRect.size.height){
                    UIView.animate(withDuration: 0.1, animations: { [weak self] () -> Void in
                        if let vc = self {
                            vc.view.frame.origin.y -= vc.distanceMoved
                        }
                    })
                }
            }
        }
    }
    
    @objc private func keyboardWillHide(notification: Notification) {
        view.frame.origin.y = 0
    }
}

extension ForgotPasswordViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        activeField = nil
    }
}
