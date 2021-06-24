//
//  ERSideAppointmentTableViewCell.swift
//  Appointment
//
//  Created by Anurag Bhakuni on 13/11/20.
//  Copyright © 2020 Anurag Bhakuni. All rights reserved.
//

import UIKit

class ERSideAppointmentTableViewCell: UITableViewCell {

    @IBAction func btnViewDetailTapped(_ sender: Any) {
        
        let erSideOHDetail = ERSideOHDetailViewController.init(nibName: "ERSideOHDetailViewController", bundle: nil)
       
//        erSideOHDetail.identifier = self.objERSideAppointmentModalResult?.identifier
        erSideOHDetail.viewControllerType = 1
        erSideOHDetail.delegate = viewControllerI as! ErSideOpenHourTCDelegate
        
        erSideOHDetail.viewControllerI = viewControllerI
        erSideOHDetail.modalPresentationStyle = .overFullScreen
        erSideOHDetail.dateSelected = self.dateSelected
        viewControllerI.navigationController?.pushViewController(erSideOHDetail, animated: false)
    }
    @IBOutlet weak var viewouter: UIView!
    var dateSelected : Date!

    @IBOutlet weak var viewContainer: UIView!
    var viewControllerI : ERSideHomeViewController!
    @IBOutlet weak var lblNoAppoinment: UILabel!
    @IBOutlet weak var btnViewDetail: UIButton!
    
    @IBOutlet weak var lblName: UILabel!
    
    @IBOutlet weak var imgView: UIImageView!
    
    @IBOutlet weak var lblNameInitial: UILabel!
    
    @IBOutlet weak var lblTiming: UILabel!
    
    @IBOutlet weak var lblDot: UILabel!
   
    var objERSideAppointmentModalResult: ERSideAppointmentModalNewResult?

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    func customization(isAppoinment: Bool) {
        let fontMedium =  UIFont(name: "FontMediumWithoutNext".localized(), size: Device.FONTSIZETYPE11)
        
        
        self.viewouter.backgroundColor = ILColor.color(index: 22)
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        self.viewContainer.backgroundColor = .clear

        
        if isAppoinment{
            viewContainer.isHidden =  false
            lblNoAppoinment.isHidden = true
            
            UILabel.labelUIHandling(label: lblDot, text: "",  isBold: false, isCircular: true, backgroundColor: ILColor.color(index: 23), cornerRadius: Int(lblDot.frame.size.width)/2)
            
            self.lblNameInitial.isHidden = false
            self.imgView?.isHidden = true
            
            
            if let fontHeavy = UIFont(name: "FontHeavy".localized(), size: Device.FONTSIZETYPE12)
            {
                
                let stringImg = GeneralUtility.startNameCharacter(stringName: (self.objERSideAppointmentModalResult?.requests![0].studentDetails?.name) ?? " ")
                UILabel.labelUIHandling(label: lblNameInitial, text: stringImg, textColor:ILColor.color(index: 28) , isBold: false, fontType: fontHeavy)
                lblNameInitial.layer.borderColor = UIColor.black.cgColor
                lblNameInitial.layer.borderWidth = 1;
                lblNameInitial.layer.cornerRadius = lblNameInitial.frame.size.height/2
                lblNameInitial.clipsToBounds = true
                lblNameInitial.layer.masksToBounds = true
                
                UILabel.labelUIHandling(label: lblName, text: self.objERSideAppointmentModalResult?.requests![0].studentDetails?.name ?? " ", textColor:ILColor.color(index: 43) , isBold: false, fontType: fontMedium)

            }
            
            UILabel.labelUIHandling(label: lblTiming, text: GeneralUtility.startAndEndDateDetail2(startDate: self.objERSideAppointmentModalResult?.startDatetimeUTC ?? "", endDate: self.objERSideAppointmentModalResult?.endDatetimeUTC ?? "") + " with " , textColor:ILColor.color(index: 43) , isBold: false, fontType: fontMedium)
            UIButton.buttonUIHandling(button: btnViewDetail, text: "View Details", backgroundColor: .clear, textColor: ILColor.color(index: 23),  fontType: fontMedium)
        }
        else{
            
            viewContainer.isHidden = true
            lblNoAppoinment.isHidden = false
            
            UILabel.labelUIHandling(label: lblNoAppoinment, text: "No Appointments available", textColor:ILColor.color(index: 43) , isBold: false, fontType: fontMedium)
        }
        
        
      
        
        
        
        
    }
    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
