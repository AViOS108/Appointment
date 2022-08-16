//
//  ConfirmationAvailableSlotTableViewCell.swift
//  Appointment
//
//  Created by Anurag Bhakuni on 28/10/21.
//  Copyright © 2021 Anurag Bhakuni. All rights reserved.
//

import UIKit

class ConfirmationAvailableSlotTableViewCell: UITableViewCell {

    var results: OpenHourCoachModalResult!
    @IBOutlet weak var viewSeperator: UIView!

    // Design Changes
    
    @IBOutlet weak var lblTimingFrom: UILabel!
    @IBOutlet weak var lblTimingTo: UILabel!
    @IBOutlet weak var lblAvailableSlots: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func customization(){
        self.customizationTimeSlot()
        self.customizationLocation()
        viewSeperator.backgroundColor = ILColor.color(index: 54)

    }
    
    
    func customizationTimeSlot(){
        
        let fontHeavy = UIFont(name: "FontHeavy".localized(), size: Device.FONTSIZETYPE12)
        UILabel.labelUIHandling(label: lblAvailableSlots, text: "Selected Slot", textColor: ILColor.color(index: 59), isBold: true, fontType: fontHeavy)
        
        if let fontMediumI =  UIFont(name: "FontMediumWithoutNext".localized(), size: Device.FONTSIZETYPE14), let fontMedium =  UIFont(name: "FontMediumWithoutNext".localized(), size: Device.FONTSIZETYPE12)
        {
            let strHeader = NSMutableAttributedString.init()
            let strTiTle = NSAttributedString.init(string: "Start Time"
                , attributes: [NSAttributedString.Key.foregroundColor : ILColor.color(index: 42),NSAttributedString.Key.font : fontMedium]);
            let nextLine1 = NSAttributedString.init(string: "\n")

            let strTime = NSAttributedString.init(string: GeneralUtility.currentDateDetailType3(emiDate: results.startDatetimeUTC)
                , attributes: [NSAttributedString.Key.foregroundColor : ILColor.color(index: 53),NSAttributedString.Key.font : fontMediumI]);
            
            
            let para = NSMutableParagraphStyle.init()
            //            para.alignment = .center
            para.lineSpacing = 8

            strHeader.append(strTiTle)
            strHeader.append(nextLine1)
            strHeader.append(strTime)
            
            strHeader.addAttribute(NSAttributedString.Key.paragraphStyle, value: para, range: NSMakeRange(0, strHeader.length))
            
            
            
            lblTimingFrom.attributedText = strHeader
        }
        if let fontMediumI =  UIFont(name: "FontMediumWithoutNext".localized(), size: Device.FONTSIZETYPE14),let fontMedium =  UIFont(name: "FontMediumWithoutNext".localized(), size: Device.FONTSIZETYPE12)
        {
            let strHeader = NSMutableAttributedString.init()
            let nextLine1 = NSAttributedString.init(string: "\n")

            let strTiTle = NSAttributedString.init(string: "End Time"
                , attributes: [NSAttributedString.Key.foregroundColor : ILColor.color(index: 42),NSAttributedString.Key.font : fontMedium]);
            let strTime = NSAttributedString.init(string: GeneralUtility.currentDateDetailType3(emiDate: results.endDatetimeUTC)
                , attributes: [NSAttributedString.Key.foregroundColor : ILColor.color(index: 53),NSAttributedString.Key.font : fontMediumI]);
            let para = NSMutableParagraphStyle.init()
            para.lineSpacing = 8

            strHeader.append(strTiTle)
            strHeader.append(nextLine1)
            strHeader.append(strTime)
            strHeader.addAttribute(NSAttributedString.Key.paragraphStyle, value: para, range: NSMakeRange(0, strHeader.length))
            lblTimingTo.attributedText = strHeader
        }

    }
    
    func customizationLocation(){
        
        if   let fontHeavy = UIFont(name: "FontHeavy".localized(), size: Device.FONTSIZETYPE12),let fontBook =  UIFont(name: "FontBook".localized(), size: Device.FONTSIZETYPE12)
        {
            let strHeader = NSMutableAttributedString.init()
            let nextLine1 = NSAttributedString.init(string: "\n")
            
            let strTiTle = NSAttributedString.init(string: "Location/ Meeting Link"
                                                   , attributes: [NSAttributedString.Key.foregroundColor : ILColor.color(index: 59),NSAttributedString.Key.font : fontHeavy]);
            let strlocation = NSAttributedString.init(string: self.results.location
                                                      , attributes: [NSAttributedString.Key.foregroundColor : ILColor.color(index: 34),NSAttributedString.Key.font : fontBook]);
            let para = NSMutableParagraphStyle.init()
            para.lineSpacing = 6

            strHeader.append(strTiTle)
            strHeader.append(nextLine1)
            strHeader.append(strlocation)
            strHeader.addAttribute(NSAttributedString.Key.paragraphStyle, value: para, range: NSMakeRange(0, strHeader.length))
            lblLocation.attributedText = strHeader
        }
        
    }
    
    
}
