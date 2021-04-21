//
//  ERUpdateAppoinmentTableViewCell.swift
//  Appointment
//
//  Created by Anurag Bhakuni on 14/04/21.
//  Copyright © 2021 Anurag Bhakuni. All rights reserved.
//

import UIKit

protocol ERUpdateAppoinmentTableViewCellDelegate {
    
    func attendedStatus(requestStudentDetail : Request)
}

class ERUpdateAppoinmentTableViewCell: UITableViewCell {

    
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblInitialName: UILabel!
    @IBOutlet weak var lblAttended: UILabel!
    @IBOutlet weak var switchAttended: UISwitch!
    var requestStudentDetail : Request!
    var delegate : ERUpdateAppoinmentTableViewCellDelegate!
    
    @IBAction func switchAttendedTapped(_ sender: Any) {
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func customization()
    {
        nameIntialandImageLogic()
        switchLogic()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @objc func switchValueDidChange(_ sender: UISwitch) {
        let fontMedium = UIFont(name: "FontMedium".localized(), size: Device.FONTSIZETYPE12)
        if (sender.isOn == true){
            switchAttended.onTintColor = ILColor.color(index: 23)
            UILabel.labelUIHandling(label: lblAttended, text: "Attended", textColor: ILColor.color(index: 23), isBold: false, fontType: fontMedium)
        }
        else{
            switchAttended.onTintColor = ILColor.color(index: 50)
            UILabel.labelUIHandling(label: lblAttended, text: "Not Attended", textColor: ILColor.color(index: 26), isBold: false, fontType: fontMedium)
        }
        delegate.attendedStatus(requestStudentDetail: requestStudentDetail);
    }
    
    func switchLogic(){
        switchAttended.addTarget(self, action: #selector(switchValueDidChange(_:)), for: .valueChanged)

        
        let fontMedium = UIFont(name: "FontMedium".localized(), size: Device.FONTSIZETYPE12)
        if self.requestStudentDetail.hasAttended == 1{
            UILabel.labelUIHandling(label: lblAttended, text: "Attended", textColor: ILColor.color(index: 23), isBold: false, fontType: fontMedium)
            switchAttended.setOn(true, animated: false)
            switchAttended.onTintColor = ILColor.color(index: 23)

        }
        else{
             UILabel.labelUIHandling(label: lblAttended, text: "Not Attended", textColor: ILColor.color(index: 26), isBold: false, fontType: fontMedium)
            switchAttended.setOn(false, animated: false)
            switchAttended.onTintColor = ILColor.color(index: 50)


        }
        
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
        
        
        
        var displayName = (self.requestStudentDetail?.studentDetails?.firstName ?? "") +
            " " + (self.requestStudentDetail?.studentDetails?.lastName ?? "")
        
        if displayName.trimmingCharacters(in: .whitespaces).isEmpty {
            displayName = "Deleted User"
        }
        
        let stringImg = GeneralUtility.startNameCharacter(stringName: displayName)
        if let fontMedium = UIFont(name: "FontMedium".localized(), size: Device.FONTSIZETYPE15)
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
            let strType = NSAttributedString.init(string: GeneralUtility.optionalHandling(_param: self.self.requestStudentDetail.studentDetails?.benchmarkName, _returnType: String.self)
                , attributes: [NSAttributedString.Key.foregroundColor : ILColor.color(index: 13),NSAttributedString.Key.font : fontBook]);
            let para = NSMutableParagraphStyle.init()
            //            para.alignment = .center
            para.lineSpacing = 1
            strHeader.append(strTiTle)
            if displayName != "Deleted User"{
                strHeader.append(nextLine1)
                strHeader.append(strType)
            }
            strHeader.addAttribute(NSAttributedString.Key.paragraphStyle, value: para, range: NSMakeRange(0, strHeader.length))
            lblName.attributedText = strHeader
        }
    }
}
