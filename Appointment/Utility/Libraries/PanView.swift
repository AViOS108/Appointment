//
//  PanView.swift
//  PanView
//
//  Created by Gaurav on 01/03/17.
//  Copyright © 2017 Gaurav. All rights reserved.
//

import UIKit



protocol PanViewDatasource : class {
    func panViewHeightOfDraggableView () -> CGFloat
    func panViewHeightOfContainerView () -> CGFloat
}

@objc protocol PanViewDelegate : class {
    @objc optional func panView(_ panview : PanView, didChangeHeightOfContainerTo height: CGFloat)
    @objc optional func panView(_ panview : PanView, willChangeHeightOfContainerWithAnimationTo height: CGFloat)
}


class PanView: UIView {
    
    var view_container : UIView?
    var view_draggable : UIView?
    
    var imageView : UIImageView?
    var overlay : UIImageView?
    
    let overlay_alphaMax = 0.7
    
    var panGesture : UIPanGestureRecognizer?
    var tap : UITapGestureRecognizer?
    
    var height_draggableView :CGFloat = 0
    var heightMax_containerView :CGFloat {
        get {
            return (self.superview?.frame.height)! - 30
        }
    }
    var initialWidth : CGFloat = 0
    
    weak var datasource : PanViewDatasource?
    weak var delegate : PanViewDelegate?
    
    var constraint_containerHeight : NSLayoutConstraint?
    
    let color_draggableViewBG = ColorCode.applicationBlue
    var isShowingAnalytics : Bool {
        
        get {
            
            if let height = constraint_containerHeight?.constant, height > 0 {
                return true
            }
            
            return false
        }
    }
    
    class func addPanViewToView(_ view : UIView) -> PanView
    {
        let screenSize = UIScreen.main.bounds.size
        let pv = PanView(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: 30))
        pv.addPanViewToView(view)
        pv.addOverlayOnView(view)
        
