//
//  IntroViewController.swift
//  Resume
//
//  Created by Varun Wadhwa on 28/05/18.
//  Copyright © 2018 VM User. All rights reserved.
//

import UIKit

class IntroViewController: UIViewController {
    
    @IBOutlet weak var centerImageView : UIImageView!
    @IBOutlet weak var headingTitleLabel : UILabel!
    @IBOutlet weak var subTitleLabel : UILabel!
    @IBOutlet weak var screenTitleLabel: UILabel!
    
    @IBOutlet weak var centerGraphView: UIView!
    
    var centerImage : UIImage?
    var headingTitle : String?
    var subTitle : String?
    var screenTitle : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
        self.view.backgroundColor = UIColor.clear
    }
    
    func setView() {
        if let image = centerImage {
            centerImageView.image = image
        } else {
            if let _ = screenTitle {
                setGif()
            } else {
               // centerGraphView.isHidden = false
            }
        }
        
        if let headingTitle = headingTitle {
            headingTitleLabel.text = headingTitle
        }
        if let subTitle = subTitle {
            subTitleLabel.text = subTitle
        }
        if let screenTitle = screenTitle {
            self.screenTitleLabel.colorString(text: screenTitle ,
                                       coloredStrings: "RESUME","Story" )
        } else {
            screenTitleLabel.isHidden = true
        }
    }
    
    func setGif() {
        let url = Bundle.main.url(forResource: "resumeOnboarding", withExtension: "gif")
        if let url = url  {
            let data = try? Data.init(contentsOf: url)
//            centerImageView.image = UIImage.sd
        }
    }
    
    func setGraph() {
        
    }
    
}
