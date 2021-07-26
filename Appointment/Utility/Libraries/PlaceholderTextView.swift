//
//  PlaceholderTextView.swift
//  Resume
//
//  Created by apple on 21/03/17.
//  Copyright © 2017 VM User. All rights reserved.
//

import UIKit
import MBAutoGrowingTextView

class PlaceholderTextView: UITextView {

    var placeHolderText = ""
    var placeHolderTextColor = UIColor.lightGray
    var isShowingPlaceholder = false
    var normalColor = UIColor.black
    var mainText : String!{
    
        get {
            if isShowingPlaceholder
            {
                return ""
            }
            else
            {
                return text
            }
        }
    }
   
        
    
    
    func setPlaceholder(_ placeholder : String, with color : UIColor, normalColor : UIColor, isShowing : Bool)
    {
        placeHolderText = placeholder
        placeHolderTextColor = color
        self.normalColor = normalColor
        isShowingPlaceholder = isShowing
        
        if isShowingPlaceholder
        {
            text = placeHolderText
            textColor = placeHolderTextColor
        }
    }
    
}



