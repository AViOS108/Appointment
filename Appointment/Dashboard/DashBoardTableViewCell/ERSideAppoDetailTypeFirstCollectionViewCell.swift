//
//  ERSideAppoDetailTypeFirstCollectionViewCell.swift
//  Appointment
//
//  Created by Anurag Bhakuni on 01/04/21.
//  Copyright © 2021 Anurag Bhakuni. All rights reserved.
//

import UIKit

class ERSideAppoDetailTypeFirstCollectionViewCell: UICollectionViewCell {
  
    var appoinmentDetailModalObj : AppoinmentDetailModalNew?
    var requestDetail : Request!
    var index = 0;
    var  indexPathRow = 0;
    @IBOutlet weak var btnLeftArrow: UIButton!
    
    @IBAction func btnLeftArrowTapped(_ sender: Any) {
    }
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblInitialName: UILabel!
    
    @IBOutlet weak var btnRightArrow: UIButton!
    
    @IBAction func btnRightArrowTapped(_ sender: Any) {
    }
    
    @IBOutlet weak var viewbuttonContainer: UIView!
    @IBOutlet weak var viewContainer: UIView!

    @IBOutlet weak var nslayoutConstraintViewButtonHeight: NSLayoutConstraint!
    
    @IBOutlet weak var btnAccept: UIButton!
    
    @IBAction func btnAcceptTapped(_ sender: Any) {
    }
    @IBAction func btnDeclineTapped(_ sender: Any) {
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
        viewContainer.backgroundColor = ILColor.color(index: 22)
        requestDetail = self.appoinmentDetailModalObj?.requests![indexPathRow];
        buttonArrowLogic()
        nameIntialandImageLogic()
        viewButtonContainerLogic()
        lblDescription.attributedText = descriptionLogic()
    }
    
    
    
    func nameIntialandImageLogic(){
        let radius =  (Int)(lblInitialName.frame.height)/2
        //        if let urlImage = URL.init(string: self.requestDetail?.studentDetails?.firstName ?? "") {
        //            self.imgProfile
        //                .setImageWith(urlImage, placeholderImage: UIImage.init(named: "Placeeholderimage"))
        //
        //            self.imgProfile?.cornerRadius = CGFloat(radius)
        //            imgProfile?.clipsToBounds = true
        //            //                self.imgView.layer.borderColor = UIColor.black.cgColor
        //            //                self.imgView.layer.borderWidth = 1
        //            self.imgProfile?.layer.masksToBounds = true;
        //        }
        //        else{
        //            self.imgProfile.image = UIImage.init(named: "Placeeholderimage");
        //            //            self.imgView.contentMode = .scaleAspectFit;
        //
        //        }
        
        //        if self.requestDetail?.studentDetails == nil ||
        //            GeneralUtility.optionalHandling(_param:  self.requestDetail?.studentDetails?.firstName?.isEmpty, _returnType: Bool.self)
        //        {
        //            self.imgProfile?.isHidden = true
        //            self.lblInitialName.isHidden = false
        //
        //
        //        }
        //        else
        //        {
        //            self.lblInitialName.isHidden = true
        //            self.imgProfile?.isHidden = false
        //
        
        self.imgProfile?.isHidden = true
        self.lblInitialName.isHidden = false
        var stringImg = GeneralUtility.startNameCharacter(stringName: self.requestDetail?.studentDetails?.name ?? " ")
        if let fontMedium = UIFont(name: "FontMedium".localized(), size: Device.FONTSIZETYPE15)
        {
            UILabel.labelUIHandling(label: lblInitialName, text: GeneralUtility.optionalHandling(_param: stringImg, _returnType: String.self), textColor:.black , isBold: false , fontType: fontMedium, isCircular: true,  backgroundColor:.white ,cornerRadius: radius,borderColor:UIColor.black,borderWidth: 1 )
            lblInitialName.textAlignment = .center
            lblInitialName.layer.borderColor = UIColor.black.cgColor
        }
        
        let strHeader = NSMutableAttributedString.init()
        
        if let fontHeavy = UIFont(name: "FontHeavy".localized(), size: Device.FONTSIZETYPE13), let fontBook = UIFont(name: "FontBook".localized(), size: Device.FONTSIZETYPE13){
            let strTiTle = NSAttributedString.init(string: GeneralUtility.optionalHandling(_param: self.requestDetail.studentDetails?.name, _returnType: String.self)
                , attributes: [NSAttributedString.Key.foregroundColor : ILColor.color(index:13),NSAttributedString.Key.font : fontHeavy]);
            let nextLine1 = NSAttributedString.init(string: "\n")
            let strType = NSAttributedString.init(string: GeneralUtility.optionalHandling(_param: self.requestDetail.studentDetails?.benchmarkName, _returnType: String.self)
                , attributes: [NSAttributedString.Key.foregroundColor : ILColor.color(index: 13),NSAttributedString.Key.font : fontBook]);
            let para = NSMutableParagraphStyle.init()
            //            para.alignment = .center
            para.lineSpacing = 1
            strHeader.append(strTiTle)
            strHeader.append(nextLine1)
            strHeader.append(strType)
            strHeader.append(nextLine1)
            strHeader.addAttribute(NSAttributedString.Key.paragraphStyle, value: para, range: NSMakeRange(0, strHeader.length))
            lblName.attributedText = strHeader
        }
    }
    
