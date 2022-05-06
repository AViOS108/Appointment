//
//  ERSideAppoDetailTypeFirstCollectionViewCell.swift
//  Appointment
//
//  Created by Anurag Bhakuni on 01/04/21.
//  Copyright © 2021 Anurag Bhakuni. All rights reserved.
//

import UIKit


protocol ERSideAppoDetailTypeFirstCollectionViewCellDelegate {
    func moveCollectionView(backward :Bool)
    func acceptDeclineApi(isAccept : Bool,selectedRow : Int)
    func sendEmail(email :String)

}



class ERSideAppoDetailTypeFirstCollectionViewCell: UICollectionViewCell {
  
    @IBOutlet weak var lblNumber: UILabel!
    @IBOutlet weak var nslayoutConstraintContainerTop: NSLayoutConstraint!
    @IBOutlet weak var viewContainer: UIView!
    var appoinmentDetailModalObj : AppoinmentDetailModalNew?
    var requestDetail : RequestER!
    var index = 0;
    var  indexPathRow = 0;
    @IBOutlet weak var btnLeftArrow: UIButton!
    var delegate : ERSideAppoDetailTypeFirstCollectionViewCellDelegate!
    @IBOutlet weak var lblTopParticipants: UILabel!
    @IBOutlet weak var viewTopParticipants: UIView!
    
    @IBOutlet weak var viewRequestedParticipant: UIView!
    @IBOutlet weak var lblRequestedParticipant: UILabel!
    var selectedfragmentNumber = 1;

    @IBAction func btnLeftArrowTapped(_ sender: Any) {
        lblNumber.text = "\(selectedfragmentNumber) of \(appoinmentDetailModalObj?.requests?.count ?? 0)"
        delegate.moveCollectionView(backward: true)
    }
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblInitialName: UILabel!
    
    @IBOutlet weak var btnRightArrow: UIButton!
    
    @IBAction func btnRightArrowTapped(_ sender: Any) {
        lblNumber.text = "\(selectedfragmentNumber) of \(appoinmentDetailModalObj?.requests?.count ?? 0)"
           delegate.moveCollectionView(backward: false)
    }
    
    @IBOutlet weak var viewbuttonContainer: UIView!

    @IBOutlet weak var nslayoutConstraintViewButtonHeight: NSLayoutConstraint!
    
    @IBOutlet weak var btnAccept: UIButton!
    
    @IBAction func btnAcceptTapped(_ sender: Any) {
        if index == 3{
            delegate.acceptDeclineApi(isAccept: true, selectedRow: indexPathRow)
        }
        else{
            delegate.sendEmail(email: self.requestDetail?.studentDetails?.email ?? "")
        }
        
    }
    @IBAction func btnDeclineTapped(_ sender: Any) {
        delegate.acceptDeclineApi(isAccept: false, selectedRow: indexPathRow)

    }
    
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var viewSeprator: UIView!
    @IBOutlet weak var btnDecline: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    func customization()
    {
        self.shadowWithCorner(viewContainer: viewContainer, cornerRadius: 10)
       
        let isStudent = UserDefaultsDataSource(key: "student").readData() as? Bool
        if isStudent ?? false {
            nslayoutConstraintViewButtonHeight.constant = 0
            viewbuttonContainer.isHidden = true
        }
        else
        {
            nslayoutConstraintViewButtonHeight.constant = 40
            viewbuttonContainer.isHidden = false
        }
        
        requestDetail = self.appoinmentDetailModalObj?.requests![indexPathRow];
        buttonArrowLogic()
        nameIntialandImageLogic()
        viewButtonContainerLogic()
        
        if isStudent ?? false{
            lblDescription.attributedText = descriptionStudentLogic()

        }
        else{
            lblDescription.attributedText = descriptionLogic()

        }
        
        lblName .attributedText = nameLogic()
        topParticipantsCustomization()
        topRequestedParticipantsCustomization() 
    }
    
    
    func topParticipantsCustomization()  {
        
        if let fontMedium = UIFont(name: "FontMedium".localized(), size: Device.FONTSIZETYPE12)
        {
            UILabel.labelUIHandling(label: lblTopParticipants, text: GeneralUtility.optionalHandling(_param: "Total Participants: " + "\(appoinmentDetailModalObj?.requests?.count ?? 0)" , _returnType: String.self),isBold: false , fontType: fontMedium)
            lblTopParticipants.textAlignment = .center
        }
        viewTopParticipants.layoutIfNeeded()
        viewTopParticipants.cornerRadius =  viewTopParticipants.frame.height/2
        viewTopParticipants.backgroundColor = ILColor.color(index: 55)

    }
    
