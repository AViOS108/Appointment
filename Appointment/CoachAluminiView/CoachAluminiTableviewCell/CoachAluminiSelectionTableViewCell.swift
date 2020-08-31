//
//  CoachAluminiSelectionTableViewCell.swift
//  Appointment
//
//  Created by Anurag Bhakuni on 26/08/20.
//  Copyright © 2020 Anurag Bhakuni. All rights reserved.
//

import UIKit

protocol CoachAluminiSelectionTableViewCellDelegate {
    
        func changeModal(modal:Coach,row:Int )

    
}


class CoachAluminiSelectionTableViewCell: UITableViewCell {
    var delegate : CoachAluminiSelectionTableViewCellDelegate?

    @IBOutlet weak var lblNoCoach: UILabel!
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var btnSelect: UIButton!
    
    @IBAction func btnSelectTapped(_ sender: UIButton) {
        delegate?.changeModal(modal: self.coachModal!, row: self.indexPathRow)
    }
    @IBOutlet weak var nslayoutConstraintImgViewWidth: NSLayoutConstraint!
    
    @IBOutlet weak var nslayoutConstraintHorizontalSpace: NSLayoutConstraint!
    @IBOutlet weak var lblInitial: UILabel!
    
    @IBOutlet weak var imgView: UIImageView!
    
    @IBOutlet weak var lblName: UILabel!
    var coachModal : Coach?
    var indexPathRow : Int!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    func customization(noCoach: Bool,text:String,row: Int)  {
        
        self.indexPathRow = row;
        
        nslayoutConstraintImgViewWidth.constant = 8
        nslayoutConstraintImgViewWidth.constant = 36
        self.imgView.isHidden = false
        self.lblInitial.isHidden = false
        
        if noCoach {
            self.viewContainer.isHidden = true
            self.lblNoCoach.isHidden = false
            
            let fontMedium = UIFont(name: "FontMedium".localized(), size: Device.FONTSIZETYPE16)
            UILabel.labelUIHandling(label: lblNoCoach, text: text, textColor:ILColor.color(index: 28) , isBold: false, fontType: fontMedium)
        }
        else{
            
            self.viewContainer.isHidden = false
            self.lblNoCoach.isHidden = true
            
            
            let strHeader = NSMutableAttributedString.init()
            
            let radius =  (Int)(lblInitial.frame.height)/2
            
            
            if let urlImage = URL.init(string: self.coachModal?.profilePicURL ?? "") {
                self.imgView
                    .setImageWith(urlImage, placeholderImage: UIImage.init(named: "Placeeholderimage"))
                
                self.imgView?.cornerRadius = CGFloat(radius)
                imgView?.clipsToBounds = true
                //                self.imgView.layer.borderColor = UIColor.black.cgColor
                //                self.imgView.layer.borderWidth = 1
                self.imgView?.layer.masksToBounds = true;
            }
            else{
                self.imgView.image = UIImage.init(named: "Placeeholderimage");
                //            self.imgView.contentMode = .scaleAspectFit;
                
            }
            
            if let fontHeavy = UIFont(name: "FontHeavy".localized(), size: Device.FONTSIZETYPE13)
                
            {
                
                UILabel.labelUIHandling(label: lblName, text: self.coachModal!.name, textColor:ILColor.color(index: 28) , isBold: false, fontType: fontHeavy)
                
                
            }
            
            
            if self.coachModal?.profilePicURL == nil ||
                GeneralUtility.optionalHandling(_param: self.coachModal?.profilePicURL?.isBlank, _returnType: Bool.self)
            {
                
                self.imageView?.isHidden = true
                self.lblInitial.isHidden = false
                
                var stringImg = GeneralUtility.startNameCharacter(stringName: self.coachModal?.name ?? " ")
                if let fontMedium = UIFont(name: "FontMedium".localized(), size: Device.FONTSIZETYPE15)
                {
                    
                    UILabel.labelUIHandling(label: lblInitial, text: GeneralUtility.optionalHandling(_param: stringImg, _returnType: String.self), textColor:.black , isBold: false , fontType: fontMedium, isCircular: true,  backgroundColor:.white ,cornerRadius: radius,borderColor:UIColor.black,borderWidth: 1 )
                    lblInitial.textAlignment = .center
                    lblInitial.layer.borderColor = UIColor.black.cgColor
                }
                
                
            }
            else
            {
                self.lblInitial.isHidden = true
                self.imageView?.isHidden = false
                
            }
            
            let fontHeavy2 = UIFont(name: "FontHeavy".localized(), size: Device.FONTSIZETYPE13)
            
            btnSelect.isUserInteractionEnabled = true
            btnSelect.isEnabled = true
            
            if self.coachModal!.isSelected{
                UIButton.buttonUIHandling(button: btnSelect, text: "", backgroundColor:UIColor.clear )
                btnSelect.setImage(UIImage.init(named: "Check_box_selected"), for: .normal)
            }
            else{
                UIButton.buttonUIHandling(button: btnSelect, text: "", backgroundColor:UIColor.clear)
                btnSelect.setImage(UIImage.init(named: "check_box"), for: .normal)
                
            }
            
        }
        
        if row == 0
        {
            nslayoutConstraintImgViewWidth.constant = 0
            nslayoutConstraintImgViewWidth.constant = 0
            self.imgView.isHidden = true
            self.lblInitial.isHidden = true
        }
    }
    
}
