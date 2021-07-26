//
//  SelectUserTypeViewController.swift
//  Event
//
//  Created by Anurag Bhakuni on 25/01/20.
//  Copyright © 2020 Anurag Bhakuni. All rights reserved.
//

import UIKit
//import Crashlytics

class SelectUserTypeViewController: UIViewController {
    
    @IBOutlet weak var lblLoginas: UILabel!
    @IBOutlet weak var viewBlur: UIView!
    
    @IBOutlet weak var btnER: UIButton!
    @IBOutlet weak var btnStudent: UIButton!
    @IBOutlet weak var btnCoach: UIButton!
    @IBOutlet weak var btnAlumini: UIButton!
    
    
    
    @IBAction func btnStudentTapped(_ sender: Any) {
        
        let vc = LoginNavigationViewController.getLoginNavigationViewController()
        //        vc.modalPresentationStyle = .fullScreen
        
        UserDefaultsDataSource(key: "student").writeData(true);
        self.present(vc, animated: false) {
        };
    }
    
    @IBAction func btnERTapped(_ sender: Any) {
        UserDefaultsDataSource(key: "student").writeData(false);
        
        let vc = ERLoginViewController.init(nibName: "ERLoginViewController", bundle: nil);
        vc.viewTypeEr = .onlyEmail
        let navigationER = UINavigationController.init(rootViewController: vc);
        //        navigationER.modalPresentationStyle = .fullScreen
        
        self.present(navigationER, animated: false) {
            
        };
    }
    
    @IBAction func btnCoachTapped(_ sender: Any) {
        UserDefaultsDataSource(key: "student").writeData(false);
        
        let vc = ERLoginViewController.init(nibName: "ERLoginViewController", bundle: nil);
        vc.viewTypeEr = .onlyEmail
        let navigationER = UINavigationController.init(rootViewController: vc);
        //        navigationER.modalPresentationStyle = .fullScreen
        
        self.present(navigationER, animated: false) {
            
        };
    }
    
    
    @IBAction func btnAluminiTapped(_ sender: Any) {
        UserDefaultsDataSource(key: "student").writeData(false);
        
        let vc = ERLoginViewController.init(nibName: "ERLoginViewController", bundle: nil);
        vc.viewTypeEr = .onlyEmail
        let navigationER = UINavigationController.init(rootViewController: vc);
        //        navigationER.modalPresentationStyle = .fullScreen
        
        self.present(navigationER, animated: false) {
            
        };
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        self.customization();
        //fatalError()
        
        
    }
    
    // MARK: - Customization
    
    func customization()
    {
        self.view.backgroundColor = ILColor.color(index: 22)
        
        self.navigationController?.navigationBar.isHidden = true;
        self.viewBlur.backgroundColor = .clear;
        
        if let FontDemiBold = UIFont(name: "FontHeavy".localized(), size: Device.FONTSIZETYPE18)
        {
            
            UIButton.buttonUIHandling(button: btnStudent, text: "Student".localized(), backgroundColor:ILColor.color(index: 23) , textColor: ILColor.color(index: 3), cornerRadius: 5, isTitleLeftAligned : true, isUnderlined: false, fontType: FontDemiBold)
            UIButton.buttonUIHandling(button: btnER, text: "ER".localized(), backgroundColor: ILColor.color(index: 23), textColor: ILColor.color(index: 3), cornerRadius: 5,isTitleLeftAligned : true, isUnderlined: false, fontType: FontDemiBold)
            UIButton.buttonUIHandling(button: btnCoach, text: "Coach".localized(), backgroundColor: ILColor.color(index: 23), textColor: ILColor.color(index: 3), cornerRadius: 5,isTitleLeftAligned : true, isUnderlined: false, fontType: FontDemiBold)
            UIButton.buttonUIHandling(button: btnAlumini, text: "Alumni".localized(), backgroundColor: ILColor.color(index: 23), textColor: ILColor.color(index: 3), cornerRadius: 5,isTitleLeftAligned : true, isUnderlined: false, fontType: FontDemiBold)
            
            
        }
        if let FontHeavy = UIFont(name: "FontHeavy".localized(), size: Device.FONTSIZETYPE20)
        {
            
            UILabel.labelUIHandling(label: lblLoginas, text: "Login as".localized(), textColor: ILColor.color(index: 4), isBold: false, fontType: FontHeavy);
        }
    }
   
    
}