    func topRequestedParticipantsCustomization()  {
        if let fontMedium = UIFont(name: "FontMedium".localized(), size: Device.FONTSIZETYPE12)
        {
            
            let searchPurposeSelected =  appoinmentDetailModalObj?.requests?.filter({ $0.state == "pending"  }).count;
            UILabel.labelUIHandling(label: lblRequestedParticipant, text: GeneralUtility.optionalHandling(_param: "Requested Participants: "+"\(searchPurposeSelected ?? 0)", _returnType: String.self),isBold: false , fontType: fontMedium)
            lblRequestedParticipant.textAlignment = .center
        }
        viewRequestedParticipant.layoutIfNeeded()
        viewRequestedParticipant.cornerRadius =  viewRequestedParticipant.frame.height/2
        viewRequestedParticipant.backgroundColor = ILColor.color(index: 56)
    }
    
    
    
    func nameIntialandImageLogic(){
        let radius =  (Int)(lblInitialName.frame.height)/2
        self.imgProfile?.isHidden = true
        self.lblInitialName.isHidden = false
        viewbuttonContainer.borderWithWidth(1, color: ILColor.color(index:22))

        let isStudent = UserDefaultsDataSource(key: "student").readData() as? Bool
        var stringImg = ""
        if isStudent ?? false{
             stringImg = GeneralUtility.startNameCharacter(stringName: self.appoinmentDetailModalObj!.coachDetailApi?.name ?? " ")

        }
        else{
             stringImg = GeneralUtility.startNameCharacter(stringName: self.requestDetail?.studentDetails?.name ?? " ")

        }
        
        if let fontMedium = UIFont(name: "FontMedium".localized(), size: Device.FONTSIZETYPE15)
        {
            UILabel.labelUIHandling(label: lblInitialName, text: GeneralUtility.optionalHandling(_param: stringImg, _returnType: String.self), textColor:.black , isBold: false , fontType: fontMedium, isCircular: true,  backgroundColor:.white ,cornerRadius: radius,borderColor:UIColor.black,borderWidth: 1 )
            lblInitialName.textAlignment = .center
            lblInitialName.layer.borderColor = UIColor.black.cgColor
        }
        
    }
    
    
    
    
    
    
    func nameLogic() -> NSAttributedString{
        
        let strHeader = NSMutableAttributedString.init()
        
        let isStudent = UserDefaultsDataSource(key: "student").readData() as? Bool
        if isStudent ?? false{
            var roles = ""
            var index = 0
            for role in self.appoinmentDetailModalObj!.coachDetailApi!.roles{
                roles.append(role.displayName ?? "")
                index = index + 1;
                if self.appoinmentDetailModalObj!.coachDetailApi!.roles.count > 1{
                    if index == self.appoinmentDetailModalObj!.coachDetailApi!.roles.count{
                    }
                    else{
                        roles.append(", ")
                    }
                }
            }
            
            if let fontHeavy = UIFont(name: "FontHeavy".localized(), size: Device.FONTSIZETYPE14), let fontBook = UIFont(name: "FontBook".localized(), size: Device.FONTSIZETYPE13){
                let strTiTle = NSAttributedString.init(string: GeneralUtility.optionalHandling(_param: self.appoinmentDetailModalObj!.coachDetailApi?.name, _returnType: String.self)
                    , attributes: [NSAttributedString.Key.foregroundColor : ILColor.color(index:34),NSAttributedString.Key.font : fontHeavy]);
                let nextLine1 = NSAttributedString.init(string: "\n")
                let strType = NSAttributedString.init(string: GeneralUtility.optionalHandling(_param: roles, _returnType: String.self)
                    , attributes: [NSAttributedString.Key.foregroundColor : ILColor.color(index: 34),NSAttributedString.Key.font : fontBook]);
                
                let strDescription = NSAttributedString.init(string: GeneralUtility.optionalHandling(_param: self.appoinmentDetailModalObj!.coachDetailApi?.coachInfo.summary, _returnType: String.self)
                    , attributes: [NSAttributedString.Key.foregroundColor : ILColor.color(index: 34),NSAttributedString.Key.font : fontBook]);

                let para = NSMutableParagraphStyle.init()
                //            para.alignment = .center
                para.lineSpacing = 1
                strHeader.append(strTiTle)
                strHeader.append(nextLine1)
                strHeader.append(strType)
                strHeader.append(nextLine1)
                strHeader.append(strType)
                strHeader.append(strDescription)

                strHeader.addAttribute(NSAttributedString.Key.paragraphStyle, value: para, range: NSMakeRange(0, strHeader.length))
            }
        }
        else{
            
            if let fontHeavy = UIFont(name: "FontHeavy".localized(), size: Device.FONTSIZETYPE14), let fontBook = UIFont(name: "FontBook".localized(), size: Device.FONTSIZETYPE13){
                let strTiTle = NSAttributedString.init(string: GeneralUtility.optionalHandling(_param: self.requestDetail.studentDetails?.name, _returnType: String.self)
                    , attributes: [NSAttributedString.Key.foregroundColor : ILColor.color(index:34),NSAttributedString.Key.font : fontHeavy]);
                let nextLine1 = NSAttributedString.init(string: "\n")
                let strType = NSAttributedString.init(string: GeneralUtility.optionalHandling(_param: self.requestDetail.studentDetails?.benchmarkName, _returnType: String.self)
                    , attributes: [NSAttributedString.Key.foregroundColor : ILColor.color(index: 34),NSAttributedString.Key.font : fontBook]);
                let para = NSMutableParagraphStyle.init()
                //            para.alignment = .center
                para.lineSpacing = 1
                strHeader.append(strTiTle)
                strHeader.append(nextLine1)
                strHeader.append(strType)
                strHeader.append(nextLine1)
                strHeader.addAttribute(NSAttributedString.Key.paragraphStyle, value: para, range: NSMakeRange(0, strHeader.length))
              
            }
            
        }
        return strHeader
    }
    
    
    
    
    
