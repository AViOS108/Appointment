//
//  ERSideOHDetailViewController.swift
//  Appointment
//
//  Created by Anurag Bhakuni on 27/11/20.
//  Copyright © 2020 Anurag Bhakuni. All rights reserved.
//

import UIKit

class ERSideOHDetailViewController: UIViewController,UIGestureRecognizerDelegate {
    
    
    @IBOutlet weak var btnCross: UIButton!
    
    @IBAction func btnCrossTapped(_ sender: Any) {
    }
    
    @IBOutlet weak var btnDelete: UIButton!
    
    @IBAction func btnDeleteTapped(_ sender: Any) {
    }
    
    @IBOutlet weak var btnEdit: UIButton!
    
    @IBAction func btnEditTapped(_ sender: Any) {
        
        self.dismiss(animated: false) {
            let objERSideOpenHourListVC = ERSideOpenCreateEditVC.init(nibName: "ERSideOpenCreateEditVC", bundle: nil)
            objERSideOpenHourListVC.objERSideOpenHourDetail = self.objERSideOpenHourDetail
            self.viewControllerI.navigationController?.pushViewController(objERSideOpenHourListVC, animated: false)
        }
        
    }
    var viewControllerI : UIViewController!

    @IBOutlet weak var viewContainer: UIView!
    
    @IBOutlet weak var lblHeade: UILabel!
    
    @IBOutlet var viewSeprators: [UIView]!
    
    @IBOutlet weak var lblPurpose: UILabel!
    
    @IBOutlet weak var lblFromTiming: UILabel!
    
    @IBOutlet weak var lblToTiming: UILabel!
    @IBOutlet weak var lblRequestApp: UILabel!
    
    @IBOutlet weak var lblSlotDuration: UILabel!
    
    @IBOutlet weak var lblLocation: UILabel!
    
    @IBOutlet weak var lblParticipant: UILabel!
    var objERSideOpenHourDetail: ERSideOpenHourDetail?
    var identifier : String!
    var activityIndicator: ActivityIndicatorView?

    @IBOutlet weak var viewInner: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.callViewModal()
        
