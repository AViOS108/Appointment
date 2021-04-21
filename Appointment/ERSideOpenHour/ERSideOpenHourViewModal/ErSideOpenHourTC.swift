//
//  ErSideOpenHourTC.swift
//  Appointment
//
//  Created by Anurag Bhakuni on 26/11/20.
//  Copyright © 2020 Anurag Bhakuni. All rights reserved.
//

import UIKit


protocol ErSideOpenHourTCDelegate {
    
    func deleteDelgateRefresh()
    
}



class ErSideOpenHourTC: UITableViewCell {
    @IBOutlet weak var lblTiming: UILabel!
    
    @IBOutlet weak var btnCross: UIButton!
    
    var delegate :  ErSideOpenHourTCDelegate!;
    
    var viewController : UIViewController!;
    
    
    
    
    
    @IBAction func btnCrossTapped(_ sender: Any) {
        
        let erSideOHDetail = ERSideOHDetailViewController.init(nibName: "ERSideOHDetailViewController", bundle: nil)
        erSideOHDetail.identifier = results?.identifier
        erSideOHDetail.viewControllerType = 0
        erSideOHDetail.delegate = viewController as! ErSideOpenHourTCDelegate
        erSideOHDetail.viewControllerI = viewController
        erSideOHDetail.modalPresentationStyle = .overFullScreen
//        erSideOHDetail.dateSelected = self.dateSelected
        viewController.navigationController?.pushViewController(erSideOHDetail, animated: false)
        
        
     
    }
    
    var results: ResultERSideOPenHourModal?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBOutlet weak var viewContainer: UIView!
    
    func customize()  {
        if let fontMedium = UIFont(name: "FontMedium".localized(), size: Device.FONTSIZETYPE13), let fontheavy = UIFont(name: "FontHeavy".localized(), size: Device.FONTSIZETYPE14)
        {
            UILabel.labelUIHandling(label: lblTiming, text: GeneralUtility.currentDateDetailType3(emiDate: (results?.startDatetimeUTC)!) + " - " + GeneralUtility.currentDateDetailType3(emiDate: (results?.endDatetimeUTC)!), textColor:ILColor.color(index: 29) , isBold: false , fontType: fontheavy,   backgroundColor:.clear )
            
            
        }
        btnCross.setImage(UIImage.init(named: "crossDeletion"), for: .normal)
        viewContainer.backgroundColor = ILColor.color(index: 30)
        viewContainer.dropShadowER()
        
    }
    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
