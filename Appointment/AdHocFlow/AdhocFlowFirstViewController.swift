//
//  AdhocFlowFirstViewController.swift
//  Appointment
//
//  Created by Anurag Bhakuni on 06/05/21.
//  Copyright © 2021 Anurag Bhakuni. All rights reserved.
//

import UIKit

class AdhocFlowFirstViewController: SuperViewController,UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate {
    
    
    
    
    
    func logicForSlotDurationTiming() -> Array<Dictionary<String,String>>{
        
        
        var arrSlot = Array<Dictionary<String,String>>()
        
        
        for view : ERStartEndTImeView in arrERStartEndTImeView{
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let dateI = dateFormatter.string(from: self.dateSelected)
            
            
            
            let startime = GeneralUtility.currentDateDetailType4(emiDate: view.txtStartTime.text!, fromDateF: "hh:mm a", toDateFormate: "HH:mm")
            let endTime = GeneralUtility.currentDateDetailType4(emiDate: view.txtEndTime.text!, fromDateF: "hh:mm a", toDateFormate: "HH:mm")
            
            let completeStartdate = dateI + " " + startime + ":00"
            let completeendDate = dateI + " " + endTime + ":00"
            
            let dicTime = ["start_datetime" : completeStartdate,
                           "end_datetime" : completeendDate
            ]
            
            arrSlot.append(dicTime);
            
        }
        
        return arrSlot
    }
    
    func logicforDuplicateSlotS() -> Int  {
        
        let selectedDuplicateSlot = self.arrtimeSlotDuplicateModal.filter({$0.isSelected == true})
        
        var id = 0
        if selectedDuplicateSlot.count > 0{
            id = selectedDuplicateSlot[0].id
        }
        return id
        
    }
    
    
    
    func formingModal() -> openHourModalSubmit {
        
        
        var objOpenHourModalSubmit = openHourModalSubmit()
        let arrApprovalProcess = ["Automatic Approval","Manual Approval"]
        let arrApprovalProcessI = ["automatic","manual"]
        let indexApppProcess = arrApprovalProcess.firstIndex(where: {$0 == txtApointmentType.text})
        objOpenHourModalSubmit.open_hours_appointment_approval_process = arrApprovalProcessI[indexApppProcess ?? 0]
        if isCustomSlotSelected {
            objOpenHourModalSubmit.slotArr = self.logicForSlotDurationTiming()
        }
        else{
            objOpenHourModalSubmit.selectedSlotID = logicforDuplicateSlotS()

        }
        return objOpenHourModalSubmit;
    }
    
