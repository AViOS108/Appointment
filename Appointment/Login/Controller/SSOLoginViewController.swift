//
//  SSOLoginViewController.swift
//  Resume
//
//  Created by VMock Admin on 10/25/17.
//  Copyright © 2017 VM User. All rights reserved.
//

import UIKit

class SSOLoginViewController: UIViewController {

    var captchRequired = false
    var nameRequired = false
    var passwordRequired = false
    var link: String = ""
    @IBOutlet weak var communityLogo: UIImageView!
    @IBOutlet weak var communityLogoHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var communityLogoWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var communityNameLabel: UILabel!
    @IBOutlet weak var enclosingView: UIView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.backgroundColor = UIColor.clear
        link = UserDefaults.standard.object(forKey: "link") as! String
        CommonFunctions().loadLogo(communityName: communityNameLabel, imageView: communityLogo, enclosingView: enclosingView,logo: UserDefaults.standard.object(forKey: "communityLogoLocal") as? String,communityLogoName: UserDefaults.standard.object(forKey: "communityNameLocal") as? String)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        GoogleAnalyticsUtility().startScreenTrackingForScreenName("Login & Register: SSO Login")
    }
    
    @IBAction func universityIdButtonTapped( _ sender: Any){
        let provider = UserDefaults.standard.object(forKey: "ssoName") as! String
        let ssoUrl = UserDefaults.standard.object(forKey: "ssoUrl") as! String
        let ssoState = UserDefaults.standard.object(forKey: "ssoState") as! String
        let redirectUri = "https://\(Urls.runningHost)/?next=\(link)&&state=\(ssoState)"        
        let encodedRedirectUri = redirectUri.addingPercentEncoding(withAllowedCharacters: .alphanumerics)
        let encodeResult = "?return=\(String(describing: encodedRedirectUri!))".addingPercentEncoding(withAllowedCharacters: .alphanumerics)
        let url = URL(string: ssoUrl + encodeResult!)
        if var localUrl = url{
            localUrl.removeAllCachedResourceValues()
            let sso = UIStoryboard.socialLoginView()
            sso.url = localUrl
            sso.nameRequired = false
            sso.captchaRequired = false
            sso.passwordRequired = false
            sso.state = ssoState
            sso.redirectUri = redirectUri
            sso.provider = provider
            sso.link = link
            self.navigationController?.pushViewController(sso, animated: true)
        }
    }
    
    @IBAction func backButtonTapped( _ sender: Any){
        self.navigationController?.popViewController(animated: true)
    }
    
}
