//
//  ERSideTimeSlotBlackOut.swift
//  Appointment
//
//  Created by Anurag Bhakuni on 15/11/21.
//  Copyright © 2021 Anurag Bhakuni. All rights reserved.
//

import UIKit



protocol ERSideTimeSlotBlackOutDelegate{
    func deleteErSideTimeSlot(objtimeSlotDuplicateModal :timeSlotDuplicateModal)
    func dateSelectedTimeSlot(objtimeSlotDuplicateModal :timeSlotDuplicateModal,isStartTimeView : Bool,sendTime: Bool)

}

class ERSideTimeSlotBlackOut: SuperViewClass {
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var txtHourTime: UITextField!
    @IBOutlet weak var lblTime: UILabel!
    var viewconTroller : UIViewController!
    @IBOutlet weak var lblHeading: UILabel!

    var isStartTimeView = true

    @IBOutlet weak var viewStack: UIStackView!
    var objtimeSlotDuplicateModal : timeSlotDuplicateModal!
    let pickerView = UIPickerView()
    var delegate : ERSideTimeSlotBlackOutDelegate!
    
    @IBAction func deleteTimeSlotTapped(_ sender: Any) {
        delegate.deleteErSideTimeSlot(objtimeSlotDuplicateModal: objtimeSlotDuplicateModal)
    }
    @IBOutlet weak var deleteTimeSlot: UIButton!
    
    @IBAction func dateSelectedTapped(_ sender: UIButton) {
        
        delegate.dateSelectedTimeSlot(objtimeSlotDuplicateModal: objtimeSlotDuplicateModal, isStartTimeView: isStartTimeView, sendTime: false)

        let frame = sender.convert(sender.frame, from:AppDelegate.getDelegate().window)
        let viewCalender = CalenderViewController.init(nibName: "CalenderViewController", bundle: nil)
        viewCalender.index = 2
        viewCalender.pointedArrow = false
        viewCalender.viewControllerI = self.viewconTroller
        viewCalender.pointSign = CGPoint.init(x: abs(frame.origin.x) + abs(frame.size.width/2), y: abs(frame.origin.y) + abs(frame.size.height/2) + 10 )
        viewCalender.modalPresentationStyle = .overFullScreen
        self.viewconTroller.present(viewCalender, animated: false) {
        }
        
    }
    @IBOutlet weak var dateSelected: UIButton!
    @IBOutlet weak var viewTimeContainer: UIView!
   lazy var  dbDatePickerFromTiming = UIDatePicker.init()

  
    func loadView() -> UIView{
        
        let bundle = Bundle(for: type(of: self))
        let nibName = type(of: self).description().components(separatedBy: ".").last!
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as! UIView
    }
    
    func customization(){
      
        
        if self.objtimeSlotDuplicateModal.isSelected{
            self.txtHourTime.isHidden = true
            self.viewStack.spacing = 0;
        }
        else{
            self.txtHourTime.isHidden = false
            self.viewStack.spacing = 20;
        }
       
        
        datePickerTiming(txtInput: self.txtHourTime, tag: 193)
        
        if let fontMedium = UIFont(name: "FontMedium".localized(), size: Device.FONTSIZETYPE11)
        {
            UILabel.labelUIHandling(label: lblHeading, text: lblHeading.text ?? "", textColor: ILColor.color(index: 31), isBold: true, fontType: fontMedium)
        }
        
        txtHourTime.delegate = self.viewconTroller as! UITextFieldDelegate
        self.addInputAccessoryForTextFields(textFields: [txtHourTime], dismissable: true, previousNextable: true)
        
        if let fontMedium = UIFont(name: "FontMedium".localized(), size: Device.FONTSIZETYPE11)
        {
            txtHourTime.backgroundColor = ILColor.color(index: 48)
            self.txtHourTime.font = fontMedium
            self.txtHourTime.layer.cornerRadius = 3;
            let imageView3 = UIImageView.init(image: UIImage.init(named: "clocktime"))
            imageView3.frame = CGRect(x: 0.0, y: 0.0, width: 20, height: 20)
            self.txtHourTime.leftView = imageView3
            txtHourTime.leftViewMode = .always;
        }
        
        if objtimeSlotDuplicateModal.isSelected{
            if let fontMedium = UIFont(name: "FontMedium".localized(), size: Device.FONTSIZETYPE11)
            {
                UILabel.labelUIHandling(label: lblTime, text: objtimeSlotDuplicateModal.timeStart, textColor: ILColor.color(index: 66), isBold: true, fontType: fontMedium)
            }
            deleteTimeSlot.isHidden = false
        }
        else{
            if isStartTimeView {
                if let fontMedium = UIFont(name: "FontMedium".localized(), size: Device.FONTSIZETYPE11)
                {
                    if   GeneralUtility.currentDateDetailType4(emiDate: objtimeSlotDuplicateModal.timeStart, fromDateF: "dd MMM, yyyy hh:mm a", toDateFormate: "hh:mm a") != ""{
                        UILabel.labelUIHandling(label: lblTime, text:  GeneralUtility.currentDateDetailType4(emiDate: objtimeSlotDuplicateModal.timeStart, fromDateF: "dd MMM, yyyy hh:mm a", toDateFormate: "dd MMM, yyyy"), textColor: ILColor.color(index: 66), isBold: true, fontType: fontMedium)
                    }
                    else{
                        UILabel.labelUIHandling(label: lblTime, text: objtimeSlotDuplicateModal.timeStart, textColor: ILColor.color(index: 66), isBold: true, fontType: fontMedium)
                    }
                    
                }
                deleteTimeSlot.isHidden = true
                if   GeneralUtility.currentDateDetailType4(emiDate: objtimeSlotDuplicateModal.timeStart, fromDateF: "dd MMM, yyyy hh:mm a", toDateFormate: "hh:mm a") != ""{
                    self.txtHourTime.text =   GeneralUtility.currentDateDetailType4(emiDate: objtimeSlotDuplicateModal.timeStart, fromDateF: "dd MMM, yyyy hh:mm a", toDateFormate: "hh:mm a")
                }
                else{
                    self.txtHourTime.text = "10:00 AM"
                }
            }
            else{
                if let fontMedium = UIFont(name: "FontMedium".localized(), size: Device.FONTSIZETYPE11)
                {
                    if   GeneralUtility.currentDateDetailType4(emiDate: objtimeSlotDuplicateModal.timeEnd, fromDateF: "dd MMM, yyyy hh:mm a", toDateFormate: "hh:mm a") != ""{
                        UILabel.labelUIHandling(label: lblTime, text:  GeneralUtility.currentDateDetailType4(emiDate: objtimeSlotDuplicateModal.timeEnd, fromDateF: "dd MMM, yyyy hh:mm a", toDateFormate: "dd MMM, yyyy"), textColor: ILColor.color(index: 66), isBold: true, fontType: fontMedium)
                    }
                    else{
                        UILabel.labelUIHandling(label: lblTime, text: objtimeSlotDuplicateModal.timeEnd, textColor: ILColor.color(index: 66), isBold: true, fontType: fontMedium)
                    }
                }
                if   GeneralUtility.currentDateDetailType4(emiDate: objtimeSlotDuplicateModal.timeEnd, fromDateF: "dd MMM, yyyy hh:mm a", toDateFormate: "hh:mm a") != ""{
                    self.txtHourTime.text =    GeneralUtility.currentDateDetailType4(emiDate: objtimeSlotDuplicateModal.timeEnd, fromDateF: "dd MMM, yyyy hh:mm a", toDateFormate: "hh:mm a")
                }
                else{
                    self.txtHourTime.text = "10:00 AM"
                }
                deleteTimeSlot.isHidden = false
            }
        }
        
       
        UIButton.buttonUIHandling(button: dateSelected  , text: "", backgroundColor: .clear, textColor: .clear)
        UIButton.buttonUIHandling(button:deleteTimeSlot  , text: "", backgroundColor: .clear, textColor: .clear, buttonImage: UIImage.init(named: "delete"))

        viewTimeContainer.backgroundColor = ILColor.color(index: 48)
    }
    override func actnResignKeyboard() {
        txtHourTime!.resignFirstResponder()
        
    }
    