    func  validatingForm() -> Bool {
        
        if nslayoutConstraintGroupLimitHeight.constant != 0 {
            
            if txtGroupLimit.text?.isEmpty ?? true{
                CommonFunctions().showError(title: "Error", message: StringConstants.GROUPLIMITERROR)
                return false
            }
            
            if (Int(txtGroupLimit.text ?? "0") ?? 0 > 15) || Int(txtGroupLimit.text ?? "0") ?? 0 <= 0 {
                CommonFunctions().showError(title: "Error", message: StringConstants.GROUPLIMITRANGEERROR)
                return false
            }
            
        }
        
        if isCustomSlotSelected{
            var isAllTimeSlotFilled = true;
            var isAlltimeValid = true
            
            for view in arrERStartEndTImeView{
                if view.isBothTimeField {
                }
                else{
                    isAllTimeSlotFilled = false
                    break;
                }
                
            }
            for view in arrERStartEndTImeView{
                if view.isTimeValid {
                }
                else{
                    isAlltimeValid = false
                    break;
                }
            }
            if !isAllTimeSlotFilled{
                CommonFunctions().showError(title: "Error", message: StringConstants.ERTIMESLOTERROR)
                return false
                
            }
            if !isAlltimeValid{
                CommonFunctions().showError(title: "Error", message: StringConstants.ERTIMESLOTERROR)
                return false
                
            }
            return true
        }
            
        else{
            
            if arrtimeSlotDuplicateModal.count > 0 {
                
            }
            else{
                CommonFunctions().showError(title: "Error", message: StringConstants.ERNOAVAILABELTIMESLOTERROR)
                return false
            }
            
            let deSelectID = self.arrtimeSlotDuplicateModal.filter({$0.isSelected == true})
            if  deSelectID.count > 0 {
                return true
            }
            CommonFunctions().showError(title: "Error", message: StringConstants.ERSELECTAVAILABELTIMESLOTERROR)
            
            return false
        }
        
        
    }
    @objc override func buttonClicked(sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func btnNextTapped(_ sender: Any) {
        if validatingForm(){
            let objAdhocFlowSecondViewController = AdhocFlowSecondViewController.init(nibName: "AdhocFlowSecondViewController", bundle: nil)
            objAdhocFlowSecondViewController.objOpenHourModalSubmit = self.formingModal()
         
            objAdhocFlowSecondViewController.dateSelected = self.dateSelected
            self.navigationController?.pushViewController(objAdhocFlowSecondViewController, animated: false)
        }
        
        
    }
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var viewHeader: UIView!
    var dateSelected : Date!
    var objERSideOPenHourModal : ERSideOPenHourModal?
    
    @IBOutlet weak var lblAppointmentType: UILabel!
    
    @IBOutlet weak var lblAddCustom: UILabel!
    @IBOutlet weak var txtApointmentType: LeftPaddedTextField!
    
    @IBOutlet weak var txtGroupLimit: LeftPaddedTextField!
    
    @IBOutlet weak var nslayoutConstraintGroupLimitHeight: NSLayoutConstraint!
    @IBOutlet weak var viewInner: UIView!
    @IBOutlet weak var viewOuter: UIView!
    @IBOutlet weak var viewScroll: UIScrollView!
    var activeField : UITextField?
    var keyBooradAlreadyShown = false
    var keyBoardHieght : CGFloat = 0.0;
    
    @IBOutlet weak var lblDate: UILabel!
    
    @IBOutlet weak var txtDateSelected: UITextField!
    
    @IBOutlet weak var btmDateSelected: UIButton!
    @IBOutlet weak var viewDuplicate2: UIView!
    
    @IBOutlet weak var lblAvailable: UILabel!
    let pickerView = UIPickerView()
    var PickerSelectedTag = 0;
    
    @IBOutlet weak var btnAvailable: UIButton!
    @IBAction func btnAvailableTapped(_ sender: Any) {
        isCustomSlotSelected = false
        
        if !isCustomSlotSelected {
            btnAvailable.setImage(UIImage.init(named: "Radio_filled"), for: .normal);
            btnAddCustomeSlot.setImage(UIImage.init(named: "Radio"), for: .normal);
            
        }
        else{
            btnAvailable.setImage(UIImage.init(named: "Radio"), for: .normal);
            btnAddCustomeSlot.setImage(UIImage.init(named: "Radio_filled"), for: .normal);
            
        }
        
    }
    var arrtimeSlotDuplicateModal = [timeSlotDuplicateModal]();
    var arrERStartEndTImeView = [ERStartEndTImeView]()
    var objERSideOpenHourPrefilledDetail: ERSideOpenHourDetail?
    
    @IBOutlet weak var viewAvailableSlot: UIView!
    
    @IBAction func btmDateSelectedTapped(_ sender: UIButton) {
        let frame = sender.convert(sender.frame, from:AppDelegate.getDelegate().window)
        let viewCalender = CalenderViewController.init(nibName: "CalenderViewController", bundle: nil)
        viewCalender.index = 1
        viewCalender.pointedArrow = false
        viewCalender.viewControllerI = self
        viewCalender.pointSign = CGPoint.init(x: abs(frame.origin.x) + abs(frame.size.width/2), y: abs(frame.origin.y) + abs(frame.size.height/2) + 10 )
        viewCalender.modalPresentationStyle = .overFullScreen
        self.present(viewCalender, animated: false) {
        }
        
    }
    
    var arrPicker = [String]();
    
    @IBOutlet weak var viewContainerStartEnd: UIView!
    
    @IBOutlet weak var lblAppointmentSlot: UILabel!
    
    @IBOutlet weak var btnAddCustomeSlot: UIButton!
    
    @IBAction func btnAddCustomeSlotTapped(_ sender: Any) {
        isCustomSlotSelected = true
        if isCustomSlotSelected {
            btnAddCustomeSlot.setImage(UIImage.init(named: "Radio_filled"), for: .normal);
            btnAvailable.setImage(UIImage.init(named: "Radio"), for: .normal);
        }
        else{
            btnAddCustomeSlot.setImage(UIImage.init(named: "Radio"), for: .normal);
            btnAvailable.setImage(UIImage.init(named: "Radio_filled"), for: .normal);
        }
    }
    
    //Timing
    
    @IBOutlet weak var lblTimingFrom: UILabel!
    @IBOutlet weak var lblTimingTo: UILabel!
    
    var isCustomSlotSelected = true
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewInner.isHidden = true
        callViewModal()
        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        GeneralUtility.customeNavigationBarWithOnlyBack(viewController: self, title: "Ad hoc Appointment")

    
        
    }
    
