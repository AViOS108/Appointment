//
//  ERCancelViewController.swift
//  Appointment
//
//  Created by Anurag Bhakuni on 13/01/21.
//  Copyright © 2021 Anurag Bhakuni. All rights reserved.
//

import UIKit

enum viewTypeCancelDecline{
    case cancel
    case decline
}


protocol ERCancelViewControllerDelegate {
    
    func refreshTableView()
    
}


class ERCancelViewController: SuperViewController,UIGestureRecognizerDelegate,UITextViewDelegate {
  
    
    @IBOutlet weak var lblInitialName: UILabel!
    
    @IBOutlet weak var lblDescribtion: UILabel!
    @IBOutlet weak var lblCoachName: UILabel!
    var viewType : viewTypeCancelDecline!
    var delegate : ERCancelViewControllerDelegate!
    @IBOutlet weak var viewInner: UIView!
    @IBOutlet weak var viewContainer: UIView!
    var results: ERSideAppointmentModalNewResult!
    var seletectedIndex : Int = 0

    
    @IBOutlet weak var lblComment: UILabel!
    
    @IBOutlet weak var lblFooterInfo: UILabel!
    
    @IBOutlet weak var txtView: UITextView!
    
    @IBOutlet weak var btnSubmit: UIButton!
    var colectionViewHandler = ERStudentOverlayView()

    @IBAction func btnSubmitTapped(_ sender: Any) {
        callApi()
    }
    
    
    
