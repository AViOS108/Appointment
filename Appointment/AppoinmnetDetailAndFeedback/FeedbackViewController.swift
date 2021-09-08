//
//  FeedbackViewController.swift
//  Appointment
//
//  Created by Anurag Bhakuni on 15/10/20.
//  Copyright © 2020 Anurag Bhakuni. All rights reserved.
//

import UIKit



struct feedbackModal {
    var comments: String?
    var coach_helpfulness: Int!
    var coach_expertise: Int!
    var overall_experience: Int!
    
}



protocol feedbackViewControllerDelegate {
    func feedbackSucessFullySent();
}


class FeedbackViewController: SuperViewController,UIGestureRecognizerDelegate,UITextViewDelegate {
    
    @IBOutlet weak var lbltxtView: UILabel!
    @IBOutlet weak var txtView: UITextView!
    @IBOutlet weak var lblImageView: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    var delegate : feedbackViewControllerDelegate!
    @IBOutlet weak var lblCoachName: UILabel!
    @IBOutlet weak var lblOverallExp: UILabel!
    @IBOutlet var btnOverallExpGrp: [UIButton]!
    var appoinmentDetailModalObj : AppoinmentDetailModalNew?

    var coach_helpfulness: Int = -1
    var coach_expertise: Int = -1
    var overall_experience: Int = -1
    
    
    
    @IBAction func btnOveralExpTapped(_ sender: UIButton) {
        
        overall_experience = sender.tag
        self.btnOverallExpGrp.forEach { (btn) in
            if btn.tag <= sender.tag{
                btn.setImage(UIImage.init(named: "noun_Star_select"), for: .normal)
            }
            else{
                btn.setImage(UIImage.init(named: "noun_Star_nonselect"), for: .normal)
            }
        }
    }
    
    @IBOutlet weak var lblCoachPrecise: UILabel!
    @IBOutlet var btnCoachPreciseGrp: [UIButton]!
    @IBOutlet var viewSeperators: [UIView]!
    
    var contentSize : CGSize!
    @IBAction func btnCoachPreTapped(_ sender: UIButton) {
        coach_expertise = sender.tag
        self.btnCoachPreciseGrp.forEach { (btn) in
            
            if btn.tag <= sender.tag{
                btn.setImage(UIImage.init(named: "noun_Star_select"), for: .normal)
            }
            else{
                btn.setImage(UIImage.init(named: "noun_Star_nonselect"), for: .normal)
            }
            
        }
        
    }
    
    @IBOutlet weak var lblHelpFulness: UILabel!
    @IBOutlet var btnHelpFulnessGrp: [UIButton]!
    @IBAction func btnHelpFulTapped(_ sender: UIButton) {
        coach_helpfulness = sender.tag
        self.btnHelpFulnessGrp.forEach { (btn) in
            if btn.tag <= sender.tag{
                btn.setImage(UIImage.init(named: "noun_Star_select"), for: .normal)
            }
            else{
                btn.setImage(UIImage.init(named: "noun_Star_nonselect"), for: .normal)
            }
            
        }
        
    }
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var viewInner: UIView!
    @IBOutlet weak var viewScroll: UIScrollView!
    @IBOutlet weak var viewOuter: UIView!
    var activityIndicator: ActivityIndicatorView?
    
    
    @IBOutlet weak var btnSubmit: UIButton!
    
