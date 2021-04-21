//
//  ERSideSpecificUserTableViewCell.swift
//  Appointment
//
//  Created by Anurag Bhakuni on 20/04/21.
//  Copyright © 2021 Anurag Bhakuni. All rights reserved.
//

import UIKit


protocol ERSideSpecificUserTableViewCellDelegate {
    func specificUserSelected(items: ERSideNotesSpecificUserModalItem)
}


class ERSideSpecificUserTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var viewSeperator: UIView!
    var delegateI : ERSideSpecificUserTableViewCellDelegate!
    
    @IBOutlet weak var viewContainer: UIView!
    
    @IBOutlet weak var lblNameInitial: UILabel!
    
    @IBOutlet weak var imageNameInitial: UIImageView!
    
    @IBOutlet weak var lblStudentName: UILabel!
    
    @IBOutlet weak var btnSelect: UIButton!
    
    @IBAction func btnSelectTapped(_ sender: Any) {
        
        isSelectedStudent = !isSelectedStudent
        if isSelectedStudent {
            btnSelect.setImage(UIImage.init(named: "Check_box_selected"), for: .normal);
        }
        else{
            btnSelect.setImage(UIImage.init(named: "check_box"), for: .normal);
        }
        delegateI.specificUserSelected(items: self.items!)
    }
    
    var items: ERSideNotesSpecificUserModalItem?
    
    var isSelectedStudent : Bool = false
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    func customization()  {
        
        viewSeperator.backgroundColor = ILColor.color(index: 54)
        lblNameInitial.layoutIfNeeded()
        let radius =  (lblNameInitial.frame.height)/2
        lblNameInitial.textAlignment = .center
        let fontHeavy = UIFont(name: "FontHeavy".localized(), size: Device.FONTSIZETYPE13)
        imageNameInitial.isHidden = true;
        isSelectedStudent = self.items?.isSelected ?? false
        let stringImg = GeneralUtility.startNameCharacter(stringName: (items?.name ?? ""))
        
        if let fontHeavy = UIFont(name: "FontHeavy".localized(), size: Device.FONTSIZETYPE13)
        {
            UILabel.labelUIHandling(label: lblNameInitial, text: stringImg, textColor:ILColor.color(index: 28) , isBold: false, fontType: fontHeavy)
            lblNameInitial.layer.borderColor = UIColor.black.cgColor
            lblNameInitial.layer.borderWidth = 1;
            lblNameInitial.layer.cornerRadius = radius
            lblNameInitial.clipsToBounds = true
            lblNameInitial.layer.masksToBounds = true
        }
        
        let fontBook =  UIFont(name: "FontBook".localized(), size: Device.FONTSIZETYPE14)
        
        let coachText = (items?.name ?? "")
        let strHeader = NSMutableAttributedString.init()
        
        let strTiTle = NSAttributedString.init(string: GeneralUtility.optionalHandling(_param: coachText, _returnType: String.self)
            , attributes: [NSAttributedString.Key.foregroundColor : ILColor.color(index:13),NSAttributedString.Key.font : fontHeavy]);
        let nextLine1 = NSAttributedString.init(string: "\n")
        let para = NSMutableParagraphStyle.init()
//        para.alignment = .center
        para.lineSpacing = 1
        strHeader.append(strTiTle)
        strHeader.addAttribute(NSAttributedString.Key.paragraphStyle, value: para, range: NSMakeRange(0, strHeader.length))
        lblStudentName.attributedText = strHeader
        
        if isSelectedStudent {
            btnSelect.setImage(UIImage.init(named: "Check_box_selected"), for: .normal);
        }
        else{
            btnSelect.setImage(UIImage.init(named: "check_box"), for: .normal);
        }
    }
    
}
