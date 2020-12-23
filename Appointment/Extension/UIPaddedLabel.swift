//
//  UIPaddedLabel.swift
//  Indialends
//
//  Created by IndiaLends on 10/01/19.
//  Copyright © 2019 IndiaLends. All rights reserved.
//

import Foundation
import UIKit



extension String {
    var isBlank: Bool {
        return allSatisfy({ $0.isWhitespace })
    }
   
}

public class UIPaddedLabel: UILabel {
    
    @IBInspectable var topInset: CGFloat = 5.0
    @IBInspectable var bottomInset: CGFloat = 5.0
    @IBInspectable var leftInset: CGFloat = 10.0
    @IBInspectable var rightInset: CGFloat = 10.0
    
    public override func drawText(in rect: CGRect) {
      
        super.drawText(in: rect.inset(by: UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)))
    }
    
    public override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + leftInset + rightInset,
                      height: size.height + topInset + bottomInset)
    }
    
    public override func sizeToFit() {
        super.sizeThatFits(intrinsicContentSize)
    }
}
