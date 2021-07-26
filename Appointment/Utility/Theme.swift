//
//  Theme.swift
//  Resume
//
//  Created by Varun Wadhwa on 30/10/18.
//  Copyright © 2018 VM User. All rights reserved.
//

import Foundation
import UIKit

enum Theme {
    case communityUser , defaultUser
    
    var backgroundColor : UIColor {
        switch self {
        case .defaultUser:
            //  return UIColor.white
            return UIColor.fromHex(0xF1F0F0)
        case .communityUser:
            return  UIColor.fromHex(0xF1F0F0)
        }
    }
    
    var viewColor : UIColor {
        switch self {
        case .defaultUser:
            return UIColor.white
        case .communityUser:
            return  UIColor.fromHex(0xF1F0F0)
        }
    }
    
    var cardPadding : CGFloat {
        switch self {
        case .defaultUser:
            return 16
        case .communityUser:
            return  10
        }
    }
    
    var cardCornerRadius : CGFloat {
        switch self {
        case .defaultUser:
          return 15
        case .communityUser:
            return  0
        }
    }
    
}

class ThemeManager {
    static func currentTheme() -> Theme {
        return CommonFunctions().userHasNoCommunity() ? .defaultUser : .communityUser
    }
}


