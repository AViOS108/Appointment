//
//  ERSideTimeSlotDuplicate.swift
//  Appointment
//
//  Created by Anurag Bhakuni on 03/03/21.
//  Copyright © 2021 Anurag Bhakuni. All rights reserved.
//

import UIKit


protocol RefreshSelectedTimeSlotDelegate {
    func refreshSelectedTS(id:Int,isSelected: Bool)
}

class ERSideTimeSlotDuplicate: UIView {
    
    var objtimeSlotDuplicateModal : timeSlotDuplicateModal!
    @IBOutlet weak var lblTimeSlot: UILabel!
    var objStudentListType : StudentListType?
    var delegate : RefreshSelectedTimeSlotDelegate!
    var viewconTroller : UIViewController!
    
    @IBOutlet weak var btnTimeSlot: UIButton!
    
    @IBAction func btnTimeSlotTapped(_ sender: Any) {
        delegate.refreshSelectedTS(id: objtimeSlotDuplicateModal.id, isSelected: !objtimeSlotDuplicateModal.isSelected);
        
        switch  self.objStudentListType {
        case .groupType:
            
            if objtimeSlotDuplicateModal.isSelected {
                btnTimeSlot.setImage(UIImage.init(named: "Check_box_selected"), for: .normal);
            }
            else{
                btnTimeSlot.setImage(UIImage.init(named: "check_box"), for: .normal);
            }
            
            break
            
        case .One2OneType:
            if objtimeSlotDuplicateModal.isSelected {
                btnTimeSlot.setImage(UIImage.init(named: "Radio_filled"), for: .normal);
            }
            else{
                btnTimeSlot.setImage(UIImage.init(named: "Radio"), for: .normal);
            }
            
            break
            
        default:
            break
        }
        
    }
    
    func customization()  {
        let fontBook =  UIFont(name: "FontBook".localized(), size: Device.FONTSIZETYPE11)
        
        UILabel.labelUIHandling(label: lblTimeSlot, text:  objtimeSlotDuplicateModal.timeStart + "-" + objtimeSlotDuplicateModal.timeEnd, textColor: ILColor.color(index: 42), isBold: false, fontType: fontBook)
        
        switch  self.objStudentListType {
        case .groupType:
            
            if objtimeSlotDuplicateModal.isSelected {
                btnTimeSlot.setImage(UIImage.init(named: "Check_box_selected"), for: .normal);
            }
            else{
                btnTimeSlot.setImage(UIImage.init(named: "check_box"), for: .normal);
            }
            
            break
            
        case .One2OneType:
            if objtimeSlotDuplicateModal.isSelected {
                btnTimeSlot.setImage(UIImage.init(named: "Radio_filled"), for: .normal);
            }
            else{
                btnTimeSlot.setImage(UIImage.init(named: "Radio"), for: .normal);
            }
            
            break
            
        default:
            break
        }
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
