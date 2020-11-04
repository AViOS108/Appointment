//
//  NextStepAppointmentTableViewCell.swift
//  Appointment
//
//  Created by Anurag Bhakuni on 25/09/20.
//  Copyright © 2020 Anurag Bhakuni. All rights reserved.
//

import UIKit

class NextStepAppointmentTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nextStepCollectionView: NextStepCollectionView!
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var lblNextStepHeader: UILabel!
    var viewController : UIViewController!
    var nextModalObj : [NextStepModal]?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
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
     
    
    func customization()  {
        self.backgroundColor = .clear

        let fontHeavy = UIFont(name: "FontHeavy".localized(), size: Device.FONTSIZETYPE14)
        UILabel.labelUIHandling(label: lblNextStepHeader, text: "Next steps", textColor: ILColor.color(index: 34), isBold: false,fontType: fontHeavy)

        nextStepCollectionView.register(UINib.init(nibName: "NextStepCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "NextStepCollectionViewCell")
        nextStepCollectionView.viewController = viewController
        nextStepCollectionView.nextModalObj = self.nextModalObj
        nextStepCollectionView.customize()
        self.viewContainer.backgroundColor = .white
       self.shadowWithCorner(viewContainer: viewContainer, cornerRadius: 3)
    }
    
    
    
    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
