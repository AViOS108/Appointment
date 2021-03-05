//
//  NextStepCollectionViewCell.swift
//  Appointment
//
//  Created by Anurag Bhakuni on 25/09/20.
//  Copyright © 2020 Anurag Bhakuni. All rights reserved.
//

import UIKit

class NextStepCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var lblNoNextSteps: UILabel!
    @IBOutlet weak var viewContainer: UIView!
    var nextModalObj : NextStepModal?

    @IBOutlet weak var lblDate: UILabel!
    
    @IBOutlet weak var lblDueDate: UILabel!
    
    @IBOutlet weak var lblDescription: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
       
        // Initialization code
    }
    func customization(isNextStep: Bool)  {
        
        if isNextStep {
            let fontBook =  UIFont(name: "FontBook".localized(), size: Device.FONTSIZETYPE14)
            UILabel.labelUIHandling(label: lblNoNextSteps, text: "Not Available !!!", textColor: ILColor.color(index: 39), isBold: false, fontType: fontBook)
            viewContainer.isHidden = true
            lblNoNextSteps.isHidden = false

        }
        else{
            
            lblNoNextSteps.isHidden = true
            viewContainer.isHidden = false
            
            
            let weekDay = ["Sun","Mon","Tue","Wed","Thu","Fri","Sat"]
            let componentDay = GeneralUtility.dateComponent(date: self.nextModalObj?.createdAt ?? "", component: .weekday)
            let date =
                GeneralUtility.currentDateDetailType4(emiDate: self.nextModalObj?.createdAt ?? "", fromDateF: "yyyy-MM-dd HH:mm:ss", toDateFormate: "dd MMM yyyy")
                
               
            let timeText = "\(weekDay[(componentDay?.weekday ?? 1) - 1]), " + date;
            let fontMedium =  UIFont(name: "FontMediumWithoutNext".localized(), size: Device.FONTSIZETYPE10)
            let fontBook =  UIFont(name: "FontBook".localized(), size: Device.FONTSIZETYPE14)
            UILabel.labelUIHandling(label: lblDate, text: timeText, textColor: ILColor.color(index: 38), isBold: false, fontType: fontMedium)
            
            let componentDueDay = GeneralUtility.dateComponent(date: self.nextModalObj?.dueDatetime ?? "", component: .weekday)
            let dueDate =  GeneralUtility.currentDateDetailType4(emiDate: self.nextModalObj?.dueDatetime ?? "", fromDateF: "yyyy-MM-dd HH:mm:ss", toDateFormate: "dd MMM yyyy")
           
         
            
            let duetTimeText = "Due Date:" + "\(weekDay[(componentDueDay?.weekday ?? 1) - 1]), " + dueDate;
            let fontHeavy = UIFont(name: "FontHeavy".localized(), size: Device.FONTSIZETYPE10)

            UILabel.labelUIHandling(label: lblDueDate, text: duetTimeText, textColor: ILColor.color(index: 38), isBold: false, fontType: fontHeavy)
            UILabel.labelUIHandling(label: lblDescription, text: self.nextModalObj?.data ?? "", textColor: ILColor.color(index: 38), isBold: false, fontType: fontBook)
            
        }
        
    }
    

}
