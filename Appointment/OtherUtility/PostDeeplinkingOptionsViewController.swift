//
//  PostDeeplinkingOptionsViewController.swift
//  Resume
//
//  Created by Gaurav Gupta on 06/11/17.
//  Copyright © 2017 VM User. All rights reserved.
//

import UIKit

enum PostDeeplinkingOptions {
    case referral
    case community
}

class PostDeeplinkingOptionsViewController: UIViewController {

    var option : PostDeeplinkingOptions?
    let splash = UIImageView(image: #imageLiteral(resourceName: "Splash Icon"))
    var info = [String:Any]()
    let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 37, height: 37))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSplash()
        setupLoader()
        // Do any additional setup after loading the view.
    }
    private func setupSplash() {
        view.addSubview(splash, withCenterConstraints: CGPoint(x: 0, y: -150))
    }
    
    private func setupLoader() {
        activityIndicator.style = .gray
        activityIndicator.color = ColorCode.textColor
        view.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraint(NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal, toItem: activityIndicator, attribute: .bottom, multiplier: 1, constant: 38))
        view.addConstraint(NSLayoutConstraint(item: view, attribute: .centerX, relatedBy: .equal, toItem: activityIndicator, attribute: .centerX, multiplier: 1, constant: 0))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let option = self.option {
            switch option {
            case .community:
                getProvidersApiDetails()
            default:
                self.createAlertController()
            }
        }
        else {
            self.createAlertController()
        }
    }
    
    func getProvidersApiDetails(){
        activityIndicator.startAnimating()
        ProviderServcie().providerServcieCall(link: info["link"] as! String,{ response in
            self.activityIndicator.stopAnimating()
            self.createAlertController()
        }, failure: { (error,errorCode) in
            self.activityIndicator.stopAnimating()
            if errorCode == 404{
                if self.info["url"] != nil{
                    (UIApplication.shared.delegate as? AppDelegate)?.checkLoginState()
                }
            }else{
                if ErrorView.canShowForErrorCode(errorCode){
                    ErrorView.showOnView(self.view, forErrorOn: nil, errorCode: errorCode, completion: {
                        self.getProvidersApiDetails()
                    })
                }else{
                    CommonFunctions().showError(title: "Error", message: error)
                }
            }
        })
    }
    
    func createAlertController(){
        let userEmail = UserDefaultsDataSource(key: "userEmail").readData() as? String
        guard let email = userEmail else {
            return
        }
        
        let alertController = UIAlertController(title: "Alert", message: "\(StringConstants.alreadyLoginText) as \(email)", preferredStyle: .alert)
        
        let continueActionButton = UIAlertAction(title:"Continue" , style: .default) { action -> Void in            
            (UIApplication.shared.delegate as? AppDelegate)?.checkLoginState()
        }
        alertController.addAction(continueActionButton)
        
        let startFreshActionButton = UIAlertAction(title: "New user", style: .default) { action -> Void in
            if let option = self.option {
                switch option {
                case .community:
                    UserDefaultsDataSource(key: "link").writeData(self.info["link"] as? String ?? "")
                default:
                    break
                }
                LogoutHandler.logout(removeEmail: true)
            }
        }
        alertController.addAction(startFreshActionButton)
        
        self.present(alertController, animated: true, completion: nil)
    }
}
