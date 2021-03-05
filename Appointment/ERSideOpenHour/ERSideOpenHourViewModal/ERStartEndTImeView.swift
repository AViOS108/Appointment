//
//  ERStartEndTImeView.swift
//  Appointment
//
//  Created by Anurag Bhakuni on 23/02/21.
//  Copyright © 2021 Anurag Bhakuni. All rights reserved.
//

import UIKit

protocol  DeleteParticularStartTimeViewDelegate {
    func deleteViewWith(tag: Int)
    func addValueToDicModal(tag: Int,data:String)

}


class ERStartEndTImeView: UIView {
    
    @IBOutlet weak var viewContainer: UIView!
    
    var delegate : DeleteParticularStartTimeViewDelegate!
    
    var viewconTroller : UIViewController!
    @IBOutlet weak var txtStartTime: UITextField!
    
    @IBOutlet weak var txtEndTime: UITextField!
    
    @IBOutlet weak var btnDelete: UIButton!
    
    var dicstartTime :Dictionary<String,String>!
    
    
    
    @IBAction func btnDeleteTapped(_ sender: UIButton) {
        delegate.deleteViewWith(tag: sender.tag)
    }
    
    func customization()  {
        
        btnDelete.setImage(UIImage.init(named: "crossDeletion"), for: .normal);
        
        let fontMedium = UIFont(name: "FontMediumWithoutNext".localized(), size: Device.FONTSIZETYPE13)
        txtStartTime.backgroundColor = ILColor.color(index: 48)
        self.txtStartTime.font = fontMedium
        self.txtStartTime.layer.borderColor = ILColor.color(index: 27).cgColor
        self.txtStartTime.layer.borderWidth = 1;
        self.txtStartTime.layer.cornerRadius = 3;
        let imageView = UIImageView.init(image: UIImage.init(named: "Calendar-1"))
        imageView.frame = CGRect(x: 0.0, y: 0.0, width: 20, height: 20)
        
        self.txtStartTime.leftView = imageView
        txtStartTime.leftViewMode = .always;
        
        txtEndTime.delegate = (viewconTroller as! UITextFieldDelegate)
        txtStartTime.delegate = (viewconTroller as! UITextFieldDelegate)

        self.addInputAccessoryForTextFields(textFields: [txtEndTime,txtStartTime], dismissable: true, previousNextable: true)

        
        
        txtEndTime.backgroundColor = ILColor.color(index: 48)
        self.txtEndTime.font = fontMedium
        self.txtEndTime.layer.borderColor = ILColor.color(index: 27).cgColor
        self.txtEndTime.layer.borderWidth = 1;
        self.txtEndTime.layer.cornerRadius = 3;
        let imageView1 = UIImageView.init(image: UIImage.init(named: "Calendar-1"))
        
        imageView1.frame = CGRect(x: 0.0, y: 0.0, width: 20, height: 20)
        
        self.txtEndTime.leftView = imageView1
        txtEndTime.leftViewMode = .always;
        
       
        self.txtStartTime.text =  "HH:MM"
        self.txtEndTime .text =  "HH:MM"
        datePickerTiming(txtInput: txtStartTime, tag: 998)
        datePickerTiming(txtInput: txtEndTime, tag: 999)

    }
    
    
    
    
    
       func datePickerTiming(txtInput : UITextField, tag : Int)  {
            
            let  dbDatePickerFromTiming = UIDatePicker.init()
            dbDatePickerFromTiming.tag = tag
            dbDatePickerFromTiming.addTarget(self, action: #selector(datePickerValueChanged(sender:)), for: .valueChanged)
            dbDatePickerFromTiming.timeZone = NSTimeZone.default;
            dbDatePickerFromTiming.datePickerMode = .time
            txtInput.inputView = dbDatePickerFromTiming;
            if tag == 998{
                
                let string = "11:00 AM"
                let formatter = DateFormatter()
                 formatter.dateFormat = "hh:mm a"
                let date = formatter.date(from: string)
               
                dbDatePickerFromTiming.setDate(date!, animated: false)
                
            }
            else{
                let string = "1:00 PM"
                let formatter = DateFormatter()
                 formatter.dateFormat = "hh:mm a"
                let date = formatter.date(from: string)
               
                dbDatePickerFromTiming.setDate(date!, animated: false)
                
            }
        }
        
    @objc func datePickerValueChanged(sender:UIDatePicker)  {
        
        if sender.tag == 998{
            let dateFormatter = DateFormatter.init();
            dateFormatter.dateFormat = "hh:mm a"
            txtStartTime.text = dateFormatter.string(from: sender.date);
//            delegate.addValueToDicModal(tag: sender.tag,data: dateFormatter.string(from: sender.date))
            
        }
        else{
            let dateFormatter = DateFormatter.init();
            dateFormatter.dateFormat = "hh:mm a"
            txtEndTime.text = dateFormatter.string(from: sender.date);
//            delegate.addValueToDicModal(tag: sender.tag,data: dateFormatter.string(from: sender.date))
        }
        
        
        
    }
        
    
    func loadView() -> UIView{
        
        let bundle = Bundle(for: type(of: self))
        let nibName = type(of: self).description().components(separatedBy: ".").last!
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as! UIView
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
    }
}
