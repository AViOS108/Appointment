//
//  ERNotesTextViewTableViewCell.swift
//  Appointment
//
//  Created by Anurag Bhakuni on 15/04/21.
//  Copyright © 2021 Anurag Bhakuni. All rights reserved.
//

import UIKit

protocol ERNotesTextViewTableViewCellDelegate {
    func sendDescription(strText:String);
}


class ERNotesTextViewTableViewCell: TableviewCellSuperClass, UITextViewDelegate {

    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var txtView: UITextView!
    
    @IBOutlet weak var lblText: UILabel!
    
    var delegate : ERNotesTextViewTableViewCellDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    override func actnResignKeyboard() {
          txtView.resignFirstResponder()
      }
    func customization()  {
        
        txtView.delegate = self
        if txtView.text.isEmpty {
            txtView.text = "Type here (max 10000 characters)"
            txtView.textColor = .lightGray
        }
        self.addInputAccessoryForTextView(textVIew: txtView )

        txtView.backgroundColor = ILColor.color(index: 22)
        txtView.autocorrectionType = .no
        txtView.spellCheckingType = .no
        let fontMedium = UIFont(name: "FontMediumWithoutNext".localized(), size: Device.FONTSIZETYPE13)
        txtView.font = fontMedium
        txtView.delegate = self
        txtView.layer.borderWidth = 1;
        txtView.layer.borderColor = ILColor.color(index: 22).cgColor
        let isStudent = UserDefaultsDataSource(key: "student").readData() as? Bool
        if isStudent ?? false {
            lblText.isHidden = true
        }
        else
        {
            lblText.isHidden = false
            UILabel.labelUIHandling(label: lblText, text: "Share this note with", textColor: ILColor.color(index: 23), isBold: false, fontType: fontMedium)
        }
    }
    
    
    func textViewDidBeginEditing(_ textView: UITextView)
       {
           if (textView.text == "Type here (max 10000 characters)" && textView.textColor == .lightGray)
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
               textView.text = "Type here (max 10000 characters)"
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
