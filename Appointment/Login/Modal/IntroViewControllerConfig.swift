//
//  IntroViewControllerConfig.swift
//  Resume
//
//  Created by Varun Wadhwa on 29/05/18.
//  Copyright © 2018 VM User. All rights reserved.
//

import Foundation
import UIKit
struct IntroViewControllerConfig {
    var headingTitle : String
    var subTitle : String
    var centerImage : UIImage?
    var screenTitle : String?
    
    init(headingTitle : String , subTitle : String , centerImage : UIImage? , screenTitle : String?) {
        self.headingTitle = headingTitle
        self.subTitle = subTitle
        self.centerImage = centerImage
        self.screenTitle = screenTitle
    }
}

extension IntroViewControllerConfig {
    
    static func getData() -> [IntroViewControllerConfig] {
        return [IntroViewControllerConfig.init(headingTitle: "Be Recruiter Ready", subTitle: "Our AI driven insights help you bridge the gap between your resume and recruiter needs" , centerImage: nil , screenTitle: "Does your RESUME tell your Story?" ) ,
                
                IntroViewControllerConfig.init(headingTitle: "SMART Resume Feedback", subTitle: "Our proprietary algorithms evaluate your resume against community benchmarks to visualise where you stand" , centerImage: nil , screenTitle: nil)  ,
                
                IntroViewControllerConfig.init(headingTitle: "Create an Impact", subTitle: "Actionable bullet-level insights and targeted resume guidance to help you stand out amongst others" , centerImage: nil , screenTitle : nil)
        ]
    }
    
}




