//
//  ERUpdateStatusAddNextStepViewController.swift
//  Appointment
//
//  Created by Anurag Bhakuni on 14/01/21.
//  Copyright © 2021 Anurag Bhakuni. All rights reserved.
//

import UIKit

import Foundation

typealias ERStandardResponseModalArr = [String]

protocol ERUpdateStatusAddNextStepViewControllerDelegate {
    func refreshTableView()
}
class ERUpdateStatusAddNextStepViewController: SuperViewController,UITextViewDelegate {
    var activeField : UITextField?
    var keyBooradAlreadyShown = false
    @IBOutlet weak var viewScroll: UIScrollView!
    var keyBoardHieght : CGFloat = 0.0;
    var delegate : ERUpdateStatusAddNextStepViewControllerDelegate!
    
    @IBOutlet weak var txtTime: UITextField!
    @IBOutlet weak var viewinner: UIView!
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var txtStandardResponse: UITextField!
    
    var appoinmentDetailModalObj : AppoinmentDetailModalNew?
    
    
    var objERStandardResponseModal : ERStandardResponseModalArr!
    
    let pickerView = UIPickerView()
    
    @IBOutlet weak var lblDate: UILabel!
    
    @IBOutlet weak var lblStandardResponse: UILabel!
    
    @IBOutlet weak var txtView: UITextView!
    
    @IBOutlet weak var btnSubmit: UIButton!
    
    @IBAction func btnSubmitTapped(_ sender: Any) {
        submitNextStep()
    }
    
    
    
    @IBOutlet weak var txtDateTime: UITextField!
    
    @IBAction func btnDateTimeTapped(_ sender: UIButton) {
        
        let frame = sender.convert(sender.frame, from:AppDelegate.getDelegate().window)
        
        let viewCalender = CalenderViewController.init(nibName: "CalenderViewController", bundle: nil)
        viewCalender.index = 1
        
        viewCalender.viewControllerI = self
        viewCalender.pointSign = CGPoint.init(x: abs(frame.origin.x) + abs(frame.size.width/2), y: abs(frame.origin.y) + abs(frame.size.height/2) + 10 )
        viewCalender.modalPresentationStyle = .overFullScreen
        self.present(viewCalender, animated: false) {
        }
        
        
    }
    @IBOutlet weak var btnDateTime: UIButton!
    
    var arrPicker = [String]();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customize()
        pickerViewSetUp()
        viewModal()
        var strTextTitle = "Next steps - Rachel Hudson"
        
        GeneralUtility.customeNavigationBarWithOnlyBack(viewController: self,title:strTextTitle);

