//
//  ERSideTimeSlotDuplicate.swift
//  Appointment
//
//  Created by Anurag Bhakuni on 03/03/21.
//  Copyright © 2021 Anurag Bhakuni. All rights reserved.
//

import UIKit


protocol RefreshSelectedTimeSlotDelegate {
    func refreshSelectedTS(id:String)
}

class ERSideTimeSlotDuplicate: UIView {
    
    var objtimeSlotDuplicateModal : timeSlotDuplicateModal!
    @IBOutlet weak var lblTimeSlot: UILabel!
    
    var delegate : RefreshSelectedTimeSlotDelegate!
    var viewconTroller : UIViewController!
    
    @IBOutlet weak var btnTimeSlot: UIButton!
    
    @IBAction func btnTimeSlotTapped(_ sender: Any) {
        //        delegate.refreshSelectedTS(id: objtimeSlotDuplicateModal.id)
        delegate.refreshSelectedTS(id: "objtimeSlotDuplicateModal.id")
        
    }
    
    func customization()  {
        let fontBook =  UIFont(name: "FontBook".localized(), size: Device.FONTSIZETYPE11)
        
        UILabel.labelUIHandling(label: lblTimeSlot, text: "10:30 AM    -  10:45 AM", textColor: ILColor.color(index: 42), isBold: false, fontType: fontBook)
        
        btnTimeSlot.setImage(UIImage.init(named: "Check_box_selected"), for: .normal)
        
        
        //        if objtimeSlotDuplicateModal.isSelected {
        //
        //            btnTimeSlot.setImage(UIImage.init(named: "Check_box_selected"), for: .normal)
        //        }
        //        else{
        //            btnTimeSlot.setImage(UIImage.init(named: "check_box"), for: .normal)
        //
        //        }
        
    }
    
    func loadView() -> UIView{
        
        let bundle = Bundle(for: type(of: self))
        let nibName = type(of: self).description().components(separatedBy: ".").last!
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as! UIView
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
    }
    
}