    func descriptionLogic() -> NSAttributedString{
        let strHeader = NSMutableAttributedString.init()
        
        if let fontHeavy = UIFont(name: "FontHeavy".localized(), size: Device.FONTSIZETYPE13), let fontBook = UIFont(name: "FontBook".localized(), size: Device.FONTSIZETYPE13){
            let strPurposeText = NSAttributedString.init(string: GeneralUtility.optionalHandling(_param: "Purpose", _returnType: String.self)
                , attributes: [NSAttributedString.Key.foregroundColor : ILColor.color(index:42),NSAttributedString.Key.font : fontHeavy]);
            
            var purpose = ""
            var index = 0
            for userpurpose in (self.requestDetail.purposes)!{
                if let displayName = userpurpose.purposeText {
                    purpose.append(displayName)
                    index = index + 1
                    if index >= self.requestDetail.purposes?.count ?? 0{
                    }
                    else{
                        purpose.append(",")
                    }
                }
            }
            if purpose.isEmpty {
                purpose = "Not Available"
            }
            
            let strPurposeValue = NSAttributedString.init(string: GeneralUtility.optionalHandling(_param: purpose, _returnType: String.self)
                , attributes: [NSAttributedString.Key.foregroundColor : ILColor.color(index: 37),NSAttributedString.Key.font : fontBook]);
            
            let strAdditionText = NSAttributedString.init(string: GeneralUtility.optionalHandling(_param: "Additional Message", _returnType: String.self)
                , attributes: [NSAttributedString.Key.foregroundColor : ILColor.color(index: 42),NSAttributedString.Key.font : fontHeavy]);
            var additionalComments = "Not Available"

            if self.requestDetail.additionalComments?.isEmpty ?? true  {
                
            }
            else{
                additionalComments = self.requestDetail.additionalComments?.replacingOccurrences(of: "\n", with: " ") ?? "Not Available"
            }
            
            let strAdditionValue  = NSAttributedString.init(string: GeneralUtility.optionalHandling(_param: String(additionalComments.prefix(30)), _returnType: String.self)
                , attributes: [NSAttributedString.Key.foregroundColor : ILColor.color(index: 37),NSAttributedString.Key.font : fontBook]);
            
            var attachmentValue = "No attachment available"
            
            if let attachment = self.requestDetail.attachmentInfo{
                if attachment.count > 0 {
                    attachmentValue = attachment[0].fileName ?? "";

                }
            }
            
            let strattachmentText = NSAttributedString.init(string: GeneralUtility.optionalHandling(_param: "Attachments", _returnType: String.self)
                , attributes: [NSAttributedString.Key.foregroundColor : ILColor.color(index: 42),NSAttributedString.Key.font : fontHeavy]);
            
            let strattachmentValue  = NSAttributedString.init(string: GeneralUtility.optionalHandling(_param: attachmentValue, _returnType: String.self)
                , attributes: [NSAttributedString.Key.foregroundColor : ILColor.color(index: 37),NSAttributedString.Key.font : fontBook]);
            
            let nextLine1 = NSAttributedString.init(string: "\n")
            
            let para = NSMutableParagraphStyle.init()
            //            para.alignment = .center
            para.lineSpacing = 3
            strHeader.append(strPurposeText)
            strHeader.append(nextLine1)
            strHeader.append(strPurposeValue)
            strHeader.append(nextLine1)
            strHeader.append(strAdditionText)
            strHeader.append(nextLine1)
            strHeader.append(strAdditionValue)
            strHeader.append(nextLine1)
            strHeader.append(strattachmentText)
            strHeader.append(nextLine1)
            strHeader.append(strattachmentValue)
            strHeader.append(nextLine1)

            strHeader.addAttribute(NSAttributedString.Key.paragraphStyle, value: para, range: NSMakeRange(0, strHeader.length))
        }
        
        return strHeader
    }
    func descriptionStudentLogic() -> NSAttributedString{
        

        let strHeaderDescription = NSMutableAttributedString.init()
        if let fontHeavy = UIFont(name: "FontHeavy".localized(), size: Device.FONTSIZETYPE14), let fontBook =  UIFont(name: "FontBook".localized(), size: Device.FONTSIZETYPE14),let fontMedium =  UIFont(name: "FontMediumWithoutNext".localized(), size: Device.FONTSIZETYPE14)
            
        {
            
            
            let strTitle = NSAttributedString.init(string: GeneralUtility.optionalHandling(_param: "Purpose", _returnType: String.self)
                , attributes: [NSAttributedString.Key.foregroundColor : ILColor.color(index:34),NSAttributedString.Key.font : fontHeavy]);
            
            let nextLine1 = NSAttributedString.init(string: "\n")
            let strDescText = NSAttributedString.init(string: GeneralUtility.optionalHandling(_param: "Description", _returnType: String.self)
                , attributes: [NSAttributedString.Key.foregroundColor : ILColor.color(index: 35),NSAttributedString.Key.font : fontMedium]);
            
            let strFunctionText = NSAttributedString.init(string: GeneralUtility.optionalHandling(_param: "Functions: ", _returnType: String.self)
                , attributes: [NSAttributedString.Key.foregroundColor : ILColor.color(index:34),NSAttributedString.Key.font : fontMedium]);
            
            let strFunctionValue = NSAttributedString.init(string: GeneralUtility.optionalHandling(_param:  self.description(requestDetail: requestDetail.targetFunctions), _returnType: String.self)
                , attributes: [NSAttributedString.Key.foregroundColor : ILColor.color(index: 36),NSAttributedString.Key.font : fontBook]);
            
            
            let strnIndustriesText = NSAttributedString.init(string: GeneralUtility.optionalHandling(_param: "Industries: ", _returnType: String.self)
                , attributes: [NSAttributedString.Key.foregroundColor : ILColor.color(index:34),NSAttributedString.Key.font : fontMedium]);
            
            
            let strnIndustriesValue = NSAttributedString.init(string: GeneralUtility.optionalHandling(_param:  self.description(requestDetail: requestDetail.targetIndustries), _returnType: String.self)
                , attributes: [NSAttributedString.Key.foregroundColor : ILColor.color(index: 36),NSAttributedString.Key.font : fontBook]);
            
            
            let strnCompaniesText = NSAttributedString.init(string: GeneralUtility.optionalHandling(_param: "Companies: ", _returnType: String.self)
                , attributes: [NSAttributedString.Key.foregroundColor : ILColor.color(index:34),NSAttributedString.Key.font : fontMedium]);
            
            
            let strnCompaniesValue = NSAttributedString.init(string: GeneralUtility.optionalHandling(_param: self.description(requestDetail: requestDetail.targetCompanies), _returnType: String.self)
                , attributes: [NSAttributedString.Key.foregroundColor : ILColor.color(index: 36),NSAttributedString.Key.font : fontBook]);
            
            
            let para = NSMutableParagraphStyle.init()
            //            para.alignment = .center
            para.lineSpacing = 18
            strHeaderDescription.append(strTitle)
            strHeaderDescription.append(nextLine1)
            strHeaderDescription.append(nextLine1)

            strHeaderDescription.append(strDescText)
            if self.description(requestDetail: requestDetail.targetFunctions) != "" {
                strHeaderDescription.append(nextLine1)
                strHeaderDescription.append(strFunctionText)
                strHeaderDescription.append(strFunctionValue)
            }
            
            if self.description(requestDetail: requestDetail.targetIndustries) != "" {
                strHeaderDescription.append(nextLine1)
                strHeaderDescription.append(strnIndustriesText)
                strHeaderDescription.append(strnIndustriesValue)
            }
            if self.description(requestDetail: requestDetail.targetCompanies) != "" {
                strHeaderDescription.append(nextLine1)
                strHeaderDescription.append(strnCompaniesText)
                strHeaderDescription.append(strnCompaniesValue)
            }
            
            if self.description(requestDetail: requestDetail.targetCompanies) == "" && self.description(requestDetail: requestDetail.targetIndustries) == "" &&  self.description(requestDetail: requestDetail.targetFunctions) == ""{
                let strnCompaniesValue = NSAttributedString.init(string: "Not Available"
                    , attributes: [NSAttributedString.Key.foregroundColor : ILColor.color(index: 36),NSAttributedString.Key.font : fontBook]);
                
                strHeaderDescription.append(nextLine1)
                strHeaderDescription.append(strnCompaniesValue)

            }
            var attachmentValue = "No attachment available"
            
            if let attachment = self.requestDetail.attachmentInfo{
                if attachment.count > 0 {
                    attachmentValue = attachment[0].fileName ?? "";

                }
            }
            
            let strattachmentText = NSAttributedString.init(string: GeneralUtility.optionalHandling(_param: "Attachments", _returnType: String.self)
                , attributes: [NSAttributedString.Key.foregroundColor : ILColor.color(index: 42),NSAttributedString.Key.font : fontHeavy]);
            
            let strattachmentValue  = NSAttributedString.init(string: GeneralUtility.optionalHandling(_param: attachmentValue, _returnType: String.self)
                , attributes: [NSAttributedString.Key.foregroundColor : ILColor.color(index: 37),NSAttributedString.Key.font : fontBook]);
            strHeaderDescription.append(nextLine1)
            strHeaderDescription.append(nextLine1)

            strHeaderDescription.append(strattachmentText)
            strHeaderDescription.append(nextLine1)
            strHeaderDescription.append(strattachmentValue)

        }
        
        return strHeaderDescription
        
    }
    func description(requestDetail:Array<String>?)-> String{
        
        if let requestDetailI = requestDetail {
            if requestDetailI.count > 0 {
                let strInbetween = requestDetailI.joined(separator: ",")
                return strInbetween
            }
            else{
                return ""
            }
        }
        else{
            return ""

        }
    }
    
