//
//  ERAppoDetailThirdTableViewCell.swift
//  Appointment
//
//  Created by Anurag Bhakuni on 01/04/21.
//  Copyright © 2021 Anurag Bhakuni. All rights reserved.
//

import UIKit

class ERAppoDetailThirdTableViewCell: UITableViewCell {

    @IBOutlet weak var lblCandidateText: UILabel!
    @IBOutlet weak var nslayoutViewRatingHeight: NSLayoutConstraint!
    var viewController : UIViewController!
    var appoinmentDetailModalObj : AppoinmentDetailModalNew?

    @IBOutlet weak var viewRating: UIView!
    @IBOutlet var btnCoachPreciseGrp: [UIButton]!
        @IBAction func btnCoachPreTapped(_ sender: UIButton) {
    //        coach_expertise = sender.tag
            self.btnCoachPreciseGrp.forEach { (btn) in
                
                if btn.tag <= sender.tag{
                    btn.setImage(UIImage.init(named: "noun_Star_select"), for: .normal)
                }
                else{
                    btn.setImage(UIImage.init(named: "noun_Star_nonselect"), for: .normal)
                }
                
            }
            
        }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func customization(){
        let fontHeavy = UIFont(name: "FontHeavy".localized(), size: Device.FONTSIZETYPE13)
        UILabel.labelUIHandling(label: lblCandidateText, text: "Candidate’s Feedback", textColor: ILColor.color(index: 34), isBold: false, fontType: fontHeavy)
        self.viewRating.backgroundColor = .white
        self.btnCoachPreciseGrp.forEach { (btn) in
                      btn.setImage(UIImage.init(named: "noun_Star_nonselect"), for: .normal)
                  }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
