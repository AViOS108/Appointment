//
//  TimeZoneTableViewCell.swift
//  Appointment
//
//  Created by Anurag Bhakuni on 01/09/20.
//  Copyright © 2020 Anurag Bhakuni. All rights reserved.
//

import UIKit

class TimeZoneTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblTimeZone: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    @IBOutlet weak var viewSeperator: UIView!
    func customize(timeZonetitle: String)  {
        if let fontMedium = UIFont(name: "FontMedium".localized(), size: Device.FONTSIZETYPE11)
        {
            UILabel.labelUIHandling(label: lblTimeZone, text: timeZonetitle, textColor:ILColor.color(index: 29) , isBold: false , fontType: fontMedium,   backgroundColor:.white )
        }
        viewSeperator.backgroundColor = ILColor.color(index:19);
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
