//
//  SplashWithLoaderViewControllerViewController.swift
//  Resume
//
//  Created by Gaurav Gupta on 01/11/17.
//  Copyright © 2017 VM User. All rights reserved.
//

import UIKit

class SplashWithLoaderViewControllerViewController: UIViewController {
    
    let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 37, height: 37))
    let splash = UIImageView(image: #imageLiteral(resourceName: "Splash Icon"))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSplash()
        setupLoader()
    }
    
    private func setupSplash() {
        view.addSubview(splash, withCenterConstraints: CGPoint.zero)
    }
    
    private func setupLoader() {
        
        activityIndicator.style = .whiteLarge
        activityIndicator.color = ColorCode.textColor
        view.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraint(NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal, toItem: activityIndicator, attribute: .bottom, multiplier: 1, constant: 38))
        view.addConstraint(NSLayoutConstraint(item: view, attribute: .centerX, relatedBy: .equal, toItem: activityIndicator, attribute: .centerX, multiplier: 1, constant: 0))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func start() {
        
        activityIndicator.startAnimating()
    }
    
    func stop() {
        
        activityIndicator.stopAnimating()
    }
    
    
}
