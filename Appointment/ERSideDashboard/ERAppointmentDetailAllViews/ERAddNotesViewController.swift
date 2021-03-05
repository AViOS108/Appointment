//
//  ERAddNotesViewController.swift
//  Appointment
//
//  Created by Anurag Bhakuni on 14/01/21.
//  Copyright © 2021 Anurag Bhakuni. All rights reserved.
//

import UIKit

class ERAddNotesViewController: SuperViewController,UITextViewDelegate {
    @IBOutlet weak var viewinner: UIView!
    
      @IBOutlet weak var viewContainer: UIView!
      @IBOutlet weak var lblHeader: UILabel!
      var results: ERSideAppointmentModalResult!

    var isFooter1Selected = 0
    var isFooter2Selected = 0
    
    @IBOutlet var viewSeprators: [UIView]!
      
      @IBOutlet weak var lblFooterInfo1: UILabel!
      
      @IBOutlet weak var lblFooterInfo2: UILabel!
      
      @IBOutlet weak var txtView: UITextView!
      
      @IBOutlet weak var btnSubmit: UIButton!
      
      @IBAction func btnSubmitTapped(_ sender: Any) {
        callApi()
        
      }
    
    
    func callApi()   {
        
        
        var activityIndicator = ActivityIndicatorView.showActivity(view: self.view, message: StringConstants.SubmittingDandCOpenHour)
        
        var arrEntities = Array<Dictionary<String,AnyObject>>()
        
        let entitesObj1 = ["entity_id":results.participants![0].id,
                           "entity_type":"student_user",
                           "can_view_note":isFooter1Selected] as [String : AnyObject]
        
        let entitesObj2 = ["entity_id":results.id,
                           "entity_type":"community",
                           "can_view_note":isFooter2Selected] as [String : AnyObject]
        let entitesObj3 = ["entity_id":results.identifier,
                                  "entity_type":"event"] as [String : AnyObject]
        
        arrEntities.append(entitesObj1)
        arrEntities.append(entitesObj2)
        arrEntities.append(entitesObj3)

        
        let params = [
            "_method" : "post",
            "data":txtView.text ?? "",
            "csrf_token" : UserDefaultsDataSource(key: "csrf_token").readData() as! String,
            "appointment_cancellation_reason" :txtView.text ?? "",
            "entities":arrEntities
            
            ] as Dictionary<String,AnyObject>
        
        
        
        ERSideAppointmentService().erSideAppointemntSaveNotes(params: params, { (data) in
            
            activityIndicator.hide()

            
        }) { (error, errorCode) in
            
            activityIndicator.hide()

        }
        
        
        
    }
    
    
    
    
    
    
    
      
    @IBOutlet weak var btnFooterInfo1: UIButton!
    
    @IBAction func btnFooterInfo1Tapped(_ sender: Any) {
        btnFooterInfo1.isSelected = !btnFooterInfo1.isSelected
        if btnFooterInfo1.isSelected{
            btnFooterInfo1.setImage(UIImage.init(named: "Check_box_selected"), for: .normal);
        }
        else{
            btnFooterInfo1.setImage(UIImage.init(named: "check_box"), for: .normal);
            
        }
        
    }
    
    
    @IBOutlet weak var btnFooterInfo2: UIButton!
    
    @IBAction func btnFooterInfo2Tapped(_ sender: Any) {
        btnFooterInfo2.isSelected = !btnFooterInfo2.isSelected
        if btnFooterInfo2.isSelected{
            btnFooterInfo2.setImage(UIImage.init(named: "Check_box_selected"), for: .normal);
        }
        else{
            btnFooterInfo2.setImage(UIImage.init(named: "check_box"), for: .normal);
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        customize()
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
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
         let currentText = (textView.text as NSString?)?.replacingCharacters(in: range, with: text)
        
        if currentText?.count ?? 0 > 0{
            btnSubmit.isEnabled = true
        }
        else{
            btnSubmit.isEnabled = false

        }
        
        return true
    }
    
    
   override func actnResignKeyboard() {
          
          txtView.resignFirstResponder()
      }

}