    func customization(){
        self.addInputAccessoryForTextFields(textFields: [txtApointmentType,txtGroupLimit], dismissable: true, previousNextable: true)
        
        
        
        customizeHeader()
        customizationAppointmentType()
        customizationTimeSlot()
        customizaTionAvailabeSlot()
        self.viewInner.isHidden = false
        
        
    }
    
    override func actnResignKeyboard() {
        activeField!.resignFirstResponder()
        
    }
    func callViewModal(){
        let csrftoken = UserDefaultsDataSource(key: "csrf_token").readData() as! String
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateStart = dateFormatter.string(from: dateSelected)
        var dateCompStartChange = DateComponents()
        dateCompStartChange.day = -1 ;
        let dateEnd = Calendar.current.date(byAdding: dateCompStartChange, to: dateSelected)!
        let dateEndStr = dateFormatter.string(from: dateEnd)
        dateFormatter.dateFormat = "HH:mm:ss"
        let appendDate = dateFormatter.string(from: Date())
        var localTimeZoneAbbreviation: String { return TimeZone.current.description }
        var   param = [
            ParamName.PARAMFILTERSEL : [
                "from": dateEndStr + " " + "18:30:00",
                "to": dateStart + " " + "18:29:59"
            ],
            

            ParamName.PARAMCSRFTOKEN : csrftoken,
            ParamName.PARAMMETHODKEY : "post"
            ] as [String : AnyObject]
        let activityIndicator = ActivityIndicatorView.showActivity(view: self.view, message: StringConstants.FetchingCoachSelection)
        
        ERSideAppointmentService().erSideOpenHourListApi(params: param, { (jsonData) in
            activityIndicator.hide()
            do {
                self.objERSideOPenHourModal = try
                    JSONDecoder().decode(ERSideOPenHourModal.self, from: jsonData)
                self.customization()
            } catch   {
                print(error)
            }
        }) { (error, errorCode) in
            activityIndicator.hide()
            
        }
        
    }
    
}


// MARK: Header.

extension AdhocFlowFirstViewController{
    
    func customizeHeader(){
        
        if let fontHeavy = UIFont(name: "FontHeavy".localized(), size: Device.FONTSIZETYPE14), let fontBook =  UIFont(name: "FontBook".localized(), size: Device.FONTSIZETYPE14)
            
        {
            let strHeader = NSMutableAttributedString.init()
            let strTiTle = NSAttributedString.init(string: "Step 1"
                , attributes: [NSAttributedString.Key.foregroundColor : ILColor.color(index:40),NSAttributedString.Key.font : fontHeavy]);
            let strType = NSAttributedString.init(string: " of 2"
                , attributes: [NSAttributedString.Key.foregroundColor : ILColor.color(index: 40),NSAttributedString.Key.font : fontBook]);
            let para = NSMutableParagraphStyle.init()
            //            para.alignment = .center
            para.lineSpacing = 4
            strHeader.append(strTiTle)
            strHeader.append(strType)
            strHeader.addAttribute(NSAttributedString.Key.paragraphStyle, value: para, range: NSMakeRange(0, strHeader.length))
            lblHeader.attributedText = strHeader
            UIButton.buttonUIHandling(button: btnNext, text: "Next", backgroundColor: .clear, textColor: ILColor.color(index: 23),  fontType: fontHeavy)
        }
        
        if let fontHeavy = UIFont(name: "FontHeavy".localized(), size: Device.FONTSIZETYPE12)
        {
            let strHeader = NSMutableAttributedString.init()
            let strTiTle = NSAttributedString.init(string: " Set Date"
                , attributes: [NSAttributedString.Key.foregroundColor : ILColor.color(index: 31),NSAttributedString.Key.font : fontHeavy]);
            let strType = NSAttributedString.init(string: "  ⃰"
                , attributes: [NSAttributedString.Key.foregroundColor : UIColor.red,NSAttributedString.Key.font : fontHeavy]);
            let para = NSMutableParagraphStyle.init()
            //            para.alignment = .center
            strHeader.append(strTiTle)
            strHeader.append(strType)
            
            strHeader.addAttribute(NSAttributedString.Key.paragraphStyle, value: para, range: NSMakeRange(0, strHeader.length))
            lblDate.attributedText = strHeader
        }
        let fontMedium = UIFont(name: "FontMediumWithoutNext".localized(), size: Device.FONTSIZETYPE13)
        txtDateSelected.backgroundColor = ILColor.color(index: 48)
        self.txtDateSelected.font = fontMedium
        self.txtDateSelected.layer.cornerRadius = 3;
        let imageView3 = UIImageView.init(image: UIImage.init(named: "Calendar-1"))
        imageView3.frame = CGRect(x: 0.0, y: 0.0, width: 20, height: 20)
        self.txtDateSelected.leftView = imageView3
        txtDateSelected.leftViewMode = .always;
        let fontDateRe = UIFont(name: "FontRegular".localized(), size: Device.FONTSIZETYPE13)
        self.txtDateSelected.layer.borderColor = ILColor.color(index: 27).cgColor
        self.txtDateSelected.layer.borderWidth = 1;
        
        txtDateSelected.attributedPlaceholder = NSAttributedString(string: "DD/MM/YYYY", attributes: [
            .foregroundColor: ILColor.color(index: 40),
            .font: fontDateRe
        ])
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateConverted = dateFormatter.string(from: self.dateSelected)
        
        let dateSelectedValue =     GeneralUtility.currentDateDetailType4(emiDate:dateConverted , fromDateF: "yyyy-MM-dd HH:mm:ss", toDateFormate: "dd/MM/yyyy")
        txtDateSelected.text = dateSelectedValue
        
    }
    
}



