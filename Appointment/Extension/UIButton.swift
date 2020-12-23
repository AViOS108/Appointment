//  Created by Anurag Bhakuni on 15/01/20.
//  Copyright © 2020 Anurag Bhakuni. All rights reserved.


import Foundation
import UIKit


extension UIButton {
  
    
    func selectedButton(title:String, iconName: String){
       
        self.setTitle(title, for: .normal)
        self.setImage(UIImage(named: iconName), for: .normal)
       
    }
    
    
    
    public class func buttonUIHandling(button: UIButton, text: String, backgroundColor: UIColor, textColor: UIColor? = nil, cornerRadius: Int? = nil,shadowColorIndex : Int? = nil,  buttonImage: UIImage? = nil, borderColor: UIColor? = nil, borderWidth: CGFloat? = nil, isTitleLeftAligned: Bool? = nil,isEnabled: Bool? = true, isUnderlined: Bool? = nil,fontType : UIFont? = nil) {
           
           button.setTitle(text, for: .normal)
           button.backgroundColor = backgroundColor
           
           if let textColor = textColor{
               button.setTitleColor(textColor, for: .normal)
           }
           
           if let isEnabled = isEnabled {
               if isEnabled {
                   button.isEnabled = true
               } else {
                   button.isEnabled = false
               }
           }
           
            button.titleLabel?.font = fontType

        
           if let radius = cornerRadius{
               button.layer.cornerRadius = CGFloat(radius)
               button.layer.masksToBounds = true
           }
           
           if let borderWidth = borderWidth {
               button.layer.borderWidth = borderWidth
           }
           
           if let borderColor = borderColor {
               button.layer.borderColor = borderColor.cgColor
           }
           
           if let shadow = shadowColorIndex {
            button.layer.shadowColor = ILColor.color(index: 1).cgColor
               button.layer.shadowOffset = CGSize.init(width: 0, height: 3)
               button.layer.shadowOpacity = 1.0
               button.layer.shadowRadius = 2.0
           }
           
           if let buttonImage = buttonImage {
               button.setImage(buttonImage, for: .normal)
               
//               if Device.IS_IPHONE_5 {
//                   button.imageEdgeInsets = UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)
//                   button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
//               } else {
//                   button.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
//                   button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
//               }
           }
           
           if let _ = isTitleLeftAligned {
//               button.contentHorizontalAlignment = .left
//               button.imageEdgeInsets = UIEdgeInsets(top: 5, left: 0, bottom: 5, right: -15)
//               button.titleEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 0, right:0)
               
           }
           
           if let isUnderlined =  isUnderlined {
               if isUnderlined {
                   let underlineAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue]
                   let underlineAttributedString = NSAttributedString(string: text, attributes: underlineAttribute)
                   button.setAttributedTitle(underlineAttributedString, for: .normal)
               }
           }
       }
       
    func alignTextUnderImage(spacing: CGFloat = 6.0) {
        if let image = self.imageView?.image {
            let imageSize: CGSize = image.size
            self.titleEdgeInsets = UIEdgeInsets(top: 50, left: 0, bottom: -(imageSize.height + 5), right: 0.0)
//            let labelString = NSString(string: ILDefinesSwift.properHandlingofOptional(param: self.titleLabel!.text!))
//
//            let titleSize = labelString.size(withAttributes: [NSAttributedString.Key.font: self.titleLabel!.font])
            
            self.imageEdgeInsets = UIEdgeInsets(top: -8, left: 0.0, bottom: 0.0, right: 0)
        }
    }
}
