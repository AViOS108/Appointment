//
//  Tooltip.swift
//  Resume
//
//  Created by apple on 27/02/17.
//  Copyright © 2017 VM User. All rights reserved.
//

import Foundation
import UIKit


class Tooltip :NSObject {

    private var label_title : UILabel
    private var view_container : UIView
    
//    Specs for label inside container
    private let topPadding :CGFloat = 2.0
    private let leftPadding :CGFloat = 6.0
    private let rightPadding :CGFloat = -6.0
    private let bottomPadding :CGFloat = -2.0
    private var labelFont = UIFont(name: "SanFranciscoText-Bold", size: 14)!
    
    var showAnimationCounter :Int = 0
    
//    Specs for caontainer
    
    private let topPadding_container :CGFloat = 1.0
    
    private let duration_showAnimation :TimeInterval = 0.7
    private let duration_tooltipDisplay :TimeInterval = 0.8
    private let duration_hideAnimation :TimeInterval = 0.5
    
    
    private let backgroundColor = ColorCode.applicationBlue
    private let labelColor = UIColor.white
    
    private var containerFrame : CGRect?
    
    class func addTooltip(_ toView: UIView) -> Tooltip
    {
        let tooltip = Tooltip()
        tooltip.addTooltip(toView)
        return tooltip
    }

    override init() {
        let classSize = UIScreen.main.traitCollection
        
        if classSize.horizontalSizeClass == .regular, classSize.verticalSizeClass == .regular {
            labelFont = UIFont(name: labelFont.fontName, size: 17)!
        }
        
        view_container = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        label_title = UILabel(frame: view_container.bounds)
        view_container.translatesAutoresizingMaskIntoConstraints = false
        label_title.translatesAutoresizingMaskIntoConstraints = false
        view_container.addSubview(label_title)
        
        view_container.addConstraint(NSLayoutConstraint(item: label_title, attribute: .top, relatedBy: .equal, toItem: view_container, attribute: .top, multiplier: 1.0, constant: topPadding))
        view_container.addConstraint(NSLayoutConstraint(item: label_title, attribute: .leading, relatedBy: .equal, toItem: view_container, attribute: .leading, multiplier: 1.0, constant: leftPadding))
        view_container.addConstraint(NSLayoutConstraint(item: label_title, attribute: .bottom, relatedBy: .equal, toItem: view_container, attribute: .bottom, multiplier: 1.0, constant: bottomPadding))
        view_container.addConstraint(NSLayoutConstraint(item: label_title, attribute: .trailing, relatedBy: .equal, toItem: view_container, attribute: .trailing, multiplier: 1.0, constant: rightPadding))
        
        
        view_container.clipsToBounds = true
        view_container.alpha = 0;
        
        view_container.backgroundColor = backgroundColor
        label_title.textColor = labelColor
        label_title.backgroundColor = UIColor.clear
        label_title.font = labelFont
        view_container.layer.cornerRadius = 3
        
        super.init()
    }
    
    func setTitle(_ title:String, animate : Bool) -> Void {
        
        label_title.text = title
        view_container.layoutIfNeeded()
        
        containerFrame = view_container.frame
        
        if animate
        {
            self.showAnimation()
        }
        else
        {
            view_container.alpha = 1.0
            view_container.layoutIfNeeded()
            self.perform(#selector(Tooltip.hideAnimation), with: nil, afterDelay: self.duration_tooltipDisplay)
        }
    }
    
    func showAnimation() {
        view_container.alpha = 0.0
        view_container.layoutIfNeeded()
        
        showAnimationCounter += 1
        UIView.animate(withDuration: duration_showAnimation) { 
         
        }
        
        UIView.animate(withDuration: duration_showAnimation, animations: { 
            self.view_container.alpha = 1.0
            self.view_container.layoutIfNeeded()
        }) { (completed) in
            self.perform(#selector(Tooltip.hideAnimation), with: nil, afterDelay: self.duration_tooltipDisplay)
            if completed
            {
                
            }
        }
    }
    
     @objc func hideAnimation() {
        if showAnimationCounter > 1 {
            showAnimationCounter -= 1
            return
        }
        
        showAnimationCounter -= 1
        
        UIView.animate(withDuration: duration_hideAnimation) {
            self.view_container.alpha = 0.0
            self.view_container.layoutIfNeeded()
        }
    }
    
    private func addTooltip(_ toView:UIView)
    {
        toView.addSubview(view_container)
        
        toView.addConstraint(NSLayoutConstraint(item: view_container, attribute: .top, relatedBy: .equal, toItem: toView, attribute: .top, multiplier: 1.0, constant: topPadding_container))
        toView.addConstraint(NSLayoutConstraint(item: view_container, attribute: .centerX, relatedBy: .equal, toItem: toView, attribute: .centerX, multiplier: 1.0, constant: 0))
        
        toView.superview?.layoutIfNeeded()
    }    
}