    @IBAction func btnSubmitTapped(_ sender: Any) {
        
        if coach_expertise == -1 || coach_helpfulness == -1 || overall_experience == -1{
            CommonFunctions().showError(title: "", message: "Please select mandatory ratings")
            return
        }
        
        if (txtView.text == "Your notes here" && txtView.textColor == .lightGray) || txtView.text.isEmpty{
             CommonFunctions().showError(title: "", message: "The comments field is required")
            return

        }
        
        
        var objFeedBackMOdal = feedbackModal()
        objFeedBackMOdal.coach_expertise = coach_expertise
        objFeedBackMOdal.coach_helpfulness = coach_helpfulness
        objFeedBackMOdal.overall_experience = overall_experience
        
        if (txtView.text == "Your notes here" && txtView.textColor == .lightGray){
             objFeedBackMOdal.comments = ""
        }
        else{
             objFeedBackMOdal.comments = txtView.text
        }
        
        let objAppointment = AppoinmentUtilityVM()
        activityIndicator = ActivityIndicatorView.showActivity(view: self.view, message: StringConstants.FeedbackNotes)
        objAppointment.callbackVC = {
            (success:Bool) in
            
            if success{
                CommonFunctions().showError(title: "", message: "Successfully Submitted")

                self.delegate.feedbackSucessFullySent();
                self.navigationController?.popViewController(animated: false)

            }
            
            
            
            self.activityIndicator?.hide()
            self.dismiss(animated: false) {
                
            }
        }
    
        objAppointment.postFeedback(selectedAppointmentModal: appoinmentDetailModalObj, objFeedBackMOdal: objFeedBackMOdal)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
     
        view.backgroundColor = .white
        viewInner.backgroundColor = .white
        viewContainer.backgroundColor = .white
        self.shadowWithCorner(viewContainer: viewContainer, cornerRadius: 2.0)
        self.customization()
        GeneralUtility.customeNavigationBarWithOnlyBack(viewController: self, title: "Leave a Feedback for this session")
        
        
        if self.appoinmentDetailModalObj != nil{
            
            var coachExpertise = Int(self.appoinmentDetailModalObj?.requests?[0].feedback?.coachExpertise ?? "0")
            var overallExperience = Int(self.appoinmentDetailModalObj?.requests?[0].feedback?.overallExperience ?? "0")
            var coachHelpfulness = Int(self.appoinmentDetailModalObj?.requests?[0].feedback?.coachHelpfulness ?? "0")

            self.btnSubmit.isHidden = true
            
            self.btnCoachPreciseGrp.forEach { (btn) in
                btn.isUserInteractionEnabled = false
                if btn.tag <= coachExpertise!{
                    btn.setImage(UIImage.init(named: "noun_Star_select"), for: .normal)
                }
                else{
                    btn.setImage(UIImage.init(named: "noun_Star_nonselect"), for: .normal)
                }
                
            }
            self.btnHelpFulnessGrp.forEach { (btn) in
                btn.isUserInteractionEnabled = false
                if btn.tag <= coachHelpfulness!{
                    btn.setImage(UIImage.init(named: "noun_Star_select"), for: .normal)
                }
                else{
                    btn.setImage(UIImage.init(named: "noun_Star_nonselect"), for: .normal)
                }
            }
            self.btnOverallExpGrp.forEach { (btn) in
                btn.isUserInteractionEnabled = false
                if btn.tag <= overallExperience!{
                    btn.setImage(UIImage.init(named: "noun_Star_select"), for: .normal)
                }
                else{
                    btn.setImage(UIImage.init(named: "noun_Star_nonselect"), for: .normal)
                }
            }
            txtView.text = self.appoinmentDetailModalObj?.requests?[0].feedback?.comments
            txtView.isUserInteractionEnabled = false
            
        }
        
        
    }
    
    func shadowWithCorner(viewContainer : UIView,cornerRadius: CGFloat)
       {
           // corner radius
           viewContainer.layer.cornerRadius = cornerRadius
           // border
           viewContainer.layer.borderWidth = 1.0
           viewContainer.layer.borderColor = ILColor.color(index: 27).cgColor
           // shadow
           viewContainer.layer.shadowColor = ILColor.color(index: 27).cgColor
           viewContainer.layer.shadowOffset = CGSize(width: 3, height: 3)
           viewContainer.layer.shadowOpacity = 0.7
           viewContainer.layer.shadowRadius = 4.0
       }
    
