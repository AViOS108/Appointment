//
//  ActivityIndicatorView.swift
//  Resume
//
//  Created by VM User on 28/03/17.
//  Copyright © 2017 VM User. All rights reserved.
//

import Foundation
import UIKit

open class ActivityIndicatorView: UIView{
    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var loaderImage: UIImageView!
    
    @IBOutlet weak var loaderArcImage: UIImageView!
    
    var isShown: Bool {
        return self.superview != nil
    }
    
    class func instanceFromNib() -> ActivityIndicatorView {
        return UINib(nibName: "ActivityIndicatorView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! ActivityIndicatorView
       
    }
    
    class func showActivity(view: UIView,message: String) -> ActivityIndicatorView{
        let activityIndicatorInstance = ActivityIndicatorView.instanceFromNib()
        activityIndicatorInstance.showActivityIndicator(view: view, message: message)
        activityIndicatorInstance.layer.zPosition = CGFloat(Float.greatestFiniteMagnitude)
        return activityIndicatorInstance
    }
    
    private func showActivityIndicator(view: UIView,message: String){
        loaderArcImage.image = loaderArcImage.image!.withRenderingMode(.alwaysTemplate)
        view.addSubview(self, withInsetConstraints: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        self.messageLabel.isHidden = false
        self.messageLabel.text = message
        rotateAnimation(imageView: loaderArcImage)
        self.superview?.layoutIfNeeded()
    }
    
    func rotateAnimation(imageView: UIImageView,duration: CFTimeInterval = 1.25) {
        DispatchQueue.main.async {
            let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
            rotateAnimation.fromValue = 0.0
            self.loaderArcImage.clipsToBounds = true
            rotateAnimation.toValue = CGFloat(Double.pi * 2.0)
            rotateAnimation.duration = duration
            rotateAnimation.repeatCount = Float.greatestFiniteMagnitude;
            imageView.layer.add(rotateAnimation, forKey: nil)
        }
        
    }
    
    func hide(){
        DispatchQueue.main.async {
            self.removeFromSuperview()
        }        
    }
}