    func callApi()   {
        
        var apiHitINdex = 0
        switch viewType {
        case .decline:
            apiHitINdex = 2;
        case .cancel :
            apiHitINdex = 1
        default:
            break
        }
        var activityIndicator = ActivityIndicatorView.showActivity(view: self.view, message: StringConstants.SubmittingDandCOpenHour)

        
        let params = [
            "_method" : "patch",
            "csrf_token" : UserDefaultsDataSource(key: "csrf_token").readData() as! String,
            "appointment_cancellation_reason" :txtView.text ?? ""
            
            ] as Dictionary<String,AnyObject>
        
        
        ERSideAppointmentService().erSideAppointemntDandC(params: params, id: String(describing: results.id ?? 0), idIndex: apiHitINdex, { (jsonData) in
            
            activityIndicator.hide()
            
            self.dismiss(animated: false) {
                  self.delegate.refreshTableView()
            }
            
        }) { (error, errorCode) in
            activityIndicator.hide()

        }
        
        
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
    func customize() {
        
        let stringImg = GeneralUtility.startNameCharacter(stringName: self.results.requests![seletectedIndex].studentDetails?.name ?? "")
        
        if let fontHeavy = UIFont(name: "FontHeavy".localized(), size: Device.FONTSIZETYPE13)
        {
            UILabel.labelUIHandling(label: lblInitialName, text: stringImg, textColor:ILColor.color(index: 28) , isBold: false, fontType: fontHeavy)
            lblInitialName.layer.borderColor = UIColor.red.cgColor
            lblInitialName.layer.borderWidth = 1;
            lblInitialName.layer.cornerRadius = lblInitialName.frame.size.height/2
            lblInitialName.clipsToBounds = true
            lblInitialName.layer.masksToBounds = true
            lblInitialName.textAlignment = .center
        }
        let strHeader = NSMutableAttributedString.init()

        if let fontHeavy = UIFont(name: "FontHeavy".localized(), size: Device.FONTSIZETYPE13), let fontBook =  UIFont(name: "FontBook".localized(), size: Device.FONTSIZETYPE14)
            
        {
            let strTiTle = NSAttributedString.init(string: GeneralUtility.optionalHandling(_param: self.results.requests![seletectedIndex].studentDetails?.name, _returnType: String.self)
                , attributes: [NSAttributedString.Key.foregroundColor : ILColor.color(index:34),NSAttributedString.Key.font : fontHeavy]);
            let nextLine1 = NSAttributedString.init(string: "\n")
            let strType = NSAttributedString.init(string: GeneralUtility.optionalHandling(_param: self.results.requests![seletectedIndex].studentDetails?.benchmarkName, _returnType: String.self)
                , attributes: [NSAttributedString.Key.foregroundColor : ILColor.color(index: 34),NSAttributedString.Key.font : fontBook]);
            let para = NSMutableParagraphStyle.init()
            //            para.alignment = .center
            para.lineSpacing = 4
            strHeader.append(strTiTle)
            strHeader.append(nextLine1)
            strHeader.append(strType)
            strHeader.addAttribute(NSAttributedString.Key.paragraphStyle, value: para, range: NSMakeRange(0, strHeader.length))
            lblCoachName.attributedText = strHeader
        }
        let weekDay = ["Sun","Mon","Tue","Wed","Thu","Fri","Sat"]
        var componentDay = GeneralUtility.dateComponent(date: self.results.startDatetimeUTC!, component: .weekday)
        let strHeaderDesc = NSMutableAttributedString.init()

        if let fontHeavy = UIFont(name: "FontHeavy".localized(), size: Device.FONTSIZETYPE13), let fontBook =  UIFont(name: "FontBook".localized(), size: Device.FONTSIZETYPE14)
            
        {
            let strTiTle = NSAttributedString.init(string: GeneralUtility.optionalHandling(_param: " " +  "\(weekDay[(componentDay?.weekday ?? 1) - 1]), " +
                GeneralUtility.startAndEndDateDetail2(startDate: self.results.startDatetimeUTC ?? "", endDate: self.results.endDatetimeUTC ?? "")
                , _returnType: String.self)
                , attributes: [NSAttributedString.Key.foregroundColor : ILColor.color(index:13),NSAttributedString.Key.font : fontHeavy]);
            let nextLine1 = NSAttributedString.init(string: "\n")
            var strLocation = "Not available"
            
            let image1Attachment = NSTextAttachment()
            image1Attachment.image = UIImage(named: "locationAppo")
            image1Attachment.bounds = CGRect.init(x: 0, y: 0, width: 10, height: 14)
            
            let image1Attachment2 = NSTextAttachment()
            image1Attachment2.image = UIImage(named: "calenderAppoList")
            image1Attachment2.bounds = CGRect.init(x: 0, y: 0, width: 10, height: 10)
            
            
            
            
            // wrap the attachment in its own attributed string so we can append it
            let imageLocation = NSAttributedString(attachment: image1Attachment)
            let imageCalender = NSAttributedString(attachment: image1Attachment2)
            
            
            let strType = NSAttributedString.init(string: GeneralUtility.optionalHandling(_param: " " + (self.results.location ?? ""), _returnType: String.self)
                , attributes: [NSAttributedString.Key.foregroundColor : ILColor.color(index: 13),NSAttributedString.Key.font : fontBook]);
            let para = NSMutableParagraphStyle.init()
            //            para.alignment = .center
            para.lineSpacing = 4
            strHeaderDesc.append(imageCalender)
            strHeaderDesc.append(strTiTle)
            strHeaderDesc.append(nextLine1)
            strHeaderDesc.append(imageLocation)
            strHeaderDesc.append(strType)
            strHeaderDesc.addAttribute(NSAttributedString.Key.paragraphStyle, value: para, range: NSMakeRange(0, strHeaderDesc.length))
            lblDescribtion.attributedText = strHeaderDesc
        }
        
        
        let fontHeavy = UIFont(name: "FontHeavy".localized(), size: Device.FONTSIZETYPE15)
        let fontMedium = UIFont(name: "FontMediumWithoutNext".localized(), size: Device.FONTSIZETYPE13)
        
        switch viewType {
        case .cancel:
            GeneralUtility.customeNavigationBarWithOnlyBack(viewController: self,title:"Cancel Appointment");

            break;
            
        case .decline:
           GeneralUtility.customeNavigationBarWithOnlyBack(viewController: self,title:"Decline Request ");

            
            
            break
            
        default:
            break
        }
        
        
        self.addInputAccessoryForTextView(textVIew: txtView )
        txtView.backgroundColor = ILColor.color(index: 22)
        txtView.autocorrectionType = .no
        txtView.spellCheckingType = .no
        txtView.font = fontMedium
        txtView.delegate = self
        txtView.layer.borderWidth = 1;
        txtView.layer.borderColor = ILColor.color(index: 22).cgColor
        txtView.textColor = .black
        
        UILabel.labelUIHandling(label: lblFooterInfo, text: "A notification email will be sent to the meeting participant(s) including the comment entered above.", textColor: ILColor.color(index: 28), isBold: false, fontType: fontMedium)
        
        UILabel.labelUIHandling(label: lblComment, text: "Comment", textColor: ILColor.color(index: 40), isBold: false, fontType: fontHeavy)
        
    }
    override func actnResignKeyboard() {
           
           
           txtView.resignFirstResponder()
       }
    
    override func viewDidAppear(_ animated: Bool) {
        self.view.tag = 19682
        self.viewInner.tag = 19683
        viewInner.backgroundColor = ILColor.color(index: 22)
        viewContainer.backgroundColor = .white
        viewContainer.cornerRadius = 3;

        self.customize()
        if  let fontBook =  UIFont(name: "FontBook".localized(), size: Device.FONTSIZETYPE17)
        {
            UIButton.buttonUIHandling(button: btnSubmit, text: "Submit", backgroundColor: ILColor.color(index: 23) , textColor:.white ,  fontType: fontBook)
        }
        
    }
    
  @objc override func buttonClicked(sender: UIBarButtonItem) {
         self.navigationController?.popViewController(animated: true)
         

           }
    
}
