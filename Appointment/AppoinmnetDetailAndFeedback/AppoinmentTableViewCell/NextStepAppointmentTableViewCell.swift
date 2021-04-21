//
//  NextStepAppointmentTableViewCell.swift
//  Appointment
//
//  Created by Anurag Bhakuni on 25/09/20.
//  Copyright © 2020 Anurag Bhakuni. All rights reserved.
//

import UIKit

enum nextStepViewType {
    case studentType
    case erType
}

class NextStepAppointmentTableViewCell: UITableViewCell {
    var objNextStepViewType : nextStepViewType!

    @IBAction func btnAddNextStepTapped(_ sender: Any) {
    }
    @IBOutlet weak var btnAddNextStep: UIButton!
    @IBOutlet weak var nextStepCollectionView: NextStepCollectionView!
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var lblNextStepHeader: UILabel!
    var viewController : UIViewController!
    var nextModalObj : [NextStepModalNew]?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
   
    
    func customization()  {
        self.backgroundColor = .clear

        let fontHeavy = UIFont(name: "FontHeavy".localized(), size: Device.FONTSIZETYPE14)
        UILabel.labelUIHandling(label: lblNextStepHeader, text: "Next steps", textColor: ILColor.color(index: 34), isBold: false,fontType: fontHeavy)

        nextStepCollectionView.register(UINib.init(nibName: "NextStepCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "NextStepCollectionViewCell")
        nextStepCollectionView.viewController = viewController
        nextStepCollectionView.nextModalObj = self.nextModalObj
        nextStepCollectionView.objNextStepViewType = self.objNextStepViewType
        nextStepCollectionView.customize()
        self.viewContainer.backgroundColor = .clear
        
        UIButton.buttonUIHandling(button: btnAddNextStep, text: "Add Next Steps", backgroundColor: .clear, textColor: ILColor.color(index: 23))

//       self.shadowWithCorner(viewContainer: viewContainer, cornerRadius: 3)
    }
    
    
    
    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
