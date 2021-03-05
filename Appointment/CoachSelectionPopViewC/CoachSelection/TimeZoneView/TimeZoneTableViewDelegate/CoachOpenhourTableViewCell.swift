//
//  CoachOpenhourTableViewCell.swift
//  Appointment
//
//  Created by Anurag Bhakuni on 04/09/20.
//  Copyright © 2020 Anurag Bhakuni. All rights reserved.
//

import UIKit

class CoachOpenhourTableViewCell: UITableViewCell {
    @IBOutlet weak var lblTiming: UILabel!
    @IBOutlet weak var lblOpenHour: UILabel!
    var objModal :OpenHourCoachModalResult!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBOutlet weak var viewContainer: UIView!
    
    func customize()  {
        if let fontMedium = UIFont(name: "FontMedium".localized(), size: Device.FONTSIZETYPE13), let fontheavy = UIFont(name: "FontHeavy".localized(), size: Device.FONTSIZETYPE14)
        {
            UILabel.labelUIHandling(label: lblTiming, text: GeneralUtility.currentDateDetailType3(emiDate: objModal.startDatetimeUTC!) + " - " + GeneralUtility.currentDateDetailType3(emiDate: objModal.endDatetimeUTC!), textColor:ILColor.color(index: 29) , isBold: false , fontType: fontheavy,   backgroundColor:.clear )
            
            UILabel.labelUIHandling(label: lblOpenHour, text: "Open Hours", textColor:ILColor.color(index: 29) , isBold: false , fontType: fontMedium,   backgroundColor:.clear )
            
        }
        
        viewContainer.backgroundColor = ILColor.color(index: 30)
        viewContainer.dropShadowER()
        
    }
    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
