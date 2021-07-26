//
//  ERSideHomeSectionHeader.swift
//  Appointment
//
//  Created by Anurag Bhakuni on 13/11/20.
//  Copyright © 2020 Anurag Bhakuni. All rights reserved.
//

import UIKit

class ERSideHomeSectionHeader: UITableViewHeaderFooterView {

    @IBOutlet weak var lblDay: UILabel!
    @IBOutlet weak var viewContainer: UIView!
    var objsectionHeaderER : SectionHeaderER!

    func customization()  {
        let fontMedium =  UIFont(name: "FontMediumWithoutNext".localized(), size: Device.FONTSIZETYPE14)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM, YYYY"
        let dateS = dateFormatter.string(from: objsectionHeaderER.date)        
        
        UILabel.labelUIHandling(label: lblDay, text: dateS, textColor: ILColor.color(index: 26), isBold: false, fontType: fontMedium)
        
    }
}
