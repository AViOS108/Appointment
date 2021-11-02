//
//  ERSideDetailEditTableViewCell.swift
//  Appointment
//
//  Created by Anurag Bhakuni on 11/02/21.
//  Copyright © 2021 Anurag Bhakuni. All rights reserved.
//

import UIKit

class ERSideDetailEditTableViewCell: UITableViewCell {

    
    @IBOutlet weak var lblDetail: UILabel!
    var viewController : UIViewController!;
    var objERSideOHDetailModal : ERSideOHDetailModal!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func customize()  {
        if let fontHeavy = UIFont(name: "FontHeavy".localized(), size: Device.FONTSIZETYPE12), let fontBook =  UIFont(name: "FontBook".localized(), size: Device.FONTSIZETYPE11)
            
        {
            let strHeader = NSMutableAttributedString.init()
            let strTitle = NSAttributedString.init(string: objERSideOHDetailModal.headLinetext
                , attributes: [NSAttributedString.Key.foregroundColor : ILColor.color(index:34),NSAttributedString.Key.font : fontHeavy]);
            let nextLine1 = NSAttributedString.init(string: "\n")

            
            let strTitleText = NSAttributedString.init(string: objERSideOHDetailModal.valueText
                , attributes: [NSAttributedString.Key.foregroundColor : ILColor.color(index: 34),NSAttributedString.Key.font : fontBook]);
            
            let para = NSMutableParagraphStyle.init()
            //            para.alignment = .center
            para.lineSpacing = 4
            strHeader.append(strTitle)
            strHeader.append(nextLine1)
            strHeader.append(strTitleText);
            strHeader.addAttribute(NSAttributedString.Key.paragraphStyle, value: para, range: NSMakeRange(0, strHeader.length))
            lblDetail.attributedText = strHeader
        }
        
        
        
    }
    
    
    
    
}
