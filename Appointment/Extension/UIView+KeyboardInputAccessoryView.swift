//  Created by Anurag Bhakuni on 15/01/20.
//  Copyright © 2020 Anurag Bhakuni. All rights reserved.



import UIKit

import Foundation
extension UIView {
   @objc  func addInputAccessoryForTextFields(textFields: [UITextField], dismissable: Bool , previousNextable: Bool ) {
        for (index, textField) in textFields.enumerated() {
            let toolbar: UIToolbar = UIToolbar()
            toolbar.sizeToFit()
            var items = [UIBarButtonItem]()
            if previousNextable {

                let previousButton = UIBarButtonItem.init(title: "Prev", style: .plain, target: nil, action: nil)
                previousButton.width = 30
                if textField == textFields.first {
                    previousButton.isEnabled = false
                } else {
                    previousButton.target = textFields[index - 1]
                    previousButton.action = #selector(UITextField.becomeFirstResponder)
                }
                let nextButton = UIBarButtonItem.init(title: "Next", style: .plain, target: nil, action: nil)
                nextButton.width = 30
                if textField == textFields.last {
                    nextButton.isEnabled = false
                } else {
                    nextButton.target = textFields[index + 1]
                    nextButton.action = #selector(UITextField.becomeFirstResponder)
                }
                if textField == textFields.first {
                    items.append(contentsOf: [nextButton])
                }
                else if textField == textFields.last
                {
                    items.append(contentsOf: [previousButton])
                }
                else
                {
                    items.append(contentsOf: [previousButton, nextButton])
                }
            }
            
            let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)

            let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action:#selector(SuperViewClass.actnResignKeyboard))
            


            items.append(contentsOf: [spacer, doneButton])

            toolbar.setItems(items, animated: false)
            textField.inputAccessoryView = toolbar
        }
    }
    
    @objc func addInputAccessoryForTextView(textVIew: UITextView, dismissable: Bool = true, previousNextable: Bool = false) {
        
        let toolbar: UIToolbar = UIToolbar()
        toolbar.sizeToFit()
        var items = [UIBarButtonItem]()
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action:#selector(TableviewCellSuperClass.actnResignKeyboard))
        
        items.append(contentsOf: [spacer, doneButton])
        toolbar.setItems(items, animated: false)
        textVIew.inputAccessoryView = toolbar
    }
    
  
    
    
    
    
}

class TableviewCellSuperClass: UITableViewCell  {
    
    @objc func actnResignKeyboard() {

       }
    
}

