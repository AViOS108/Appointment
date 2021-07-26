//
//  ERNotesHeaderTypeTableViewCell.swift
//  Appointment
//
//  Created by Anurag Bhakuni on 15/04/21.
//  Copyright © 2021 Anurag Bhakuni. All rights reserved.
//

import UIKit

class ERNotesHeaderTypeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var viewContainer: UIView!
    
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var imgView: UIImageView!
    var objNotesHeaderModal : notesHeaderModal!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func customization()  {
        let fontMedium = UIFont(name: "FontMediumWithoutNext".localized(), size: Device.FONTSIZETYPE13)
        UILabel.labelUIHandling(label: lblTitle, text: objNotesHeaderModal.title ?? "", textColor: ILColor.color(index: 42), isBold: false, fontType: fontMedium);
        if objNotesHeaderModal.id == -999{
            imgView.isHidden = true
        }
        else{
            imgView.isHidden = false
            imgView.image = UIImage.init(named: "selectableIcon")
        }
        viewContainer.backgroundColor = ILColor.color(index: 48)
        viewContainer.cornerRadius = 3;
    }
}
