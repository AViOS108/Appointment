//
//  ConfirmationPopUpSecondTableViewCell.swift
//  Appointment
//
//  Created by Anurag Bhakuni on 08/09/20.
//  Copyright © 2020 Anurag Bhakuni. All rights reserved.
//

import UIKit

protocol SendDEscriptionConfirmationPopUpSecondDelegate {
    func sendDescription(strText: String)
}



class ConfirmationPopUpSecondTableViewCell: TableviewCellSuperClass,UITextViewDelegate {
    
    @IBOutlet weak var lblHeader: UILabel!
    var delegate : SendDEscriptionConfirmationPopUpSecondDelegate!
    @IBOutlet weak var txtDescription: UITextView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func actnResignKeyboard() {
        txtDescription.resignFirstResponder()
         }
    
    func customization()  {
        
        self.addInputAccessoryForTextView(textVIew: txtDescription )
        
        let strHeader = NSMutableAttributedString.init()
               
               if let fontNextMedium = UIFont(name: "FontMedium".localized(), size: Device.FONTSIZETYPE13)
                      {
                          let strTiTle = NSAttributedString.init(string: GeneralUtility.optionalHandling(_param: "Description ", _returnType: String.self)
                              , attributes: [NSAttributedString.Key.foregroundColor : ILColor.color(index: 31),NSAttributedString.Key.font : fontNextMedium]);
                          let strType = NSAttributedString.init(string: " ⃰"
                           , attributes: [NSAttributedString.Key.foregroundColor : UIColor.red,NSAttributedString.Key.font : fontNextMedium]);
                          let para = NSMutableParagraphStyle.init()
                          //            para.alignment = .center
                          strHeader.append(strTiTle)
                         
                          strHeader.addAttribute(NSAttributedString.Key.paragraphStyle, value: para, range: NSMakeRange(0, strHeader.length))
                          lblHeader.attributedText = strHeader
                      }
                
        
        
        
        
        
        
        
        
        txtDescription.backgroundColor = ILColor.color(index: 22)
        txtDescription.autocorrectionType = .no
        txtDescription.spellCheckingType = .no
        let fontMedium = UIFont(name: "FontMediumWithoutNext".localized(), size: Device.FONTSIZETYPE13)
        txtDescription.font = fontMedium
        txtDescription.delegate = self
        txtDescription.layer.borderWidth = 1;
        txtDescription.layer.borderColor = ILColor.color(index: 22).cgColor
        
    }
    
    func textViewDidBeginEditing(_ textView: UITextView)
    {
        if (textView.text == "Enter Description" && textView.textColor == .lightGray)
        {
            textView.text = ""
            textView.textColor = .black
        }
        textView.becomeFirstResponder() //Optional
    }
    
    func textViewDidEndEditing(_ textView: UITextView)
    {
        if (textView.text == "")
        {
            textView.text = "Enter Description"
            textView.textColor = .lightGray
        }
        textView.resignFirstResponder()
    }
    
    
    
       func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
           guard let currentText = (textView.text as NSString?)?.replacingCharacters(in: range, with: text) else { return true }
         delegate.sendDescription(strText:currentText)
           return true
       }
    
    
    
}
