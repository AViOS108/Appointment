//
//  CoachConfirmationPopUpFirstViewC.swift
//  Appointment
//
//  Created by Anurag Bhakuni on 07/09/20.
//  Copyright © 2020 Anurag Bhakuni. All rights reserved.
//

import UIKit

protocol passDataSecondViewDelegate {
    func passData(results: OpenHourCoachModalResult);
}


class CoachConfirmationPopUpFirstViewC: UIViewController,UIGestureRecognizerDelegate {
    
    
    @IBOutlet weak var viewContainer: UIView!
    
     var delegate : passDataSecondViewDelegate!
    var results: OpenHourCoachModalResult!
    var dataFeedingModal : DashBoardModel?
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var viewSeperator: UIView!
    @IBOutlet weak var lblInitial: UILabel!
    @IBOutlet weak var imgViewCoach: UIImageView!
    @IBOutlet weak var lblCoachName: UILabel!
    @IBOutlet weak var lblAvailableSlot: UILabel!
    @IBOutlet weak var lblStartTimeText: UILabel!
    @IBOutlet weak var lblEndTimeText: UILabel!
    @IBOutlet weak var lblStartTimeValue: UILabel!
    @IBOutlet weak var lblEndTimeValue: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var viewBottom: UIView!
    @IBOutlet weak var btnCancel: UIButton!
    @IBAction func btnCancelTapped(_ sender: UIButton) {
        self.dismiss(animated: false) {
            
        }
    }
    
    @IBOutlet weak var BtnNext: UIButton!
    