        // Do any additional setup after loading the view.
    }
    
    @objc override func buttonClicked(sender: UIBarButtonItem) {
           self.navigationController?.popViewController(animated: false)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        deRegisterKeyboardNotifications()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        registerForKeyboardNotifications()
    }
    
    func viewModal(){
        let  activityIndicator = ActivityIndicatorView.showActivity(view: self.navigationController!.view, message: StringConstants.FetchingCoachSelection)
        
        ERSideAppointmentService().erSideStandardResponse({ (data) in
            activityIndicator.hide()
            do {
                self.objERStandardResponseModal = try JSONDecoder().decode(ERStandardResponseModalArr .self, from: data)
                self.arrPicker = self.objERStandardResponseModal
                self.pickerView.reloadAllComponents()
            } catch  {
                CommonFunctions().showError(title: "Error", message: ErrorMessages.SomethingWentWrong.rawValue)
            }
            
        }) {
            (error, errorCode) in
            activityIndicator.hide()
        };
        
    }
    
    
    override func actnResignKeyboard() {
        //        txtView.resignFirstResponder()
        self.view.endEditing(true)
        //        UIApplication.shared.sendAction(#selector(self.resignFirstResponder), to:nil, from:nil, for:nil)
        
        
    }
    
    func customize()  {
        
        let fontMedium = UIFont(name: "FontMediumWithoutNext".localized(), size: Device.FONTSIZETYPE13)
        self.addInputAccessoryForTextView(textVIew: txtView )
        txtView.backgroundColor = ILColor.color(index: 22)
        txtView.autocorrectionType = .no
        txtView.spellCheckingType = .no
        txtView.delegate = self
        txtView.font = fontMedium
        txtView.delegate = self
        txtView.layer.borderWidth = 1;
        txtView.layer.borderColor = ILColor.color(index: 22).cgColor
        btnSubmit.isEnabled = false
        btnSubmit.cornerRadius = 3;
        txtView.text = "Type here (max 10000 characters)"
        txtView.textColor = .lightGray
        
        txtStandardResponse.backgroundColor = ILColor.color(index: 22)
        txtDateTime.backgroundColor = ILColor.color(index: 22)
        
        
        txtTime.backgroundColor = ILColor.color(index: 48)
        self.txtTime.font = fontMedium
        self.txtTime.layer.borderColor = ILColor.color(index: 27).cgColor
        self.txtTime.layer.borderWidth = 1;
        self.txtTime.layer.cornerRadius = 3;
        let imageView = UIImageView.init(image: UIImage.init(named: "Calendar-1"))
        imageView.frame = CGRect(x: 0.0, y: 0.0, width: 20, height: 20)
        
        self.txtTime.leftView = imageView
        txtTime.leftViewMode = .always;
        
        txtTime.delegate = self
        
        self.addInputAccessoryForTextFields(textFields: [txtStandardResponse, txtDateTime,txtTime], dismissable: true, previousNextable: true)
        
        
        
        txtDateTime.backgroundColor = ILColor.color(index: 48)
        self.txtDateTime.font = fontMedium
        self.txtDateTime.layer.borderColor = ILColor.color(index: 27).cgColor
        self.txtDateTime.layer.borderWidth = 1;
        self.txtDateTime.layer.cornerRadius = 3;
        let imageView1 = UIImageView.init(image: UIImage.init(named: "Calendar-1"))
        
        imageView1.frame = CGRect(x: 0.0, y: 0.0, width: 20, height: 20)
        
        self.txtDateTime.leftView = imageView1
        txtDateTime.leftViewMode = .always;
        
        
        self.txtTime.placeholder =  "HH:MM"
        self.txtDateTime .placeholder =  "DD/MM/YYYY"
        datePickerTiming(txtInput: txtTime, tag: 998)
        
        
        UILabel.labelUIHandling(label: lblStandardResponse, text: "Select Standard Responses ", textColor: ILColor.color(index: 42), isBold: false, fontType: fontMedium)
        txtStandardResponse.placeholder = "Select Standard Responses"
        
        UILabel.labelUIHandling(label: lblDate, text: "Due Date & Time", textColor: ILColor.color(index: 42), isBold: false, fontType: fontMedium)
        
        
        if  let fontBook =  UIFont(name: "FontBook".localized(), size: Device.FONTSIZETYPE17)
            
        {
            UIButton.buttonUIHandling(button: btnSubmit, text: "Submit", backgroundColor: ILColor.color(index: 23) , textColor:.white ,  fontType: fontBook)
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
        return true
    }
    
    
}

extension ERUpdateStatusAddNextStepViewController:UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate,CalenderViewDelegate{
    
    
    func dateSelected(calenderModal: CalenderModal, index: Int) {
        
        txtDateTime.text = calenderModal.StrDate
        
    }
    
    func validation() -> Bool{
        
        if txtView.text.isEmpty || (txtView.text == "Type here (max 10000 characters)" &&  txtView.textColor == .lightGray){
            CommonFunctions().showError(title: "Error", message: StringConstants.ERRADDNEXTSTEPDESCRIPTION)
            
            return false
        }
        
        if txtDateTime.text?.isEmpty ?? true{
            CommonFunctions().showError(title: "Error", message: StringConstants.ERRADDNEXTSTEPDATETIME)
            return false
        }
        
        if txtTime.text?.isEmpty ?? true{
            CommonFunctions().showError(title: "Error", message: StringConstants.ERRADDNEXTSTEPDATETIME)
            return false
        }
        
        
        return true
    }
    
    
    func submitNextStep(){
        
        if !validation(){
            return
        }
        
        var studentArr = [String]()
        
        for student in (self.appoinmentDetailModalObj?.requests)!{
            studentArr.append("\(student.studentDetails?.id ?? 0)");
        }
        
         let endTime =  GeneralUtility.dateConvertToUTC(emiDate: txtTime.text!, withDateFormat: "hh:mm a", todateFormat: "HH:mm")
        
        let timeSelected =  (txtDateTime.text ?? "") + " " + (endTime + ":00" )
        let csrftoken = UserDefaultsDataSource(key: "csrf_token").readData() as! String

        let params = [
            "_method" : "post",
            "appointment_id": "\(self.appoinmentDetailModalObj?.id ?? 0 )",
            "due_datetime" : timeSelected,
            "data":(txtView.text ?? "")!,
            "student_ids":studentArr,
            ParamName.PARAMCSRFTOKEN : csrftoken,

            ] as Dictionary<String,AnyObject>
        
        let  activityIndicator = ActivityIndicatorView.showActivity(view: self.navigationController!.view, message: StringConstants.FetchingCoachSelection)
        ERSideAppointmentService().erSideSubmitNextStep(params: params, { (data) in
            activityIndicator.hide()
            self.delegate.refreshTableView()
            self.navigationController?.popViewController(animated: false)
            
        }) {
            (error, errorCode) in
            activityIndicator.hide()
        };
        
    }
    
    
    