    @objc override func buttonClicked(sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: false)
    }
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view?.isDescendant(of: self.view) == true  && touch.view?.tag != 19682  {
            self.view.resignFirstResponder()
            
            return false
        }
        return true
    }
    
  
    func customization()  {

        let fontMedium =  UIFont(name: "FontMediumWithoutNext".localized(), size: Device.FONTSIZETYPE14)

        txtView.backgroundColor = ILColor.color(index: 22)
        txtView.autocorrectionType = .no
        txtView.spellCheckingType = .no
        txtView.font = fontMedium
        txtView.delegate = self
        txtView.layer.borderWidth = 1;
        txtView.layer.borderColor = ILColor.color(index: 22).cgColor
        txtView.text = "Your notes here"
        txtView.textColor = .lightGray
        self.addInputAccessoryForTextView(textVIew: txtView )




        let radius =  (Int)(lblImageView.frame.height)/2
//        if let urlImage = URL.init(string: self.selectedAppointmentModal?.coach?.profilePicURL ?? "") {
//            self.imgView
//                .setImageWith(urlImage, placeholderImage: UIImage.init(named: "Placeeholderimage"))
//
//            self.imgView?.cornerRadius = CGFloat(radius)
//            imgView?.clipsToBounds = true
//            //                self.imgView.layer.borderColor = UIColor.black.cgColor
//            //                self.imgView.layer.borderWidth = 1
//            self.imgView?.layer.masksToBounds = true;
//        }
//        else{
//            self.imgView.image = UIImage.init(named: "Placeeholderimage");
//            //            self.imgView.contentMode = .scaleAspectFit;
//
//        }

//        if self.selectedAppointmentModal?.coach?.profilePicURL == nil ||
//            GeneralUtility.optionalHandling(_param: self.selectedAppointmentModal?.coach?.profilePicURL?.isBlank, _returnType: Bool.self)
//        {

            self.imgView?.isHidden = true
            self.lblImageView.isHidden = false

        let stringImg = GeneralUtility.startNameCharacter(stringName: self.appoinmentDetailModalObj?.coachDetails?.name ?? " ")
            if let fontMedium = UIFont(name: "FontMedium".localized(), size: Device.FONTSIZETYPE15)
            {

                UILabel.labelUIHandling(label: lblImageView, text: GeneralUtility.optionalHandling(_param: stringImg, _returnType: String.self), textColor:.black , isBold: false , fontType: fontMedium, isCircular: true,  backgroundColor:.white ,cornerRadius: radius,borderColor:UIColor.black,borderWidth: 1 )
                lblImageView.textAlignment = .center
                lblImageView.layer.borderColor = UIColor.black.cgColor
            }


//        }
//        else
//        {
//            self.lblImageView.isHidden = true
//            self.imgView?.isHidden = false
//
//        }


        let fontHeavy = UIFont(name: "FontHeavy".localized(), size: Device.FONTSIZETYPE15)
        let fontBook =  UIFont(name: "FontBook".localized(), size: Device.FONTSIZETYPE14)


        self.textWithAstrikMark(lblSpecific: lblOverallExp, text: "Overall Experience for the sessions")
        self.textWithAstrikMark(lblSpecific: lblCoachPrecise, text: "Coach’s precision and helpfulness")
        self.textWithAstrikMark(lblSpecific: lblHelpFulness, text: "Helpfulness due to coach’s area of expertise")

        UILabel.labelUIHandling(label: lblCoachName, text: self.appoinmentDetailModalObj?.coachDetails?.name ?? "", textColor: ILColor.color(index: 40), isBold: false,  fontType: fontHeavy)

        UILabel.labelUIHandling(label: lbltxtView, text: "Additional Comments", textColor: ILColor.color(index: 40), isBold: false,  fontType: fontHeavy)
        UIButton.buttonUIHandling(button: btnSubmit, text: "Submit", backgroundColor: ILColor.color(index: 23) , textColor: .white, cornerRadius: 3, fontType: fontHeavy)
        viewSeperators.forEach { (viewSep) in
            viewSep.backgroundColor = ILColor.color(index: 22)
        }
        var index = 1
        self.btnOverallExpGrp.forEach { (btn) in
            btn.tag = index
            btn.setImage(UIImage.init(named: "noun_Star_nonselect"), for: .normal)
            index = index + 1
        }
        index = 1
        self.btnHelpFulnessGrp.forEach { (btn) in
            btn.tag = index
            btn.setImage(UIImage.init(named: "noun_Star_nonselect"), for: .normal)
            index = index + 1
        }
        index = 1
        self.btnCoachPreciseGrp.forEach { (btn) in
            btn.tag = index
            btn.setImage(UIImage.init(named: "noun_Star_nonselect"), for: .normal)
            index = index + 1
        }
        contentSize = CGSize.init(width: self.viewScroll.contentSize.width, height: self.viewScroll.contentSize.height)
   }
    
    
    func textWithAstrikMark(lblSpecific: UILabel,text:String){
        let strHeader = NSMutableAttributedString.init()
        if  let fontMedium =  UIFont(name: "FontMediumWithoutNext".localized(), size: Device.FONTSIZETYPE14)
        {
            let strTiTle = NSAttributedString.init(string: GeneralUtility.optionalHandling(_param: text, _returnType: String.self)
                , attributes: [NSAttributedString.Key.foregroundColor : ILColor.color(index: 34),NSAttributedString.Key.font : fontMedium]);
            let strType = NSAttributedString.init(string: " ⃰"
                , attributes: [NSAttributedString.Key.foregroundColor : UIColor.red,NSAttributedString.Key.font : fontMedium]);
            let para = NSMutableParagraphStyle.init()
            //            para.alignment = .center
            strHeader.append(strTiTle)
            strHeader.append(strType)
            
            strHeader.addAttribute(NSAttributedString.Key.paragraphStyle, value: para, range: NSMakeRange(0, strHeader.length))
            lblSpecific.attributedText = strHeader
        }
    }
    
    
    func textViewDidBeginEditing(_ textView: UITextView)
    {
        if (textView.text == "Your notes here" && textView.textColor == .lightGray)
        {
            textView.text = ""
            textView.textColor = .black
        }
        
        self.viewScroll.setContentOffset(CGPoint.init(x: 0, y: 150), animated: false)

        textView.becomeFirstResponder()
    }
    func textViewDidEndEditing(_ textView: UITextView)
    {
        if (textView.text == "")
        {
            textView.text = "Your notes here"
            textView.textColor = .lightGray
        }
        textView.resignFirstResponder()
    }
    
    override func actnResignKeyboard() {
        
        self.viewScroll.setContentOffset(CGPoint.init(x: 0, y: 0), animated: false)

        
        txtView.resignFirstResponder()
    }
    
    
}
