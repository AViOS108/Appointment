//
//  DashBoardAppointmentTableViewCell.swift
//  Appointment
//
//  Created by Anurag Bhakuni on 20/09/20.
//  Copyright © 2020 Anurag Bhakuni. All rights reserved.
//

import UIKit

// 1 : - Feedback
// 2 :- View Detail
// 3:- Cancel


protocol DashBoardAppointmentTableViewCellDelegate {
    func redirectAppoinment(openMOdal:ERSideAppointmentModalNewResult,isFeedback: Int)
}

class DashBoardAppointmentTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var viewDateContainer: UIView!
    @IBOutlet weak var lblImageView: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblNoCoach: UILabel!
    @IBOutlet weak var lblDescribtion: UILabel!
    @IBOutlet weak var lblTimeVenue: UILabel!
    @IBOutlet weak var lblMonth: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    var appointmentModal: ERSideAppointmentModalNewResult!
    
    @IBOutlet weak var btnCancelAppoHeightConstraints: NSLayoutConstraint!

    
    @IBOutlet weak var viewContainer: UIView!
    var delegate : DashBoardAppointmentTableViewCellDelegate!
    
  
    @IBOutlet weak var btnFeedback: UIButton!
    @IBAction func btnFeedbackTapped(_ sender: Any) {
        
        if self.appointmentModal.typeERSide == 1{
            delegate.redirectAppoinment(openMOdal: self.appointmentModal, isFeedback: 3)
        }
        else{
            if (appointmentModal.state == "confirmed" && appointmentModal.requests![0].hasAttended == 1)
            {
                if let feedback = appointmentModal.requests![0].feedback{
                    
                }
                else{
                    delegate.redirectAppoinment(openMOdal: self.appointmentModal, isFeedback: 1)

                }
            }
            else{
               
            }
        }
        
        

    }
    func customize(noAppoinment: Bool,text:String)  {
        if noAppoinment {
            self.viewContainer.isHidden = true
            self.lblNoCoach.isHidden = false
            
            let fontMedium = UIFont(name: "FontMedium".localized(), size: Device.FONTSIZETYPE16)
            UILabel.labelUIHandling(label: lblNoCoach, text: text, textColor:ILColor.color(index: 28) , isBold: false, fontType: fontMedium)
    
        }else{
            
            let fontMedium = UIFont(name: "FontMedium".localized(), size: Device.FONTSIZETYPE12)

            if (appointmentModal.requests?[0].state == "rejected") {
                
                UILabel.labelUIHandling(label: lblStatus, text: "Rejected", textColor:ILColor.color(index: 12) , isBold: false, fontType: fontMedium)

            } else if (appointmentModal.typeERSide ==  1) {
               
                if  GeneralUtility.isPastDate(date: appointmentModal.startDatetime!) && !GeneralUtility.isPastDate(date: appointmentModal.endDatetime!) {
                    
                    UILabel.labelUIHandling(label: lblStatus, text: "Ongoing", textColor:ILColor.color(index: 14) , isBold: false, fontType: fontMedium)

                }
                    
                else if appointmentModal.state == "pending" && appointmentModal.state == "accepted"
                    {
                    UILabel.labelUIHandling(label: lblStatus, text: "To be finalized", textColor:ILColor.color(index: 15) , isBold: false, fontType: fontMedium)
                    }
                else {
                    UILabel.labelUIHandling(label: lblStatus, text: "Confirmed", textColor:ILColor.color(index: 15) , isBold: false, fontType: fontMedium)
                    }
                  }
            else if (appointmentModal.typeERSide == 2) {
                
                    if (GeneralUtility.isPastDate(date: appointmentModal.startDatetime!)) {
                        UILabel.labelUIHandling(label: lblStatus, text: "Request Expired", textColor:ILColor.color(index: 12) , isBold: false, fontType: fontMedium)
                    } else if (appointmentModal.requests?[0].state == "pending") {
                        UILabel.labelUIHandling(label: lblStatus, text: "Pending", textColor:ILColor.color(index: 60) , isBold: false, fontType: fontMedium)
                    }
                  }
            else if (appointmentModal.typeERSide == 3) {
                
                    if (appointmentModal.state == "confirmed") {
                        UILabel.labelUIHandling(label: lblStatus, text: "Completed", textColor:ILColor.color(index: 14) , isBold: false, fontType: fontMedium)
                    } else if (appointmentModal.state == "pending") {
                        
                        UILabel.labelUIHandling(label: lblStatus, text: "Request Expired", textColor:ILColor.color(index: 12) , isBold: false, fontType: fontMedium)

                    } else if (appointmentModal.state == "cancelled") {
                        
                        UILabel.labelUIHandling(label: lblStatus, text: "Cancelled", textColor:ILColor.color(index: 12) , isBold: false, fontType: fontMedium)

                    } else if (appointmentModal.state == "rejected") {
                        UILabel.labelUIHandling(label: lblStatus, text: "Rejected", textColor:ILColor.color(index: 12) , isBold: false, fontType: fontMedium)

                    } else {
                        UILabel.labelUIHandling(label: lblStatus, text: "Unknown Status", textColor:ILColor.color(index: 6) , isBold: false, fontType: fontMedium)

                    }
                  }
            
            
            
            
            self.viewContainer.isHidden = false
            self.lblNoCoach.isHidden = true
            let strHeader = NSMutableAttributedString.init()
            let strHeaderDesc = NSMutableAttributedString.init()

            let radius =  (Int)(lblImageView.frame.height)/2
            if let urlImage = URL.init(string: self.appointmentModal.coachDetails?.name ?? "") {
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
   
            if let fontHeavy = UIFont(name: "FontHeavy".localized(), size: Device.FONTSIZETYPE13), let fontBook =  UIFont(name: "FontBook".localized(), size: Device.FONTSIZETYPE14)

            {
                let strTiTle = NSAttributedString.init(string: GeneralUtility.optionalHandling(_param: self.appointmentModal.coachDetails?.name, _returnType: String.self)
                    , attributes: [NSAttributedString.Key.foregroundColor : ILColor.color(index:34),NSAttributedString.Key.font : fontHeavy]);
                let nextLine1 = NSAttributedString.init(string: "\n")
                let strType = NSAttributedString.init(string: GeneralUtility.optionalHandling(_param: "coachType", _returnType: String.self)
                    , attributes: [NSAttributedString.Key.foregroundColor : ILColor.color(index: 34),NSAttributedString.Key.font : fontBook]);
                let para = NSMutableParagraphStyle.init()
                //            para.alignment = .center
                para.lineSpacing = 4
                strHeader.append(strTiTle)
//                strHeader.append(nextLine1)
//                strHeader.append(strType)
                strHeader.addAttribute(NSAttributedString.Key.paragraphStyle, value: para, range: NSMakeRange(0, strHeader.length))
                lblDescribtion.attributedText = strHeader
            }
            let weekDay = ["Sun","Mon","Tue","Wed","Thu","Fri","Sat"]
            var componentDay = GeneralUtility.dateComponent(date: self.appointmentModal.startDatetimeUTC!, component: .weekday)

            if let fontHeavy = UIFont(name: "FontHeavy".localized(), size: Device.FONTSIZETYPE13), let fontBook =  UIFont(name: "FontBook".localized(), size: Device.FONTSIZETYPE14)

            {
                
                let strTiTle = NSAttributedString.init(string: GeneralUtility.optionalHandling(_param: "\(weekDay[(componentDay?.weekday ?? 1) - 1]), " +
                                                                                                
                                                                                                GeneralUtility.startAndEndDateDetail(startDate: self.appointmentModal.startDatetimeUTC ?? "", endDate: self.appointmentModal.endDatetimeUTC ?? "")
                                                                                               
                                                                                               , _returnType: String.self)
                                                       , attributes: [NSAttributedString.Key.foregroundColor : ILColor.color(index:13),NSAttributedString.Key.font : fontHeavy]);
                let nextLine1 = NSAttributedString.init(string: "\n")
                
                let image1Attachment = NSTextAttachment()
                image1Attachment.image = UIImage(named: "calenderAppoList")
                image1Attachment.bounds = CGRect.init(x: 0, y: -2, width: 14, height: 14)
                // wrap the attachment in its own attributed string so we can append it
                let imageMeeting = NSAttributedString(attachment: image1Attachment)
                
                let image4Attachment = NSTextAttachment()
                image4Attachment.image = UIImage(named: "")
                image4Attachment.bounds = CGRect.init(x: 0, y: 0, width: 10, height: 10)
                // wrap the attachment in its own attributed string so we can append it
                let imageSpace = NSAttributedString(attachment: image4Attachment)
                
                let image2Attachment = NSTextAttachment()
                image2Attachment.image = UIImage(named: "locationAppo")
                image2Attachment.bounds = CGRect.init(x: 0, y: -2, width: 12, height: 14)
                // wrap the attachment in its own attributed string so we can append it
                let imageLocation = NSAttributedString(attachment: image2Attachment)
               
                
                
                
                let strType = NSAttributedString.init(string: GeneralUtility.optionalHandling(_param: self.appointmentModal.location, _returnType: String.self)
                                                      , attributes: [NSAttributedString.Key.foregroundColor : ILColor.color(index: 13),NSAttributedString.Key.font : fontBook]);
                let para = NSMutableParagraphStyle.init()
                //            para.alignment = .center
                para.lineSpacing = 4
                strHeaderDesc.append(imageMeeting)
                strHeaderDesc.append(imageSpace)
                strHeaderDesc.append(strTiTle)
                strHeaderDesc.append(nextLine1)
                strHeaderDesc.append(imageLocation)
                strHeaderDesc.append(imageSpace)
                strHeaderDesc.append(strType)

                strHeaderDesc.addAttribute(NSAttributedString.Key.paragraphStyle, value: para, range: NSMakeRange(0, strHeaderDesc.length))
                lblTimeVenue.attributedText = strHeaderDesc
            }


//            if self.appointmentModal.coachDetails?.name == nil ||
//                GeneralUtility.optionalHandling(_param: self.appointmentModal.coach?.profilePicURL?.isBlank, _returnType: Bool.self)
//            {
                self.imageView?.isHidden = true
                self.lblImageView.isHidden = false
                let stringImg = GeneralUtility.startNameCharacter(stringName: self.appointmentModal.coachDetails?.name ?? " ")
                if let fontMedium = UIFont(name: "FontMedium".localized(), size: Device.FONTSIZETYPE15)
                {

                    UILabel.labelUIHandling(label: lblImageView, text: GeneralUtility.optionalHandling(_param: stringImg, _returnType: String.self), textColor:.black , isBold: false , fontType: fontMedium, isCircular: true,  backgroundColor:.white ,cornerRadius: radius,borderColor:UIColor.black,borderWidth: 1 )
                    lblImageView.textAlignment = .center
                    lblImageView.layer.borderColor = UIColor.black.cgColor
                }
//            }
//            else
//            {
//                self.lblImageView.isHidden = true
//                self.imageView?.isHidden = false
//            }

            let fontHeavy2 = UIFont(name: "FontHeavy".localized(), size: Device.FONTSIZETYPE13)

            UIButton.buttonUIHandling(button: btnFeedback, text: "Cancel Appointment", backgroundColor:UIColor.white ,textColor: ILColor.color(index: 23),borderColor: ILColor.color(index: 23), borderWidth: 1,fontType:fontHeavy2)
            
            btnFeedback.cornerRadius = 3
            btnFeedback.sizeToFit()
            btnFeedback.titleLabel?.adjustsFontSizeToFitWidth = true
            btnFeedback.isUserInteractionEnabled = true
            btnFeedback.isEnabled = true
           
            
            if self.appointmentModal.typeERSide == 1{
                btnFeedback.isHidden = false
                btnCancelAppoHeightConstraints.constant = 30
            }
            else{
                if (appointmentModal.state == "confirmed" && appointmentModal.requests![0].hasAttended == 1)
                {
                    if let feedback = appointmentModal.requests![0].feedback{
                        
                    }
                    else{
                        btnFeedback.isHidden = false
                        btnCancelAppoHeightConstraints.constant = 30
                        UIButton.buttonUIHandling(button: btnFeedback, text: "Leave a Feedback", backgroundColor:.clear ,textColor: ILColor.color(index: 23),fontType:fontHeavy2)
                    }
                }
                else{
                    btnFeedback.isHidden = true
                    btnCancelAppoHeightConstraints.constant = 0
                }
            }

            let monthI   = ["Jan","Feb","Mar","Apr","May","Jun","July","Aug","Sep","Oct","Nov","Dec"]

            shadowWithCorner(viewContainer: self.viewContainer, cornerRadius: 10)
            shadowWithCorner(viewContainer: self.viewDateContainer, cornerRadius: 3)
            viewDateContainer.clipsToBounds = true
            viewDateContainer.backgroundColor = ILColor.color(index: 33)
            let componentDate = GeneralUtility.dateComponent(date: self.appointmentModal.startDatetimeUTC!, component: .day)
            if let dayI = componentDate?.day {
                let fontMedium = UIFont(name: "FontHeavy".localized(), size: Device.FONTSIZETYPE15)

                UILabel.labelUIHandling(label: lblDate, text: "\(dayI)", textColor:ILColor.color(index: 34) , isBold: false, fontType: fontMedium)
                lblDate.textAlignment = .center
                lblDate.backgroundColor = .white

            }
            let componentMonth = GeneralUtility.dateComponent(date: self.appointmentModal.startDatetimeUTC!, component: .month)
            if let monthCom = componentMonth?.month {
                let fontMedium = UIFont(name: "FontMedium".localized(), size: Device.FONTSIZETYPE15)
                UILabel.labelUIHandling(label: lblMonth, text: "\(monthI[monthCom-1])", textColor:ILColor.color(index: 3) , isBold: false, fontType: fontMedium,backgroundColor: ILColor.color(index: 33))
                lblMonth.textAlignment = .center
            }
        }
        self.backgroundColor = .clear
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
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
