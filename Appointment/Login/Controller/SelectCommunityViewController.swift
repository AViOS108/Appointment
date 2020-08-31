//
//  SelectCommunityViewController.swift
//  Resume
//
//  Created by Manu Gupta on 21/06/17.
//  Copyright © 2017 VM User. All rights reserved.
//

import UIKit
import SwiftyJSON

class SelectCommunityViewController: UIViewController {

    @IBOutlet weak var communityNameLabel: UILabel!
    var communityName: String!
    var community: String!
    var captchaRequired = false
    var nameRequired = false
    var emailRequired = false
    var passwordRequired = false
    var email: String!
    var provider: String!
    var socialParams: Dictionary<String,AnyObject>!
    var socialHeader: Dictionary<String,String>!
    var name: String!
    var activityIndicator: ActivityIndicatorView?
    // Vmock Logo
    @IBOutlet weak var communityLogo: UIImageView!
    @IBOutlet weak var communityLogoHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var communityLogoWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var communityNameLogoLabel: UILabel!
    @IBOutlet weak var enclosingView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        communityNameLabel.text = "You can register as \(communityName!) community user or as a standard user"
        let communityLogoLocal = UserDefaultsDataSource(key: "communityLogoLocal").readData()
        let communityLogoName = UserDefaultsDataSource(key: "communityNameLocal").readData()
        CommonFunctions().loadLogo(communityName: communityNameLogoLabel, imageView: communityLogo, enclosingView: enclosingView,logo: communityLogoLocal as? String,communityLogoName: communityLogoName as? String)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        GoogleAnalyticsUtility().startScreenTrackingForScreenName("Login & Register: Select Community or Standard")
    }
    
    @IBAction func standardButtonTapped(_ sender: Any) {
        getProvidersApiDetails(link: "")
    }
    
    @IBAction func communityButtonTapped(_ sender: Any) {
        getProvidersApiDetails(link: community)
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
                let registerVC = UIStoryboard.register()
                registerVC.captchaRequired = self.captchaRequired
                registerVC.email = self.email
                registerVC.link = communityDetails["community"].string!
                registerVC.provider = self.provider
                registerVC.socialHeader = self.socialHeader
                registerVC.socialParams = self.socialParams
                registerVC.nameRequired = self.nameRequired
                registerVC.passwordRequired = self.passwordRequired
                registerVC.emailRequired = self.emailRequired
                if self.name != nil,self.name != "" {
                    registerVC.name = self.name
                }
                self.navigationController?.pushViewController(registerVC, animated: true)
            }
            
        }, failure: { (error,errorCode) in
            self.activityIndicator?.hide()
            CommonFunctions().showError(title: "Error", message: error)
        })
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
