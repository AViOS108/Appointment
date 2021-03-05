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

    var viewType : viewTypeCancelDecline!
    var delegate : ERCancelViewControllerDelegate!
    @IBOutlet weak var viewInner: UIView!
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var lblHeader: UILabel!
    var results: ERSideAppointmentModalResult!

    @IBOutlet weak var viewSeprator: UIView!
    
    @IBOutlet weak var lblComment: UILabel!
    
    @IBOutlet weak var lblFooterInfo: UILabel!
    
    @IBOutlet weak var txtView: UITextView!
    
    @IBOutlet weak var btnSubmit: UIButton!
    
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
        
        
        ERSideAppointmentService().erSideAppointemntDandC(params: params, id: results.identifier ?? "", idIndex: apiHitINdex, { (jsonData) in
            
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
        
        let fontHeavy = UIFont(name: "FontHeavy".localized(), size: Device.FONTSIZETYPE15)
        let fontMedium = UIFont(name: "FontMediumWithoutNext".localized(), size: Device.FONTSIZETYPE13)
        
        switch viewType {
        case .cancel:
            
            let strHeader = NSMutableAttributedString.init()
            let strTiTle = NSAttributedString.init(string: GeneralUtility.optionalHandling(_param: "Cancel Request", _returnType: String.self)
                , attributes: [NSAttributedString.Key.foregroundColor : ILColor.color(index:13),NSAttributedString.Key.font : fontHeavy]);
            let nextLine1 = NSAttributedString.init(string: "\n")
            
            let strType = NSAttributedString.init(string: GeneralUtility.optionalHandling(_param: self.results.participants![0].name, _returnType: String.self)
                , attributes: [NSAttributedString.Key.foregroundColor : ILColor.color(index: 13),NSAttributedString.Key.font : fontMedium]);
            let para = NSMutableParagraphStyle.init()
            //        para.alignment = .center
            para.lineSpacing = 1
            strHeader.append(strTiTle)
            strHeader.append(nextLine1)
            strHeader.append(strType)
            strHeader.addAttribute(NSAttributedString.Key.paragraphStyle, value: para, range: NSMakeRange(0, strHeader.length))
            lblHeader.attributedText = strHeader
            break;
            
        case .decline:
            
            let strHeader = NSMutableAttributedString.init()
            let strTiTle = NSAttributedString.init(string: GeneralUtility.optionalHandling(_param: "Decline Request", _returnType: String.self)
                , attributes: [NSAttributedString.Key.foregroundColor : ILColor.color(index:13),NSAttributedString.Key.font : fontHeavy]);
            let nextLine1 = NSAttributedString.init(string: "\n")
            
            let strType = NSAttributedString.init(string: GeneralUtility.optionalHandling(_param: self.results.participants![0].name, _returnType: String.self)
                , attributes: [NSAttributedString.Key.foregroundColor : ILColor.color(index: 13),NSAttributedString.Key.font : fontMedium]);
            let para = NSMutableParagraphStyle.init()
            //        para.alignment = .center
            para.lineSpacing = 1
            strHeader.append(strTiTle)
            strHeader.append(nextLine1)
            strHeader.append(strType)
            strHeader.addAttribute(NSAttributedString.Key.paragraphStyle, value: para, range: NSMakeRange(0, strHeader.length))
            lblHeader.attributedText = strHeader
            
            
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
        tapGesture()
        viewInner.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.2)
        viewContainer.backgroundColor = .white
        viewContainer.cornerRadius = 3;
        self.viewSeprator.backgroundColor = ILColor.color(index: 22)
        
        self.customize()
        if  let fontBook =  UIFont(name: "FontBook".localized(), size: Device.FONTSIZETYPE17)
        {
            UIButton.buttonUIHandling(button: btnSubmit, text: "Submit", backgroundColor: ILColor.color(index: 23) , textColor:.white ,  fontType: fontBook)
        }
        
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view?.isDescendant(of: self.view) == true  && touch.view?.tag != 19682 && touch.view?.tag != 19683 {
            self.view.resignFirstResponder()
            
            return false
        }
        return true
    }
    
    func tapGesture()  {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        tap.delegate = self
        self.viewInner.isUserInteractionEnabled = true
        self.viewInner.addGestureRecognizer(tap)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        self.dismiss(animated: false) {
        }
    }
    
}
