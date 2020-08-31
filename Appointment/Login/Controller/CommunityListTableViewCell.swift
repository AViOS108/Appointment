//
//  CommunityListTableViewCell.swift
//  Resume
//
//  Created by Manu Gupta on 06/11/17.
//  Copyright © 2017 VM User. All rights reserved.
//

import UIKit

class CommunityListTableViewCell: UITableViewCell {

    
    @IBOutlet weak var optionTextlabel: UILabel!
    @IBOutlet weak var labelContainerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            optionTextlabel.textColor = .white
            labelContainerView.backgroundColor = ColorCode.applicationBlue
        }else{
            optionTextlabel.textColor = ColorCode.textColor
            labelContainerView.backgroundColor = UIColor.fromHex(0xECECEC)
        }
    }
    
//    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
//        super.setHighlighted(highlighted, animated: animated)
//        if highlighted {
//            optionTextlabel.textColor = .white
//            labelContainerView.backgroundColor = ColorCode.applicationBlue
//        }else{
//            optionTextlabel.textColor = ColorCode.textColor
//            labelContainerView.backgroundColor = UIColor.fromHex(0xECECEC)
//        }
//    }
}
