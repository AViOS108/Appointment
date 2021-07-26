//
//  WaitingForApprovalViewController.swift
//  Resume
//
//  Created by VM User on 08/03/17.
//  Copyright © 2017 VM User. All rights reserved.
//

import UIKit

class WaitingForApprovalViewController: UIViewController {

    @IBOutlet weak var messageLabel: UILabel!
    var message = ""
    // Vmock Logo
    @IBOutlet weak var communityLogo: UIImageView!
    @IBOutlet weak var communityLogoHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var communityLogoWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var communityLogoTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var communityNameLabel: UILabel!
    @IBOutlet weak var enclosingView: UIView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        messageLabel.text = message
        CommonFunctions().loadLogo(communityName: communityNameLabel, imageView: communityLogo, enclosingView: enclosingView,logo: UserDefaults.standard.object(forKey: "communityLogo") as? String,communityLogoName: UserDefaults.standard.object(forKey: "communityName") as? String)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        GoogleAnalyticsUtility().startScreenTrackingForScreenName("Login & Register: Admin Approval")
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        (UIApplication.shared.delegate as! AppDelegate).checkLoginState()
    }
}