    func descriptionLogic() -> NSAttributedString{
        let strHeader = NSMutableAttributedString.init()
        
        if let fontHeavy = UIFont(name: "FontHeavy".localized(), size: Device.FONTSIZETYPE13), let fontBook = UIFont(name: "FontBook".localized(), size: Device.FONTSIZETYPE13){
            let strPurposeText = NSAttributedString.init(string: GeneralUtility.optionalHandling(_param: "Purpose", _returnType: String.self)
                , attributes: [NSAttributedString.Key.foregroundColor : ILColor.color(index:13),NSAttributedString.Key.font : fontHeavy]);
            
            var purpose = "Not Available"
            var index = 0
            for userpurpose in (self.requestDetail.purposes)!{
                purpose.append(userpurpose.userPurpose?.displayName ?? "")
                index = index + 1
                if index >= self.requestDetail.purposes?.count ?? 0{
                }
                else{
                    purpose.append(",")
                }
            }
            
            let strPurposeValue = NSAttributedString.init(string: GeneralUtility.optionalHandling(_param: purpose, _returnType: String.self)
                , attributes: [NSAttributedString.Key.foregroundColor : ILColor.color(index: 13),NSAttributedString.Key.font : fontBook]);
            
            let strAdditionText = NSAttributedString.init(string: GeneralUtility.optionalHandling(_param: "Additional Message", _returnType: String.self)
                , attributes: [NSAttributedString.Key.foregroundColor : ILColor.color(index: 13),NSAttributedString.Key.font : fontHeavy]);
            var additionalComments = "Not Available"

            if self.requestDetail.additionalComments?.isEmpty ?? true  {
                
            }
            else{
                additionalComments = self.requestDetail.additionalComments ?? "Not Available"
            }
            
            let strAdditionValue  = NSAttributedString.init(string: GeneralUtility.optionalHandling(_param: additionalComments, _returnType: String.self)
                , attributes: [NSAttributedString.Key.foregroundColor : ILColor.color(index: 13),NSAttributedString.Key.font : fontBook]);
            
            var attachmentValue = "No attachment available"
            
            if let attachment = self.requestDetail.attachmentInfo{
                if attachment.count > 0 {
                    attachmentValue = attachment[0].fileName ?? "";

                }
            }
            
            let strattachmentText = NSAttributedString.init(string: GeneralUtility.optionalHandling(_param: "Attachments", _returnType: String.self)
                , attributes: [NSAttributedString.Key.foregroundColor : ILColor.color(index: 13),NSAttributedString.Key.font : fontHeavy]);
            
            let strattachmentValue  = NSAttributedString.init(string: GeneralUtility.optionalHandling(_param: attachmentValue, _returnType: String.self)
                , attributes: [NSAttributedString.Key.foregroundColor : ILColor.color(index: 13),NSAttributedString.Key.font : fontBook]);
            
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
    
    func viewButtonContainerLogic()
    {
        if index == 4{
            
            btnDecline.isHidden = true
            self.viewSeprator.isHidden = true
            let fontMedium = UIFont(name: "FontMedium".localized(), size: Device.FONTSIZETYPE15)
            UIButton.buttonUIHandling(button: btnAccept, text: "Send Email", backgroundColor: .clear, textColor: ILColor.color(index: 23), buttonImage: UIImage.init(named: "cancel"),  fontType: fontMedium)
            // upcoming
        }
        else if index == 2{
            btnDecline.isHidden = false
            self.viewSeprator.isHidden = false

            viewSeprator.backgroundColor = ILColor.color(index: 22)
            let fontMedium = UIFont(name: "FontMedium".localized(), size: Device.FONTSIZETYPE15)
            UIButton.buttonUIHandling(button: btnAccept, text: "  Accept", backgroundColor: .clear, textColor: ILColor.color(index: 23), buttonImage: UIImage.init(named: "accept-circular-button-outline"),  fontType: fontMedium)
            UIButton.buttonUIHandling(button: btnDecline, text: "  Decline", backgroundColor: .clear, textColor: ILColor.color(index: 23), buttonImage: UIImage.init(named: "cancel"),  fontType: fontMedium)
            // pending
        }
        else{
            btnDecline.isHidden = true
            self.viewSeprator.isHidden = true
            let fontMedium = UIFont(name: "FontMedium".localized(), size: Device.FONTSIZETYPE15)
            UIButton.buttonUIHandling(button: btnAccept, text: "  Send Email", backgroundColor: .clear, textColor: ILColor.color(index: 23), buttonImage: UIImage.init(named: "cancel"),  fontType: fontMedium)
            // past
        }
    }
    
    
    
    
    
    func buttonArrowLogic(){
        
        if appoinmentDetailModalObj?.requests?.count ?? 0 > 1{
            btnLeftArrow.isHidden = false
            btnRightArrow.isHidden = false
            if indexPathRow == 0 {
                btnLeftArrow.isUserInteractionEnabled = false
                btnLeftArrow.alpha = 0.6
            }
            else {
                btnLeftArrow.isUserInteractionEnabled = true
                btnLeftArrow.alpha = 1
            }
            if (indexPathRow + 1) == appoinmentDetailModalObj?.requests?.count {
                btnRightArrow.isUserInteractionEnabled = false
                btnRightArrow.alpha = 0.6
            }
            else{
                btnRightArrow.isUserInteractionEnabled = true
                btnRightArrow.alpha = 1
            }
        }
        else{
            btnLeftArrow.isHidden = true
            btnRightArrow.isHidden = true
        }
        btnRightArrow.setImage(UIImage.init(named: "GroupArrowRight"), for: .normal)
        btnLeftArrow.setImage(UIImage.init(named: "GroupArrowleft"), for: .normal)
    }
    
    
    
    

}