    func viewButtonContainerLogic()
    {
        btnDecline.isUserInteractionEnabled = true
        btnAccept.isUserInteractionEnabled = true
        if index == 3{
            btnDecline.isHidden = false
            self.viewSeprator.isHidden = false
            
            viewSeprator.backgroundColor = ILColor.color(index: 22)
            let fontMedium = UIFont(name: "FontMedium".localized(), size: Device.FONTSIZETYPE15)
            UIButton.buttonUIHandling(button: btnAccept, text: "  Accept", backgroundColor: .clear, textColor: ILColor.color(index: 23), buttonImage: UIImage.init(named: "accept-circular-button-outline"),  fontType: fontMedium)
            UIButton.buttonUIHandling(button: btnDecline, text: "  Decline", backgroundColor: .clear, textColor: ILColor.color(index: 23), buttonImage: UIImage.init(named: "cancel"),  fontType: fontMedium)
            
            if  GeneralUtility.isPastDate(date: self.appoinmentDetailModalObj?.startDatetime ?? ""){
                if GeneralUtility.isPastDate(date: self.appoinmentDetailModalObj?.endDatetime ?? ""){
                    
                    UIButton.buttonUIHandling(button: btnAccept, text: "Request Expired", backgroundColor:.white , textColor: ILColor.color(index: 34),buttonImage:UIImage.init(named: ""),fontType:fontMedium)
                    btnAccept.setImage(nil, for: .normal)
                    btnAccept.isUserInteractionEnabled = false
                    viewSeprator.isHidden = true
 
                }
                else{
                   
                        if requestDetail.state == "pending"{
                            UIButton.buttonUIHandling(button: btnAccept, text: "Request Expired", backgroundColor:.white ,textColor: ILColor.color(index: 34),fontType:fontMedium)
                            btnAccept.setImage(nil, for: .normal)
                            btnAccept.isUserInteractionEnabled = false
                            viewSeprator.isHidden = true
                        }
                        else if requestDetail.state == "accepted" || requestDetail.state == "auto_accepted" {
                            UIButton.buttonUIHandling(button: btnAccept, text: "Accepted", backgroundColor:.white ,textColor: ILColor.color(index: 58),fontType:fontMedium)
                            btnAccept.setImage(nil, for: .normal)
                            btnAccept.isUserInteractionEnabled = false

                        }
                        else  {
                            UIButton.buttonUIHandling(button: btnAccept, text: "Decline", backgroundColor:.white ,textColor: ILColor.color(index: 57),fontType:fontMedium)
                            btnAccept.setImage(nil, for: .normal)
                            btnAccept.isUserInteractionEnabled = false

                        }
                }
                btnDecline.isHidden = true
            }
            else{
                if requestDetail.state == "pending"{
                    UIButton.buttonUIHandling(button: btnAccept, text: " Accept", backgroundColor:UIColor.white ,textColor: ILColor.color(index: 23), buttonImage:UIImage.init(named: "accept-circular-button-outline"),fontType:fontMedium)
                    UIButton.buttonUIHandling(button: btnDecline, text: " Decline", backgroundColor:UIColor.white ,textColor: ILColor.color(index: 23),buttonImage:UIImage.init(named: "cancel"),fontType:fontMedium)
                    btnDecline.isHidden = false

                }
                else if requestDetail.state == "accepted" || requestDetail.state == "auto_accepted" {
                    UIButton.buttonUIHandling(button: btnAccept, text: "Accepted", backgroundColor:.white ,textColor: ILColor.color(index: 58),fontType:fontMedium)
                    btnAccept.setImage(nil, for: .normal)
                    btnDecline.isHidden = true
                    btnAccept.isUserInteractionEnabled = false

                }
                else  {
                    UIButton.buttonUIHandling(button: btnAccept, text: "Declined", backgroundColor:.white ,textColor: ILColor.color(index: 57),fontType:fontMedium)
                    btnAccept.setImage(nil, for: .normal)
                    btnDecline.isHidden = true
                    btnAccept.isUserInteractionEnabled = false

                }
            }
            // pending
        }
        else if index == 2{
            btnDecline.isHidden = true
            self.viewSeprator.isHidden = true
            let fontMedium = UIFont(name: "FontMedium".localized(), size: Device.FONTSIZETYPE15)
            UIButton.buttonUIHandling(button: btnAccept, text: "Send Email", backgroundColor: .clear, textColor: ILColor.color(index: 23),  fontType: fontMedium)
            // upcoming
            
        }
        else{
            btnDecline.isHidden = true
            self.viewSeprator.isHidden = true
            let fontMedium = UIFont(name: "FontMedium".localized(), size: Device.FONTSIZETYPE15)
            UIButton.buttonUIHandling(button: btnAccept, text: "Send Email", backgroundColor: .clear, textColor: ILColor.color(index: 23),fontType: fontMedium)
            // past
        }
    }
    
    
    
