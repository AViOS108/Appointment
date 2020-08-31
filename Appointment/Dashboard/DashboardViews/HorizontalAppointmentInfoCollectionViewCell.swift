//
//  HorizontalAppointmentInfoCollectionViewCell.swift
//  Appointment
//
//  Created by Anurag Bhakuni on 17/08/20.
//  Copyright © 2020 Anurag Bhakuni. All rights reserved.
//

import UIKit

class HorizontalAppointmentInfoCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var lblDescribtion: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    var studentHeader : StudentHeaderModel?


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    func customization(){
        let strHeader = NSMutableAttributedString.init()
        if let fontHeavy = UIFont(name: "FontHeavy".localized(), size: Device.FONTSIZETYPE13), let fontMedium =  UIFont(name: "FontMedium".localized(), size: Device.FONTSIZETYPE14)
            
        {
            let strTiTle = NSAttributedString.init(string: GeneralUtility.optionalHandling(_param: self.studentHeader?.title, _returnType: String.self)
                , attributes: [NSAttributedString.Key.foregroundColor : ILColor.color(index:3),NSAttributedString.Key.font : fontHeavy]);
            let nextLine1 = NSAttributedString.init(string: "\n")
            
            let strDesc = NSAttributedString.init(string: GeneralUtility.optionalHandling(_param: self.studentHeader?.describtion, _returnType: String.self)
                , attributes: [NSAttributedString.Key.foregroundColor : ILColor.color(index: 3),NSAttributedString.Key.font : fontMedium]);
            
            let para = NSMutableParagraphStyle.init()
            //            para.alignment = .center
            para.lineSpacing = 4
            strHeader.append(strTiTle)
            strHeader.append(nextLine1)
            strHeader.append(strDesc)
            
            strHeader.addAttribute(NSAttributedString.Key.paragraphStyle, value: para, range: NSMakeRange(0, strHeader.length))
            lblDescribtion.attributedText = strHeader
        }
        self.imgView.image = UIImage.init(named: (self.studentHeader?.ImageName)!);
        self.imgView.contentMode = .scaleToFill
    }

}
