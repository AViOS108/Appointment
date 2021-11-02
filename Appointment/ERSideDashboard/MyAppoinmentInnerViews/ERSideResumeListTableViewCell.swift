//
//  ERSideResumeListTableViewCell.swift
//  Appointment
//
//  Created by Anurag Bhakuni on 12/04/21.
//  Copyright © 2021 Anurag Bhakuni. All rights reserved.
//

import UIKit

protocol ERSideResumeListTableViewCellDelegate {
    func taskProvidedToVC(taskType:ERSideResumeListTaskProvidedBycell,resumeID: Int,name : String)
}

class ERSideResumeListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblInitialName: UILabel!
    var objERSideResumeListModalItem : ERSideResumeListModalItem!
    var delegate : ERSideResumeListTableViewCellDelegate?
    
    @IBOutlet weak var viewLatestUpload: UIView!
    @IBOutlet weak var lblLatestUpload: UILabel!
    @IBOutlet weak var lblLatestUploadResume: UILabel!
    
    @IBOutlet weak var btnLatestUploadView: UIButton!
    @IBAction func btnLatestUploadViewTapped(_ sender: Any) {
        
        if let delegateAssign = delegate {
            var displayName = (self.objERSideResumeListModalItem?.firstName ?? "") +
                " " + (self.objERSideResumeListModalItem?.lastName ?? "")

            delegateAssign.taskProvidedToVC(taskType: .view, resumeID: objERSideResumeListModalItem.rpLatestResumeID ?? 0, name: displayName);

        }
        
        
    }
    @IBOutlet weak var lblLatestScore: UILabel!
    @IBOutlet weak var btnLatestDownload: UIButton!
    @IBAction func btnLatestDownloadTapped(_ sender: Any) {
        if let delegateAssign = delegate {
            var displayName = (self.objERSideResumeListModalItem?.firstName ?? "") +
                " " + (self.objERSideResumeListModalItem?.lastName ?? "")

            delegateAssign.taskProvidedToVC(taskType: .download, resumeID: objERSideResumeListModalItem.rpLatestResumeID ?? 0, name: displayName);

        }
    }
    @IBOutlet weak var btnLatestDownloadPrint: UIButton!
    @IBAction func btnLatestDownloadPrintTapped(_ sender: Any) {
        if let delegateAssign = delegate {
            var displayName = (self.objERSideResumeListModalItem?.firstName ?? "") +
                " " + (self.objERSideResumeListModalItem?.lastName ?? "")
            delegateAssign.taskProvidedToVC(taskType: .print, resumeID: objERSideResumeListModalItem.rpLatestResumeID ?? 0, name: displayName);

        }
    }
    
    
    @IBOutlet weak var viewHighestUpload: UIView!
    @IBOutlet weak var lblHighestUpload: UILabel!
    @IBOutlet weak var lblHighestUploadResume: UILabel!
    
    @IBOutlet weak var btnHighestUploadView: UIButton!
    @IBAction func btnHighestUploadViewTapped(_ sender: Any) {
        if let delegateAssign = delegate {
            var displayName = (self.objERSideResumeListModalItem?.firstName ?? "") +
                " " + (self.objERSideResumeListModalItem?.lastName ?? "")

            delegateAssign.taskProvidedToVC(taskType: .view, resumeID: objERSideResumeListModalItem.rpHighestScoredResumeID ?? 0, name: displayName);

        }
    }
    @IBOutlet weak var lblHighestScore: UILabel!
    @IBOutlet weak var btnHighestDownload: UIButton!
    @IBAction func btnHighestDownloadTapped(_ sender: Any) {
        if let delegateAssign = delegate {
            var displayName = (self.objERSideResumeListModalItem?.firstName ?? "") +
                " " + (self.objERSideResumeListModalItem?.lastName ?? "")


            delegateAssign.taskProvidedToVC(taskType: .download, resumeID: objERSideResumeListModalItem.rpHighestScoredResumeID ?? 0, name: displayName);

        }
    }
    @IBOutlet weak var btnHighestDownloadPrint: UIButton!
    @IBAction func btnHighestDownloadPrintTapped(_ sender: Any) {
        if let delegateAssign = delegate {
            var displayName = (self.objERSideResumeListModalItem?.firstName ?? "") +
                " " + (self.objERSideResumeListModalItem?.lastName ?? "")

            delegateAssign.taskProvidedToVC(taskType: .print, resumeID: objERSideResumeListModalItem.rpHighestScoredResumeID ?? 0, name: displayName);

        }
    }
    
    
    @IBOutlet weak var viewApprovedUpload: UIView!
    @IBOutlet weak var lblApprovedUpload: UILabel!
    @IBOutlet weak var lblApprovedUploadResume: UILabel!
    
    @IBOutlet weak var btnApprovedUploadView: UIButton!
    @IBAction func btnApprovedUploadViewTapped(_ sender: Any) {
        if let delegateAssign = delegate {
            var displayName = (self.objERSideResumeListModalItem?.firstName ?? "") +
                " " + (self.objERSideResumeListModalItem?.lastName ?? "")

            delegateAssign.taskProvidedToVC(taskType: .view, resumeID: objERSideResumeListModalItem.rpFirstResumeID ?? 0, name: displayName);

        }
    }
    @IBOutlet weak var lblApprovedScore: UILabel!
    @IBOutlet weak var btnApprovedDownload: UIButton!
    @IBAction func btnApprovedDownloadTapped(_ sender: Any) {
        if let delegateAssign = delegate {
            var displayName = (self.objERSideResumeListModalItem?.firstName ?? "") +
                " " + (self.objERSideResumeListModalItem?.lastName ?? "")

            delegateAssign.taskProvidedToVC(taskType: .download, resumeID: objERSideResumeListModalItem.rpFirstResumeID ?? 0, name: displayName);

        }
    }
    @IBOutlet weak var btnApprovedDownloadPrint: UIButton!
    @IBAction func btnApprovedDownloadPrintTapped(_ sender: Any) {
        if let delegateAssign = delegate {
            var displayName = (self.objERSideResumeListModalItem?.firstName ?? "") +
                " " + (self.objERSideResumeListModalItem?.lastName ?? "")

            delegateAssign.taskProvidedToVC(taskType: .print, resumeID: objERSideResumeListModalItem.rpFirstResumeID ?? 0, name: displayName);

        }
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func customization(){
        nameIntialandImageLogic()
        resumeDetail()
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
        shadowWithCorner(viewContainer: self.viewContainer, cornerRadius: 3)
        self.imgProfile?.isHidden = true
        self.lblInitialName.isHidden = false
        
        var displayName = (self.objERSideResumeListModalItem?.firstName ?? "") +
            " " + (self.objERSideResumeListModalItem?.lastName ?? "")
        
        var stringImg = GeneralUtility.startNameCharacter(stringName: displayName)
        if   let fontMedium = UIFont(name: "FontMediumWithoutNext".localized(), size: Device.FONTSIZETYPE13)
        {
            UILabel.labelUIHandling(label: lblInitialName, text: GeneralUtility.optionalHandling(_param: stringImg, _returnType: String.self), textColor:.black , isBold: false , fontType: fontMedium, isCircular: true,  backgroundColor:.white ,cornerRadius: radius,borderColor:UIColor.black,borderWidth: 1 )
            lblInitialName.textAlignment = .center
            lblInitialName.layer.borderColor = UIColor.black.cgColor
        }
        
        let strHeader = NSMutableAttributedString.init()
        
        if let fontHeavy = UIFont(name: "FontHeavy".localized(), size: Device.FONTSIZETYPE13), let fontBook = UIFont(name: "FontBook".localized(), size: Device.FONTSIZETYPE13){
            let strTiTle = NSAttributedString.init(string: GeneralUtility.optionalHandling(_param: displayName, _returnType: String.self)
                , attributes: [NSAttributedString.Key.foregroundColor : ILColor.color(index:13),NSAttributedString.Key.font : fontHeavy]);
            let nextLine1 = NSAttributedString.init(string: "\n")
            let strType = NSAttributedString.init(string: GeneralUtility.optionalHandling(_param: self.objERSideResumeListModalItem.benchmark?.name, _returnType: String.self)
                , attributes: [NSAttributedString.Key.foregroundColor : ILColor.color(index: 13),NSAttributedString.Key.font : fontBook]);
            let para = NSMutableParagraphStyle.init()
            //            para.alignment = .center
            para.lineSpacing = 1
            strHeader.append(strTiTle)
            strHeader.append(nextLine1)
            strHeader.append(strType)
            strHeader.addAttribute(NSAttributedString.Key.paragraphStyle, value: para, range: NSMakeRange(0, strHeader.length))
            lblName.attributedText = strHeader
        }
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
       
    
    func resumeDetail(){
        
        let fontHeavy2 = UIFont(name: "FontHeavy".localized(), size: Device.FONTSIZETYPE12)
        let fontHeavy3 = UIFont(name: "FontHeavy".localized(), size: Device.FONTSIZETYPE16)

           let fontMedium = UIFont(name: "FontMediumWithoutNext".localized(), size: Device.FONTSIZETYPE10)
        if (self.objERSideResumeListModalItem.rpLatestResumeID != nil){
            UILabel.labelUIHandling(label: lblLatestUpload, text: "Latest uploaded", textColor: ILColor.color(index: 53), isBold: false, fontType: fontHeavy2)
            UILabel.labelUIHandling(label: lblLatestUploadResume, text: self.objERSideResumeListModalItem.rpSummary?[0].filename?.capitalized ?? "", textColor: ILColor.color(index: 42), isBold: false, fontType: fontMedium)
            
            
            if case let .integer(score) = self.objERSideResumeListModalItem.rpLatestResumeScore {
                UILabel.labelUIHandling(label: lblLatestScore , text: "\(score)", textColor: ILColor.color(index: 53), isBold: false, fontType: fontHeavy3)
                
                if self.objERSideResumeListModalItem.rpLatestResumeScoreType == "Yellow"{
                    lblLatestScore.textColor = ILColor.color(index: 60)
                }
                else if self.objERSideResumeListModalItem.rpLatestResumeScoreType == "Green"{
                    lblLatestScore.textColor = ILColor.color(index: 58)

                }
                else{
                    lblLatestScore.textColor = ILColor.color(index: 33)

                }
                
                
            }
            UIButton.buttonUIHandling(button: btnLatestUploadView, text: "View", backgroundColor: .clear,textColor: ILColor.color(index: 23),fontType: fontMedium)
            btnLatestDownload.setImage(UIImage.init(named: "downloadImage"), for: .normal)
            btnLatestDownloadPrint.setImage(UIImage.init(named: "printImageBlue"), for: .normal)
            btnLatestUploadView.isHidden = false
            
            btnLatestDownload.alpha = 1
            btnLatestDownloadPrint.alpha = 1
            
            btnLatestDownload.isUserInteractionEnabled = true
            btnLatestDownloadPrint.isUserInteractionEnabled = true
        }
        else{
            UILabel.labelUIHandling(label: lblLatestUpload, text: "Latest uploaded", textColor: ILColor.color(index: 53), isBold: false, fontType: fontHeavy2)
            UILabel.labelUIHandling(label: lblLatestScore, text: "N/A", textColor: ILColor.color(index: 53), isBold: false, fontType: fontHeavy2)
            UILabel.labelUIHandling(label: lblLatestUploadResume, text: "N/A", textColor: ILColor.color(index: 42), isBold: false, fontType: fontMedium)
            btnLatestUploadView.isHidden = true
            btnLatestDownload.setImage(UIImage.init(named: "downloadImage"), for: .normal)
            btnLatestDownloadPrint.setImage(UIImage.init(named: "printImageBlue"), for: .normal)
            btnLatestDownload.alpha = 0.6
            btnLatestDownloadPrint.alpha = 0.6
            
            btnLatestDownload.isUserInteractionEnabled = false
            btnLatestDownloadPrint.isUserInteractionEnabled = false
            
        }
        if (self.objERSideResumeListModalItem.rpHighestScoredResumeID != nil){
            
            UILabel.labelUIHandling(label: lblHighestUpload, text: "Highest Scored Resume", textColor: ILColor.color(index: 53), isBold: false, fontType: fontHeavy2)
            UIButton.buttonUIHandling(button: btnHighestUploadView, text: "View", backgroundColor: .clear,textColor: ILColor.color(index: 23),fontType: fontMedium)
            UILabel.labelUIHandling(label: lblHighestUploadResume, text: self.objERSideResumeListModalItem.rpSummary?[0].filename?.capitalized ?? "", textColor: ILColor.color(index: 42), isBold: false, fontType: fontMedium)
            
            if case let .integer(score) = self.objERSideResumeListModalItem.rpHighestScoredResumeScore {
                UILabel.labelUIHandling(label: lblHighestScore , text: "\(score)", textColor: ILColor.color(index: 53), isBold: false, fontType: fontHeavy3)
                if self.objERSideResumeListModalItem.rpHighestScoredResumeScoreType == "Yellow"{
                    lblHighestScore.textColor = ILColor.color(index: 60)
                }
                else if self.objERSideResumeListModalItem.rpHighestScoredResumeScoreType == "Green"{
                    lblHighestScore.textColor = ILColor.color(index: 58)

                }
                else{
                    lblHighestScore.textColor = ILColor.color(index: 33)

                }
                
            }
            
            btnHighestDownload.setImage(UIImage.init(named: "downloadImage"), for: .normal)
            btnHighestDownloadPrint.setImage(UIImage.init(named: "printImageBlue"), for: .normal)
            btnHighestDownload.alpha = 1
            btnHighestDownloadPrint.alpha = 1
            btnHighestDownload.isUserInteractionEnabled = true
            btnHighestDownloadPrint.isUserInteractionEnabled = true
            btnHighestUploadView.isHidden = false
        }
        else {
            UILabel.labelUIHandling(label: lblHighestUpload, text: "Highest Scored Resume", textColor: ILColor.color(index: 53), isBold: false, fontType: fontHeavy2)
            UILabel.labelUIHandling(label: lblHighestScore, text: "N/A", textColor: ILColor.color(index: 53), isBold: false, fontType: fontHeavy2)
            UILabel.labelUIHandling(label: lblHighestUploadResume, text: "N/A", textColor: ILColor.color(index: 42), isBold: false, fontType: fontMedium)
            btnHighestUploadView.isHidden = true
            btnHighestDownload.setImage(UIImage.init(named: "downloadImage"), for: .normal)
            btnHighestDownloadPrint.setImage(UIImage.init(named: "printImageBlue"), for: .normal)
            btnHighestDownload.alpha = 0.6
            btnHighestDownloadPrint.alpha = 0.6
            btnHighestDownload.isUserInteractionEnabled = false
            btnHighestDownloadPrint.isUserInteractionEnabled = false
        }
        if (self.objERSideResumeListModalItem.rpFirstResumeID != nil){
            
            UILabel.labelUIHandling(label: lblApprovedUpload, text: "Approved Resume", textColor: ILColor.color(index: 53), isBold: false, fontType: fontHeavy2)
            UIButton.buttonUIHandling(button: btnApprovedUploadView, text: "View", backgroundColor: .clear,textColor: ILColor.color(index: 23),fontType: fontMedium)
            UILabel.labelUIHandling(label: lblApprovedUploadResume, text: self.objERSideResumeListModalItem.rpSummary?[0].filename?.capitalized ?? "", textColor: ILColor.color(index: 42), isBold: false, fontType: fontMedium)
            
            if case let .integer(score) = self.objERSideResumeListModalItem.rpFirstResumeScore {
                UILabel.labelUIHandling(label: lblApprovedScore , text: "\(score)", textColor: ILColor.color(index: 53), isBold: false, fontType: fontHeavy3)
                if self.objERSideResumeListModalItem.rpFirstResumeScoreType == "Yellow"{
                    lblApprovedScore.textColor = ILColor.color(index: 60)
                }
                else if self.objERSideResumeListModalItem.rpFirstResumeScoreType == "Green"{
                    lblApprovedScore.textColor = ILColor.color(index: 58)
                }
                else{
                    lblApprovedScore.textColor = ILColor.color(index: 33)
                }
            }
            
            btnApprovedUploadView.isHidden = false
            btnApprovedDownload.setImage(UIImage.init(named: "downloadImage"), for: .normal)
            btnApprovedDownloadPrint.setImage(UIImage.init(named: "printImageBlue"), for: .normal)
            btnApprovedDownload.alpha = 1
            btnApprovedDownloadPrint.alpha = 1
            btnApprovedDownload.isUserInteractionEnabled = true
            btnApprovedDownloadPrint.isUserInteractionEnabled = true
            
        }
        else {
            UILabel.labelUIHandling(label: lblApprovedUpload, text: "Approved Resume", textColor: ILColor.color(index: 53), isBold: false, fontType: fontHeavy2)
            UILabel.labelUIHandling(label: lblApprovedScore, text: "N/A", textColor: ILColor.color(index: 53), isBold: false, fontType: fontHeavy2)
            UILabel.labelUIHandling(label: lblApprovedUploadResume, text: "N/A", textColor: ILColor.color(index: 53), isBold: false, fontType: fontMedium)
            btnApprovedDownload.setImage(UIImage.init(named: "downloadImage"), for: .normal)
            btnApprovedDownloadPrint.setImage(UIImage.init(named: "printImageBlue"), for: .normal)
            btnApprovedUploadView.isHidden = true
            btnApprovedDownload.alpha = 0.6
            btnApprovedDownloadPrint.alpha = 0.6
            btnApprovedDownload.isUserInteractionEnabled = true
            btnApprovedDownloadPrint.isUserInteractionEnabled = true
        }
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
