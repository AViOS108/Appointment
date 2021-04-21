//
//  ERSideMyAppoinmentTableViewCell.swift
//  Appointment
//
//  Created by Anurag Bhakuni on 23/11/20.
//  Copyright © 2020 Anurag Bhakuni. All rights reserved.
//

import UIKit

protocol ERSideMyAppoinmentTableViewCellDelegate {
    func changeInFollowingWith(results :ERSideAppointmentModalNewResult, index : Int? )
}



class ERSideMyAppoinmentTableViewCell: UITableViewCell {
  
    @IBOutlet weak var btnViewResume: UIButton!
    
    
    
    
    
    @IBOutlet weak var btnUpdateStatus: UIButton!
    
    @IBAction func btnUpdateStatusTapped(_ sender: Any) {
        delegate.changeInFollowingWith(results: results, index: 5)

    }

    @IBOutlet weak var nslayoutAcceptDeclineViewHeight: NSLayoutConstraint!
    @IBOutlet weak var nslayoutCandiateFeedbackView: NSLayoutConstraint!
    @IBOutlet weak var nslayoutUpdateStatusViewHeight: NSLayoutConstraint!
    @IBOutlet weak var nslayoutCustomerRatingViewHeight: NSLayoutConstraint!
    @IBOutlet weak var viewUpdateStatus: UIView!
    @IBOutlet weak var viewFeedback: UIView!
    @IBOutlet weak var viewAcceptDecline: UIView!
    @IBOutlet weak var viewCustomerRating: UIView!
    
    
    @IBOutlet weak var lblFeedback: UILabel!
    @IBOutlet var btnCoachPreciseGrp: [UIButton]!
    @IBAction func btnCoachPreTapped(_ sender: UIButton) {
//        coach_expertise = sender.tag
        self.btnCoachPreciseGrp.forEach { (btn) in
            
            if btn.tag <= sender.tag{
                btn.setImage(UIImage.init(named: "noun_Star_select"), for: .normal)
            }
            else{
                btn.setImage(UIImage.init(named: "noun_Star_nonselect"), for: .normal)
            }
            
        }
        
    }
    
    
    @IBOutlet weak var nslayputCollectionViewWidth: NSLayoutConstraint!
    @IBOutlet weak var viewCollection: UICollectionView!
    
    @IBOutlet weak var viewDateContainer: UIView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDescribtion: UILabel!
    @IBOutlet weak var lblMonth: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var btnAccept: UIButton!
    @IBOutlet weak var btnDecline: UIButton!
    
    var results: ERSideAppointmentModalNewResult!
    @IBOutlet weak var viewContainer: UIView!
    
    var colectionViewHandler = ERStudentOverlayView()
    
    
    var delegate : ERSideMyAppoinmentTableViewCellDelegate!
    
    func collectionViewDataFeed()  {
        colectionViewHandler.viewcontrollerI = self
        colectionViewHandler.viewCollection = self.viewCollection
        colectionViewHandler.customize();
        
    }
    
    
    
