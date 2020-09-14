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



class ConfirmationPopUpSecondTableViewCell: UITableViewCell,UITextViewDelegate {
    
    @IBOutlet weak var lblHeader: UILabel!
    var delegate : SendDEscriptionConfirmationPopUpSecondDelegate!
    @IBOutlet weak var txtDescription: UITextView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func customization()  {
        let fontNextMedium = UIFont(name: "FontMedium".localized(), size: Device.FONTSIZETYPE13)
        UILabel.labelUIHandling(label: lblHeader, text: "Description", textColor:ILColor.color(index: 31) , isBold: false , fontType: fontNextMedium,   backgroundColor:.white )
        txtDescription.backgroundColor = ILColor.color(index: 22)
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