        // Do any additional setup after loading the view.
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        self.view.tag = 19682
        self.viewInner.tag = 19683
        tapGesture()
        viewInner.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.2)
        viewContainer.backgroundColor = .white
        viewContainer.cornerRadius = 3;
        self.viewSeprators.forEach { (viewSeperator) in
            viewSeperator.backgroundColor = ILColor.color(index: 22)
        }
        self.customization()
        if let fontHeavy = UIFont(name: "FontHeavy".localized(), size: Device.FONTSIZETYPE15), let fontBook =  UIFont(name: "FontBook".localized(), size: Device.FONTSIZETYPE14)
            
        {
            
            UIButton.buttonUIHandling(button: btnDelete, text: "Delete", backgroundColor: .white, textColor: ILColor.color(index: 23),  fontType: fontBook)
            UIButton.buttonUIHandling(button: btnEdit, text: "Edit", backgroundColor: .white, textColor: ILColor.color(index: 23),  fontType: fontHeavy)
            
        }
        
        btnCross.imageView?.image = UIImage.init(named: "Cross")
        
        
    }
      
      func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
          if touch.view?.isDescendant(of: self.view) == true  && touch.view?.tag != 19682  {
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
    
    
    func callViewModal()  {
        
        viewContainer.isHidden = true
        activityIndicator = ActivityIndicatorView.showActivity(view: self.view, message: StringConstants.FetchingCoachSelection)
        ERSideOpenHourDetailVM().fetchOpenHourDetail(id: identifier, { (data) in
            do {
                self.activityIndicator?.hide()
                self.objERSideOpenHourDetail = try
                    JSONDecoder().decode(ERSideOpenHourDetail.self, from: data)
                self.customization();
            } catch   {
                print(error)
                
            }
        }) { (error, errorCode) in
        }
    }
    
    
    
    
    
    
    
    func customization()  {
        if let fontHeavy = UIFont(name: "FontHeavy".localized(), size: Device.FONTSIZETYPE15)
        {
            
            let txtHeader = "Open Hour " + GeneralUtility.currentDateDetailType5(emiDate: self.objERSideOpenHourDetail?.startDatetimeUTC ?? "")
            UILabel.labelUIHandling(label: lblHeade, text: txtHeader, textColor: .black, isBold: true, fontType: fontHeavy)
            
        }
        var purpose = "NA"
        if (objERSideOpenHourDetail?.purposes) != nil{
            var index = 0
            for objPurpose in (objERSideOpenHourDetail?.purposes)!{
                purpose = objPurpose.userPurpose?.displayName ?? ""
                index = index + 1;
                if objERSideOpenHourDetail?.purposes?.count ?? 0 > index{
                    purpose = purpose + ","
                }
            }
        }
        
        
        if let fontHeavy = UIFont(name: "FontHeavy".localized(), size: Device.FONTSIZETYPE15), let fontBook =  UIFont(name: "FontBook".localized(), size: Device.FONTSIZETYPE14)
            
        {
            
            let strHeader = NSMutableAttributedString.init()
            let strTiTle = NSAttributedString.init(string: "Purpose"
                , attributes: [NSAttributedString.Key.foregroundColor : ILColor.color(index:34),NSAttributedString.Key.font : fontHeavy]);
            let nextLine1 = NSAttributedString.init(string: "\n")
            let strType = NSAttributedString.init(string: purpose
                , attributes: [NSAttributedString.Key.foregroundColor : ILColor.color(index: 34),NSAttributedString.Key.font : fontBook]);
            let para = NSMutableParagraphStyle.init()
            //            para.alignment = .center
            para.lineSpacing = 4
            strHeader.append(strTiTle)
            strHeader.append(nextLine1)
            strHeader.append(strType)
            strHeader.addAttribute(NSAttributedString.Key.paragraphStyle, value: para, range: NSMakeRange(0, strHeader.length))
            lblPurpose.attributedText = strHeader
        }
        
        
        if let fontHeavy = UIFont(name: "FontHeavy".localized(), size: Device.FONTSIZETYPE15), let fontBook =  UIFont(name: "FontBook".localized(), size: Device.FONTSIZETYPE14)
            
        {
            
            let strHeader = NSMutableAttributedString.init()
            let strFrom = NSAttributedString.init(string: "From"
                , attributes: [NSAttributedString.Key.foregroundColor : ILColor.color(index:34),NSAttributedString.Key.font : fontHeavy]);
          
            
            let nextLine1 = NSAttributedString.init(string: "\n")
            
            let strFromValue = NSAttributedString.init(string: GeneralUtility.currentDateDetailType3(emiDate: objERSideOpenHourDetail?.startDatetimeUTC ?? "")
                , attributes: [NSAttributedString.Key.foregroundColor : ILColor.color(index: 34),NSAttributedString.Key.font : fontBook]);
            
          
            
            let para = NSMutableParagraphStyle.init()
            //            para.alignment = .center
            para.lineSpacing = 4
            strHeader.append(strFrom)
            strHeader.append(nextLine1)
            strHeader.append(strFromValue);
            strHeader.addAttribute(NSAttributedString.Key.paragraphStyle, value: para, range: NSMakeRange(0, strHeader.length))
            lblFromTiming.attributedText = strHeader
        }
        
        if let fontHeavy = UIFont(name: "FontHeavy".localized(), size: Device.FONTSIZETYPE15), let fontBook =  UIFont(name: "FontBook".localized(), size: Device.FONTSIZETYPE14)
            
        {
            
            let strHeader = NSMutableAttributedString.init()
       
            let strTo = NSAttributedString.init(string: "\tTo"
                , attributes: [NSAttributedString.Key.foregroundColor : ILColor.color(index:34),NSAttributedString.Key.font : fontHeavy]);
            
            let nextLine1 = NSAttributedString.init(string: "\n")
          
            let strToValue = NSAttributedString.init(string: "\t" + GeneralUtility.currentDateDetailType3(emiDate: objERSideOpenHourDetail?.endDatetimeUTC ?? "")
                , attributes: [NSAttributedString.Key.foregroundColor : ILColor.color(index: 34),NSAttributedString.Key.font : fontBook]);
            
            let para = NSMutableParagraphStyle.init()
            //            para.alignment = .center
            para.lineSpacing = 4
            strHeader.append(strTo)
            strHeader.append(nextLine1)
            strHeader.append(strToValue);
            strHeader.addAttribute(NSAttributedString.Key.paragraphStyle, value: para, range: NSMakeRange(0, strHeader.length))
            lblToTiming.attributedText = strHeader
        }
        
        
        
        
        
        if let fontHeavy = UIFont(name: "FontHeavy".localized(), size: Device.FONTSIZETYPE15), let fontBook =  UIFont(name: "FontBook".localized(), size: Device.FONTSIZETYPE14)
            
        {
            
            let strHeader = NSMutableAttributedString.init()
            let strRequest = NSAttributedString.init(string: "Request Approval"
                , attributes: [NSAttributedString.Key.foregroundColor : ILColor.color(index:34),NSAttributedString.Key.font : fontHeavy]);
            let nextLine1 = NSAttributedString.init(string: "\n")
            let strRequestValue = NSAttributedString.init(string: objERSideOpenHourDetail?.state ?? "NA"
                , attributes: [NSAttributedString.Key.foregroundColor : ILColor.color(index: 34),NSAttributedString.Key.font : fontBook]);
            let para = NSMutableParagraphStyle.init()
            //            para.alignment = .center
            para.lineSpacing = 4
            strHeader.append(strRequest)
            strHeader.append(nextLine1)
            strHeader.append(strRequestValue)
            strHeader.addAttribute(NSAttributedString.Key.paragraphStyle, value: para, range: NSMakeRange(0, strHeader.length))
            lblRequestApp.attributedText = strHeader
        }
        
        if let fontHeavy = UIFont(name: "FontHeavy".localized(), size: Device.FONTSIZETYPE15), let fontBook =  UIFont(name: "FontBook".localized(), size: Device.FONTSIZETYPE14)
            
        {
            
            let strHeader = NSMutableAttributedString.init()
            let strSlotDuration = NSAttributedString.init(string: "Slot Duration"
                , attributes: [NSAttributedString.Key.foregroundColor : ILColor.color(index:34),NSAttributedString.Key.font : fontHeavy]);
            let nextLine1 = NSAttributedString.init(string: "\n")
            let strSlotDurationValue = NSAttributedString.init(string:"\(objERSideOpenHourDetail?.duration ?? 450/30)"
                , attributes: [NSAttributedString.Key.foregroundColor : ILColor.color(index: 34),NSAttributedString.Key.font : fontBook]);
            let para = NSMutableParagraphStyle.init()
            //            para.alignment = .center
            para.lineSpacing = 4
            strHeader.append(strSlotDuration)
            strHeader.append(nextLine1)
            strHeader.append(strSlotDurationValue)
            strHeader.addAttribute(NSAttributedString.Key.paragraphStyle, value: para, range: NSMakeRange(0, strHeader.length))
            lblSlotDuration.attributedText = strHeader
        }
        
        if let fontHeavy = UIFont(name: "FontHeavy".localized(), size: Device.FONTSIZETYPE15), let fontBook =  UIFont(name: "FontBook".localized(), size: Device.FONTSIZETYPE14)
            
        {
            var strLocation = "Not available", strLocationValue = ""
            var imageName = "false"
            
            if let str = self.objERSideOpenHourDetail?.locations{
                if str.count > 0 {
                    strLocationValue = (str[0].data?.value) ?? "Not available"
                    if str[0].provider == "zoom_link"{
                        imageName = "Zoom"
                        strLocation = " Zoom"
                    }
                    else  if str[0].provider == "physical_location"{
                        imageName = "custom_location"
                        strLocation = " Physical Location"
                        
                    }
                    else{
                        imageName = "In_person_meeting"
                        strLocation = " Meeting Url"
                    }
                }
                
            }
            
            
            
            
            let strHeader = NSMutableAttributedString.init()
            let strLocationText = NSAttributedString.init(string: "Location"
                , attributes: [NSAttributedString.Key.foregroundColor : ILColor.color(index:34),NSAttributedString.Key.font : fontHeavy]);
            
            let image1Attachment = NSTextAttachment()
            image1Attachment.image = UIImage(named: imageName)
            image1Attachment.bounds = CGRect.init(x: 0, y: 0, width: 20, height: 20)
            
            
            // wrap the attachment in its own attributed string so we can append it
            let imageLocation = NSAttributedString(attachment: image1Attachment)
            
            
            let nextLine1 = NSAttributedString.init(string: "\n")
            let strLocationTe = NSAttributedString.init(string: strLocation
                , attributes: [NSAttributedString.Key.foregroundColor : ILColor.color(index: 34),NSAttributedString.Key.font : fontBook]);
            let strLocationValueI = NSAttributedString.init(string: strLocationValue
                , attributes: [NSAttributedString.Key.foregroundColor : ILColor.color(index: 34),NSAttributedString.Key.font : fontBook]);
            let para = NSMutableParagraphStyle.init()
            //            para.alignment = .center
            para.lineSpacing = 4
            strHeader.append(strLocationText)
            strHeader.append(nextLine1)
            strHeader.append(imageLocation)
            strHeader.append(strLocationTe)
            strHeader.append(nextLine1)
            strHeader.append(strLocationValueI)
            
            strHeader.addAttribute(NSAttributedString.Key.paragraphStyle, value: para, range: NSMakeRange(0, strHeader.length))
            lblLocation.attributedText = strHeader
        }
        
        
        if let fontHeavy = UIFont(name: "FontHeavy".localized(), size: Device.FONTSIZETYPE15), let fontBook =  UIFont(name: "FontBook".localized(), size: Device.FONTSIZETYPE14)
            
        {
            
            
            var participants = "NA"
            
            if (objERSideOpenHourDetail?.participants) != nil{
                
                if objERSideOpenHourDetail?.participants!.count ?? 0 > 0 {
                    participants = objERSideOpenHourDetail?.participants![0].name ?? ""
                }
                
                if objERSideOpenHourDetail?.participants!.count ?? 0 > 1 {
                    participants = participants + ", + \((objERSideOpenHourDetail?.participants!.count ?? 0) - 1 )"
                    
                }
            }
            
            
            
            
            let strHeader = NSMutableAttributedString.init()
            let strParticipants = NSAttributedString.init(string: "Participants"
                , attributes: [NSAttributedString.Key.foregroundColor : ILColor.color(index:34),NSAttributedString.Key.font : fontHeavy]);
            let nextLine1 = NSAttributedString.init(string: "\n")
            let strParticipantsValue = NSAttributedString.init(string:participants
                , attributes: [NSAttributedString.Key.foregroundColor : ILColor.color(index: 34),NSAttributedString.Key.font : fontBook]);
            let para = NSMutableParagraphStyle.init()
            //            para.alignment = .center
            para.lineSpacing = 4
            strHeader.append(strParticipants)
            strHeader.append(nextLine1)
            strHeader.append(strParticipantsValue)
            strHeader.addAttribute(NSAttributedString.Key.paragraphStyle, value: para, range: NSMakeRange(0, strHeader.length))
            lblParticipant.attributedText = strHeader
        }
        
        viewContainer.isHidden = false

    }
}
