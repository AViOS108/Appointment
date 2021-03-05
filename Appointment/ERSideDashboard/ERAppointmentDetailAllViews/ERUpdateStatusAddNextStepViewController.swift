//
//  ERUpdateStatusAddNextStepViewController.swift
//  Appointment
//
//  Created by Anurag Bhakuni on 14/01/21.
//  Copyright © 2021 Anurag Bhakuni. All rights reserved.
//

import UIKit

class ERUpdateStatusAddNextStepViewController: UIViewController,UITextViewDelegate {

    
    @IBOutlet weak var viewinner: UIView!
       
         @IBOutlet weak var viewContainer: UIView!
         @IBOutlet weak var lblHeader: UILabel!
         var results: ERSideAppointmentModalResult!

       @IBOutlet var viewSeprators: [UIView]!
         
         @IBOutlet weak var lblFooterInfo1: UILabel!
         
         @IBOutlet weak var lblFooterInfo2: UILabel!
         
         @IBOutlet weak var txtView: UITextView!
         
         @IBOutlet weak var btnSubmit: UIButton!
         
         @IBAction func btnSubmitTapped(_ sender: Any) {
         }
         
       @IBOutlet weak var btnFooterInfo1: UIButton!
       
       @IBAction func btnFooterInfo1Tapped(_ sender: Any) {
       }
       
       
       @IBOutlet weak var btnFooterInfo2: UIButton!
       
       @IBAction func btnFooterInfo2Tapped(_ sender: Any) {
       }
    
    
    @IBOutlet weak var txtDateTime: UITextField!
    
    @IBAction func btnDateTimeTapped(_ sender: Any) {
    }
    @IBOutlet weak var btnDateTime: UIButton!
    @IBOutlet weak var segAttendedNon: UISegmentedControl!
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


      func customize()  {
          self.viewSeprators.forEach { (view) in
              view.backgroundColor = ILColor.color(index: 22)
          }
          let fontMedium = UIFont(name: "FontMediumWithoutNext".localized(), size: Device.FONTSIZETYPE13)
          
          UILabel.labelUIHandling(label: lblHeader, text: "Add Notes", textColor: ILColor.color(index: 28), isBold: false, fontType: fontMedium)
          self.addInputAccessoryForTextView(textVIew: txtView )
          txtView.backgroundColor = ILColor.color(index: 22)
          txtView.autocorrectionType = .no
          txtView.spellCheckingType = .no
          txtView.font = fontMedium
          txtView.delegate = self
          txtView.layer.borderWidth = 1;
          txtView.layer.borderColor = ILColor.color(index: 22).cgColor
          txtView.textColor = .black
          
          UILabel.labelUIHandling(label: lblFooterInfo1, text: "Share this note with Candidate", textColor: ILColor.color(index: 28), isBold: false, fontType: fontMedium)
          
          UILabel.labelUIHandling(label: lblFooterInfo2, text: "Share this note with Community Members", textColor: ILColor.color(index: 28), isBold: false, fontType: fontMedium)

          btnSubmit.isEnabled = false
          
          btnFooterInfo1.setImage(UIImage.init(named: "check_box"), for: .normal);
          btnFooterInfo2.setImage(UIImage.init(named: "check_box"), for: .normal);
           btnFooterInfo1.isSelected = false
          btnFooterInfo2.isSelected = false

          if  let fontBook =  UIFont(name: "FontBook".localized(), size: Device.FONTSIZETYPE17)
              
          {
              UIButton.buttonUIHandling(button: btnSubmit, text: "Submit", backgroundColor: ILColor.color(index: 23) , textColor:.white ,  fontType: fontBook)
          }
          
          
      }
      

}
