//
//  VerificatonCompletedViewController.swift
//  Resume
//
//  Created by Manu Gupta on 18/08/17.
//  Copyright © 2017 VM User. All rights reserved.
//

import UIKit

class VerificatonCompletedViewController: UIViewController {
    
    enum VerifyState {
        case verifying, error
        case verifyFailed
        case verifySuccess
    }
    
    var verifyState = VerifyState.verifying
    
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var messageLabel: UILabel!
    
    var verificationId = ""
    var verificationCode = ""
    
    var activityIndicator : ActivityIndicatorView?
    
    var email : String?
    // Vmock Logo
    @IBOutlet weak var communityLogo: UIImageView!
    @IBOutlet weak var communityLogoHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var communityLogoWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var communityLogoTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var communityNameLabel: UILabel!
    @IBOutlet weak var enclosingView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AppUtility.lockOrientation(.portrait, andRotateTo: .portrait)
        verifyApiCall()
        let communityLogoLocal = UserDefaultsDataSource(key: "communityLogoLocal").readData()
        CommonFunctions().loadLogo(communityName: communityNameLabel, imageView: communityLogo, enclosingView: enclosingView,logo: communityLogoLocal as? String,communityLogoName: "VMock Default")
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        GoogleAnalyticsUtility().startScreenTrackingForScreenName("Login & Register: Verification Completed")
    }
    
    @IBAction func continueButtonTapped(_ sender: Any){
        switch verifyState {
        case .error, .verifying:
            verifyApiCall()
        case .verifySuccess:
            fallthrough
        case .verifyFailed:
            continueAfterVerifySuccessFail()
        }
    }
    @IBAction func cancelButtonTapped(_ sender: Any){
         UserDefaultsDataSource(key: "link").writeData("default")
         (UIApplication.shared.delegate as? AppDelegate)?.checkLoginState()
    }
    
    func continueAfterVerifySuccessFail() {
        let loggedIn = (UserDefaultsDataSource(key: "loggedIn").readData() as? Bool) ?? false
        let areDetailsRequired = (UserDefaultsDataSource(key: "areDetailsRequired").readData() as? Bool) ?? false
        if loggedIn ,!areDetailsRequired {
            if let currentUser = (UserDefaultsDataSource(key: "userEmail").readData() as? String), let email = email, email == currentUser {
                cancelButtonTapped(cancelButton)
            }
            else {
                createAlertController()
            }
            
        }else{
            UserDefaultsDataSource(key: "").clearAllData()
            UserDefaultsDataSource(key: "userEmail").writeData(email)
            cancelButtonTapped(cancelButton)
        }
    }
    func createAlertController(){
        let actionSheetController = UIAlertController(title: StringConstants.alreadyLoginText, message: "Continue as" , preferredStyle: .actionSheet)
        
        let userEmail = (UserDefaultsDataSource(key: "userEmail").readData() as? String)
        let continueActionButton = UIAlertAction(title: userEmail!, style: .default) { action -> Void in
            self.cancelButtonTapped(self.cancelButton)
        }
        actionSheetController.addAction(continueActionButton)
        
        let startFreshActionButton = UIAlertAction(title: "New user", style: .default) { action -> Void in
            UserDefaultsDataSource(key: "newUserEmail").writeData(self.email)
            LogoutHandler.logout(removeEmail: false)
        }
        actionSheetController.addAction(startFreshActionButton)
        
        let canceButton = UIAlertAction(title: "Cancel", style: .cancel, handler : nil)
        actionSheetController.addAction(canceButton)
        
        actionSheetController.popoverPresentationController?.sourceView = continueButton.superview
        actionSheetController.popoverPresentationController?.sourceRect = continueButton.frame
        actionSheetController.popoverPresentationController?.permittedArrowDirections = .any
        self.present(actionSheetController, animated: true) { 
            actionSheetController.popoverPresentationController?.passthroughViews = nil
        }
    }
    
    func verifyApiCall() {
        
        messageLabel.text = ""
        continueButton.isHidden = true
        
        activityIndicator = ActivityIndicatorView.showActivity(view: self.view, message: StringConstants.verifyingApiLoader)
        
        let params = ["verification_id" : verificationId,
                      "verification_code" : verificationCode]
        
        AccountDetailsServices().verifyAccountCall(headerIncluded: false, params: params as Dictionary<String, AnyObject>, header: ["" : ""], { (response) in
            self.activityIndicator?.hide()
            
            if let email = response["email"].string {
                self.email = email
            }
            if let isApproved = response["isApproved"].bool, !isApproved {
                self.messageLabel.text = StringConstants.userVerifySuccessApprovalPendingText
            }
            else {
                self.messageLabel.text = StringConstants.userVerifySuccessText
            }
            
            self.continueButton.setTitle("CONTINUE", for: .normal)
            self.continueButton.isHidden = false
            self.verifyState = .verifySuccess
        }) { (error,errorCode) in
            self.activityIndicator?.hide()
            if error == "Not Found", errorCode == 404 {
                self.messageLabel.text = StringConstants.userVerifyFailedText
                self.continueButton.setTitle("CONTINUE", for: .normal)
                self.verifyState = .verifyFailed
            }
            else{
                self.messageLabel.text = error
                self.continueButton.setTitle("RETRY", for: .normal)
                self.verifyState = .error
                CommonFunctions().showError(title: "Error", message: error)
            }
            self.continueButton.isHidden = false
        }
    }
}
