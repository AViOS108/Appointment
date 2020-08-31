//
//  VerificationPendingViewController.swift
//  Resume
//
//  Created by VM User on 08/03/17.
//  Copyright © 2017 VM User. All rights reserved.
//

import UIKit


class VerificationPendingViewController: UIViewController {
    
    @IBOutlet weak var resendVerificationButton: UIButton!
    @IBOutlet weak var emailLabel: UILabel!
    var email: String!
    var activityIndicator: ActivityIndicatorView?
    var timer : Timer?
    // Vmock Logo
    @IBOutlet weak var communityLogo: UIImageView!
    @IBOutlet weak var communityLogoHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var communityLogoWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var communityLogoTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var communityNameLabel: UILabel!
    @IBOutlet weak var enclosingView: UIView!


    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailLabel.text = "\(StringConstants.resendVerificationScreenText) \(email!)"
        CommonFunctions().loadLogo(communityName: communityNameLabel, imageView: communityLogo, enclosingView: enclosingView,logo: UserDefaults.standard.object(forKey: "communityLogo") as? String,communityLogoName: UserDefaults.standard.object(forKey: "communityName") as? String)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        GoogleAnalyticsUtility().startScreenTrackingForScreenName("Login & Register: Verification Pending")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)         
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        timer?.invalidate()
        timer = nil
        (UIApplication.shared.delegate as! AppDelegate).checkLoginState()
    }
    
    @IBAction func resendVerificationLinkButtonTapped(_ sender: Any) {
        guard timer == nil else {
            backButtonTapped(self)
            return
        }
        let params = ["email": email]
        activityIndicator = ActivityIndicatorView.showActivity(view: self.navigationController!.view, message: StringConstants.resendVerificationApiLoader)
        ResendVerificationService().resendVerificationCall(params: params as Dictionary<String, AnyObject>, { response in
            if response["status"].bool! {
                CommonFunctions().showSuccess(title: "Success", message: StringConstants.resendVerificationSuccessText)
                GoogleAnalyticsUtility().logEvent(GoogleAnalyticsEvent(category: "Login & Register", action: "Resend Verification Link", label: "Success"))
                self.activityIndicator?.hide()
            }else{
                CommonFunctions().showError(title: "Error", message: "Could not send verification link to your email")
                self.activityIndicator?.hide()
            }
            self.setTimer()
        }, failure: {(error,errorCode) in
            self.activityIndicator?.hide()
            CommonFunctions().showError(title: "Error", message: error)
        })
    }
    
    func setTimer() {
        timer?.invalidate()
        timer = nil
        let date = Date()
        timer = Timer(fireAt: date.addingTimeInterval(3), interval: 0, target: self, selector: #selector(self.resetToCheckLoginState), userInfo: nil, repeats: false)
        RunLoop.current.add(timer!, forMode: .default)
    }
    
    @objc func resetToCheckLoginState() {
        (UIApplication.shared.delegate as! AppDelegate).checkLoginState()
    }
    
}