// MARK: Appointment Type.

extension AdhocFlowFirstViewController
{
    
    func customizationAppointmentType(){
        pickerViewSetUp(txtInput: txtApointmentType, tag: 194)
        let fontHeavy = UIFont(name: "FontHeavy".localized(), size: Device.FONTSIZETYPE12)
        UILabel.labelUIHandling(label: lblAppointmentType, text: "Appointment Type", textColor: ILColor.color(index: 40), isBold: false, fontType: fontHeavy)
        let fontMedium = UIFont(name: "FontMediumWithoutNext".localized(), size: Device.FONTSIZETYPE13)
        txtApointmentType.backgroundColor = ILColor.color(index: 48)
        self.txtApointmentType.font = fontMedium
        self.txtApointmentType.layer.borderColor = ILColor.color(index: 27).cgColor
        self.txtApointmentType.layer.borderWidth = 1;
        self.txtApointmentType.layer.cornerRadius = 3;
        self.txtApointmentType.text = "1 on 1 Appointment"
        self.txtApointmentType.rightView = UIImageView.init(image: UIImage.init(named: "Drop-down_arrow"))
        txtApointmentType.rightViewMode = .always;
        
        txtGroupLimit.isHidden = true
        nslayoutConstraintGroupLimitHeight.constant = 0
        self.txtGroupLimit.font = fontMedium
        self.txtGroupLimit.layer.borderColor = ILColor.color(index: 27).cgColor
        self.txtGroupLimit.layer.borderWidth = 1;
        self.txtGroupLimit.layer.cornerRadius = 3;
        self.txtGroupLimit.placeholder = "Enter Participants Limit"
        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        registerForKeyboardNotifications()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        deRegisterKeyboardNotifications()
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
        
        self.viewInner.layoutIfNeeded()
        self.viewScroll.contentSize = CGSize.init(width: self.viewScroll.contentSize.width, height:  self.viewInner.frame.height)
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
    
    
    
    // MARK:  Textfield delegate
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        arrPicker = ["1 on 1 Appointment","Group Appointment"]
        PickerSelectedTag = 194;
        let pickerSelected = self.arrPicker.firstIndex(where: {$0 == textField.text}) ?? 0
        pickerView.selectRow(pickerSelected, inComponent: 0, animated: false)
        pickerView.reloadAllComponents()
        activeField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        activeField = nil
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let currentText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) else { return true }
        