    func customize()  {
        self.viewContainer.isHidden = false
        let strHeader = NSMutableAttributedString.init()
        let strHeaderDesc = NSMutableAttributedString.init()
        collectionViewDataFeed();
        if let fontHeavy = UIFont(name: "FontHeavy".localized(), size: Device.FONTSIZETYPE13), let fontBook =  UIFont(name: "FontBook".localized(), size: Device.FONTSIZETYPE14)
            
        {
            let strTiTle = NSAttributedString.init(string: GeneralUtility.optionalHandling(_param: self.results.requests![0].studentDetails?.name, _returnType: String.self)
                , attributes: [NSAttributedString.Key.foregroundColor : ILColor.color(index:34),NSAttributedString.Key.font : fontHeavy]);
            let nextLine1 = NSAttributedString.init(string: "\n")
            let strType = NSAttributedString.init(string: GeneralUtility.optionalHandling(_param: self.results.requests![0].studentDetails?.benchmarkName, _returnType: String.self)
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
        let weekDay = ["Sun","Mon","Tue","Wed","Thu","Fri","Sat"]
        var componentDay = GeneralUtility.dateComponent(date: self.results.startDatetimeUTC!, component: .weekday)
        
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
        
        let stringImg = GeneralUtility.startNameCharacter(stringName: self.results.requests![0].studentDetails?.name ?? " ")
      
        
        
        let fontHeavy2 = UIFont(name: "FontHeavy".localized(), size: Device.FONTSIZETYPE13)
      
        UIButton.buttonUIHandling(button: btnAccept, text: "Accept", backgroundColor:UIColor.white ,textColor: ILColor.color(index: 23),borderColor: ILColor.color(index: 23), borderWidth: 1,fontType:fontHeavy2)
        UIButton.buttonUIHandling(button: btnDecline, text: "Decline", backgroundColor:UIColor.white ,textColor: ILColor.color(index: 23),borderColor: ILColor.color(index: 23), borderWidth: 1,fontType:fontHeavy2)
        
        btnAccept.cornerRadius = 3
        btnDecline.cornerRadius = 3
        
        let monthI   = ["Jan","Feb","Mar","Apr","May","Jun","July","Aug","Sep","Oct","Nov","Dec"]
        
        shadowWithCorner(viewContainer: self.viewContainer, cornerRadius: 10)
        shadowWithCorner(viewContainer: self.viewDateContainer, cornerRadius: 3)
        viewDateContainer.clipsToBounds = true
        viewDateContainer.backgroundColor = ILColor.color(index: 33)
        var componentDate = GeneralUtility.dateComponent(date: self.results.startDatetimeUTC!, component: .day)
        
        
        if let dayI = componentDate?.day {
            let fontMedium = UIFont(name: "FontHeavy".localized(), size: Device.FONTSIZETYPE15)
            
            UILabel.labelUIHandling(label: lblDate, text: "\(dayI)", textColor:ILColor.color(index: 34) , isBold: false, fontType: fontMedium)
            lblDate.textAlignment = .center
            lblDate.backgroundColor = .white
            
        }
        
        let componentMonth = GeneralUtility.dateComponent(date: self.results.startDatetimeUTC!, component: .month)
        
        if let monthCom = componentMonth?.month {
            let fontMedium = UIFont(name: "FontMedium".localized(), size: Device.FONTSIZETYPE15)
            
            UILabel.labelUIHandling(label: lblMonth, text: "\(monthI[monthCom-1])", textColor:ILColor.color(index: 3) , isBold: false, fontType: fontMedium,backgroundColor: ILColor.color(index: 33))
            lblMonth.textAlignment = .center
            
        }
        self.backgroundColor = .clear
        
        let fontMedium = UIFont(name: "FontMediumWithoutNext".localized(), size: Device.FONTSIZETYPE12)

        
        if results?.typeERSide == 2{
            // upcoming
            nslayoutCandiateFeedbackView.constant = 0
            nslayoutUpdateStatusViewHeight.constant = 0
            viewFeedback.isHidden = true
            viewUpdateStatus.isHidden = true
            
            nslayoutAcceptDeclineViewHeight.constant = 46
            viewAcceptDecline.isHidden = false
            
            UIButton.buttonUIHandling(button: btnViewResume, text: "View Resume", backgroundColor:UIColor.white ,textColor: ILColor.color(index: 23), buttonImage:UIImage.init(named: "locationAppo"),borderColor: ILColor.color(index: 23), borderWidth: 1,fontType:fontMedium)
            
            UIButton.buttonUIHandling(button: btnAccept, text: "Cancel Appointment", backgroundColor:UIColor.white ,textColor: ILColor.color(index: 23),borderColor: ILColor.color(index: 23), borderWidth: 1,fontType:fontMedium)
            btnDecline.isHidden = true
        }
        else if results?.typeERSide == 3{
            // pending
            
            nslayoutCandiateFeedbackView.constant = 0
            nslayoutUpdateStatusViewHeight.constant = 0
            viewFeedback.isHidden = true
            viewUpdateStatus.isHidden = true
            
            nslayoutAcceptDeclineViewHeight.constant = 46
            viewAcceptDecline.isHidden = false

            
            btnAccept.isHidden = false
            btnDecline.isHidden = false
            btnViewResume.isHidden = false
            UIButton.buttonUIHandling(button: btnViewResume, text: "View Resume", backgroundColor:UIColor.white ,textColor: ILColor.color(index: 23), buttonImage:UIImage.init(named: "locationAppo"),borderColor: ILColor.color(index: 23), borderWidth: 1,fontType:fontMedium)
            
            UIButton.buttonUIHandling(button: btnAccept, text: "Accept", backgroundColor:UIColor.white ,textColor: ILColor.color(index: 23),borderColor: ILColor.color(index: 23), borderWidth: 1,fontType:fontMedium)
            UIButton.buttonUIHandling(button: btnDecline, text: "Decline", backgroundColor:UIColor.white ,textColor: ILColor.color(index: 23),borderColor: ILColor.color(index: 23), borderWidth: 1,fontType:fontMedium)
            
            
            if   !GeneralUtility.isPastDate(date: self.results.startDatetime!){
                //                btnAccept.isHidden = false
                //                btnDecline.isHidden = false
                //
            }
            else{
                
                //                btnAccept.isHidden = false
                //                btnDecline.isHidden = true
                
//                let fontHeavy2 = UIFont(name: "FontHeavy".localized(), size: Device.FONTSIZETYPE11)
//
//                UIButton.buttonUIHandling(button: btnAccept, text: "Request Expired", backgroundColor:UIColor.clear ,textColor: ILColor.color(index: 52),borderColor: .clear, borderWidth: 1,fontType:fontHeavy2)
                
            }
            
        }
        else{
            
            nslayoutCandiateFeedbackView.constant = 69
            nslayoutUpdateStatusViewHeight.constant = 45
            viewFeedback.isHidden = false
            viewUpdateStatus.isHidden = false
            nslayoutAcceptDeclineViewHeight.constant = 0
            viewAcceptDecline.isHidden = true
            
            self.btnCoachPreciseGrp.forEach { (btn) in
                btn.setImage(UIImage.init(named: "noun_Star_nonselect"), for: .normal)
            }
            
            let fontHeavy2 = UIFont(name: "FontHeavy".localized(), size: Device.FONTSIZETYPE16)
            
            UIButton.buttonUIHandling(button: btnUpdateStatus, text: "Update Attendance Status", backgroundColor:UIColor.white ,textColor: ILColor.color(index: 23),borderColor: ILColor.color(index: 23), borderWidth: 1,fontType:fontHeavy2)
            
            if  let fontMedium = UIFont(name: "FontMediumWithoutNext".localized(), size: Device.FONTSIZETYPE12), let fontBook =  UIFont(name: "FontBook".localized(), size: Device.FONTSIZETYPE14)
                
            {
                let strHeaderFeedback = NSMutableAttributedString.init()

                
                let strTiTle = NSAttributedString.init(string: "Candidate’s Feedback"
                    , attributes: [NSAttributedString.Key.foregroundColor : ILColor.color(index:42),NSAttributedString.Key.font : fontMedium]);
                let nextLine1 = NSAttributedString.init(string: "\n")
                let strType = NSAttributedString.init(string: "Not added"
                    , attributes: [NSAttributedString.Key.foregroundColor : ILColor.color(index: 34),NSAttributedString.Key.font : fontBook]);
                let para = NSMutableParagraphStyle.init()
                //            para.alignment = .center
                para.lineSpacing = 4
                strHeaderFeedback.append(strTiTle)
                strHeaderFeedback.append(nextLine1)
                strHeaderFeedback.append(strType)
                strHeaderFeedback.addAttribute(NSAttributedString.Key.paragraphStyle, value: para, range: NSMakeRange(0, strHeaderFeedback.length))
                lblFeedback.attributedText = strHeaderFeedback
                
                nslayoutCustomerRatingViewHeight.constant = 0
                nslayoutCandiateFeedbackView.constant = 60

                viewCustomerRating.isHidden = true
            }
            
            
            
            
            
            
            //            if let isCompleted = results.appointmentIsCompleted{
            //
            //
            //                let fontHeavy2 = UIFont(name: "FontHeavy".localized(), size: Device.FONTSIZETYPE15)
            //
            //
            //                btnAccept.isUserInteractionEnabled = false
            //                btnAccept.isEnabled = false
            //
            //                if isCompleted == 0 {
            //                    let fontHeavy2 = UIFont(name: "FontHeavy".localized(), size: Device.FONTSIZETYPE13)
            //
            //                    UIButton.buttonUIHandling(button: btnAccept, text: "Not Attended", backgroundColor:UIColor.clear ,textColor: ILColor.color(index: 52),borderColor: .clear, borderWidth: 1,fontType:fontHeavy2)
            //                }
            //                else{
            //                    UIButton.buttonUIHandling(button: btnAccept, text: "Attended", backgroundColor:.clear ,textColor: ILColor.color(index: 51),borderColor: .clear, borderWidth: 1,fontType:fontHeavy2)
            //                }
            //
            //
            //            }
            //            else{
            //
            //                UIButton.buttonUIHandling(button: btnAccept, text: "Update Status", backgroundColor:UIColor.white ,textColor: ILColor.color(index: 23),borderColor: ILColor.color(index: 23), borderWidth: 1,fontType:fontHeavy2)
            //            }
        }
        btnDecline.isUserInteractionEnabled = true
        btnAccept.isUserInteractionEnabled = true
        btnViewResume.isUserInteractionEnabled = true
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
    
   
    @IBAction func btnViewResumeTappd(_ sender: Any) {
         delegate.changeInFollowingWith(results: results, index: 6)
        
    }
    
    
    @IBAction func btnAcceptTapped(_ sender: Any) {
        // 1. Detail
        // 2. Cancel
        // 3. Accept
        // 4. Decline
        // 5. UpDate Status
        // 6. view Resume

        if results?.typeERSide == 2{
            
            if   GeneralUtility.isPastDate(date: self.results.endDatetime!){
                delegate.changeInFollowingWith(results: results, index: 2)
            }
            else{
                
            }
            
        }
        else if results?.typeERSide == 3{
            
            if   !GeneralUtility.isPastDate(date: self.results.startDatetime!){
                delegate.changeInFollowingWith(results: results, index: 3)
                
                
            }
            else{
                
            }
            
        }
        else{
            
            //            if let isCompleted = results.appointmentIsCompleted{
            //            }
            //            else{
            //                delegate.changeInFollowingWith(results: results, index: 5)
            //
            //            }
            
            
            
        }
        
    }
    
    @IBAction func btnDeclineTapped(_ sender: Any) {
        delegate.changeInFollowingWith(results: results, index: 4)

        if results?.typeERSide == 2{
            
        }
        else if results?.typeERSide == 3{
            
            if   !GeneralUtility.isPastDate(date: self.results.startDatetime!){
//                delegate.changeInFollowingWith(results: results, index: 4)
            }
            else{
                
            }
            
        }
        else{
            
        }
    }
}
