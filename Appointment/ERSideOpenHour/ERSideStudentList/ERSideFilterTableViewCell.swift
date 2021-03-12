//
//  ERSideFilterTableViewCell.swift
//  Appointment
//
//  Created by Anurag Bhakuni on 18/12/20.
//  Copyright © 2020 Anurag Bhakuni. All rights reserved.
//

import UIKit


protocol ERSideFilterTableViewCellDelegate {
    
    func tagSelected(tag: TagValueObject,isSelectedStudent: Bool)
    
}


class ERSideFilterTableViewCell: UITableViewCell {

    @IBOutlet weak var btnSelectFilter: UIButton!
   
    var delegateI : ERSideFilterTableViewCellDelegate!
    
    var objTagValue : TagValueObject?

    @IBOutlet weak var lblSelectFilter: UILabel!
    
    @IBOutlet weak var viewContainer: UIView!
    @IBAction func btnSelectFilterTapped(_ sender: Any) {
        let isSelected  = !(objTagValue?.isSelected ?? false)
        
        if   isSelected {
            btnSelectFilter.setImage(UIImage.init(named: "Check_box_selected"), for: .normal);
        }
        else{
            btnSelectFilter.setImage(UIImage.init(named: "check_box"), for: .normal);
        }
        delegateI.tagSelected(tag: objTagValue!, isSelectedStudent: isSelected)
    }
    
    
    func customize()  {
        
        if let fontBook =  UIFont(name: "FontBook".localized(), size: Device.FONTSIZETYPE14)
        {
            UILabel.labelUIHandling(label: lblSelectFilter, text: objTagValue?.tagValueText ?? "", textColor:ILColor.color(index: 39) , isBold: false, fontType: fontBook)
        }
        
        if objTagValue?.isSelected ?? false {
            btnSelectFilter.setImage(UIImage.init(named: "Check_box_selected"), for: .normal);
        }
        else{
            btnSelectFilter.setImage(UIImage.init(named: "check_box"), for: .normal);
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