        //         if  textField == txtRepeatCount || textField == txtOccurenceCount{
        //
        //             if currentText.count > 4 {
        //                 return false
        //             }
        //
        //         }
        return true
    }
    
    
    // MARK:  Picker delegate and datasource
    
    func pickerViewSetUp(txtInput : UITextField,tag : Int)   {
        
        txtInput.tag = tag
        pickerView.tag = tag
        pickerView.delegate = self
        pickerView.dataSource = self
        txtInput.inputView = pickerView
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
        
        if PickerSelectedTag == 194{
            arrPicker = ["1 on 1 Appointment","Group Appointment"]
            txtApointmentType.text = arrPicker[row]
            if row == 0{
                txtGroupLimit.isHidden = true
                nslayoutConstraintGroupLimitHeight.constant = 0
            }
            else{
                txtGroupLimit.isHidden = false
                nslayoutConstraintGroupLimitHeight.constant = 50
            }
        }
    }
    
    
    
    
}

extension AdhocFlowFirstViewController: CalenderViewDelegate{
    func dateSelected(calenderModal: CalenderModal, index: Int) {
        let dateInRequiredFormate =     GeneralUtility.currentDateDetailType4(emiDate: calenderModal.StrDate!, fromDateF: "yyyy-MM-dd", toDateFormate: "dd/MM/yyyy")
        txtDateSelected.text = dateInRequiredFormate
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateSelected = dateFormatter.date(from: calenderModal.StrDate!)!
        callViewModal();
        
    }
    
    
}


// MARK: StartAndEndTime View


extension AdhocFlowFirstViewController:DeleteParticularStartTimeViewDelegate,RefreshSelectedTimeSlotDelegate {
   
    
    func customizationTimeSlot(){
        let fontHeavy = UIFont(name: "FontHeavy".localized(), size: Device.FONTSIZETYPE12)
        let fontBook =  UIFont(name: "FontBook".localized(), size: Device.FONTSIZETYPE12)
        
        UILabel.labelUIHandling(label: lblAppointmentSlot, text: "Appointment Slot", textColor: ILColor.color(index: 40), isBold: true, fontType: fontHeavy)
        UILabel.labelUIHandling(label: lblAddCustom, text: "Add Custom Slot", textColor: ILColor.color(index: 42), isBold: true, fontType: fontBook)
        let fontHeavy1 = UIFont(name: "FontHeavy".localized(), size: Device.FONTSIZETYPE15)
        
        if let fontHeavy = UIFont(name: "FontHeavy".localized(), size: Device.FONTSIZETYPE15)
        {
            let strHeader = NSMutableAttributedString.init()
            let strTiTle = NSAttributedString.init(string: "Start Time"
                , attributes: [NSAttributedString.Key.foregroundColor : ILColor.color(index: 31),NSAttributedString.Key.font : fontHeavy]);
            let strType = NSAttributedString.init(string: "  ⃰"
                , attributes: [NSAttributedString.Key.foregroundColor : UIColor.red,NSAttributedString.Key.font : fontHeavy]);
            let para = NSMutableParagraphStyle.init()
            //            para.alignment = .center
            strHeader.append(strTiTle)
            strHeader.append(strType)
            
            strHeader.addAttribute(NSAttributedString.Key.paragraphStyle, value: para, range: NSMakeRange(0, strHeader.length))
            lblTimingFrom.attributedText = strHeader
        }
        if let fontHeavy = UIFont(name: "FontHeavy".localized(), size: Device.FONTSIZETYPE15)
        {
            let strHeader = NSMutableAttributedString.init()
            let strTiTle = NSAttributedString.init(string: "End Time"
                , attributes: [NSAttributedString.Key.foregroundColor : ILColor.color(index: 31),NSAttributedString.Key.font : fontHeavy]);
            let strType = NSAttributedString.init(string: "  ⃰"
                , attributes: [NSAttributedString.Key.foregroundColor : UIColor.red,NSAttributedString.Key.font : fontHeavy]);
            let para = NSMutableParagraphStyle.init()
            //            para.alignment = .center
            strHeader.append(strTiTle)
            strHeader.append(strType)
            
            strHeader.addAttribute(NSAttributedString.Key.paragraphStyle, value: para, range: NSMakeRange(0, strHeader.length))
            lblTimingTo.attributedText = strHeader
        }
       
        btnAddCustomeSlot.setImage(UIImage.init(named: "Radio_filled"), for: .normal)
        self.configureStartEndView(isnewlyAdded: true)

    }
    
    
    
