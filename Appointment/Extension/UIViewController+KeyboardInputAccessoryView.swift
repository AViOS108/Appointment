//  Created by Anurag Bhakuni on 15/01/20.
//  Copyright © 2020 Anurag Bhakuni. All rights reserved.



import UIKit
import Foundation

extension UIViewController {
    @objc func addInputAccessoryForTextFields(textFields: [UITextField], dismissable: Bool = true, previousNextable: Bool = false) {
        for (index, textField) in textFields.enumerated() {
            let toolbar: UIToolbar = UIToolbar()
            toolbar.sizeToFit()
            
            var items = [UIBarButtonItem]()
            if previousNextable {
                
                let previousButton = UIBarButtonItem(title: "Prev", style: .plain, target: self, action: nil)
                previousButton.width = 30
                if textField == textFields.first {
                    previousButton.isEnabled = false
                } else {
                    previousButton.target = textFields[index - 1]
                    previousButton.action = #selector(UITextField.becomeFirstResponder)
                }
                
                let nextButton = UIBarButtonItem(title: "Next", style: .plain, target: self, action: nil)
                nextButton.width = 30
                if textField == textFields.last {
                    nextButton.isEnabled = false
                } else {
                    nextButton.target = textFields[index + 1]
                    nextButton.action = #selector(UITextField.becomeFirstResponder)
                }
                
                items.append(contentsOf: [previousButton, nextButton])
                
            }
            
            let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            
            let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action:#selector(SuperViewController.actnResignKeyboard))
            doneButton.isEnabled = true;
            doneButton.accessibilityIdentifier = "barButton1";
            
      
            items.append(contentsOf: [spacer, doneButton])
            toolbar.setItems(items, animated: false)
            textField.inputAccessoryView = toolbar
        }
    }
    
    
    
    @objc func addInputAccessoryForSearchbar(textVIew: UISearchBar, dismissable: Bool = true, previousNextable: Bool = false) {
           
           let toolbar: UIToolbar = UIToolbar()
           toolbar.sizeToFit()
           var items = [UIBarButtonItem]()
           let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
           
           let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action:#selector(SuperViewController.actnResignKeyboard))
           
           items.append(contentsOf: [spacer, doneButton])
           toolbar.setItems(items, animated: false)
           textVIew.inputAccessoryView = toolbar
       }
       
    
    
    @objc func addInputAccessoryForTextView(textVIew: UITextView, dismissable: Bool = true, previousNextable: Bool = false) {
        
        let toolbar: UIToolbar = UIToolbar()
        toolbar.sizeToFit()
        var items = [UIBarButtonItem]()
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action:#selector(SuperViewController.actnResignKeyboard))
        
        items.append(contentsOf: [spacer, doneButton])
        toolbar.setItems(items, animated: false)
        textVIew.inputAccessoryView = toolbar
    }
    
    
       
    func reloadViewFromNib() {
        let parent = view.superview
        view.removeFromSuperview()
        view = nil
        parent?.addSubview(view) // This line causes the view to be reloaded
    }
}