    func deRegisterKeyboardNotifications() {
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    func registerForKeyboardNotifications()  {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown2(aNotification:)), name: UIResponder.keyboardDidShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        
    }
    
    
    @objc func keyboardWillHide(notification: NSNotification) {
        
        if activeField != nil{
            
        }
        else
        {
            return
        }
        
        
        let kbSize = ((notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue)!
        self.viewScroll.contentSize = CGSize.init(width: self.viewScroll.contentSize.width, height: self.viewScroll.contentSize.height - kbSize.size.height)
        keyBooradAlreadyShown = false
        
    }
    
    
    
    @objc func keyboardWasShown2(aNotification:Notification)
    {
        print("a")
        
        if activeField != nil{
            
        }
        else
        {
            return
        }
        
        
        let kbSize = ((aNotification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue)!
        
        keyBoardHieght = (kbSize.height)
        if !keyBooradAlreadyShown {
            self.viewScroll.contentSize = CGSize.init(width: self.viewScroll.contentSize.width, height: self.viewScroll.contentSize.height + kbSize.size.height)
            
        }
        
        keyBooradAlreadyShown = true
        let kbSize1 : CGRect = CGRect(x: kbSize.origin.x, y: (self.view.frame.size.height + self.view.frame.origin.y) - (kbSize.size.height), width: kbSize.size.width, height: kbSize.size.height)
        
        let rect : CGPoint = (activeField?.superview?.convert(activeField!.frame.origin, to: nil))!;
        
        let changedTextfiledFrame : CGRect = CGRect(x: rect.x, y: rect.y , width: activeField!.frame.size.width, height: activeField!.frame.size.height)
        
        let yupKeyoboard = changedTextfiledFrame.origin.y  + activeField!.frame.size.height+10 - kbSize1.origin.y ;
        
        if (kbSize1.intersects(changedTextfiledFrame))
        {
            
            UIView.animate(withDuration: 0.25, delay: 0, options: .curveLinear, animations: {
                
                self.viewScroll.setContentOffset(CGPoint.init(x: self.viewScroll.contentOffset.x, y: self.viewScroll.contentOffset.y + yupKeyoboard), animated: false)
                
            }, completion: nil)
        }
        else
        {
            
        }
        
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
        
        let string = "11:00 AM"
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        let date = formatter.date(from: string)
        
        dbDatePickerFromTiming.setDate(date!, animated: false)
        
        
    }
    
    @objc func datePickerValueChanged(sender:UIDatePicker)  {
        let dateFormatter = DateFormatter.init();
        
        dateFormatter.dateFormat = "hh:mm a"
        txtTime.text = dateFormatter.string(from: sender.date);
        
    }
    
    // MARK:  Textfield delegate
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        activeField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        activeField = nil
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let currentText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) else { return true }
        
        
        return true
    }
    
    
    
    
    // MARK:  Picker delegate and datasource
    
    func pickerViewSetUp()   {
        pickerView.delegate = self
        pickerView.dataSource = self
        txtStandardResponse.inputView = pickerView
        pickerView.showsSelectionIndicator = true;
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1;
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arrPicker.count;
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return arrPicker[row];
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        txtStandardResponse.text = arrPicker[row]
        txtView.text = txtStandardResponse.text
    }
}


