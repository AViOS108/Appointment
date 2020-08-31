//
//  CoachImageOverlayCiCollectionViewCell.swift
//  Appointment
//
//  Created by Anurag Bhakuni on 28/08/20.
//  Copyright © 2020 Anurag Bhakuni. All rights reserved.
//

import UIKit

class CoachImageOverlayCiCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var lblInitial: UILabel!
    @IBOutlet weak var viewImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    func customize()  {
        viewImage.isHidden = true
        lblInitial.text = "A"
        lblInitial.layer.borderColor = UIColor.red.cgColor
        lblInitial.layer.borderWidth = 1;
        lblInitial.layer.cornerRadius = lblInitial.frame.size.height/2
        lblInitial.clipsToBounds = true
        lblInitial.layer.masksToBounds = true
    }

}

