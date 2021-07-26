//
//  ERSideMyAppointmentHeaderCollectionViewCell.swift
//  Appointment
//
//  Created by Anurag Bhakuni on 20/11/20.
//  Copyright © 2020 Anurag Bhakuni. All rights reserved.
//

import UIKit

protocol ERSideMyAppointmentHeaderCollectionViewCelDelegate {
    func selectedHeaderCVCell(id: Int)
}

class ERSideMyAppointmentHeaderCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var btnHeader: UIButton!
    var objERSideMyAppointmentCVModal : ERSideMyAppointmentCVModal!

    var delegate : ERSideMyAppointmentHeaderCollectionViewCelDelegate!
    
    @IBAction func btnHeaderTapped(_ sender: Any) {
        
        if !self.objERSideMyAppointmentCVModal.isSelected{
            delegate.selectedHeaderCVCell(id: self.objERSideMyAppointmentCVModal.id)
        }
        
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBOutlet weak var viewSelected: UIView!
    func customize()  {
        
         let fontMedium = UIFont(name: "FontMedium".localized(), size: Device.FONTSIZETYPE15)

        
        if self.objERSideMyAppointmentCVModal.isSelected{
            self.viewSelected.isHidden = false
            UIButton.buttonUIHandling(button: btnHeader, text: self.objERSideMyAppointmentCVModal.title, backgroundColor: ILColor.color(index: 23), textColor: .white,  fontType: fontMedium)
            self.viewSelected.backgroundColor = .white
        }
        else{
            self.viewSelected.isHidden = true
            UIButton.buttonUIHandling(button: btnHeader, text: self.objERSideMyAppointmentCVModal.title, backgroundColor: ILColor.color(index: 23), textColor: ILColor.color(index: 47),  fontType: fontMedium)

        }
        
        
    }
    
}
