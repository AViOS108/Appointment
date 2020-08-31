//
//  AgreementConsentViewController.swift
//  Resume
//
//  Created by Gaurav Gupta on 01/10/19.
//  Copyright © 2019 VM User. All rights reserved.
//

import UIKit

class AgreementConsentViewController: CustomizedViewController {
    
    @IBOutlet weak var communityLogo: UIImageView!
    @IBOutlet weak var enclosingView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var buttonsStack: UIStackView!
    
    var errorView: ErrorView?
    var activityIndicator: ActivityIndicatorView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let logo = UserDefaultsDataSource(key: "communityLogo").readData() as? String
        let communityLogoName = UserDefaultsDataSource(key: "communityName").readData() as? String
        CommonFunctions().loadLogo(imageView: communityLogo, enclosingView: enclosingView,logo: logo)
        getAgreement()
    }
    
    func getAgreement() {
        activityIndicator = ActivityIndicatorView.showActivity(view: view, message: "")
        LoginService().agreement({ (response) in
            self.activityIndicator?.hide()
            guard let title = response["title"].string, let content = response["content"].string else {
                self.dismiss()
                return
            }
            self.titleLabel.text = title
            self.contentLabel.text = content
            self.buttonsStack.isHidden = false
        }) { (error, errorCode) in
            self.activityIndicator?.hide()
            self.errorView = ErrorView.showOnView(self.view, forErrorOn: nil, errorCode: errorCode, completion: {
                self.getAgreement()
            })
        }
    }
    
    private func dismiss() {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func getTrackingParams(agreementAccepted: Bool) -> Dictionary<String, AnyObject>{
        let params = ["curr_url": "Urls.runningHost" + "/mobile/account/agreement",
                      "curr_base_url": Urls.runningHost,
                      "track_type":  "event",
                      "event_category":  "account_agreement",
                      "event_action":  "click",
                      "event_label":  "jump_page_\(agreementAccepted ? "accept" : "decline" )_btn"]
        return params as Dictionary<String, AnyObject>
    }
    
    
    @IBAction func declineButtonAction(_ sender: UIButton) {
        activityIndicator = ActivityIndicatorView.showActivity(view: view, message: "")
        TrackingServices().track(params: getTrackingParams(agreementAccepted: false
            ), { (_) in
                self.activityIndicator?.hide()
                LogoutHandler.logout(removeEmail: false)
        }) { (error, errorCode) in
            self.activityIndicator?.hide()
            CommonFunctions().showError(title: "", message: error)
        }
    }
    @IBAction func acceptButtonAction(_ sender: Any) {
        activityIndicator = ActivityIndicatorView.showActivity(view: view, message: "")
        TrackingServices().track(params: getTrackingParams(agreementAccepted: true
            ), { (_) in
                self.activityIndicator?.hide()
                UserDefaultsDataSource(key: "agreementConsent").writeData(false)
                self.dismiss()
        }) { (error, errorCode) in
            self.activityIndicator?.hide()
            CommonFunctions().showError(title: "", message: error)
        }
    }
}