        view.layer.addObserver(pv, forKeyPath: "bounds", options: NSKeyValueObservingOptions.new, context: nil)
        
        
        return pv
    }
    
    //    override func layoutSubviews() {
    //        super.layoutSubviews()
    //
    //        if
    //
    //    }
    
    func addPanViewToView(_ view : UIView) -> Void {
        
        self.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(self)
        
        view.addConstraint(NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1.0, constant: 0.0)) // Top
        view.addConstraint(NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1.0, constant: 0.0)) // Leading
        view.addConstraint(NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1.0, constant: 0.0)) // Trailing
    }
    
    func addOverlayOnView(_ view : UIView) -> Void {
        overlay = UIImageView(frame: view.bounds)
        overlay?.backgroundColor = UIColor.black
        overlay?.alpha = 0
        
        view.addSubview(overlay!, withInsetConstraints: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0 ))
        view.bringSubviewToFront(self)
    }
    
    func setup() -> Void
    {
        self.backgroundColor = UIColor.white
        setupContainerView()
        setupDraggableView()
        addPanGestue()
        addTapGesture()
        
        self.layoutIfNeeded()
    }
    
    private func setupContainerView()
    {
        view_container = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 0))
        view_container?.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(view_container!)
        
        //        heightMax_containerView = datasource?.panViewHeightOfContainerView() ?? 0
        
        self.addConstraint(NSLayoutConstraint(item: view_container!, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0.0)) // Top
        self.addConstraint(NSLayoutConstraint(item: view_container!, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0.0)) // Leading
        self.addConstraint(NSLayoutConstraint(item: view_container!, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: 0.0)) // Trailing
        
        constraint_containerHeight = NSLayoutConstraint(item: view_container!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 0) // Height
        constraint_containerHeight?.priority = UILayoutPriority.defaultLow
        self.addConstraint(constraint_containerHeight!)
        
        view_container!.layer.addObserver(self, forKeyPath: "bounds", options: NSKeyValueObservingOptions.new, context: nil)
    }
    
    
    
    private func setupDraggableView()
    {
        height_draggableView = datasource?.panViewHeightOfDraggableView() ?? 0
        view_draggable = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: height_draggableView))
        view_draggable?.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(view_draggable!)
        
        self.addConstraint(NSLayoutConstraint(item: view_draggable!, attribute: .top, relatedBy: .equal, toItem: view_container, attribute: .bottom, multiplier: 1.0, constant: 0.0)) // Top
        self.addConstraint(NSLayoutConstraint(item: view_draggable!, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0.0)) // Leading
        self.addConstraint(NSLayoutConstraint(item: view_draggable!, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: 0.0)) // Trailing
        self.addConstraint(NSLayoutConstraint(item: view_draggable!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: height_draggableView))  // Height
        self.addConstraint(NSLayoutConstraint(item: view_draggable!, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0.0)) // Bottom
        view_draggable!.backgroundColor = color_draggableViewBG
        addImageViewToDraggableView()
        addShadow(view: view_draggable!)
    }
    func addShadow(view : UIView)
    {
        guard initialWidth != view.bounds.width else {
            return
        }
        initialWidth = view.bounds.width
        
        let shadowPath = UIBezierPath(rect: view.bounds)
        view.layer.masksToBounds = false;
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width : 0.0, height : 2.0);
        view.layer.shadowOpacity = 0.5;
        view.layer.shadowPath = shadowPath.cgPath;
    }
    
    func addImageViewToDraggableView() -> Void {
        
        let width :CGFloat = 26
        let height :CGFloat = 26
        
        imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        imageView!.translatesAutoresizingMaskIntoConstraints = false
        view_draggable?.addSubview(imageView!)
        
        imageView!.addConstraint(NSLayoutConstraint(item: imageView!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: height))
        imageView!.addConstraint(NSLayoutConstraint(item: imageView!, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: width))
        view_draggable!.addConstraint(NSLayoutConstraint(item: imageView!, attribute: .centerX, relatedBy: .equal, toItem: view_draggable!, attribute: .centerX, multiplier: 1.0, constant: 0.0))
        view_draggable!.addConstraint(NSLayoutConstraint(item: imageView!, attribute: .centerY, relatedBy: .equal, toItem: view_draggable!, attribute: .centerY, multiplier: 1.0, constant: 0.0))
        
        //        imageView?.backgroundColor = UIColor.red
        imageView?.image = #imageLiteral(resourceName: "SliderArrow")
    }
    
    private func addTapGesture()
    {
        tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(recognizer:)))
        view_draggable?.addGestureRecognizer(tap!)
    }
    
    @objc private func handleTap(recognizer:UITapGestureRecognizer)
    {
        if constraint_containerHeight?.constant == 0
        {
            animateDraggableViewToHeight(heightMax_containerView, withVelocity: 300)
            
        }
        else
        {
            animateDraggableViewToHeight(0, withVelocity: 300)
        }
    }
    func close (){
        if isShowingAnalytics
        {
            handleTap(recognizer: tap!)
            
        }
    }
    
    
    private func addPanGestue()
    {
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(recognizer:)))
        view_draggable?.addGestureRecognizer(panGesture!)
    }
    
    @objc private func handlePan(recognizer:UIPanGestureRecognizer)
    {
        var newHeight : CGFloat = 0
        let translation = recognizer.translation(in: self)
        newHeight = constraint_containerHeight!.constant + translation.y
        if(newHeight > -1 && newHeight <= heightMax_containerView)
        {
            constraint_containerHeight!.constant = newHeight
            self.layoutIfNeeded()
            recognizer.setTranslation(CGPoint.zero, in: self)
        }
        
        if recognizer.state == .ended
        {
            let velocity = recognizer.velocity(in: self)
            let magnitude = sqrt(velocity.y*velocity.y)
            let slideMultiplier = magnitude / 200
            
            if slideMultiplier >= 1
            {
                if velocity.y > 0
                {
                    newHeight = heightMax_containerView
                }
                else{
                    newHeight = 0
                }
            }
            else
            {
                if constraint_containerHeight!.constant >= heightMax_containerView/2
                {
                    newHeight = heightMax_containerView
                }
                else
                {
                    newHeight = 0
                }
            }
            animateDraggableViewToHeight(newHeight,withVelocity: velocity.y)
        }
    }
    
    func animateDraggableViewToHeight(_ height : CGFloat, withVelocity velocity : CGFloat) -> Void {
        let dis = abs(constraint_containerHeight!.constant - height)
        constraint_containerHeight!.constant = height
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: velocity/dis, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.superview!.layoutIfNeeded()
        }, completion: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let object = object as? CALayer, object == view_container!.layer{
            if  keyPath == "bounds"{
                let frame = change?[NSKeyValueChangeKey.newKey] as! CGRect
                didChangeHeightOfContainerView(frame.height)
            }
        }else{
            if  keyPath == "bounds"{
                if constraint_containerHeight?.constant != 0{
                    animateDraggableViewToHeight(heightMax_containerView, withVelocity: 300)
                }
            }
        }
        
        addShadow(view: view_draggable!)
    }
    
    func didChangeHeightOfContainerView(_ height : CGFloat) -> Void {
        
        //        imageView!.translatesAutoresizingMaskIntoConstraints = true
        delegate?.panView!(self, didChangeHeightOfContainerTo: height)
        
        let rads = Double(height/heightMax_containerView) * M_PI
        let transform = CGAffineTransform.init(rotationAngle: CGFloat(rads))
        imageView!.transform = transform
        
        overlay?.alpha = CGFloat(Double(height/heightMax_containerView) * overlay_alphaMax)
        
    }
    
    override func removeFromSuperview() {
        view_container!.layer.removeObserver(self, forKeyPath: "bounds")
        superview!.layer.removeObserver(self, forKeyPath: "bounds")
        super.removeFromSuperview()
    }
    
}
