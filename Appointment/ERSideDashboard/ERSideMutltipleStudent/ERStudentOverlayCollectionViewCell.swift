//
//  ERStudentOverlayCollectionViewCell.swift
//  Appointment
//
//  Created by Anurag Bhakuni on 31/03/21.
//  Copyright © 2021 Anurag Bhakuni. All rights reserved.
//

import UIKit

class ERStudentOverlayCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var lblInitial: UILabel!
    @IBOutlet weak var viewImage: UIImageView!
    var studentModal : StudentDetails!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
        
    
    func customize(viewCollectinView : UICollectionView)  {
      
        let strHeader = NSMutableAttributedString.init()
        lblInitial.layoutIfNeeded()
        let radius =  (Int)(lblInitial.frame.height)/2
//        if let urlImage = URL.init(string: self.coachModal?.profilePicURL ?? "") {
//            self.viewImage
//                .setImageWith(urlImage, placeholderImage: UIImage.init(named: "Placeeholderimage"))
//
//            self.viewImage?.cornerRadius = CGFloat(radius)
//            viewImage?.clipsToBounds = true
//            //                self.imgView.layer.borderColor = UIColor.black.cgColor
//            //                self.imgView.layer.borderWidth = 1
//            self.viewImage?.layer.masksToBounds = true;
//        }
//        else{
//            self.viewImage.image = UIImage.init(named: "Placeeholderimage");
//            //            self.imgView.contentMode = .scaleAspectFit;
//
//        }
        let stringImg = GeneralUtility.startNameCharacter(stringName: self.studentModal.name ?? "")

        if let fontHeavy = UIFont(name: "FontHeavy".localized(), size: Device.FONTSIZETYPE13)
        {
            UILabel.labelUIHandling(label: lblInitial, text: stringImg, textColor:ILColor.color(index: 28) , isBold: false, fontType: fontHeavy)
            lblInitial.layer.borderColor = UIColor.black.cgColor
            lblInitial.layer.borderWidth = 1;
            lblInitial.layer.cornerRadius = lblInitial.frame.size.height/2
            lblInitial.clipsToBounds = true
            lblInitial.layer.masksToBounds = true
            lblInitial.backgroundColor = .white
        }
        
        self.viewImage?.isHidden = true
        self.lblInitial.isHidden = false
        
//        if self.coachModal?.profilePicURL == nil ||
//            GeneralUtility.optionalHandling(_param: self.coachModal?.profilePicURL?.isBlank, _returnType: Bool.self)
//        {
//            self.viewImage?.isHidden = true
//            self.lblInitial.isHidden = false
//
//            var stringImg = GeneralUtility.startNameCharacter(stringName: self.coachModal?.name ?? " ")
//            if let fontMedium = UIFont(name: "FontMedium".localized(), size: Device.FONTSIZETYPE15)
//            {
//                UILabel.labelUIHandling(label: lblInitial, text: GeneralUtility.optionalHandling(_param: stringImg, _returnType: String.self), textColor:.black , isBold: false , fontType: fontMedium, isCircular: true,  backgroundColor:.white ,cornerRadius: radius,borderColor:UIColor.black,borderWidth: 1 )
//                lblInitial.textAlignment = .center
//                lblInitial.layer.borderColor = UIColor.black.cgColor
//            }
//        }
//        else
//        {
//            self.lblInitial.isHidden = true
//            self.viewImage?.isHidden = false
//
//        }
        

    }
}