    func refreshSelectedTS(id:Int,isSelected: Bool) {
        
  
        let deSelectID = self.arrtimeSlotDuplicateModal.filter({$0.isSelected == true})
        if deSelectID.count ?? 0 > 0{
            var deSelect = deSelectID[0]
            let index = self.arrtimeSlotDuplicateModal.firstIndex(where: {$0.isSelected == true}) ?? 0
            self.arrtimeSlotDuplicateModal.removeAll(where: {$0.isSelected == true})
            deSelect.isSelected = false
            self.arrtimeSlotDuplicateModal.insert(deSelect, at: index)
            
        }
        var selectedId = self.arrtimeSlotDuplicateModal.filter({$0.id == id})[0]
        selectedId.isSelected = true
        let index = self.arrtimeSlotDuplicateModal.firstIndex(where: {$0.id == id}) ?? 0
        self.arrtimeSlotDuplicateModal.removeAll(where: {$0.id == id})
        self.arrtimeSlotDuplicateModal.insert(selectedId, at: index)
        
        timeSlotDuplicate()
    }
    
    func customizaTionAvailabeSlot(){
       let fontBook =  UIFont(name: "FontBook".localized(), size: Device.FONTSIZETYPE12)

        UILabel.labelUIHandling(label: lblAvailable, text: "Select from Available slots", textColor: ILColor.color(index: 42), isBold: true, fontType: fontBook)
        timeSlotModal()
        timeSlotDuplicate()
          btnAvailable.setImage(UIImage.init(named: "Radio"), for: .normal);
    }
    
    
    func timeSlotModal() {
        arrtimeSlotDuplicateModal = [timeSlotDuplicateModal]();
        for modaloH in (self.objERSideOPenHourModal?.results)!{
            var objtimeSlotDuplicateModal = timeSlotDuplicateModal()
            objtimeSlotDuplicateModal.id = modaloH.id
            let startTime = GeneralUtility.dateConvertToUTCDuplicate(emiDate: modaloH.startDatetimeUTC ?? "", withDateFormat: "yyyy-MM-dd HH:mm:ss", todateFormat: "hh:mm a");
            let endTime = GeneralUtility.dateConvertToUTCDuplicate(emiDate: modaloH.endDatetimeUTC ?? "", withDateFormat: "yyyy-MM-dd HH:mm:ss", todateFormat: "hh:mm a");
            objtimeSlotDuplicateModal.timeStart = startTime
            objtimeSlotDuplicateModal.timeEnd = endTime
            arrtimeSlotDuplicateModal.append(objtimeSlotDuplicateModal)
        }
    }
    
    func timeSlotDuplicate(){
        
        var viewPrevious : UIView?
        for view  in  self.viewAvailableSlot.subviews{
            view.removeFromSuperview()
        }
        for objTimeslot in arrtimeSlotDuplicateModal{
            let objERSideTimeSlotDuplicate =  ERSideTimeSlotDuplicate().loadView() as! ERSideTimeSlotDuplicate
            objERSideTimeSlotDuplicate.viewconTroller = self
            objERSideTimeSlotDuplicate.objStudentListType = .One2OneType
            objERSideTimeSlotDuplicate.delegate = self
            objERSideTimeSlotDuplicate.objtimeSlotDuplicateModal = objTimeslot
            objERSideTimeSlotDuplicate.translatesAutoresizingMaskIntoConstraints = false
            objERSideTimeSlotDuplicate.customization()
            self.viewAvailableSlot.addSubview(objERSideTimeSlotDuplicate)
            if viewPrevious == nil{
                
                viewAvailableSlot.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[view]-0-|", options: NSLayoutConstraint.FormatOptions(rawValue : 0), metrics: nil, views: ["view" :objERSideTimeSlotDuplicate ]))
                
                viewAvailableSlot.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[view(==34)]", options: NSLayoutConstraint.FormatOptions(rawValue : 0), metrics: nil, views: ["view" :objERSideTimeSlotDuplicate ]))
                
            }
            else{
                viewAvailableSlot.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[view]-0-|", options: NSLayoutConstraint.FormatOptions(rawValue : 0), metrics: nil, views: ["view" :objERSideTimeSlotDuplicate ]))
                
                viewAvailableSlot.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[viewPrevious]-4-[view(==34)]", options: NSLayoutConstraint.FormatOptions(rawValue : 0), metrics: nil, views: ["viewPrevious":viewPrevious!,"view" :objERSideTimeSlotDuplicate ]))
                
            }
            viewPrevious = objERSideTimeSlotDuplicate
        }
        if viewPrevious != nil{
            viewAvailableSlot.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[viewPrevious(==34)]-(4)-|", options: NSLayoutConstraint.FormatOptions(rawValue : 0), metrics: nil, views: ["viewPrevious":viewPrevious!]))
        }
        
    }

    
    
    
    
    
   