    func datePickerTiming(txtInput : UITextField, tag : Int)  {
        
        dbDatePickerFromTiming.tag = tag
        dbDatePickerFromTiming.addTarget(self, action: #selector(datePickerValueChanged(sender:)), for: .valueChanged)
        dbDatePickerFromTiming.timeZone = NSTimeZone.default;
        dbDatePickerFromTiming.datePickerMode = .time
        if #available(iOS 13.4, *) {
            dbDatePickerFromTiming.preferredDatePickerStyle = .automatic
        } else {
        }
        txtInput.inputView = dbDatePickerFromTiming;

        
    }
     
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if #available(iOS 13.4, *) {
            dbDatePickerFromTiming.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
    }
    @objc func datePickerValueChanged(sender:UIDatePicker)  {
        
        let dateFormatter = DateFormatter.init();
        dateFormatter.dateFormat = "hh:mm a"
        txtHourTime.text = dateFormatter.string(from: sender.date);
        
        if isStartTimeView{
            
            if GeneralUtility.currentDateDetailType4(emiDate: objtimeSlotDuplicateModal.timeStart, fromDateF: "dd MMM, yyyy hh:mm a", toDateFormate: "dd MMM, yyyy") != "" {
                objtimeSlotDuplicateModal.timeStart  = GeneralUtility.currentDateDetailType4(emiDate: objtimeSlotDuplicateModal.timeStart, fromDateF: "dd MMM, yyyy hh:mm a", toDateFormate: "dd MMM, yyyy")
            }
            
            objtimeSlotDuplicateModal.timeStart = objtimeSlotDuplicateModal.timeStart + " " + (txtHourTime.text ?? "10:00 AM")
            delegate.dateSelectedTimeSlot(objtimeSlotDuplicateModal: objtimeSlotDuplicateModal, isStartTimeView: isStartTimeView, sendTime: true)
        }
        else{
            if GeneralUtility.currentDateDetailType4(emiDate: objtimeSlotDuplicateModal.timeEnd, fromDateF: "dd MMM, yyyy hh:mm a", toDateFormate: "dd MMM, yyyy") != "" {
                objtimeSlotDuplicateModal.timeEnd  = GeneralUtility.currentDateDetailType4(emiDate: objtimeSlotDuplicateModal.timeEnd, fromDateF: "dd MMM, yyyy hh:mm a", toDateFormate: "dd MMM, yyyy")
            }
            objtimeSlotDuplicateModal.timeEnd = objtimeSlotDuplicateModal.timeEnd + " " + (txtHourTime.text  ?? "10:00 AM")
            delegate.dateSelectedTimeSlot(objtimeSlotDuplicateModal: objtimeSlotDuplicateModal, isStartTimeView: isStartTimeView, sendTime: true)
        }

    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
    }
}
