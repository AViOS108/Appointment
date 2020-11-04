//
//  AppoinmentDescriptionTableViewCell.swift
//  Appointment
//
//  Created by Anurag Bhakuni on 25/09/20.
//  Copyright © 2020 Anurag Bhakuni. All rights reserved.
//

import UIKit

class AppoinmentDescriptionTableViewCell: UITableViewCell {

    @IBOutlet weak var viewContainer: UIView!
      @IBOutlet weak var lblImageView: UILabel!
      @IBOutlet weak var imgView: UIImageView!
      @IBOutlet weak var lblDescribtion: UILabel!
      @IBOutlet weak var lblName: UILabel!
    
     var appoinmentDetailModalObj : AppoinmentDetailModal?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
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
    
    
    func customization()  {
        
        self.backgroundColor = .clear
        
        let strHeader = NSMutableAttributedString.init()
        
        self.shadowWithCorner(viewContainer: viewContainer, cornerRadius: 3)
        
        
        let radius =  (Int)(lblImageView.frame.height)/2
        if let urlImage = URL.init(string: self.appoinmentDetailModalObj?.coach?.profilePicURL ?? "") {
            self.imgView
                .setImageWith(urlImage, placeholderImage: UIImage.init(named: "Placeeholderimage"))
            self.imgView?.cornerRadius = CGFloat(radius)
            imgView?.clipsToBounds = true
            //                self.imgView.layer.borderColor = UIColor.black.cgColor
            //                self.imgView.layer.borderWidth = 1
            self.imgView?.layer.masksToBounds = true;
        }
        else{
            self.imgView.image = UIImage.init(named: "Placeeholderimage");
            //            self.imgView.contentMode = .scaleAspectFit;
        }
        var coachType = ""
        if self.appoinmentDetailModalObj?.coach?.roleMachineName.rawValue == "career_coach"{
            coachType = "Career Coach"
        }
        else{
            coachType = "Alumni"
        }
        
        
        if let fontHeavy = UIFont(name: "FontHeavy".localized(), size: Device.FONTSIZETYPE15), let fontBook =  UIFont(name: "FontBook".localized(), size: Device.FONTSIZETYPE14)
            
        {
            let strTiTle = NSAttributedString.init(string: GeneralUtility.optionalHandling(_param: self.appoinmentDetailModalObj?.coach?.name, _returnType: String.self)
                , attributes: [NSAttributedString.Key.foregroundColor : ILColor.color(index:34),NSAttributedString.Key.font : fontHeavy]);
            let nextLine1 = NSAttributedString.init(string: "\n")
            let strType = NSAttributedString.init(string: GeneralUtility.optionalHandling(_param: coachType, _returnType: String.self)
                , attributes: [NSAttributedString.Key.foregroundColor : ILColor.color(index: 34),NSAttributedString.Key.font : fontBook]);
            let para = NSMutableParagraphStyle.init()
            //            para.alignment = .center
            para.lineSpacing = 4
            strHeader.append(strTiTle)
            strHeader.append(nextLine1)
            strHeader.append(strType)
            strHeader.addAttribute(NSAttributedString.Key.paragraphStyle, value: para, range: NSMakeRange(0, strHeader.length))
            lblName.attributedText = strHeader
        }
        
        
        
        
        
        if self.appoinmentDetailModalObj?.coach?.profilePicURL == nil ||
            GeneralUtility.optionalHandling(_param: self.appoinmentDetailModalObj?.coach?.profilePicURL?.isBlank, _returnType: Bool.self)
        {
            self.imageView?.isHidden = true
            self.lblImageView.isHidden = false
            var stringImg = GeneralUtility.startNameCharacter(stringName: self.appoinmentDetailModalObj?.coach?.name ?? " ")
            if let fontMedium = UIFont(name: "FontMedium".localized(), size: Device.FONTSIZETYPE15)
            {
                
                UILabel.labelUIHandling(label: lblImageView, text: GeneralUtility.optionalHandling(_param: stringImg, _returnType: String.self), textColor:.black , isBold: false , fontType: fontMedium, isCircular: true,  backgroundColor:.white ,cornerRadius: radius,borderColor:UIColor.black,borderWidth: 1 )
                lblImageView.textAlignment = .center
                lblImageView.layer.borderColor = UIColor.black.cgColor
            }
        }
        else
        {
            self.lblImageView.isHidden = true
            self.imageView?.isHidden = false
        }
        
        let strHeaderDescription = NSMutableAttributedString.init()

        
        let weekDay = ["Sun","Mon","Tues","Wed","Thu","Fri","Sat"]
        var componentDay = GeneralUtility.dateComponent(date: self.appoinmentDetailModalObj?.startDatetimeUTC ?? "", component: .weekday)
        
        if let fontMedium = UIFont(name: "FontHeavy".localized(), size: Device.FONTSIZETYPE12), let fontBook =  UIFont(name: "FontBook".localized(), size: Device.FONTSIZETYPE14)
            
        {
            var summary = ""
            if self.appoinmentDetailModalObj?.coach?.summary.isEmpty ?? true{
                summary = "No summary available"
            }
            else{
                summary = (self.appoinmentDetailModalObj?.coach?.summary) ?? ""
            }
            
            let strSummary = NSAttributedString.init(string: GeneralUtility.optionalHandling(_param: summary, _returnType: String.self)
                , attributes: [NSAttributedString.Key.foregroundColor : ILColor.color(index:34),NSAttributedString.Key.font : fontBook]);
            let nextLine1 = NSAttributedString.init(string: "\n")
            let strMeetingText = NSAttributedString.init(string: GeneralUtility.optionalHandling(_param: "Meeting Date & Time", _returnType: String.self)
                , attributes: [NSAttributedString.Key.foregroundColor : ILColor.color(index: 34),NSAttributedString.Key.font : fontMedium]);
            let strMeetingValue = NSAttributedString.init(string: GeneralUtility.optionalHandling(_param: "\(weekDay[(componentDay?.weekday ?? 1) - 1]), " +   GeneralUtility.startAndEndDateDetail(startDate: self.appoinmentDetailModalObj?.startDatetimeUTC ?? "", endDate: self.appoinmentDetailModalObj?.endDatetimeUTC ?? ""),
                                                                                                  _returnType: String.self)
                , attributes: [NSAttributedString.Key.foregroundColor : ILColor.color(index:34),NSAttributedString.Key.font : fontBook]);
            
            let strLocationText = NSAttributedString.init(string: GeneralUtility.optionalHandling(_param: "Location/Meeting Link", _returnType: String.self)
                , attributes: [NSAttributedString.Key.foregroundColor : ILColor.color(index: 34),NSAttributedString.Key.font : fontMedium]);
            
            
            var strLocation = "Not available"
            var zoomLink = false
            
            if let str = self.appoinmentDetailModalObj?.locations{
                if str.count > 0 {
                    strLocation = (str[0].data?.value) ?? "Not available"
                    if str[0].provider == "zoom_link"{
                                       zoomLink = true
                                       strLocation = " Zoom"
                                   }
                }
                
               
                
                
            }
                   
            
            
            let image1Attachment = NSTextAttachment()
            image1Attachment.image = UIImage(named: "linkdin")
image1Attachment.image = UIImage(named: "linkdin")
            // wrap the attachment in its own attributed string so we can append it
          image1Attachment.bounds = CGRect.init(x: 0, y: -5, width: 20, height: 20)
            let imageZoom = NSAttributedString(attachment: image1Attachment)
            
            
            
            
            
            let strLocationValue = NSAttributedString.init(string: GeneralUtility.optionalHandling(_param: strLocation, _returnType: String.self)
                , attributes: [NSAttributedString.Key.foregroundColor : ILColor.color(index:34),NSAttributedString.Key.font : fontBook]);
            
            
            let strStatusText = NSAttributedString.init(string: GeneralUtility.optionalHandling(_param: "Status", _returnType: String.self)
                , attributes: [NSAttributedString.Key.foregroundColor : ILColor.color(index: 34),NSAttributedString.Key.font : fontMedium]);
            
            
            var strStatus = "Not available"
            if self.appoinmentDetailModalObj?.parent?.count ?? 0 > 0{
                strStatus = self.appoinmentDetailModalObj?.parent?[0].state ?? ""
            }
           
            
            
            let strStatusValue = NSAttributedString.init(string: GeneralUtility.optionalHandling(_param: strStatus.capitalized, _returnType: String.self)
                , attributes: [NSAttributedString.Key.foregroundColor : ILColor.color(index:34),NSAttributedString.Key.font : fontBook]);
            
            let para = NSMutableParagraphStyle.init()
            //            para.alignment = .center
            para.lineSpacing = 1
            strHeaderDescription.append(strSummary)
            strHeaderDescription.append(nextLine1)
            strHeaderDescription.append(nextLine1)
            
            strHeaderDescription.append(strMeetingText)
            strHeaderDescription.append(nextLine1)
            strHeaderDescription.append(strMeetingValue)
            
            strHeaderDescription.append(nextLine1)
            strHeaderDescription.append(nextLine1)
            
            strHeaderDescription.append(strLocationText)
            strHeaderDescription.append(nextLine1)
            if zoomLink{
                strHeaderDescription.append(imageZoom)

            }
            strHeaderDescription.append(strLocationValue)
            
            strHeaderDescription.append(nextLine1)
            strHeaderDescription.append(nextLine1)
            
            strHeaderDescription.append(strStatusText)
            strHeaderDescription.append(nextLine1)
            strHeaderDescription.append(strStatusValue)
            
            
            strHeaderDescription.addAttribute(NSAttributedString.Key.paragraphStyle, value: para, range: NSMakeRange(0, strHeaderDescription.length))
            lblDescribtion.attributedText = strHeaderDescription
        }
          
        
        
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
