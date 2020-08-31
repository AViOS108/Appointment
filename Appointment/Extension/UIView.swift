//  Created by Anurag Bhakuni on 15/01/20.
//  Copyright © 2020 Anurag Bhakuni. All rights reserved.

import UIKit


extension Bundle {

    static func loadView<T>(fromNib name: String, withType type: T.Type) -> T {
        if let view = Bundle.main.loadNibNamed(name, owner: nil, options: nil)?.first as? T {
            return view
        }

        fatalError("Could not load view with type " + String(describing: type))
    }
}

extension UIView {
   
   
    
    class func fromNib<T: UIView>() -> T {
        return Bundle.main.loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
    
    func applyGradient() {
//        self.applyGradient(colours: UIView.arrBGColors as! [UIColor], locations: nil)
    }
    
    func applyGradientFading(colors: [UIColor]) {
        self.applyGradient(colours: colors, locations: nil)
    }
    
    func applyGradientFadingForTransactions() {
        let transactionColors = [ILColor.color(index: 75), UIColor.white]
        self.applyGradient(colours: transactionColors , locations: nil)
    }
    
    func applyGradient(colours: [UIColor], locations: [NSNumber]?) {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.frame
        gradient.colors = colours.map { $0.cgColor }
        gradient.locations = locations
        self.layer.insertSublayer(gradient, at: 0)
    }
    
    func dropShadowBottom() {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 2
    }
    
    func dropShadow() {
       self.clipsToBounds = false
        self.layer.shadowColor = ILColor.color(index: 5).cgColor
        self.layer.shadowOpacity = 1
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowRadius = 2
        self.layer.cornerRadius = 10
       
    }
    
    func dropShadowER() {
          self.clipsToBounds = false
           self.layer.shadowColor = ILColor.color(index: 5).cgColor
           self.layer.shadowOpacity = 1
           self.layer.shadowOffset = CGSize.zero
           self.layer.shadowRadius = 2
           self.layer.cornerRadius = 3
          
       }
    
    func dropShadowDate() {
       self.clipsToBounds = false
        self.layer.shadowColor = ILColor.color(index: 5).cgColor
        self.layer.shadowOpacity = 1
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowRadius = 2
        self.layer.cornerRadius = 3
       
    }
    
    func dropShadowWithoutCornerRadius() {
          self.clipsToBounds = false
           self.layer.shadowColor = ILColor.color(index: 5).cgColor
           self.layer.shadowOpacity = 1
           self.layer.shadowOffset = CGSize.zero
           self.layer.shadowRadius = 2
          
       }
    
    func dropShadowEmiReminder() {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowRadius = 6
        layer.cornerRadius = 5
    }
    
    func dropShadowAllSides() {
        layer.masksToBounds = false
        
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOffset = CGSize.init(width:0,height:10)
        layer.shadowRadius = 13
        layer.shadowOpacity = 0.40
        layer.cornerRadius = 8
    }
    
    func dropShadowdashPq() {
        layer.masksToBounds = false
        layer.shadowColor = ILColor.color(index: 106).cgColor
        layer.shadowOffset = CGSize.init(width:0,height:16)
        layer.shadowRadius = 10
        layer.shadowOpacity = 0.50
        layer.cornerRadius = 8
    }
    
    /** Loads instance from nib with the same name. */
    func loadNib() -> UIView {
           let bundle = Bundle(for: type(of: self))
           let nibName = type(of: self).description().components(separatedBy: ".").last!
           let nib = UINib(nibName: nibName, bundle: bundle)
           return nib.instantiate(withOwner: self, options: nil).first as! UIView
       }
    
    func addingProgramitically(superView: UIView)   {
        let bundle = Bundle(for: type(of: self))
        let nibName = type(of: self).description().components(separatedBy: ".").last!
        let nib = UINib(nibName: nibName, bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        view.frame = CGRect.init(x: 0, y: 0, width: superView.frame.width, height: superView.frame.height);
        superView.addSubview(view);
        
//        return view
    }
    
    
    func curveViewFromLeft() {
        
        let path = UIBezierPath(roundedRect:self.bounds,
                                byRoundingCorners:[.topLeft, .bottomLeft],
                                cornerRadii: CGSize(width: 20, height:  20))
        
        let maskLayer = CAShapeLayer()
        
        maskLayer.path = path.cgPath
        self.layer.mask = maskLayer
//        self.backgroundColor = ILDefines.objectiveColor(toSwiftwithType: 27)
    }
    
    func addConstraintsWithFormatString(formate: String, views: UIView...) {
        
        var viewsDictionary = [String: UIView]()
        
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            view.translatesAutoresizingMaskIntoConstraints = false
            viewsDictionary[key] = view
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: formate, options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: viewsDictionary))
        
    }
}
