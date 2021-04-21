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
    var nextModalObj : NextStepModalNew?
    var objNextStepViewType : nextStepViewType!

    @IBOutlet weak var lblDate: UILabel!
    
    @IBAction func btnCompletionStatusTapped(_ sender: Any) {
    }
    @IBOutlet weak var btnCompletionStatus: UIButton!
    
    @IBOutlet weak var lblDescription: UILabel!
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
             
          }
    
    func customization(isNextStep: Bool)  {
        
        self.shadowWithCorner(viewContainer: viewContainer, cornerRadius: 2)
        
        if isNextStep {
            let fontBook =  UIFont(name: "FontBook".localized(), size: Device.FONTSIZETYPE14)
            UILabel.labelUIHandling(label: lblNoNextSteps, text: "Not Available !!!", textColor: ILColor.color(index: 39), isBold: false, fontType: fontBook)
            viewContainer.isHidden = true
            lblNoNextSteps.isHidden = false

        }
        else{
            
            
            
            lblNoNextSteps.isHidden = true
            viewContainer.isHidden = false
            if self.objNextStepViewType == .erType
            {
                dueDateAndButtonLogic()
                lblDescription.attributedText = coachSideDescription()
            }
            else{
                
            }

            
            
        }
        
    }
    
    func dueDateAndButtonLogic() {
       let fontMedium = UIFont(name: "FontMediumWithoutNext".localized(), size: Device.FONTSIZETYPE11)
        let dueDate =
            GeneralUtility.currentDateDetailType4(emiDate: self.nextModalObj?.dueDatetime ?? "", fromDateF: "yyyy-MM-dd HH:mm:ss", toDateFormate: "dd MMM yyyy")
        
        let dueDateComp = "Due Date: " + dueDate;
        
        UILabel.labelUIHandling(label: lblDate, text: dueDateComp, textColor: ILColor.color(index: 38), isBold: false, fontType: fontMedium)
          let fontHeavy = UIFont(name: "FontHeavy".localized(), size: Device.FONTSIZETYPE12)
        
        UIButton.buttonUIHandling(button: btnCompletionStatus, text: "Mark as complete", backgroundColor: .clear, textColor: ILColor.color(index: 23),  buttonImage: UIImage.init(named: "noun_Star_select"), fontType: fontHeavy)
        
    }
    
    
    
    func coachSideDescription() -> NSAttributedString{
           let strHeader = NSMutableAttributedString.init()
           if  let fontBook =  UIFont(name: "FontBook".localized(), size: Device.FONTSIZETYPE11), let fontMedium = UIFont(name: "FontMediumWithoutNext".localized(), size: Device.FONTSIZETYPE12)
               
           {
          
            let nextLine1 = NSAttributedString.init(string: "\n")
            
            let createDate =  GeneralUtility.currentDateDetailType4(emiDate: self.nextModalObj?.createdAt ?? "", fromDateF: "yyyy-MM-dd HH:mm:ss", toDateFormate: "dd MMM yyyy")
            
            let weekDay = ["Sun","Mon","Tue","Wed","Thu","Fri","Sat"]
             let componentDueDay = GeneralUtility.dateComponent(date: self.nextModalObj?.dueDatetime ?? "", component: .weekday)
            
            let AssignON =  "\(weekDay[(componentDueDay?.weekday ?? 1) - 1]), " + createDate;
            let strAssignONText = NSAttributedString.init(string: GeneralUtility.optionalHandling(_param: "Assign on: ", _returnType: String.self)
                           , attributes: [NSAttributedString.Key.foregroundColor : ILColor.color(index: 38),NSAttributedString.Key.font : fontBook]);
          
        let strAssignONDate = NSAttributedString.init(string: GeneralUtility.optionalHandling(_param: AssignON, _returnType: String.self)
                , attributes: [NSAttributedString.Key.foregroundColor : ILColor.color(index: 38),NSAttributedString.Key.font : fontMedium]);
            
            
            let strDescription = NSAttributedString.init(string: GeneralUtility.optionalHandling(_param: self.nextModalObj?.data ?? "", _returnType: String.self)
                           , attributes: [NSAttributedString.Key.foregroundColor : ILColor.color(index: 38),NSAttributedString.Key.font : fontBook]);
            
            
            let para = NSMutableParagraphStyle.init()
            //            para.alignment = .center
            para.lineSpacing = 2
            strHeader.append(strAssignONText)
            strHeader.append(strAssignONDate)
            strHeader.append(nextLine1)
            strHeader.append(strDescription)
            
            
            strHeader.addAttribute(NSAttributedString.Key.paragraphStyle, value: para, range: NSMakeRange(0, strHeader.length))
           
        }
        return strHeader;
       }
    
    
}