    func buttonArrowLogic(){
        
        
        
        if index != 3{
            viewRequestedParticipant.isHidden = true
        }
        
        if appoinmentDetailModalObj?.requests?.count ?? 0 > 1{
            btnLeftArrow.isHidden = false
            btnRightArrow.isHidden = false
            if indexPathRow == 0 {
                btnLeftArrow.isUserInteractionEnabled = false
                btnLeftArrow.alpha = 0.4
            }
            else {
                btnLeftArrow.isUserInteractionEnabled = true
                btnLeftArrow.alpha = 1
            }
            if (indexPathRow + 1) == appoinmentDetailModalObj?.requests?.count {
                btnRightArrow.isUserInteractionEnabled = false
                btnRightArrow.alpha = 0.4
            }
            else{
                btnRightArrow.isUserInteractionEnabled = true
                btnRightArrow.alpha = 1
            }
            lblNumber.isHidden = false
            let fontBook =  UIFont(name: "FontBook".localized(), size: Device.FONTSIZETYPE10)
            UILabel.labelUIHandling(label: lblNumber, text: "\(selectedfragmentNumber) of \(appoinmentDetailModalObj?.requests?.count ?? 0)", textColor: ILColor.color(index: 42), isBold: false, fontType: fontBook)
        }
        else{
            lblNumber.isHidden = true

            btnLeftArrow.isHidden = true
            btnRightArrow.isHidden = true
            viewTopParticipants.isHidden = true
            viewRequestedParticipant.isHidden = true
            nslayoutConstraintContainerTop.constant = 0
        }
        btnRightArrow.setImage(UIImage.init(named: "GroupArrowRight"), for: .normal)
        btnLeftArrow.setImage(UIImage.init(named: "GroupArrowleft"), for: .normal)
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
        viewContainer.backgroundColor = .white
    }

}
