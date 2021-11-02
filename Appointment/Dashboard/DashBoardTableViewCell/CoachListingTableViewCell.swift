//
//  CoachListingTableViewCell.swift
//  Appointment
//
//  Created by Anurag Bhakuni on 18/08/20.
//  Copyright © 2020 Anurag Bhakuni. All rights reserved.
//

import UIKit
import AFNetworking

 
protocol CoachListingTableViewCellDelegate {
    func changeModal(modal:Item,seemore : Bool )
    func scheduleAppoinment(modal:Item)
}


class cutomeTextView : UITextView{
    
    open override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return false
    }
    
    
    override var canBecomeFirstResponder: Bool{
        return false
    }
}






class CoachListingTableViewCell: UITableViewCell,UITextViewDelegate {
    
    @IBOutlet var txtView: cutomeTextView!

    
    @IBOutlet weak var lblImageView: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    
    @IBOutlet weak var lblNoCoach: UILabel!
    @IBOutlet weak var lblDescribtion: UILabel!
    
    @IBOutlet weak var btnSelect: UIButton!
    
    var delegate : CoachListingTableViewCellDelegate?
    
    @IBOutlet weak var BtnAppointment: UIButton!
    
    @IBOutlet weak var viewContainer: UIView!
    
    var coachModal : Item?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    func customization(noCoach: Bool,text:String)  {
        
        if noCoach {
            self.viewContainer.isHidden = true
            self.lblNoCoach.isHidden = false
            
            let fontMedium = UIFont(name: "FontMedium".localized(), size: Device.FONTSIZETYPE16)
            UILabel.labelUIHandling(label: lblNoCoach, text: text, textColor:ILColor.color(index: 28) , isBold: false, fontType: fontMedium)
                        }
        else{
            
            self.viewContainer.isHidden = false
            
            
            let strHeader = NSMutableAttributedString.init()
            
            let radius =  (Int)(lblImageView.frame.height)/2
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
            
            textViewKYC()
            
            
            if self.coachModal?.profilePicURL == nil ||
                GeneralUtility.optionalHandling(_param: self.coachModal?.profilePicURL?.isBlank, _returnType: Bool.self)
            {
                
                self.imgView?.isHidden = true
                self.lblImageView.isHidden = false
                
                let stringImg = GeneralUtility.startNameCharacter(stringName: self.coachModal?.name ?? " ")
                if let fontMedium = UIFont(name: "FontMedium".localized(), size: Device.FONTSIZETYPE15)
                {
                    
                    UILabel.labelUIHandling(label: lblImageView, text: GeneralUtility.optionalHandling(_param: stringImg, _returnType: String.self), textColor:.black , isBold: false , fontType: fontMedium, isCircular: true,  backgroundColor:.white ,cornerRadius: radius,borderColor:UIColor.black,borderWidth: 1 )
                    lblImageView.textAlignment = .center
                    lblImageView.layer.borderColor = UIColor.black.cgColor
                }
                
                
            }
            else
            {
                self.lblImageView.isHidden = true
                self.imgView?.isHidden = false
                
            }
            
            let fontHeavy2 = UIFont(name: "FontHeavy".localized(), size: Device.FONTSIZETYPE13)
            UIButton.buttonUIHandling(button: BtnAppointment, text: "Schedule an appointment", backgroundColor:UIColor.clear ,textColor: ILColor.color(index: 23),fontType:fontHeavy2)
            
            btnSelect.isUserInteractionEnabled = true
            btnSelect.isEnabled = true

            BtnAppointment.isUserInteractionEnabled = false
            BtnAppointment.isEnabled = false

            
            if self.coachModal!.isSelected{
                UIButton.buttonUIHandling(button: btnSelect, text: "", backgroundColor:UIColor.clear )
                btnSelect.setImage(UIImage.init(named: "Check_box_selected"), for: .normal)
            }
            else{
                UIButton.buttonUIHandling(button: btnSelect, text: "", backgroundColor:UIColor.clear)
                btnSelect.setImage(UIImage.init(named: "check_box"), for: .normal)
                
            }
            
            
            // corner radius
            viewContainer.layer.cornerRadius = 10
            
            // border
            viewContainer.layer.borderWidth = 1.0
            viewContainer.layer.borderColor = ILColor.color(index: 27).cgColor
            
            // shadow
            viewContainer.layer.shadowColor = ILColor.color(index: 27).cgColor
            viewContainer.layer.shadowOffset = CGSize(width: 3, height: 3)
            viewContainer.layer.shadowOpacity = 0.7
            viewContainer.layer.shadowRadius = 4.0
        }
        
    }
    
    
    
