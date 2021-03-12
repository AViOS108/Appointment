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
    
    
    func deleteApi(){
        
       var activityIndicator = ActivityIndicatorView.showActivity(view: viewController.view, message: StringConstants.DeletingOpenHour)
        let param = [
            "_method" : "delete",
            "csrf_token" : UserDefaultsDataSource(key: "csrf_token").readData() as! String
            
            ] as Dictionary<String, AnyObject>
        
        ERSideOpenHourDetailVM().OpenHourDelete(param: param, id: (results?.identifier)!
            , { (data) in
                activityIndicator.hide()

                CommonFunctions().showError(title: "", message: "successfully deleted !!!")
                self.delegate.deleteDelgateRefresh()
        }) { (error, errorCode) in
            activityIndicator.hide()
        }
    }
    
    
    @IBAction func btnCrossTapped(_ sender: Any) {
        let alert = UIAlertController(title: "", message: "Are you sure you want to delete?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { action in
        }))
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
            self.deleteApi();
            
        }))
        viewController.present(alert, animated: true, completion: nil)
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