    func deleteViewWith(tag: Int) {
        if self.arrERStartEndTImeView.count <= 1{
            
        }
        else{
            let index = self.arrERStartEndTImeView.firstIndex(where: {$0.tag == tag}) ?? 0
            self.arrERStartEndTImeView.removeAll(where: { $0.tag == tag})
//            self.arrDataStartEndTimeView.remove(at: index)
            deleteStartEndView();
        }
    }
    
    func  deleteStartEndView(){
        if arrERStartEndTImeView.count != 0{
            for view  in  self.viewContainerStartEnd.subviews{
                view.removeFromSuperview()
            }
            var index = 1
            var viewPrevious : UIView!
            for viewAlreadyAdded in self.arrERStartEndTImeView{
                viewAlreadyAdded.tag = index
                viewAlreadyAdded.viewconTroller = self
                viewAlreadyAdded.delegate = self
                viewAlreadyAdded.tag = index
                viewAlreadyAdded.btnDelete.tag = index;
//                viewAlreadyAdded.dicstartTime = arrDataStartEndTimeView[index]
//                viewAlreadyAdded.customization()
                viewAlreadyAdded.translatesAutoresizingMaskIntoConstraints = false
                self.viewContainerStartEnd.addSubview(viewAlreadyAdded)
                if index == 1{
                    viewContainerStartEnd.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[view]-0-|", options: NSLayoutConstraint.FormatOptions(rawValue : 0), metrics: nil, views: ["view" :viewAlreadyAdded ]))
                    if arrERStartEndTImeView.count == 1{
                        viewContainerStartEnd.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[view]-0-|", options: NSLayoutConstraint.FormatOptions(rawValue : 0), metrics: nil, views: ["view" :viewAlreadyAdded ]))
                    }
                    else{
                        viewContainerStartEnd.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[view]", options: NSLayoutConstraint.FormatOptions(rawValue : 0), metrics: nil, views: ["view" :viewAlreadyAdded ]))
                    }
                }
                else if index == self.arrERStartEndTImeView.count{
                    viewContainerStartEnd.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[view]-0-|", options: NSLayoutConstraint.FormatOptions(rawValue : 0), metrics: nil, views: ["view" :viewAlreadyAdded ]))
                    viewContainerStartEnd.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[viewPrevious]-4-[view]-(0)-|", options: NSLayoutConstraint.FormatOptions(rawValue : 0), metrics: nil, views: ["viewPrevious":viewPrevious!,"view" :viewAlreadyAdded ]))
                }
                else{
                    viewContainerStartEnd.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[view]-0-|", options: NSLayoutConstraint.FormatOptions(rawValue : 0), metrics: nil, views: ["view" :viewAlreadyAdded ]))
                    
                    viewContainerStartEnd.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[viewPrevious]-4-[view]", options: NSLayoutConstraint.FormatOptions(rawValue : 0), metrics: nil, views: ["viewPrevious":viewPrevious!,"view" :viewAlreadyAdded ]))
                }
                index = index + 1
                viewPrevious = viewAlreadyAdded
            }
        }
        viewContainerStartEnd.layoutIfNeeded()
        
    }
        
