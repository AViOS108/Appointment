//
//  ResumeNotEnabledViewController.swift
//  Resume
//
//  Created by Manu Gupta on 21/06/17.
//  Copyright © 2017 VM User. All rights reserved.
//

import UIKit

class ResumeNotEnabledViewController: UIViewController {
    
    @IBOutlet weak var messageLabel: UILabel!
    // Vmock Logo
    @IBOutlet weak var communityLogo: UIImageView!
    @IBOutlet weak var communityLogoHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var communityLogoWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var communityLogoTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var communityNameLabel: UILabel!
    @IBOutlet weak var enclosingView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messageLabel.text = StringConstants.notAvailableForCommunityText
        CommonFunctions().loadLogo(communityName: communityNameLabel, imageView: communityLogo, enclosingView: enclosingView,logo: UserDefaults.standard.object(forKey: "communityLogo") as? String,communityLogoName: UserDefaults.standard.object(forKey: "communityName") as? String)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        GoogleAnalyticsUtility().startScreenTrackingForScreenName("Login & Register: Community Not Enabled")
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        (UIApplication.shared.delegate as! AppDelegate).checkLoginState()
    }
}
