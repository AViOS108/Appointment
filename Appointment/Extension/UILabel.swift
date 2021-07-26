//  Created by Anurag Bhakuni on 15/01/20.
//  Copyright © 2020 Anurag Bhakuni. All rights reserved.



import Foundation
import UIKit


extension UILabel {
    

    public class func labelUIHandling (label : UILabel,text : String , textColor: UIColor? = nil , isBold : Bool, fontType : UIFont? = nil,  isCircular: Bool? = nil, isUnderlined: Bool? = nil, backgroundColor: UIColor? = nil, cornerRadius: Int? = nil, borderColor: UIColor? = nil, borderWidth: CGFloat? = nil) {
          
          label.text = text
          if let texcolor = textColor
          {
              label.textColor = texcolor
          }
          if let backgroundColor = backgroundColor {
              label.backgroundColor = backgroundColor
          }
          if let fontT = fontType {
              label.font = fontT;
          }
          if let isUnderlined =  isUnderlined {
              if isUnderlined {
                  let underlineAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue]
                  let underlineAttributedString = NSAttributedString(string: text, attributes: underlineAttribute)
                  label.attributedText = underlineAttributedString
              }
          }
          
          if let isCircular = isCircular{
              if isCircular{
                  label.layer.cornerRadius = label.frame.width / 2
                  label.layer.borderWidth = 0.0
                  label.layer.masksToBounds = true
              }
          }
          
          if let cornerRadius = cornerRadius {
              label.layer.cornerRadius = CGFloat(cornerRadius)
              label.layer.borderWidth = 0.0
              label.layer.masksToBounds = true
          }
          
          if let borderWidth = borderWidth {
              label.layer.borderWidth = borderWidth
          }
          
          if let borderColor = borderColor {
              label.layer.borderColor = borderColor.cgColor
          }
      }
   
    
    func fontwithType(type : Int){
        
        if type == 1{
            self.font = UIFont(name: "FontRegular".localized(), size: Device.FONTSIZETYPE17)
        }
        else if (type == 2){
            self.font = UIFont(name: "FontMedium".localized(), size: Device.FONTSIZETYPE17)
        }
        else if (type == 3){
            self.font = UIFont(name: "FontDemiBold".localized(), size: Device.FONTSIZETYPE17)
        }
        else
        {
            self.font = UIFont(name: "FontRegular".localized(), size: Device.FONTSIZETYPE17)
        }
    }
    
    
    
    
}