    func textViewKYC()  {
        
        
        let strHeader = NSMutableAttributedString.init()
        
        if let fontHeavy = UIFont(name: "FontHeavy".localized(), size: Device.FONTSIZETYPE13), let fontBook =  UIFont(name: "FontBook".localized(), size: Device.FONTSIZETYPE14)
            
        {
            let strTiTle = NSAttributedString.init(string: GeneralUtility.optionalHandling(_param: self.coachModal?.name, _returnType: String.self)
                , attributes: [NSAttributedString.Key.foregroundColor : ILColor.color(index:13),NSAttributedString.Key.font : fontHeavy]);
            let nextLine1 = NSAttributedString.init(string: "\n")
            
            var roles = ""
            var index = 0
            for role in self.coachModal!.roles{
                roles.append(role.displayName ?? "")
                index = index + 1;
                if self.coachModal!.roles.count > 1{
                    if index == self.coachModal?.roles.count{
                    }
                    else{
                        roles.append(", ")
                    }
                }
            }
           
            let strType = NSAttributedString.init(string: GeneralUtility.optionalHandling(_param: roles, _returnType: String.self)
                , attributes: [NSAttributedString.Key.foregroundColor : ILColor.color(index: 13),NSAttributedString.Key.font : fontBook]);
            var description = self.coachModal?.coachInfo.summary
            
            
            if self.coachModal?.coachInfo.summary?.count ?? 0 > 100 {
                
                if self.coachModal?.isSeeMoreSelected == true {
                   
                }
                else{
                    if self.coachModal?.coachInfo.summary?.count ?? 0 > 100 {
                        description = String(self.coachModal?.coachInfo.summary?.prefix(100) ?? "")
                    }
                }
            }
            
            
            let strDesc = NSAttributedString.init(string: GeneralUtility.optionalHandling(_param:description , _returnType: String.self)
                , attributes: [NSAttributedString.Key.foregroundColor : ILColor.color(index: 13),NSAttributedString.Key.font : fontBook]);
            
            let strMore = NSAttributedString.init(string: GeneralUtility.optionalHandling(_param:" see more" , _returnType: String.self)
                , attributes: [NSAttributedString.Key.foregroundColor : ILColor.color(index: 23),NSAttributedString.Key.font : fontBook]);

            let strLess = NSAttributedString.init(string: GeneralUtility.optionalHandling(_param:" see less" , _returnType: String.self)
                                                  , attributes: [NSAttributedString.Key.foregroundColor : ILColor.color(index: 23),NSAttributedString.Key.font : fontBook,  ]);
            
            let para = NSMutableParagraphStyle.init()
            //            para.alignment = .center
            para.lineSpacing = 4
            
            strHeader.append(strTiTle)
            
            strHeader.append(nextLine1)
            strHeader.append(strType)
            
            if GeneralUtility.optionalHandling(_param: self.coachModal?.coachInfo.summary, _returnType: String.self) != ""{
                strHeader.append(nextLine1)
                strHeader.append(strDesc)
                
            }
            if self.coachModal?.coachInfo.summary?.count ?? 0 > 100 {
                
                if self.coachModal?.isSeeMoreSelected == true {
                    strHeader.append(strLess)
                    var targetRange = NSMakeRange(strTiTle.length + nextLine1.length + strType.length + nextLine1.length + strDesc.length , strLess.length);
                    strHeader.addAttribute(NSAttributedString.Key.link, value: NSURL(string: "") as Any, range: targetRange)

                    
                    strHeader.addAttribute(NSAttributedString.Key.paragraphStyle, value: para, range: NSMakeRange(0, strHeader.length))
                    
                }
                else{
                    strHeader.append(strMore)
                    var targetRange = NSMakeRange(strTiTle.length + nextLine1.length + strType.length + nextLine1.length + strDesc.length , strMore.length);
                    strHeader.addAttribute(NSAttributedString.Key.link, value: NSURL(string: "") as Any, range: targetRange)

                    
                    strHeader.addAttribute(NSAttributedString.Key.paragraphStyle, value: para, range: NSMakeRange(0, strHeader.length))

                }
            }
          

            
            txtView.attributedText = strHeader
            txtView.delegate = self;
            txtView.isUserInteractionEnabled = true
            txtView.isEditable = false
            txtView.isSelectable = true

            
        }
        
      
    }
    
    
    public func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool
    {
        if self.coachModal?.coachInfo.summary?.count ?? 0 > 100 {
            
            if self.coachModal?.isSeeMoreSelected == true {
                delegate?.changeModal(modal: self.coachModal!, seemore: true)

            }
            else{
                delegate?.changeModal(modal: self.coachModal!, seemore: true)

            }
        }

        return true
    }
    
   
    
    @IBAction func coachSelectedTapped(_ sender: Any) {
        delegate?.changeModal(modal: self.coachModal!, seemore: false)
    }
    @IBAction func scheduleAppointmentTapped(_ sender: Any) {
        delegate?.scheduleAppoinment(modal: self.coachModal!)
    }
}
