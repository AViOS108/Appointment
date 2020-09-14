//
//  CalenderCollectionViewCell.swift
//  Appointment
//
//  Created by Anurag Bhakuni on 21/08/20.
//  Copyright © 2020 Anurag Bhakuni. All rights reserved.
//

import UIKit


protocol CalenderCollectionViewCellDelegate{
    func dateSelected(calenderModal : CalenderModal)
    
}




class CalenderCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var lblDay: UILabel!
    
    @IBOutlet weak var btnSelect: UIButton!
    var calenderModal : CalenderModal!
    
    var delegate : CalenderCollectionViewCellDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func customize()  {
        let fontMedium = UIFont(name: "FontMedium".localized(), size: Device.FONTSIZETYPE16)
        UILabel.labelUIHandling(label: lblDay, text: self.calenderModal.strText!, textColor:ILColor.color(index: 28) , isBold: false, fontType: fontMedium)
        if calenderModal.isSelected!
        {
            lblDay.textColor = .white
            // corner radius
            self.lblDay.layer.cornerRadius = self.lblDay.frame.height/2
            // border
            self.lblDay.layer.borderWidth = 1.0
            self.lblDay.layer.borderColor = ILColor.color(index: 27).cgColor
            self.lblDay.clipsToBounds = true
            self.lblDay.backgroundColor = ILColor.color(index: 23)
        }
        else{
            self.lblDay.backgroundColor = .white
            self.lblDay.layer.cornerRadius = 0
            // border
            self.lblDay.layer.borderWidth = 0.0
        }
    }
    
    @IBAction func BtnDaySelectTapped(_ sender: Any) {
        delegate.dateSelected(calenderModal: self.calenderModal)
    }
    
    
    
    

}
