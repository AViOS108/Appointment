//
//  NibView.swift
//  TestApp
//
//  Created by Shilpa on 28/07/18.
//  Copyright © 2018 Shilpa. All rights reserved.
//

import Foundation
import UIKit

class NibView: UIView {
    var view: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        // Setup view from .xib file
        xibSetup()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
            xibSetup()

        // Setup view from .xib file
    }
    
   

}

private extension NibView {
    
    
     func xibSetup() {
             backgroundColor = UIColor.clear
             view = loadNib()
             // use bounds not frame or it'll be offset
     //        view.frame = bounds
             
             self.frame.size.height = view.frame.size.height
             // Adding custom subview on top of our view
             addSubview(view)
             
             self.translatesAutoresizingMaskIntoConstraints = false
             view.translatesAutoresizingMaskIntoConstraints = false
             
             addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[childView]|",
                                                           options: [],
                                                           metrics: nil,
                                                           views: ["childView": view]))
             addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[childView]|",
                                                           options: [],
                                                           metrics: nil,
                                                           views: ["childView": view]))
             
             // Height constraint
             self.addConstraint(NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: view.frame.size.height))

         }
    
}
