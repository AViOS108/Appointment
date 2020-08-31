//
//  ResetPasswordViewController.swift
//  Resume
//
//  Created by Manu Gupta on 18/08/17.
//  Copyright © 2017 VM User. All rights reserved.
//

import UIKit

class ResetPasswordViewController: UIViewController {

    enum ResetState {
        case enterPassword
        case passwordResetted
        case generateNewLink
        case newLinkGenerated
    }
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var updatePasswordButton: UIButton!
    @IBOutlet weak var passwordContainerView: UIView!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordHintLabel: UILabel!
    var passwordResetId = ""
    var passwordResetToken = ""
    var activityIndicator : ActivityIndicatorView?
    var resetState = ResetState.enterPassword
    // Vmock Logo
    @IBOutlet weak var communityLogo: UIImageView!
    @IBOutlet weak var communityLogoHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var communityLogoWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var communityNameLabel: UILabel!
    @IBOutlet weak var enclosingView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        AppUtility.lockOrientation(.portrait, andRotateTo: .portrait)
        let communityLogoLocal = UserDefaultsDataSource(key: "communityLogoLocal") as? String
        CommonFunctions().loadLogo(communityName: communityNameLabel, imageView: communityLogo, enclosingView: enclosingView,logo: communityLogoLocal,communityLogoName: "VMock Default")
        passwordHintLabel.text = StringConstants.invalidPasswordError
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        GoogleAnalyticsUtility().startScreenTrackingForScreenName("Login & Register: Reset Password Link Request")
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any){
        UserDefaultsDataSource(key: "link").writeData("default")
        (UIApplication.shared.delegate as? AppDelegate)?.checkLoginState()
    }
    
    @IBAction func updatePasswordButtonTapped(_ sender: Any){
        
        switch resetState {
        case .enterPassword:
            resetPassword()
        case .generateNewLink:
            openForgetPassword()
        case .newLinkGenerated:
            cancelButtonTapped(cancelButton)
        case .passwordResetted:
            continueAfterPasswordReset()
        }
    }
    
    func continueAfterPasswordReset() {
        let loggedIn = (UserDefaultsDataSource(key: "loggedIn").readData() as? Bool) ?? false
        let areDetailsRequired = (UserDefaultsDataSource(key: "areDetailsRequired").readData() as? Bool) ?? false
        if loggedIn ,!areDetailsRequired {
            createAlertController()
        }else{
            UserDefaultsDataSource(key: "").clearAllData()
            cancelButtonTapped(cancelButton)
            
        }
        
    }
    func createAlertController(){
        let actionSheetController = UIAlertController(title: StringConstants.alreadyLoginText, message: "Continue as" , preferredStyle: .actionSheet)
        let userEmail = UserDefaultsDataSource(key: "userEmail").readData() as! String
        let continueActionButton = UIAlertAction(title: userEmail, style: .default) { action -> Void in
            self.cancelButtonTapped(self.cancelButton)
        }
        actionSheetController.addAction(continueActionButton)
        
        let startFreshActionButton = UIAlertAction(title: "New user", style: .default) { action -> Void in
            UserDefaultsDataSource(key: "link").writeData("default")
           LogoutHandler.logout(removeEmail: true)
        }
        actionSheetController.addAction(startFreshActionButton)
        
        let canceButton = UIAlertAction(title: "Cancel", style: .cancel, handler : nil)
        actionSheetController.addAction(canceButton)

        actionSheetController.popoverPresentationController?.sourceView = updatePasswordButton.superview
        actionSheetController.popoverPresentationController?.sourceRect = updatePasswordButton.frame
        actionSheetController.popoverPresentationController?.permittedArrowDirections = .any
        self.present(actionSheetController, animated: true) { 
            actionSheetController.popoverPresentationController?.passthroughViews = nil
        }
    }
    
    func openForgetPassword() {
        GoogleAnalyticsUtility().logEvent(GoogleAnalyticsEvent(category: "Login & Register", action: "Reset Password", label: "Reset Password Initiator"))
        let forgotPasswordController = UIStoryboard.forgot()
        forgotPasswordController.isFromDeeplink = true
        forgotPasswordController.delegate = self
        forgotPasswordController.providesPresentationContextTransitionStyle = true
        forgotPasswordController.definesPresentationContext = true
        forgotPasswordController.modalPresentationStyle=UIModalPresentationStyle.overFullScreen
        forgotPasswordController.modalTransitionStyle = .crossDissolve
        self.present(forgotPasswordController, animated: true, completion: nil)
    }
    
    func resetPassword() {
        guard dataValidations() else {
            return
        }
        
        passwordTextField.resignFirstResponder()
        activityIndicator = ActivityIndicatorView.showActivity(view: self.view, message: StringConstants.resetPasswordApiLoader)
        let params = ["password": passwordTextField.text!,
                      "password_reset_id": passwordResetId,
                      "password_reset_token": passwordResetToken]
        UserInfoService().resetPasswordCall(headerIncluded: false, params: params as Dictionary<String, AnyObject>, header: ["":""], { (response) in
            self.activityIndicator?.hide()
            if let status = response["status"].bool, status {
                self.resetState = .passwordResetted
                self.infoLabel.text = StringConstants.resetPasswordSuccessText
            }
            else {
                self.resetState = .generateNewLink
                self.infoLabel.text = StringConstants.resetLinkExpiredText
            }
            self.passwordContainerView.isHidden = true
            self.passwordHintLabel.isHidden = true
            self.updatePasswordButton.setTitle("CONTINUE", for: .normal)
        }) { (error,errorCode) in
            self.activityIndicator?.hide()
            CommonFunctions().showError(title: "Error", message: error)
        }
    }
    func dataValidations() -> Bool {
        guard passwordTextField.text != "" else {
            CommonFunctions().showError(title: "Error", message: StringConstants.emptyPasswordError)
            passwordTextField.shake()
            return false
        }
        let passwordValidity = passwordTextField.text!.isValidPasword()
        guard passwordValidity.status else {
            let message = passwordValidity.message
            CommonFunctions().showError(title: "Error", message: message)
            passwordTextField.shake()
            return false
        }
        return true
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
    
}

extension ResetPasswordViewController: UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension ResetPasswordViewController : ForgotPasswordViewControllerDelegate {
    func forgotPasswordViewControllerDidCompleteSendingLink() {
        resetState = .newLinkGenerated
        infoLabel.text = StringConstants.forgotPasswordSuccessText
    }
}
