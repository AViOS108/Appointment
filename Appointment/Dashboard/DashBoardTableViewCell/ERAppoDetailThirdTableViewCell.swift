//
//  ERAppoDetailThirdTableViewCell.swift
//  Appointment
//
//  Created by Anurag Bhakuni on 01/04/21.
//  Copyright © 2021 Anurag Bhakuni. All rights reserved.
//

import UIKit

class ERAppoDetailThirdTableViewCell: UITableViewCell {
    @IBOutlet weak var viewContainer: UIView!
    
    @IBOutlet weak var lblCandidateText: UILabel!
    @IBOutlet weak var nslayoutViewRatingHeight: NSLayoutConstraint!
    var viewController : UIViewController!
    var appoinmentDetailModalObj : AppoinmentDetailModalNew?
    var selectedAppointmentModal : ERSideAppointmentModalNewResult!

    @IBOutlet weak var viewRating: UIView!
    @IBOutlet var btnCoachPreciseGrp: [UIButton]!
    
    @IBOutlet weak var btnViewFeedback: UIButton!
    @IBAction func btnViewFeedbackTapped(_ sender: Any) {
        
        let objFeedbackViewController = FeedbackViewController.init(nibName: "FeedbackViewController", bundle: nil)
        objFeedbackViewController.delegate = viewController as? feedbackViewControllerDelegate
        objFeedbackViewController.selectedAppointmentModal = self.selectedAppointmentModal;
        objFeedbackViewController.appoinmentDetailModalObj = self.appoinmentDetailModalObj
        objFeedbackViewController.modalPresentationStyle = .overFullScreen
        viewController.navigationController?.pushViewController(objFeedbackViewController, animated: false)
    }
    
    @IBAction func btnCoachPreTapped(_ sender: UIButton) {
        //        coach_expertise = sender.tag
//        self.btnCoachPreciseGrp.forEach { (btn) in
//            if btn.tag <= sender.tag{
//                btn.setImage(UIImage.init(named: "noun_Star_select"), for: .normal)
//            }
//            else{
//                btn.setImage(UIImage.init(named: "noun_Star_nonselect"), for: .normal)
//            }
//        }
        
    }
    
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
        viewContainer.backgroundColor = .white
    }
    func customization(){
        
        
        let isStudent = UserDefaultsDataSource(key: "student").readData() as? Bool
        
        var feedbackText = ""
        
        if isStudent ?? false {
            
            
            btnViewFeedback.isHidden = false
            let fontHeavy = UIFont(name: "FontHeavy".localized(), size: Device.FONTSIZETYPE12)

            UIButton.buttonUIHandling(button: btnViewFeedback, text: "View Feedback", backgroundColor: .clear, textColor: ILColor.color(index: 23), fontType: fontHeavy)
            
            feedbackText = "Feedback"
        }
        else
        {
            feedbackText = "Candidate’s Feedback"
            btnViewFeedback.isHidden = true
        }
        
        
        
        let fontHeavy = UIFont(name: "FontHeavy".localized(), size: Device.FONTSIZETYPE13)
        UILabel.labelUIHandling(label: lblCandidateText, text: feedbackText, textColor: ILColor.color(index: 34), isBold: false, fontType: fontHeavy)
        self.viewRating.backgroundColor = .white
        if self.appoinmentDetailModalObj?.requests?.count ?? 0 > 0{
            if self.appoinmentDetailModalObj?.requests?[0].feedback != nil{
                let rating : Int = Int(self.appoinmentDetailModalObj?.requests?[0].feedback?.averageRating?.rounded() ?? 0)
                self.btnCoachPreciseGrp.forEach { (btn) in
                    if btn.tag > rating{
                        btn.setImage(UIImage.init(named: "noun_Star_nonselect"), for: .normal)
                    }
                    else{
                        btn.setImage(UIImage.init(named: "noun_Star_select"), for: .normal)

                    }
                    
                }
                
            }
            else{
                self.btnCoachPreciseGrp.forEach { (btn) in
                    btn.setImage(UIImage.init(named: "noun_Star_nonselect"), for: .normal)
                }
            }
        }
        else{
            self.btnCoachPreciseGrp.forEach { (btn) in
                btn.setImage(UIImage.init(named: "noun_Star_nonselect"), for: .normal)
            }
        }
       
        self.shadowWithCorner(viewContainer: viewContainer, cornerRadius: 10)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