    @IBAction func btnNextTapped(_ sender: UIButton) {
        self.dismiss(animated: false) {
            self.delegate.passData(results: self.results)
        }
    }
    
    
    @IBOutlet weak var viewSeperatorVerticale: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if  (Device.IS_IPAD)
        {
            
        }
        else
        {
            AppUtility.lockOrientation(.portrait, andRotateTo: .portrait)

        }
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
          AppUtility.lockOrientation(.all)
    }
    override func viewDidAppear(_ animated: Bool) {
        self.customization()
        if  (Device.IS_IPAD)
        {
            
        }
        else
        {
            AppUtility.lockOrientation(.portrait, andRotateTo: .portrait)
            
        }
        self.view.tag = 19682
        tapGesture()
        view.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.2)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view?.isDescendant(of: self.view) == true  && touch.view?.tag != 19682  {
            return false
        }
        return true
    }
    
    func tapGesture()  {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        tap.delegate = self
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(tap)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        self.dismiss(animated: false) {
        }
    }
    
    
    func dateChangeWithFormatter(formatterInput:String,formatterOutpput: String,date: String) -> String  {
        
        let dateformatter = DateFormatter.init()
        dateformatter.dateFormat = formatterInput
        dateformatter.timeZone = TimeZone.init(abbreviation: "UTC")
        let DateModal = dateformatter.date(from: date)
        dateformatter.dateFormat = formatterOutpput
        var localTimeZoneAbbreviation: String { return TimeZone.current.abbreviation() ?? "" }
        let token = UserDefaultsDataSource(key: "timeZoneOffset").readData() as! String
        dateformatter.timeZone = TimeZone.init(identifier: token);        return dateformatter.string(from: DateModal!)
    }
    
    
   func customization(){
//        viewContainer.cornerRadius = 3;
//        viewSeperator.backgroundColor = ILColor.color(index:19);
//        viewSeperatorVerticale.backgroundColor = ILColor.color(index:19);
//        viewBottom.backgroundColor = ILColor.color(index:19);
////        let selectedCoach =  self.dataFeedingModal?.items.filter({
////            "\($0.id)" == results.createdByID
////        })[0]
//
//        _ = UIFont(name: "FontMediumWithoutNext".localized(), size: Device.FONTSIZETYPE13)
//        let fontBook = UIFont(name: "FontBook".localized(), size: Device.FONTSIZETYPE13)
//        let fontHeavy = UIFont(name: "FontHeavy".localized(), size: Device.FONTSIZETYPE13)
//        let fontNextMedium = UIFont(name: "FontMedium".localized(), size: Device.FONTSIZETYPE13)
//        let fontDemiBold = UIFont(name: "FontDemiBold".localized(), size: Device.FONTSIZETYPE13)
//
//
//        UILabel.labelUIHandling(label: lblHeader, text: "Confirm Appointment", textColor:ILColor.color(index: 4) , isBold: false , fontType: UIFont(name: "FontHeavy".localized(), size: Device.FONTSIZETYPE15),   backgroundColor:.white )
//        lblInitial.layoutIfNeeded()
//        let radius =  (Int)(lblInitial.frame.height)/2
//        if let urlImage = URL.init(string: selectedCoach?.profilePicURL ?? "") {
//            self.imgViewCoach
//                .setImageWith(urlImage, placeholderImage: UIImage.init(named: "Placeeholderimage"))
//
//            self.imgViewCoach?.cornerRadius = CGFloat(radius)
//            imgViewCoach?.clipsToBounds = true
//            self.imgViewCoach?.layer.masksToBounds = true;
//        }
//        else{
//            self.imgViewCoach.image = UIImage.init(named: "Placeeholderimage");
//
//        }
//
//        if let fontHeavy = UIFont(name: "FontHeavy".localized(), size: Device.FONTSIZETYPE13)
//        {
////            UILabel.labelUIHandling(label: lblInitial, text: selectedCoach!.name, textColor:ILColor.color(index: 28) , isBold: false, fontType: fontHeavy)
//            lblInitial.layer.borderColor = UIColor.red.cgColor
//            lblInitial.layer.borderWidth = 1;
//            lblInitial.layer.cornerRadius = lblInitial.frame.size.height/2
//            lblInitial.clipsToBounds = true
//            lblInitial.layer.masksToBounds = true
//        }
//
//        if selectedCoach?.profilePicURL == nil ||
//            GeneralUtility.optionalHandling(_param: selectedCoach?.profilePicURL?.isBlank, _returnType: Bool.self)
//        {
//            self.imgViewCoach?.isHidden = true
//            self.lblInitial.isHidden = false
//
//            let stringImg = GeneralUtility.startNameCharacter(stringName: selectedCoach?.name ?? " ")
//            if let fontMedium = UIFont(name: "FontMedium".localized(), size: Device.FONTSIZETYPE15)
//            {
//                UILabel.labelUIHandling(label: lblInitial, text: GeneralUtility.optionalHandling(_param: stringImg, _returnType: String.self), textColor:.black , isBold: false , fontType: fontMedium, isCircular: true,  backgroundColor:.white ,cornerRadius: radius,borderColor:UIColor.black,borderWidth: 1 )
//                lblInitial.textAlignment = .center
//                lblInitial.layer.borderColor = UIColor.black.cgColor
//            }
//        }
//        else
//        {
//            self.lblInitial.isHidden = true
//            self.imgViewCoach?.isHidden = false
//
//        }
//        let coachText = selectedCoach?.name
//        var coachType = ""
//
//        let strHeader = NSMutableAttributedString.init()
//
//        let strTiTle = NSAttributedString.init(string: GeneralUtility.optionalHandling(_param: coachText, _returnType: String.self)
//            , attributes: [NSAttributedString.Key.foregroundColor : ILColor.color(index:13),NSAttributedString.Key.font : fontHeavy]);
//        let nextLine1 = NSAttributedString.init(string: "\n")
//        let strType = NSAttributedString.init(string: GeneralUtility.optionalHandling(_param: coachType, _returnType: String.self)
//            , attributes: [NSAttributedString.Key.foregroundColor : ILColor.color(index: 13),NSAttributedString.Key.font : fontBook]);
//        let para = NSMutableParagraphStyle.init()
//        //            para.alignment = .center
//        para.lineSpacing = 1
//        strHeader.append(strTiTle)
//        strHeader.append(nextLine1)
//        strHeader.append(strType)
//        strHeader.append(nextLine1)
//        strHeader.addAttribute(NSAttributedString.Key.paragraphStyle, value: para, range: NSMakeRange(0, strHeader.length))
//        lblCoachName.attributedText = strHeader
//
//
//        let strHeader1 = NSMutableAttributedString.init()
//
//        let strSlot = NSAttributedString.init(string: "Available Slot on "
//            , attributes: [NSAttributedString.Key.foregroundColor : ILColor.color(index:13),NSAttributedString.Key.font : fontHeavy]);
//
//
//        let strDate = NSAttributedString.init(string: self.dateChangeWithFormatter(formatterInput: "yyyy-MM-dd HH:mm:ss", formatterOutpput: "dd MMM yyyy", date: (results?.startDatetimeUTC)!)
//            , attributes: [NSAttributedString.Key.foregroundColor : ILColor.color(index: 13),NSAttributedString.Key.font : fontBook]);
//        let paraSlot = NSMutableParagraphStyle.init()
//        //            para.alignment = .center
//        paraSlot.lineSpacing = 1
//        strHeader1.append(strSlot)
//        strHeader1.append(strDate)
//        strHeader1.addAttribute(NSAttributedString.Key.paragraphStyle, value: paraSlot, range: NSMakeRange(0, strHeader1.length))
//        lblAvailableSlot.attributedText = strHeader1
//
//
//        UILabel.labelUIHandling(label: lblStartTimeText, text: "Start Time", textColor:.black , isBold: false , fontType: fontNextMedium,  backgroundColor:.white )
//        UILabel.labelUIHandling(label: lblEndTimeText, text: "End Time", textColor:.black , isBold: false , fontType: fontNextMedium,  backgroundColor:.white )
//
//        UILabel.labelUIHandling(label: lblStartTimeValue, text:" " + self.dateChangeWithFormatter(formatterInput: "yyyy-MM-dd HH:mm:ss", formatterOutpput: "hh:mm a", date: (results?.startDatetimeUTC)!), textColor:.black , isBold: false , fontType: fontDemiBold, isCircular: true,  backgroundColor:.white ,cornerRadius: 2,borderColor:UIColor.black,borderWidth: 1 )
//
//        UILabel.labelUIHandling(label: lblEndTimeValue, text:" " + self.dateChangeWithFormatter(formatterInput: "yyyy-MM-dd HH:mm:ss", formatterOutpput: "hh:mm a", date: (results?.endDatetimeUTC)!), textColor:.black , isBold: false , fontType: fontDemiBold, isCircular: true,  backgroundColor:.white ,cornerRadius: 2,borderColor:UIColor.black,borderWidth: 1 )
//        self.location()
//
   }
    
    
    
    func location()
    {
        let fontHeavy = UIFont(name: "FontHeavy".localized(), size: Device.FONTSIZETYPE13)
        let fontBook = UIFont(name: "FontBook".localized(), size: Device.FONTSIZETYPE13)
        let fontMedium = UIFont(name: "FontMedium".localized(), size: Device.FONTSIZETYPE13)
        
        
        let strHeader1 = NSMutableAttributedString.init()
        
        let strLocationHeader = NSAttributedString.init(string: "Location/ Meeting Link"
            , attributes: [NSAttributedString.Key.foregroundColor : ILColor.color(index:13),NSAttributedString.Key.font : fontHeavy]);
        let nextLine1 = NSAttributedString.init(string: "\n")
        
        var strLocationText = "Not available"
        var zoomLink = false

//        if let str = results.locations{
//            if str.count > 0 {
//                strLocationText = (str[0].data?.value) ?? "Not available"
//                if str[0].provider == "zoom_link"{
//                               zoomLink = true
//                               strLocationText = " Zoom"
//                           }
//            }
//
//
//
//        }
        
        let image1Attachment = NSTextAttachment()
                 image1Attachment.image = UIImage(named: "Zoom")
image1Attachment.bounds = CGRect.init(x: 0, y: -5, width: 20, height: 20)
                 // wrap the attachment in its own attributed string so we can append it
                 let imageZoom = NSAttributedString(attachment: image1Attachment)
                 
        
        let strLocation = NSAttributedString.init(string: strLocationText
            , attributes: [NSAttributedString.Key.foregroundColor : ILColor.color(index: 13),NSAttributedString.Key.font : fontBook]);
        let paraSlot = NSMutableParagraphStyle.init()
        //            para.alignment = .center
        paraSlot.lineSpacing = 1
        strHeader1.append(strLocationHeader)
        strHeader1.append(nextLine1)
        if zoomLink{
                     strHeader1.append(imageZoom)

                 }
        strHeader1.append(strLocation)
        strHeader1.addAttribute(NSAttributedString.Key.paragraphStyle, value: paraSlot, range: NSMakeRange(0, strHeader1.length))
        lblLocation.attributedText = strHeader1
        
        UIButton.buttonUIHandling(button: btnCancel, text: "Cancel", backgroundColor:.white , textColor: ILColor.color(index: 23), fontType: fontMedium)
        UIButton.buttonUIHandling(button: BtnNext, text: "Next", backgroundColor:.white , textColor: ILColor.color(index: 23), fontType: fontHeavy)
        
    }
    
}
