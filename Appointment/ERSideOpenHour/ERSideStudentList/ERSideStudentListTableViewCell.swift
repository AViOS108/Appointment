//
//  ERSideStudentListTableViewCell.swift
//  Appointment
//
//  Created by Anurag Bhakuni on 15/12/20.
//  Copyright © 2020 Anurag Bhakuni. All rights reserved.
//

import UIKit


protocol ERSideStudentListTableViewCellDelegate {
    func studentSelected(items: StudentDetailModalItem,isSelectedStudent: Bool)
}


class ERSideStudentListTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var viewSeperator: UIView!
    var delegateI : ERSideStudentListTableViewCellDelegate!
    
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
        delegateI.studentSelected(items: self.items!, isSelectedStudent: isSelectedStudent)
    }
    
    var items: StudentDetailModalItem?
    
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
        let stringImg = GeneralUtility.startNameCharacter(stringName: (items?.firstName ?? "") + (items?.lastName ?? ""))
        
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
        
        let coachText = (items?.firstName ?? "") + (items?.lastName ?? "")
        let coachType = items?.benchmark?.name
        
        let strHeader = NSMutableAttributedString.init()
        
        let strTiTle = NSAttributedString.init(string: GeneralUtility.optionalHandling(_param: coachText, _returnType: String.self)
            , attributes: [NSAttributedString.Key.foregroundColor : ILColor.color(index:13),NSAttributedString.Key.font : fontHeavy]);
        let nextLine1 = NSAttributedString.init(string: "\n")
        let strType = NSAttributedString.init(string: GeneralUtility.optionalHandling(_param: coachType, _returnType: String.self)
            , attributes: [NSAttributedString.Key.foregroundColor : ILColor.color(index: 13),NSAttributedString.Key.font : fontBook]);
        let para = NSMutableParagraphStyle.init()
//        para.alignment = .center
        para.lineSpacing = 1
        strHeader.append(strTiTle)
        strHeader.append(nextLine1)
        strHeader.append(strType)
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
