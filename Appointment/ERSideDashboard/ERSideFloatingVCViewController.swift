//
//  ERSideFloatingVCViewController.swift
//  Appointment
//
//  Created by Anurag Bhakuni on 24/11/20.
//  Copyright © 2020 Anurag Bhakuni. All rights reserved.
//

import UIKit

//class ERSideFloatingVCViewController: UIViewController,UIGestureRecognizerDelegate {
//    
//    
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        // Do any additional setup after loading the view.
//    }
//    
//    
//    override func viewDidAppear(_ animated: Bool) {
//        self.view.tag = 19682
//        self.viewOuter.tag = 19683
//        tapGesture()
//        view.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.2)
//        viewOuter.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.2)
//        viewContainer.cornerRadius = 3;
//        
//        let fontHeavy = UIFont(name: "FontHeavy".localized(), size: Device.FONTSIZETYPE15)
//        UILabel.labelUIHandling(label: lblSetOpen, text: "Set Open Hours", textColor: .white, isBold: false, fontType: fontHeavy)
//        UILabel.labelUIHandling(label: lblNextStep, text: "Next Steps", textColor: .white, isBold: false, fontType: fontHeavy)
//        
//        imgViewSetOpen.image = UIImage.init(named: "Calendar")
//        imgViewNextStep.image = UIImage.init(named: "NextImage")
//        viewContainer.backgroundColor = ILColor.color(index: 25)
//        
//        
//               
//       
//       
//       
//
//    }
//    
//    override func viewDidLayoutSubviews() {
//        viewContainer.layoutIfNeeded()
//        let width = viewContainer.frame.size.width
//        let height = viewContainer.frame.size.height
//        
//        viewContainer.removeFromSuperview()
//        
//        self.viewOuter.addSubview(viewContainer)
//        viewContainer.frame = CGRect.init(x: frame.origin.x - width, y: frame.origin.y, width: width, height: height)
//        
//    }
//    
//    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
//        if touch.view?.isDescendant(of: self.view) == true  && touch.view?.tag != 19682 && touch.view?.tag != 19683  {
//            self.view.resignFirstResponder()
//            
//            return false
//        }
//        return true
//    }
//    
//    func tapGesture()  {
//        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
//        tap.delegate = self
//        self.viewOuter.isUserInteractionEnabled = true
//        self.viewOuter.addGestureRecognizer(tap)
//    }
//    
//    @objc func handleTap(_ sender: UITapGestureRecognizer) {
//        self.dismiss(animated: false) {
//        }
//    }
//    
//    
//    
//    override func viewWillAppear(_ animated: Bool) {
//       
//        
//    }
//    
//}
