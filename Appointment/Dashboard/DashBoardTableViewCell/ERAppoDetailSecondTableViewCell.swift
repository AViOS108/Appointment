//
//  ERAppoDetailSecondTableViewCell.swift
//  Appointment
//
//  Created by Anurag Bhakuni on 01/04/21.
//  Copyright © 2021 Anurag Bhakuni. All rights reserved.
//

import UIKit

class ERAppoDetailSecondTableViewCell: UITableViewCell {

    @IBOutlet weak var lblDescription: UILabel!
    var appoinmentDetailModalObj : AppoinmentDetailModalNew?
    var indexStatus = 0
    var viewController : UIViewController!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func customization(){
        
        let strHeader = NSMutableAttributedString.init()
        
        let image1Attachment = NSTextAttachment()
        image1Attachment.image = UIImage(named: "Zoom")
        image1Attachment.bounds = CGRect.init(x: 0, y: -5, width: 20, height: 20)
        // wrap the attachment in its own attributed string so we can append it
        let imageMeeting = NSAttributedString(attachment: image1Attachment)
        
        let image4Attachment = NSTextAttachment()
               image4Attachment.image = UIImage(named: "")
               image4Attachment.bounds = CGRect.init(x: 0, y: -5, width: 20, height: 20)
               // wrap the attachment in its own attributed string so we can append it
               let imageSpace = NSAttributedString(attachment: image4Attachment)
        
        
        let image2Attachment = NSTextAttachment()
        image2Attachment.image = UIImage(named: "Zoom")
        image2Attachment.bounds = CGRect.init(x: 0, y: -5, width: 20, height: 20)
        // wrap the attachment in its own attributed string so we can append it
        let imageLocation = NSAttributedString(attachment: image2Attachment)
        let image3Attachment = NSTextAttachment()
        image3Attachment.image = UIImage(named: "Zoom")
        image3Attachment.bounds = CGRect.init(x: 0, y: -5, width: 20, height: 20)
        // wrap the attachment in its own attributed string so we can append it
        let imageStatus  = NSAttributedString(attachment: image3Attachment)
        
        
        
        if let fontHeavy = UIFont(name: "FontHeavy".localized(), size: Device.FONTSIZETYPE13), let fontBook = UIFont(name: "FontBook".localized(), size: Device.FONTSIZETYPE13){
            let strMeetingText = NSAttributedString.init(string: GeneralUtility.optionalHandling(_param: " Meeting Date & Time", _returnType: String.self)
                , attributes: [NSAttributedString.Key.foregroundColor : ILColor.color(index:13),NSAttributedString.Key.font : fontHeavy]);
            
            
            let weekDay = ["Sun","Mon","Tue","Wed","Thu","Fri","Sat"]
            var componentDay = GeneralUtility.dateComponent(date: self.appoinmentDetailModalObj?.startDatetimeUTC ?? "", component: .weekday)
            let date = GeneralUtility.currentDateDetailType4(emiDate: self.appoinmentDetailModalObj?.startDatetimeUTC ?? "", fromDateF: "yyyy-MM-dd HH:mm:ss", toDateFormate: "dd MMM yyyy")
            
            var timeStartEnd =    GeneralUtility.startAndEndDateDetail2(startDate: self.appoinmentDetailModalObj?.startDatetimeUTC ?? "", endDate: self.appoinmentDetailModalObj?.timezone ?? "")
            
            var meetingCompleteTime = "\(weekDay[(componentDay?.weekday ?? 1) - 1]), " + date + timeStartEnd
            
            let strMeetingValue = NSAttributedString.init(string: GeneralUtility.optionalHandling(_param: "  " + meetingCompleteTime, _returnType: String.self)
                , attributes: [NSAttributedString.Key.foregroundColor : ILColor.color(index: 13),NSAttributedString.Key.font : fontBook]);
            
            
            let strLocationText = NSAttributedString.init(string: GeneralUtility.optionalHandling(_param: " Location/Meeting Link", _returnType: String.self)
                , attributes: [NSAttributedString.Key.foregroundColor : ILColor.color(index:13),NSAttributedString.Key.font : fontHeavy]);
            
            
            let strLocationValue = NSAttributedString.init(string: GeneralUtility.optionalHandling(_param: "  " + (self.appoinmentDetailModalObj?.location ?? ""), _returnType: String.self)
                , attributes: [NSAttributedString.Key.foregroundColor : ILColor.color(index:13),NSAttributedString.Key.font : fontHeavy]);
            
            let strStatusText = NSAttributedString.init(string: GeneralUtility.optionalHandling(_param: " Status", _returnType: String.self)
                , attributes: [NSAttributedString.Key.foregroundColor : ILColor.color(index:13),NSAttributedString.Key.font : fontHeavy]);
            
            let strStatusValue = NSAttributedString.init(string: GeneralUtility.optionalHandling(_param: "  " + "Upcoming", _returnType: String.self)
                , attributes: [NSAttributedString.Key.foregroundColor : ILColor.color(index:13),NSAttributedString.Key.font : fontHeavy]);
            
            let nextLine1 = NSAttributedString.init(string: "\n")
            
            let para = NSMutableParagraphStyle.init()
            //            para.alignment = .center
            para.lineSpacing = 3
            strHeader.append(imageMeeting)
            strHeader.append(strMeetingText)
            strHeader.append(nextLine1)
            strHeader.append(imageSpace)

            strHeader.append(strMeetingValue)
            strHeader.append(nextLine1)
            
            strHeader.append(imageLocation)
            strHeader.append(strLocationText)
            strHeader.append(nextLine1)
            strHeader.append(strLocationValue)
            strHeader.append(nextLine1)
            
            strHeader.append(imageStatus)
            strHeader.append(strStatusText)
            strHeader.append(nextLine1)
            strHeader.append(strStatusValue)
            strHeader.append(nextLine1)

            
            strHeader.addAttribute(NSAttributedString.Key.paragraphStyle, value: para, range: NSMakeRange(0, strHeader.length))
            lblDescription.attributedText = strHeader
            
        }
    }
        
}
