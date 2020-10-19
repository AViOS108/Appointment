//
//  HeaderSectionCoach.swift
//  Appointment
//
//  Created by Anurag Bhakuni on 18/08/20.
//  Copyright © 2020 Anurag Bhakuni. All rights reserved.
//

import UIKit


protocol HeaderSectionCoachDelegate {
    
    func changeModal(modal:sectionHead,seeMore:Bool )
    
    
}

class HeaderSectionCoach: UITableViewHeaderFooterView {
    @IBOutlet weak var btnSelectAll: UIButton!
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var lblheader: UILabel!
    @IBOutlet weak var btnMultiPurpose: UIButton!
    var sectionHeader : sectionHead?
    var delegate : HeaderSectionCoachDelegate?
    
    @IBOutlet weak var nslayoutWidthSelectAllButton: NSLayoutConstraint!
    func customization() {
        
        if sectionHeader?.id == "-10" || sectionHeader?.id == "-09"
        {
            self.nslayoutWidthSelectAllButton.constant = 0
            btnSelectAll.isHidden = true
        }
        else{
            self.nslayoutWidthSelectAllButton.constant = 30
            btnSelectAll.isHidden = false
        }
        
        
        let fontMedium = UIFont(name: "FontMedium".localized(), size: Device.FONTSIZETYPE13)
        UILabel.labelUIHandling(label: lblheader, text:  GeneralUtility.optionalHandling(_param: sectionHeader?.name, _returnType: String.self),  textColor: ILColor.color(index: 5), isBold: false, fontType: fontMedium,  backgroundColor: .white)
        
        
        if self.sectionHeader!.selectAll{
            UIButton.buttonUIHandling(button: btnSelectAll, text: "", backgroundColor:UIColor.clear )
            btnSelectAll.setImage(UIImage.init(named: "Check_box_selected"), for: .normal)
        }
        else{
            UIButton.buttonUIHandling(button: btnSelectAll, text: "", backgroundColor:UIColor.clear)
            btnSelectAll.setImage(UIImage.init(named: "check_box"), for: .normal)
            
        }
        
        if self.sectionHeader!.seeAll{
            UIButton.buttonUIHandling(button: btnMultiPurpose, text: "See Less", backgroundColor:UIColor.clear,textColor: ILColor.color(index: 23),fontType: fontMedium )
        }
        else{
            UIButton.buttonUIHandling(button: btnMultiPurpose, text: "See All", backgroundColor:UIColor.clear,textColor: ILColor.color(index: 23),fontType: fontMedium)
            
        }
        
        
    }
    
    
    @IBAction func btnSelectAllTapped(_ sender: Any) {
        
        delegate?.changeModal(modal: sectionHeader!, seeMore: false)
    }
    
    @IBAction func btnMultipurposeTapped(_ sender: Any) {
        delegate?.changeModal(modal: sectionHeader!, seeMore: true)
    }
}
