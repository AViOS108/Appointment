//
//  AppoinmentPurposeTableViewCell.swift
//  Appointment
//
//  Created by Anurag Bhakuni on 25/09/20.
//  Copyright © 2020 Anurag Bhakuni. All rights reserved.
//

import UIKit

class AppoinmentPurposeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var viewContainer: UIView!
    
    @IBOutlet weak var lblPurposeDescribtion: UILabel!
    
    @IBOutlet weak var lblAttachment: UILabel!
    
    @IBOutlet weak var btnAttachment: UIButton!
    var appoinmentDetailModalObj : AppoinmentDetailModal?
    
    var viewController : UIViewController!
    
    
    @IBAction func btnAttachmentTapped(_ sender: Any) {
        
        let wvc = UIStoryboard.webViewer()
        wvc.webUrl = self.appoinmentDetailModalObj?.attachmentsPublic?[0].url ?? ""
        viewController.navigationController?.pushViewController(wvc, animated: true)
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
    
    func customization(){
        
        self.shadowWithCorner(viewContainer: viewContainer, cornerRadius: 3)
        self.backgroundColor = .clear

        let strHeaderDescription = NSMutableAttributedString.init()
        if let fontHeavy = UIFont(name: "FontHeavy".localized(), size: Device.FONTSIZETYPE14), let fontBook =  UIFont(name: "FontBook".localized(), size: Device.FONTSIZETYPE14),let fontMedium =  UIFont(name: "FontMediumWithoutNext".localized(), size: Device.FONTSIZETYPE14)
            
        {
            
            
            let strTitle = NSAttributedString.init(string: GeneralUtility.optionalHandling(_param: "Purpose", _returnType: String.self)
                , attributes: [NSAttributedString.Key.foregroundColor : ILColor.color(index:34),NSAttributedString.Key.font : fontHeavy]);
            
            let nextLine1 = NSAttributedString.init(string: "\n")
            let strDescText = NSAttributedString.init(string: GeneralUtility.optionalHandling(_param: "Description", _returnType: String.self)
                , attributes: [NSAttributedString.Key.foregroundColor : ILColor.color(index: 35),NSAttributedString.Key.font : fontMedium]);
            
            let strFunctionText = NSAttributedString.init(string: GeneralUtility.optionalHandling(_param: "Functions:", _returnType: String.self)
                , attributes: [NSAttributedString.Key.foregroundColor : ILColor.color(index:34),NSAttributedString.Key.font : fontMedium]);
            
            let strFunctionValue = NSAttributedString.init(string: GeneralUtility.optionalHandling(_param: self.description(key: "Functions:"), _returnType: String.self)
                , attributes: [NSAttributedString.Key.foregroundColor : ILColor.color(index: 36),NSAttributedString.Key.font : fontBook]);
            
            
            let strnIndustriesText = NSAttributedString.init(string: GeneralUtility.optionalHandling(_param: "Industries:", _returnType: String.self)
                , attributes: [NSAttributedString.Key.foregroundColor : ILColor.color(index:34),NSAttributedString.Key.font : fontMedium]);
            
            
            let strnIndustriesValue = NSAttributedString.init(string: GeneralUtility.optionalHandling(_param: self.description(key: "Industries:"), _returnType: String.self)
                , attributes: [NSAttributedString.Key.foregroundColor : ILColor.color(index: 36),NSAttributedString.Key.font : fontBook]);
            
            
            let strnCompaniesText = NSAttributedString.init(string: GeneralUtility.optionalHandling(_param: "Companies:", _returnType: String.self)
                , attributes: [NSAttributedString.Key.foregroundColor : ILColor.color(index:34),NSAttributedString.Key.font : fontMedium]);
            
            
            let strnCompaniesValue = NSAttributedString.init(string: GeneralUtility.optionalHandling(_param: self.description(key: "Companies:"), _returnType: String.self)
                , attributes: [NSAttributedString.Key.foregroundColor : ILColor.color(index: 36),NSAttributedString.Key.font : fontBook]);
            
            
            let para = NSMutableParagraphStyle.init()
            //            para.alignment = .center
            para.lineSpacing = 4
            strHeaderDescription.append(strTitle)
            strHeaderDescription.append(nextLine1)
            strHeaderDescription.append(strDescText)
            var boolFunc = false, boolIndus = false,boolCompa = false
            if self.description(key: "Functions:") != "" {
                boolFunc = true
                strHeaderDescription.append(nextLine1)
                strHeaderDescription.append(strFunctionText)
                strHeaderDescription.append(strFunctionValue)
            }
            
            if self.description(key: "Industries:") != "" {
                boolIndus = true
                strHeaderDescription.append(nextLine1)
                strHeaderDescription.append(strnIndustriesText)
                strHeaderDescription.append(strnIndustriesValue)
            }
            if self.description(key: "Companies:") != "" {
                boolCompa = true
                strHeaderDescription.append(nextLine1)
                strHeaderDescription.append(strnCompaniesText)
                strHeaderDescription.append(strnCompaniesValue)
            }
            
            if !boolFunc && !boolIndus && !boolCompa{
                
                let strDescription = NSAttributedString.init(string: GeneralUtility.optionalHandling(_param: self.appoinmentDetailModalObj?.welcomeDescription, _returnType: String.self)
                    , attributes: [NSAttributedString.Key.foregroundColor : ILColor.color(index:36),NSAttributedString.Key.font : fontBook]);
                strHeaderDescription.append(nextLine1)
                strHeaderDescription.append(strDescription)
                
            }
            else{
                
                let descriptionIndex = self.appoinmentDetailModalObj?.welcomeDescription?.range(of: ";", options: .backwards)?.lowerBound
                let descriptionString = self.appoinmentDetailModalObj?.welcomeDescription
                let descriptionIndexI = descriptionIndex!..<descriptionString!.endIndex
                let descriptiontext = descriptionString![descriptionIndexI] ;
                
                let strDescription = NSAttributedString.init(string: GeneralUtility.optionalHandling(_param: String(descriptiontext), _returnType: String.self)
                    , attributes: [NSAttributedString.Key.foregroundColor : ILColor.color(index:36),NSAttributedString.Key.font : fontBook]);
                strHeaderDescription.append(strDescription)
                
            }
            
            strHeaderDescription.addAttribute(NSAttributedString.Key.paragraphStyle, value: para, range: NSMakeRange(0, strHeaderDescription.length))
            lblPurposeDescribtion.attributedText = strHeaderDescription
            
            UILabel.labelUIHandling(label: lblAttachment, text: "Attachments", textColor: ILColor.color(index:34), isBold: false, fontType: fontMedium)
            
            if self.appoinmentDetailModalObj?.attachmentsPublic == nil && self.appoinmentDetailModalObj?.attachmentsPublic?.count == 0{
                
                btnAttachment.isUserInteractionEnabled = false
                btnAttachment.isEnabled = false
                UIButton.buttonUIHandling(button: btnAttachment, text: "No attachment available", backgroundColor: .clear, textColor: ILColor.color(index:36),fontType: fontBook)
                
            }
            else{
                
                btnAttachment.isUserInteractionEnabled = true
                btnAttachment.isEnabled = true
                
                UIButton.buttonUIHandling(button: btnAttachment, text: self.appoinmentDetailModalObj?.attachmentsPublic?[0].name ?? "", backgroundColor: .clear, textColor: ILColor.color(index:36),fontType: fontBook)
                
            }
            
            
        }
        
    }
    
    func description(key:String)-> String{
        if self.appoinmentDetailModalObj?.welcomeDescription?.contains(key) ?? false{
            let strInbetween =  self.appoinmentDetailModalObj?.welcomeDescription!.slice(from:key,to:";")
            return strInbetween ?? ""
            
        }
        else{
            return ""
        }
        
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