    func  configureStartEndView(isnewlyAdded : Bool){
        arrERStartEndTImeView = [ERStartEndTImeView]()
        let  arrPickerI = ["15 mins","30 mins","45 mins","60 mins","custom"]
        
        if arrERStartEndTImeView.count != 0{
            for view  in  self.viewContainerStartEnd.subviews{
                view.removeFromSuperview()
            }
            
            var index = 1
            var viewPrevious : UIView!
            for viewAlreadyAdded in self.arrERStartEndTImeView{
                viewAlreadyAdded.translatesAutoresizingMaskIntoConstraints = false
                self.viewContainerStartEnd.addSubview(viewAlreadyAdded)
                viewAlreadyAdded.noDeleteBtn = true
                let indexSelected = arrPickerI.firstIndex(where: {$0 == "custom"})
                viewAlreadyAdded.objtimeDifference =  timeDifference(rawValue: Int(indexSelected ?? 0))
                if index == 1{
                    
                    viewContainerStartEnd.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[view]-0-|", options: NSLayoutConstraint.FormatOptions(rawValue : 0), metrics: nil, views: ["view" :viewAlreadyAdded ]))
                    
                    viewContainerStartEnd.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[view]", options: NSLayoutConstraint.FormatOptions(rawValue : 0), metrics: nil, views: ["view" :viewAlreadyAdded ]))
                    
                }
                else{
                    viewContainerStartEnd.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[view]-0-|", options: NSLayoutConstraint.FormatOptions(rawValue : 0), metrics: nil, views: ["view" :viewAlreadyAdded ]))
                    
                    viewContainerStartEnd.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[viewPrevious]-4-[view]", options: NSLayoutConstraint.FormatOptions(rawValue : 0), metrics: nil, views: ["viewPrevious":viewPrevious!,"view" :viewAlreadyAdded ]))
                    
                }
                index = index + 1
                viewPrevious = viewAlreadyAdded
            }
            
            if isnewlyAdded {
                let startEndTime = ERStartEndTImeView().loadView() as! ERStartEndTImeView
                startEndTime.noDeleteBtn = true
                startEndTime.viewconTroller = self
                startEndTime.delegate = self
                let indexSelected = arrPickerI.firstIndex(where: {$0 == "custom"})
                startEndTime.objtimeDifference =  timeDifference(rawValue: Int(indexSelected ?? 0))
                startEndTime.translatesAutoresizingMaskIntoConstraints = false
                startEndTime.tag = index
                startEndTime.btnDelete.tag = index
                
                startEndTime.customization()
                self.viewContainerStartEnd.addSubview(startEndTime)
                viewContainerStartEnd.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[view]-0-|", options: NSLayoutConstraint.FormatOptions(rawValue : 0), metrics: nil, views: ["view" :startEndTime ]))
                viewContainerStartEnd.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[viewPrevious]-(4)-[view]-0-|", options: NSLayoutConstraint.FormatOptions(rawValue : 0), metrics: nil, views: ["viewPrevious":viewPrevious!,"view" :startEndTime ]))
                self.addInputAccessoryForTextFields(textFields: [startEndTime.txtStartTime,startEndTime.txtEndTime], dismissable: true, previousNextable: true)
                arrERStartEndTImeView.append(startEndTime)
            }
            else
            {
                viewContainerStartEnd.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[viewPrevious]-0-|", options: NSLayoutConstraint.FormatOptions(rawValue : 0), metrics: nil, views: ["viewPrevious":viewPrevious!]))
                
            }
        }
        else{
            
            if isnewlyAdded {
                let startEndTime = ERStartEndTImeView().loadView() as! ERStartEndTImeView
                startEndTime.tag = 1
                startEndTime.noDeleteBtn = true
                
                startEndTime.btnDelete.tag = 1
                startEndTime.delegate = self
                startEndTime.viewconTroller = self
                startEndTime.customization()
                let indexSelected = arrPickerI.firstIndex(where: {$0 == "custom"})
                startEndTime.objtimeDifference =  timeDifference(rawValue: Int(indexSelected ?? 0))
                startEndTime.translatesAutoresizingMaskIntoConstraints = false
                self.viewContainerStartEnd.addSubview(startEndTime)
                viewContainerStartEnd.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[view]-0-|", options: NSLayoutConstraint.FormatOptions(rawValue : 0), metrics: nil, views: ["view" :startEndTime ]))
                viewContainerStartEnd.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[view]-0-|", options: NSLayoutConstraint.FormatOptions(rawValue : 0), metrics: nil, views: ["view" :startEndTime ]))
                self.addInputAccessoryForTextFields(textFields: [startEndTime.txtStartTime,startEndTime.txtEndTime], dismissable: true, previousNextable: true)
                if self.objERSideOpenHourPrefilledDetail != nil{
                    startEndTime.txtStartTime.text = (GeneralUtility.currentDateDetailType3(emiDate: self.objERSideOpenHourPrefilledDetail?.startDatetimeUTC ?? "12:00 PM "))
                    startEndTime.txtEndTime.text = (GeneralUtility.currentDateDetailType3(emiDate: self.objERSideOpenHourPrefilledDetail?.endDatetimeUTC ?? "12:00 PM "))
                    startEndTime.isTimeValid = true
                    startEndTime.isBothTimeField = true
                }
                arrERStartEndTImeView.append(startEndTime)
            }
        }
        viewContainerStartEnd.layoutIfNeeded()
        
    }
}
