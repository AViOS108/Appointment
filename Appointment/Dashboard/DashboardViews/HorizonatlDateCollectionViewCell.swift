//
//  HorizonatlDateCollectionViewCell.swift
//  Appointment
//
//  Created by Anurag Bhakuni on 13/07/20.
//  Copyright © 2020 Anurag Bhakuni. All rights reserved.
//

import UIKit


struct HorizontalDateModal {
    var date:Int , WeekDay : String;
   
//    init() {
//
//        self.surveyName = ""
//        self.surveyHeader = ""
//        self.surveyInstructions = ""
//        self.questions = [Question]();
//
//    }
    
}


class HorizonatlDateCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var btnDaySelected: UIButton!
    
    @IBOutlet weak var lblDate: UILabel!
    
    var modelDate : HorizontalDateModal!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func customize()  {
        let strHeaderRecevingMode = NSMutableAttributedString.init()

        if let fontHeavy =  UIFont(name: "FontHeavy".localized(), size: Device.FONTSIZETYPE10)
            
        {
            
            let strTiTle = NSAttributedString.init(string: GeneralUtility.optionalHandling(_param: "Mon", _returnType: String.self)
                , attributes: [NSAttributedString.Key.foregroundColor : ILColor.color(index:25),NSAttributedString.Key.font : fontHeavy]);
            let nextLine1 = NSAttributedString.init(string: "\n")
            
            let strNote = NSAttributedString.init(string: GeneralUtility.optionalHandling(_param: "1", _returnType: String.self)
                , attributes: [NSAttributedString.Key.foregroundColor : ILColor.color(index: 26),NSAttributedString.Key.font : fontHeavy, NSAttributedString.Key.backgroundColor : UIColor.red ]);
        
            // create our NSTextAttachment
            
            let para = NSMutableParagraphStyle.init()
            para.alignment = .center
            strHeaderRecevingMode.append(strTiTle)
            strHeaderRecevingMode.append(nextLine1)
            strHeaderRecevingMode.append(strNote)
            strHeaderRecevingMode.addAttribute(NSAttributedString.Key.paragraphStyle, value: para, range: NSMakeRange(0, strHeaderRecevingMode.length))
            lblDate.attributedText = strHeaderRecevingMode
        }
        
        
    }

    @IBAction func btnDayTapped(_ sender: Any) {
    }
    

}
