//
//  ERSideMyAppoinmentTableViewCell.swift
//  Appointment
//
//  Created by Anurag Bhakuni on 23/11/20.
//  Copyright © 2020 Anurag Bhakuni. All rights reserved.
//

import UIKit

class ERSideMyAppoinmentTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var viewDateContainer: UIView!
    @IBOutlet weak var lblImageView: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDescribtion: UILabel!
    @IBOutlet weak var lblMonth: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var btnViewDetail: UIButton!
    @IBOutlet weak var btnAccept: UIButton!
    @IBOutlet weak var btnDecline: UIButton!
    
    var results: ERSideAppointmentModalResult!
    @IBOutlet weak var viewContainer: UIView!
    
    
    
    func customize()  {
        self.viewContainer.isHidden = false
        let strHeader = NSMutableAttributedString.init()
        let strHeaderDesc = NSMutableAttributedString.init()
        
        let radius =  (Int)(lblImageView.frame.height)/2
        if let urlImage = URL.init(string: self.results.participants![0].participantImage ) {
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
        
        
        
        if let fontHeavy = UIFont(name: "FontHeavy".localized(), size: Device.FONTSIZETYPE13), let fontBook =  UIFont(name: "FontBook".localized(), size: Device.FONTSIZETYPE14)
            
        {
            let strTiTle = NSAttributedString.init(string: GeneralUtility.optionalHandling(_param: self.results.participants![0].name, _returnType: String.self)
                , attributes: [NSAttributedString.Key.foregroundColor : ILColor.color(index:34),NSAttributedString.Key.font : fontHeavy]);
            let nextLine1 = NSAttributedString.init(string: "\n")
            let strType = NSAttributedString.init(string: GeneralUtility.optionalHandling(_param: self.results.participants![0].benchmarkName, _returnType: String.self)
                , attributes: [NSAttributedString.Key.foregroundColor : ILColor.color(index: 34),NSAttributedString.Key.font : fontBook]);
            let para = NSMutableParagraphStyle.init()
            //            para.alignment = .center
            para.lineSpacing = 4
            strHeader.append(strTiTle)
            strHeader.append(nextLine1)
            strHeader.append(strType)
            strHeader.addAttribute(NSAttributedString.Key.paragraphStyle, value: para, range: NSMakeRange(0, strHeader.length))
            lblName.attributedText = strHeader
        }
        let weekDay = ["Sun","Mon","Tue","Wed","Thu","Fri","Sat"]
        var componentDay = GeneralUtility.dateComponent(date: self.results.startDatetimeUTC!, component: .weekday)
        
        if let fontHeavy = UIFont(name: "FontHeavy".localized(), size: Device.FONTSIZETYPE13), let fontBook =  UIFont(name: "FontBook".localized(), size: Device.FONTSIZETYPE14)
            
        {
            
            let strTiTle = NSAttributedString.init(string: GeneralUtility.optionalHandling(_param: "\(weekDay[(componentDay?.weekday ?? 1) - 1]), " +
                
                GeneralUtility.startAndEndDateDetail2(startDate: self.results.startDatetimeUTC ?? "", endDate: self.results.endDatetimeUTC ?? "")
                
                , _returnType: String.self)
                , attributes: [NSAttributedString.Key.foregroundColor : ILColor.color(index:13),NSAttributedString.Key.font : fontHeavy]);
            let nextLine1 = NSAttributedString.init(string: "\n")
            
            var strLocation = "Not available"
            var zoomLink = false
            
            if let str = self.results?.locations{
                if str.count > 0 {
                    strLocation = (str[0].data?.value) ?? "Not available"
                    
                    if str[0].provider == "zoom_link"{
                        zoomLink = true
                        strLocation = " Zoom"
                    }
                }
                
            }
            
            let image1Attachment = NSTextAttachment()
            image1Attachment.image = UIImage(named: "Zoom")
            image1Attachment.bounds = CGRect.init(x: 0, y: -5, width: 20, height: 20)
            
            
            // wrap the attachment in its own attributed string so we can append it
            let imageZoom = NSAttributedString(attachment: image1Attachment)
            
            
            let strType = NSAttributedString.init(string: GeneralUtility.optionalHandling(_param: strLocation, _returnType: String.self)
                , attributes: [NSAttributedString.Key.foregroundColor : ILColor.color(index: 13),NSAttributedString.Key.font : fontBook]);
            let para = NSMutableParagraphStyle.init()
            //            para.alignment = .center
            para.lineSpacing = 4
            strHeaderDesc.append(strTiTle)
            strHeaderDesc.append(nextLine1)
            if zoomLink{
                strHeaderDesc.append(imageZoom)
                
            }
            strHeaderDesc.append(strType)
            strHeaderDesc.addAttribute(NSAttributedString.Key.paragraphStyle, value: para, range: NSMakeRange(0, strHeaderDesc.length))
            lblDescribtion.attributedText = strHeaderDesc
        }
        
        
        if
            GeneralUtility.optionalHandling(_param: self.results.participants![0].participantImage.isBlank, _returnType: Bool.self)
        {
            
            self.imageView?.isHidden = true
            self.lblImageView.isHidden = false
            let stringImg = GeneralUtility.startNameCharacter(stringName: self.results.participants![0].name ?? " ")
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
            self.imageView?.isHidden = false
        }
        
        let fontHeavy2 = UIFont(name: "FontHeavy".localized(), size: Device.FONTSIZETYPE13)
        UIButton.buttonUIHandling(button: btnViewDetail, text: "View Details", backgroundColor:ILColor.color(index: 23) ,textColor: ILColor.color(index: 3),fontType:fontHeavy2)
        
        UIButton.buttonUIHandling(button: btnAccept, text: "Accept", backgroundColor:UIColor.white ,textColor: ILColor.color(index: 23),borderColor: ILColor.color(index: 23), borderWidth: 1,fontType:fontHeavy2)
        UIButton.buttonUIHandling(button: btnDecline, text: "Decline", backgroundColor:UIColor.white ,textColor: ILColor.color(index: 23),borderColor: ILColor.color(index: 23), borderWidth: 1,fontType:fontHeavy2)
        
        
        btnAccept.cornerRadius = 3
        btnViewDetail.cornerRadius = 3
        btnDecline.cornerRadius = 3
        
        
        
        
        
        let monthI   = ["Jan","Feb","Mar","Apr","May","Jun","July","Aug","Sep","Oct","Nov","Dec"]
        
        shadowWithCorner(viewContainer: self.viewContainer, cornerRadius: 10)
        shadowWithCorner(viewContainer: self.viewDateContainer, cornerRadius: 3)
        viewDateContainer.clipsToBounds = true
        viewDateContainer.backgroundColor = ILColor.color(index: 33)
        var componentDate = GeneralUtility.dateComponent(date: self.results.startDatetimeUTC!, component: .day)
        
        
        if let dayI = componentDate?.day {
            let fontMedium = UIFont(name: "FontHeavy".localized(), size: Device.FONTSIZETYPE15)
            
            UILabel.labelUIHandling(label: lblDate, text: "\(dayI)", textColor:ILColor.color(index: 34) , isBold: false, fontType: fontMedium)
            lblDate.textAlignment = .center
            lblDate.backgroundColor = .white
            
        }
        
        let componentMonth = GeneralUtility.dateComponent(date: self.results.startDatetimeUTC!, component: .month)
        
        if let monthCom = componentMonth?.month {
            let fontMedium = UIFont(name: "FontMedium".localized(), size: Device.FONTSIZETYPE15)
            
            UILabel.labelUIHandling(label: lblMonth, text: "\(monthI[monthCom-1])", textColor:ILColor.color(index: 3) , isBold: false, fontType: fontMedium,backgroundColor: ILColor.color(index: 33))
            lblMonth.textAlignment = .center
            
            
        }
        
        
        self.backgroundColor = .clear
        
    }
    
    
    
    func shadowWithCorner(viewContainer : UIView,cornerRadius: CGFloat)
    {
        // corner radius
        viewContainer.layer.cornerRadius = cornerRadius
        // border
        viewContainer.layer.borderWidth = 1.0
        viewContainer.layer.borderColor = ILColor.color(index: 27).cgColor
        // shadow
        viewContainer.layer.shadowColor = ILColor.color(index: 27).cgColor
        viewContainer.layer.shadowOffset = CGSize(width: 3, height: 3)
        viewContainer.layer.shadowOpacity = 0.7
        viewContainer.layer.shadowRadius = 4.0
    }
    
    
    
    
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
