//
//  ERNoteSelectableTypeTableViewCell.swift
//  Appointment
//
//  Created by Anurag Bhakuni on 15/04/21.
//  Copyright © 2021 Anurag Bhakuni. All rights reserved.
//

import UIKit
protocol ERNoteSelectableTypeTableViewCellDelegate {
    func selectedNotes(items :Role);
}



class ERNoteSelectableTypeTableViewCell: UITableViewCell {

    
    var delegate : ERNoteSelectableTypeTableViewCellDelegate!
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var btnSelected: UIButton!
    
    @IBAction func btnSelectedTapped(_ sender: Any) {
        delegate.selectedNotes(items: items)
        if items.isSelected {
                   btnSelected.setImage(UIImage.init(named: "check_box"), for: .normal)
               }
               else {
                   btnSelected.setImage(UIImage.init(named: "Check_box_selected"), for: .normal)
               }
    }
    
    @IBOutlet weak var nslayoutLeadingSpace: NSLayoutConstraint!
    @IBOutlet weak var lblTitle: UILabel!
    var items: Role!
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
        UILabel.labelUIHandling(label: lblTitle, text: items.displayName ?? "", textColor: ILColor.color(index: 42), isBold: false, fontType: fontMedium)
        
        if (items.id == -999) || (items.id == -1999){
            nslayoutLeadingSpace.constant = 8
        }
        else{
            nslayoutLeadingSpace.constant = 20
        }
        if items.isSelected {
            btnSelected.setImage(UIImage.init(named: "Check_box_selected"), for: .normal)
        }
        else {
            btnSelected.setImage(UIImage.init(named: "check_box"), for: .normal)
        }
    }
}
