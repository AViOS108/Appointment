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

}


enum timeDifference : Int {
    case fifteenmin
    case thiryMin
    case fortyfiveMin
    case sixty
    case customMin

}


class ERStartEndTImeView: SuperViewClass {
    
    @IBOutlet weak var viewContainer: UIView!
    
    var noDeleteBtn = false
    
    var delegate : DeleteParticularStartTimeViewDelegate!
    
    var objtimeDifference : timeDifference!
    
    var viewconTroller : UIViewController!
    @IBOutlet weak var txtStartTime: TexFieldWithoutPast!
    
    @IBOutlet weak var txtEndTime: TexFieldWithoutPast!
    
    @IBOutlet weak var btnDelete: UIButton!
    
    var dicstartTime :Dictionary<String,String>!
    
    var isBothTimeField : Bool = false
    var isTimeValid = false
    
    @IBOutlet weak var nslayoutConstarintWidth: NSLayoutConstraint!
    @IBAction func btnDeleteTapped(_ sender: UIButton) {
        delegate.deleteViewWith(tag: sender.tag)
    }
    
    func customization()  {
        
        self.layoutIfNeeded()
        if noDeleteBtn {
            btnDelete.setImage(UIImage.init(named: "crossDeletion"), for: .normal);
            btnDelete.isHidden = true
            nslayoutConstarintWidth.constant = 0
        }
        else{
            btnDelete.setImage(UIImage.init(named: "crossDeletion"), for: .normal);
            btnDelete.isHidden = false
            nslayoutConstarintWidth.constant = 40
 

        }
        
        
        let fontMedium = UIFont(name: "FontMediumWithoutNext".localized(), size: Device.FONTSIZETYPE13)
        txtStartTime.backgroundColor = ILColor.color(index: 48)
        self.txtStartTime.font = fontMedium
        self.txtStartTime.layer.borderColor = ILColor.color(index: 27).cgColor
        self.txtStartTime.layer.borderWidth = 1;
        self.txtStartTime.layer.cornerRadius = 3;
        let imageView = UIImageView.init(image: UIImage.init(named: "clocktimetools"))
        imageView.frame = CGRect(x: 0.0, y: 0.0, width: 20, height: 20)
        
        self.txtStartTime.leftView = imageView
        txtStartTime.leftViewMode = .always;
        
        txtEndTime.delegate = (viewconTroller as! UITextFieldDelegate)
        txtStartTime.delegate = (viewconTroller as! UITextFieldDelegate)

        self.addInputAccessoryForTextFields(textFields: [txtStartTime,txtEndTime], dismissable: true, previousNextable: true)

        
        
        txtEndTime.backgroundColor = ILColor.color(index: 48)
        self.txtEndTime.font = fontMedium
        self.txtEndTime.layer.borderColor = ILColor.color(index: 27).cgColor
        self.txtEndTime.layer.borderWidth = 1;
        self.txtEndTime.layer.cornerRadius = 3;
        let imageView1 = UIImageView.init(image: UIImage.init(named: "clocktimetools"))
        
        imageView1.frame = CGRect(x: 10.0, y: 0.0, width: 20, height: 20)
        
        self.txtEndTime.leftView = imageView1
        txtEndTime.leftViewMode = .always;
        
       
        self.txtStartTime.placeholder =  "HH:MM"
        self.txtEndTime .placeholder =  "HH:MM"
        datePickerTiming(txtInput: txtStartTime, tag: 998)
        datePickerTiming(txtInput: txtEndTime, tag: 999)

    }
    
    
    override func actnResignKeyboard() {
        self.endEditing(true)
    }
    
    
       func datePickerTiming(txtInput : UITextField, tag : Int)  {
            
            let  dbDatePickerFromTiming = UIDatePicker.init()
            dbDatePickerFromTiming.tag = tag
            dbDatePickerFromTiming.addTarget(self, action: #selector(datePickerValueChanged(sender:)), for: .valueChanged)
            dbDatePickerFromTiming.timeZone = NSTimeZone.default;
            dbDatePickerFromTiming.datePickerMode = .time
        if #available(iOS 13.4, *) {
            dbDatePickerFromTiming.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
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
            
            
            switch objtimeDifference {
            case .fifteenmin:
                txtEndTime.text =  GeneralUtility.timeAddedInParticularComponent(date:  txtStartTime.text!, component: .minute, addingValue: 15)

                isBothTimeField = true
                break
            case .thiryMin:
              txtEndTime.text =   GeneralUtility.timeAddedInParticularComponent(date:  txtStartTime.text!, component: .minute, addingValue: 30)
              isBothTimeField = true

                break
            case .fortyfiveMin:
             txtEndTime.text =     GeneralUtility.timeAddedInParticularComponent(date:  txtStartTime.text!, component: .minute, addingValue: 45)
             isBothTimeField = true

                break
            case .sixty:
             txtEndTime.text =     GeneralUtility.timeAddedInParticularComponent(date:  txtStartTime.text!, component: .minute, addingValue: 60)
             isBothTimeField = true

                break
            case .customMin:
                if txtEndTime.text!.isEmpty{
                    
                }
                else{
                     isBothTimeField = true
                   
                }
                
                break
            default:
                break
            }
            
            
            
        }
        else{
            let dateFormatter = DateFormatter.init();
            dateFormatter.dateFormat = "hh:mm a"
            txtEndTime.text = dateFormatter.string(from: sender.date);
            switch objtimeDifference {
            case .fifteenmin:
                txtStartTime.text =  GeneralUtility.timeAddedInParticularComponent(date:  txtEndTime.text!, component: .minute, addingValue: -15)
                
                isBothTimeField = true

                break
            case .thiryMin:
                txtStartTime.text =   GeneralUtility.timeAddedInParticularComponent(date:  txtEndTime.text!, component: .minute, addingValue: -30)
                isBothTimeField = true

                break
            case .fortyfiveMin:
                txtStartTime.text =     GeneralUtility.timeAddedInParticularComponent(date:  txtEndTime.text!, component: .minute, addingValue: -45)
                isBothTimeField = true

                break
            case .sixty:
                txtStartTime.text =     GeneralUtility.timeAddedInParticularComponent(date:  txtEndTime.text!, component: .minute, addingValue: -60)
                isBothTimeField = true

                break
            case .customMin:
                if txtStartTime.text!.isEmpty{
                    
                }
                else{
                     isBothTimeField = true
                }
                break
            default:
                break
            }
            
        }
        
        if isBothTimeField{
            if GeneralUtility.differenceBetweenTwoDateInSec(dateFirst: txtStartTime.text!, dateSecond: txtEndTime.text!, dateformatter: "hh:mm a")  < 0 {
                                   isTimeValid = true
                               }
                               else {
                                    isTimeValid = false
                               }
        }
        delegate.deleteViewWith(tag: 999)

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
