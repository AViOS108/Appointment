//
//  AddBlackOutDateVC.swift
//  Appointment
//
//  Created by Anurag Bhakuni on 09/11/21.
//  Copyright © 2021 Anurag Bhakuni. All rights reserved.
//

import UIKit

class AddBlackOutDateVC: SuperViewController,UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate {

    @IBOutlet weak var viewOuter: UIView!
    @IBOutlet weak var viewInner: UIView!
    @IBOutlet weak var viewScroll: UIScrollView!
    @IBOutlet weak var viewContainer: UIView!

    @IBOutlet weak var lblTimeZone: UILabel!
    @IBOutlet weak var txtTimeZone: LeftPaddedTextField!
    var dateSelected : Date!
    var reasonId = 1
    var isStartTimeView = true

    @IBOutlet weak var lblBlackOutTime: UILabel!
    @IBOutlet weak var txtBlackOutTime: LeftPaddedTextField!
    
    @IBOutlet weak var viewSelectDay: UIView!
    
    
    @IBOutlet weak var btnAddTime: UIButton!
    
    
    @IBOutlet weak var lblReasonBlackout: UILabel!
    
    @IBOutlet weak var txtReasonBlackout: LeftPaddedTextField!
    @IBOutlet weak var btnSubmit: UIButton!
    
    
    @IBAction func btnSubmitTapped(_ sender: UIButton) {
    
        if validation(){
            
            let csrftoken = UserDefaultsDataSource(key: "csrf_token").readData() as! String
            var localTimeZoneAbbreviation: String { return TimeZone.current.description }

            var span =  Array<Dictionary<String,String>>()
            for time in self.arrtimeSlotDuplicateModal{
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd MMM, yyyy hh:mm a"
                var dateStart =   dateFormatter.date(from: time.timeStart)
                
                let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: dateStart)

                let dicSpanTime = ["start_datetime_utc" :  GeneralUtility.dateConvertToUTC(emiDate: time.timeStart, withDateFormat: "dd MMM, yyyy hh:mm a", todateFormat: "YYYY-MM-DD HH:mm:ss") ,
                           "end_datetime_utc" : GeneralUtility.dateConvertToUTC(emiDate: tomorrow, withDateFormat: "dd MMM, yyyy hh:mm a", todateFormat: "YYYY-MM-DD HH:mm:ss") ]
                span.append(dicSpanTime)
                
            }
            var span_type = ""
            if isFullDay{
                span_type = "date_range"
            }
            else{
                span_type = "time_range"
            }
            let params = [
                "_method":"post",
                "reason_id": reasonId,
                "activities" : ["appointment"],
                "span_type" : span_type,
                "timezone" : localTimeZoneAbbreviation,
                "spans" : span,
                ParamName.PARAMCSRFTOKEN : csrftoken] as [String : AnyObject]
            
            
            
            let objAddBlackOutViewModal = AddBlackOutViewModal()
            activityView = ActivityIndicatorView.showActivity(view: self.view, message: StringConstants.FetchingCoachSelection)

            objAddBlackOutViewModal.createManySpans(params: params) { data in
                
            } failure: { codeError,codeInt in
                
            }
        }
        
    
    }
    
    
    func validation()-> Bool{
        
        if isFullDay{
            
        }
        else{
            
            var  isInValid = false
            for date in self.arrtimeSlotDuplicateModal{
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                let dateStart = dateFormatter.date(from: date.timeStart!)
                let dateEnd = dateFormatter.date(from: date.timeEnd!)

                if dateEnd != nil && dateStart != nil{
                    if dateEnd! <= dateStart!{
                        isInValid = true
                        break;
                    }
                }
            }
            
            if isInValid{
                CommonFunctions().showError(title: "Error", message: StringConstants.ERRDATEBLACKOUT);
                return false
            }

        }
        
        return true
    }
    
    var arrtimeSlotDuplicateModal = [timeSlotDuplicateModal]();
    var objtimeSlotDuplicateSelectedModal : timeSlotDuplicateModal!
    var objAddBlackOutModal : AddBlackOutModal!
    var   timeZoneViewController : TimeZoneViewController!
    var timeZOneArr = [TimeZoneSel]()
    var dashBoardViewModal = DashBoardViewModel()
    var selectedTextZone = ""

    var activeField : UITextField?
    var keyBooradAlreadyShown = false
    var keyBoardHieght : CGFloat = 0.0;
    var arrPicker = [String]();
    let pickerView = UIPickerView()
    var PickerSelectedTag = 0;
    var activityView: ActivityIndicatorView?
    var index = 1
    var isFullDay = true
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


    
    override func viewDidAppear(_ animated: Bool) {
        
        if dateSelected == nil{
            dateSelected = Date()
        }
        
        
        dashBoardViewModal.viewController = self
        viewInner.isHidden = true
        dashBoardViewModal.fetchTimeZoneCall { (timeArr) in
            self.timeZOneArr = timeArr
            self.callViewModal()
        }
        registerForKeyboardNotifications()
        
        self.addInputAccessoryForTextFields(textFields: [txtBlackOutTime], dismissable: true, previousNextable: true)
        self.addInputAccessoryForTextFields(textFields: [txtReasonBlackout], dismissable: true, previousNextable: true)
        self.viewInner.backgroundColor = ILColor.color(index: 22)
        viewContainer.cornerRadius = 3.0
        viewContainer.backgroundColor = .white
        GeneralUtility.customeNavigationBarWithOnlyBack(viewController: self,title:"Add Blackout Date");
    }
    
    
    @objc override func buttonClicked(sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: false)
    }
    
    override func actnResignKeyboard() {
        activeField!.resignFirstResponder()
    }
    
    func callViewModal(){
        
        let objAddBlackOutViewModal = AddBlackOutViewModal()
        activityView = ActivityIndicatorView.showActivity(view: self.view, message: StringConstants.FetchingCoachSelection)

        objAddBlackOutViewModal.callReasonList(params: ["" : ""] as Dictionary<String, AnyObject>, { (response) in
            self.objAddBlackOutModal = response;
            self.viewInner.isHidden = false
            self.customization()
            self.activityView?.hide()
        }) { (error, errorCode) in
            CommonFunctions().showError(title: "Error", message: StringConstants.userVerifyError);
        }

    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        deRegisterKeyboardNotifications()
    }

    func customization(){
        
        setTimeZoneTextField()
        customizationBlackOutType()
        customizationBlackOutReason()
        customizationBlackOutTime()
    }
    
  
    
}

// BLACKOUTTIME
extension AddBlackOutDateVC  : ERSideTimeSlotBlackOutDelegate, CalenderViewDelegate {
    
  
    func dateSelected(calenderModal: CalenderModal, index: Int) {
        
        let index = self.arrtimeSlotDuplicateModal.firstIndex(where: {$0.id ==   self.objtimeSlotDuplicateSelectedModal.id}) ?? 0
        var selected = self.arrtimeSlotDuplicateModal[index]
        self.arrtimeSlotDuplicateModal.remove(at: index)
        
        if self.objtimeSlotDuplicateSelectedModal.isSelected{
            
            let dateInRequiredFormate =     GeneralUtility.currentDateDetailType4(emiDate: calenderModal.StrDate!, fromDateF: "yyyy-MM-dd", toDateFormate: "dd MMM, yyyy")
            selected.timeStart = dateInRequiredFormate
            
        }
        else{
            
            if self.isStartTimeView {
                
                let dateInRequiredFormate =     GeneralUtility.currentDateDetailType4(emiDate: calenderModal.StrDate!, fromDateF: "yyyy-MM-dd", toDateFormate: "dd MMM, yyyy")
                let dateTimeAMPM =     GeneralUtility.currentDateDetailType4(emiDate: self.objtimeSlotDuplicateSelectedModal.timeStart, fromDateF: "dd MMM, YYYY hh:mm a", toDateFormate: "hh:mm a")
                selected.timeStart = dateInRequiredFormate + " " + dateTimeAMPM
            }
            else{
                
                let dateInRequiredFormate =     GeneralUtility.currentDateDetailType4(emiDate: calenderModal.StrDate!, fromDateF: "yyyy-MM-dd", toDateFormate: "dd MMM, yyyy")
                let dateTimeAMPM =     GeneralUtility.currentDateDetailType4(emiDate: self.objtimeSlotDuplicateSelectedModal.timeEnd, fromDateF: "dd MMM, YYYY hh:mm a", toDateFormate: "hh:mm a")
                selected.timeEnd = dateInRequiredFormate + " " + dateTimeAMPM
                
            }
            
        }
        self.arrtimeSlotDuplicateModal.insert(selected, at: index)
        
        if isFullDay{
            createDateAndTimeViewDay()
        }
        else{
            createDateAndTimeViewSlot()
        }
        
    }
    
    func dateSelectedTimeSlot(objtimeSlotDuplicateModal: timeSlotDuplicateModal, isStartTimeView: Bool, sendTime: Bool) {

        self.objtimeSlotDuplicateSelectedModal = objtimeSlotDuplicateModal
        self.isStartTimeView = isStartTimeView;

        if self.objtimeSlotDuplicateSelectedModal.isSelected{
         
        }
        else{
            if sendTime {
                
                let index = self.arrtimeSlotDuplicateModal.firstIndex(where: {$0.id ==   self.objtimeSlotDuplicateSelectedModal.id}) ?? 0
                var timeSlotDuplicateSelectedModal = self.arrtimeSlotDuplicateModal[index]
                if isStartTimeView{
                    timeSlotDuplicateSelectedModal.timeStart = objtimeSlotDuplicateModal.timeStart
                }
                else{
                    timeSlotDuplicateSelectedModal.timeEnd = objtimeSlotDuplicateModal.timeEnd
                }
                self.arrtimeSlotDuplicateModal.remove(at: index)
                self.arrtimeSlotDuplicateModal.insert( timeSlotDuplicateSelectedModal, at: index)
                
            }
        }
        
        if isFullDay{
            createDateAndTimeViewDay()
        }
        else{
            createDateAndTimeViewSlot()
        }
        
    }
    
    
    func deleteErSideTimeSlot(objtimeSlotDuplicateModal: timeSlotDuplicateModal) {

        self.objtimeSlotDuplicateSelectedModal = objtimeSlotDuplicateModal
        if self.arrtimeSlotDuplicateModal.count > 1 {
            self.arrtimeSlotDuplicateModal.removeAll(where: {$0.id == objtimeSlotDuplicateModal.id})
            if isFullDay{
                createDateAndTimeViewDay()
            }
            else{
                createDateAndTimeViewSlot()
            }
        }
    }
    
    
    func customizationBlackOutTime()  {
        
       
        let fontMedium = UIFont(name: "FontMediumWithoutNext".localized(), size: Device.FONTSIZETYPE12)
        UIButton.buttonUIHandling(button: btnAddTime, text: "+ Add new date(s)", backgroundColor: .clear, textColor: ILColor.color(index: 23), fontType: fontMedium)
        timeSlotModalDay()
        createDateAndTimeViewDay()
    }
    
    
    func resetAll(){
        arrtimeSlotDuplicateModal.removeAll()
    }
    
    
    func timeSlotModalDay() {
        var objtimeSlotDuplicateModal = timeSlotDuplicateModal()
        objtimeSlotDuplicateModal.id = index
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.string(from: dateSelected)
        let startTime = GeneralUtility.dateConvertToUTC(emiDate: date , withDateFormat: "yyyy-MM-dd HH:mm:ss", todateFormat: "dd MMM, YYYY");
        objtimeSlotDuplicateModal.timeStart = startTime
        objtimeSlotDuplicateModal.isSelected = true
        arrtimeSlotDuplicateModal.append(objtimeSlotDuplicateModal)
    }
    
    func timeSlotModalTime() {
        var objtimeSlotDuplicateModal = timeSlotDuplicateModal()
        objtimeSlotDuplicateModal.id = index
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.string(from: dateSelected)
        let startTime = GeneralUtility.dateConvertToUTC(emiDate: date , withDateFormat: "yyyy-MM-dd HH:mm:ss", todateFormat: "dd MMM, YYYY hh:mm a");
        objtimeSlotDuplicateModal.timeStart = startTime
        objtimeSlotDuplicateModal.timeEnd = startTime
        objtimeSlotDuplicateModal.isSelected = false
        arrtimeSlotDuplicateModal.append(objtimeSlotDuplicateModal)
    }
    
    
    
    func innerTimeSlotView(objtimeSlotDuplicateModal : timeSlotDuplicateModal) -> UIView{
        
        let insideView = UIView()
        let objERSideTimeSlotDuplicate =  ERSideTimeSlotBlackOut().loadView() as! ERSideTimeSlotBlackOut
        objERSideTimeSlotDuplicate.viewconTroller = self
        objERSideTimeSlotDuplicate.objtimeSlotDuplicateModal = objtimeSlotDuplicateModal
        objERSideTimeSlotDuplicate.delegate = self
        objERSideTimeSlotDuplicate.lblHeading.text = "Start Date & Time"
        objERSideTimeSlotDuplicate.isStartTimeView = true
        objERSideTimeSlotDuplicate.translatesAutoresizingMaskIntoConstraints = false
        objERSideTimeSlotDuplicate.customization()
        insideView.addSubview(objERSideTimeSlotDuplicate)
        
        
        let objERSideTimeSlotDuplicate1 =  ERSideTimeSlotBlackOut().loadView() as! ERSideTimeSlotBlackOut
        objERSideTimeSlotDuplicate1.viewconTroller = self
        objERSideTimeSlotDuplicate1.objtimeSlotDuplicateModal = objtimeSlotDuplicateModal
        objERSideTimeSlotDuplicate1.delegate = self
        objERSideTimeSlotDuplicate1.isStartTimeView = false 
        objERSideTimeSlotDuplicate1.lblHeading.text = "End Date & Time"
        objERSideTimeSlotDuplicate1.translatesAutoresizingMaskIntoConstraints = false
        objERSideTimeSlotDuplicate1.customization()
        insideView.addSubview(objERSideTimeSlotDuplicate1)
        
        insideView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[view]-0-|", options: NSLayoutConstraint.FormatOptions(rawValue : 0), metrics: nil, views: ["view" :objERSideTimeSlotDuplicate ]))
        insideView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[view]-0-|", options: NSLayoutConstraint.FormatOptions(rawValue : 0), metrics: nil, views: ["view" :objERSideTimeSlotDuplicate1 ]))
        insideView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-8-[view(==68)]-0-[view1(==68)]-8-|", options: NSLayoutConstraint.FormatOptions(rawValue : 0), metrics: nil, views: ["view" :objERSideTimeSlotDuplicate,"view1" :objERSideTimeSlotDuplicate1 ]))

        return insideView
        
    }
    
    
    
    
    func createDateAndTimeViewSlot()  {

        var viewPrevious : UIView?
        for view  in  self.viewSelectDay.subviews{
            view.removeFromSuperview()
        }
        for objTimeslot in arrtimeSlotDuplicateModal{
            var view = innerTimeSlotView(objtimeSlotDuplicateModal: objTimeslot)
            view.translatesAutoresizingMaskIntoConstraints = false
            self.viewSelectDay.addSubview(view)

            if viewPrevious == nil{

                viewSelectDay.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[view]-0-|", options: NSLayoutConstraint.FormatOptions(rawValue : 0), metrics: nil, views: ["view" :view ]))

                viewSelectDay.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[view(==152)]", options: NSLayoutConstraint.FormatOptions(rawValue : 0), metrics: nil, views: ["view" :view ]))

            }
            else{
                viewSelectDay.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[view]-0-|", options: NSLayoutConstraint.FormatOptions(rawValue : 0), metrics: nil, views: ["view" :view ]))

                viewSelectDay.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[viewPrevious]-4-[view(==152)]", options: NSLayoutConstraint.FormatOptions(rawValue : 0), metrics: nil, views: ["viewPrevious":viewPrevious!,"view" :view ]))

            }
            viewPrevious = view
        }
        if viewPrevious != nil{
            viewSelectDay.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[viewPrevious(==152)]-(4)-|", options: NSLayoutConstraint.FormatOptions(rawValue : 0), metrics: nil, views: ["viewPrevious":viewPrevious!]))
        }

    }
    
    
    func createDateAndTimeViewDay()  {

        var viewPrevious : UIView?
        for view  in  self.viewSelectDay.subviews{
            view.removeFromSuperview()
        }
        for objTimeslot in arrtimeSlotDuplicateModal{
            let objERSideTimeSlotDuplicate =  ERSideTimeSlotBlackOut().loadView() as! ERSideTimeSlotBlackOut
            objERSideTimeSlotDuplicate.viewconTroller = self
            objERSideTimeSlotDuplicate.objtimeSlotDuplicateModal = objTimeslot
            objERSideTimeSlotDuplicate.delegate = self
            if viewPrevious != nil{
                objERSideTimeSlotDuplicate.lblHeading.text = ""
            }
            else{
                objERSideTimeSlotDuplicate.lblHeading.text = "Select Day"
            }
            objERSideTimeSlotDuplicate.isStartTimeView = false

            objERSideTimeSlotDuplicate.translatesAutoresizingMaskIntoConstraints = false
            objERSideTimeSlotDuplicate.customization()
            self.viewSelectDay.addSubview(objERSideTimeSlotDuplicate)
            if viewPrevious == nil{

                viewSelectDay.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[view]-0-|", options: NSLayoutConstraint.FormatOptions(rawValue : 0), metrics: nil, views: ["view" :objERSideTimeSlotDuplicate ]))

                viewSelectDay.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[view(==68)]", options: NSLayoutConstraint.FormatOptions(rawValue : 0), metrics: nil, views: ["view" :objERSideTimeSlotDuplicate ]))

            }
            else{
                viewSelectDay.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[view]-0-|", options: NSLayoutConstraint.FormatOptions(rawValue : 0), metrics: nil, views: ["view" :objERSideTimeSlotDuplicate ]))

                viewSelectDay.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[viewPrevious]-(-6)-[view(==68)]", options: NSLayoutConstraint.FormatOptions(rawValue : 0), metrics: nil, views: ["viewPrevious":viewPrevious!,"view" :objERSideTimeSlotDuplicate ]))

            }
            viewPrevious = objERSideTimeSlotDuplicate
        }
        if viewPrevious != nil{
            viewSelectDay.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[viewPrevious(==68)]-(0)-|", options: NSLayoutConstraint.FormatOptions(rawValue : 0), metrics: nil, views: ["viewPrevious":viewPrevious!]))
        }

    }
    
    
    @IBAction func btnAddTimeTapped(_ sender: Any) {
        index = index + 1 ;
        if isFullDay{
            timeSlotModalDay()
            createDateAndTimeViewDay()
        }
        else{
            timeSlotModalTime()
            createDateAndTimeViewSlot()
        }
        

    }
}




// BLACKOUTTYPE
extension AddBlackOutDateVC  {
    
    func customizationBlackOutType()  {
        
        if let fontHeavy = UIFont(name: "FontHeavy".localized(), size: Device.FONTSIZETYPE12)
        {
            let strHeader = NSMutableAttributedString.init()
            let strTiTle = NSAttributedString.init(string: "Blackout Type"
                , attributes: [NSAttributedString.Key.foregroundColor : ILColor.color(index: 31),NSAttributedString.Key.font : fontHeavy]);
            let para = NSMutableParagraphStyle.init()
            strHeader.append(strTiTle)
            strHeader.addAttribute(NSAttributedString.Key.paragraphStyle, value: para, range: NSMakeRange(0, strHeader.length))
            lblBlackOutTime.attributedText = strHeader
        }
        
        
        let fontHeavy1 = UIFont(name: "FontHeavy".localized(), size: Device.FONTSIZETYPE11)

        self.txtBlackOutTime.text = "Full day"
        self.txtBlackOutTime.font = fontHeavy1
        self.txtBlackOutTime.layer.borderColor = ILColor.color(index: 27).cgColor
        self.txtBlackOutTime.layer.borderWidth = 1;
        self.txtBlackOutTime.layer.cornerRadius = 3;
        txtBlackOutTime.backgroundColor = ILColor.color(index: 48)
        self.txtBlackOutTime.rightView = UIImageView.init(image: UIImage.init(named: "Drop-down_arrow"))
        txtBlackOutTime.rightViewMode = .always;
        pickerViewSetUp(txtInput: txtBlackOutTime, tag: 191)
        
        
    }
    
    
}


// BLACKOUTTYPE
extension AddBlackOutDateVC  {
    
    
    
    
    func customizationBlackOutReason()  {
        
        if let fontHeavy = UIFont(name: "FontHeavy".localized(), size: Device.FONTSIZETYPE12)
        {
            let strHeader = NSMutableAttributedString.init()
            let strTiTle = NSAttributedString.init(string: "Reason for Blackout"
                , attributes: [NSAttributedString.Key.foregroundColor : ILColor.color(index: 31),NSAttributedString.Key.font : fontHeavy]);
            let strType = NSAttributedString.init(string: "  ⃰"
                , attributes: [NSAttributedString.Key.foregroundColor : UIColor.red,NSAttributedString.Key.font : fontHeavy]);
            let para = NSMutableParagraphStyle.init()
            strHeader.append(strTiTle)
            strHeader.append(strType)
            strHeader.addAttribute(NSAttributedString.Key.paragraphStyle, value: para, range: NSMakeRange(0, strHeader.length))
            lblReasonBlackout.attributedText = strHeader
        }
        
        
        let fontHeavy1 = UIFont(name: "FontHeavy".localized(), size: Device.FONTSIZETYPE11)

        self.txtReasonBlackout.text = "Convocation"
        self.txtReasonBlackout.font = fontHeavy1
        self.txtReasonBlackout.layer.borderColor = ILColor.color(index: 27).cgColor
        self.txtReasonBlackout.layer.borderWidth = 1;
        self.txtReasonBlackout.layer.cornerRadius = 3;
        txtReasonBlackout.backgroundColor = ILColor.color(index: 48)

        self.txtReasonBlackout.rightView = UIImageView.init(image: UIImage.init(named: "Drop-down_arrow"))
        txtReasonBlackout.rightViewMode = .always;
        pickerViewSetUp(txtInput: txtReasonBlackout, tag: 192)
        
        let fontHeavy2 = UIFont(name: "FontHeavy".localized(), size: Device.FONTSIZETYPE14)

        UIButton.buttonUIHandling(button: btnSubmit, text: "Submit", backgroundColor: ILColor.color(index: 23), textColor: .white, cornerRadius: 5, fontType: fontHeavy2)
        
        
        
    }
    
    
}



// MARK: Appointment Type.

extension AddBlackOutDateVC
{
        
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
        
        if textField.tag == 191{
            arrPicker = ["Full day","Blackout for time period"]
            PickerSelectedTag = 191;
        }
        else  if textField.tag == 192{
            arrPicker = ["Summer Holidays","College Festivals","Convocation","Sports day"]
            PickerSelectedTag = 192;
        }
        
        else  if textField.tag == 193{
            arrPicker = ["Summer Holidays","College Festivals","Convocation","Sports day"]
            PickerSelectedTag = 193;
        }
        
        let pickerSelected = self.arrPicker.firstIndex(where: {$0 == textField.text}) ?? 0
        pickerView.selectRow(pickerSelected, inComponent: 0, animated: false)
        pickerView.reloadAllComponents()
        activeField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        activeField = nil
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        
        if textField.tag == 10 {
            return true
        }
        else{
            return false

        }
        
       
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
        
        if PickerSelectedTag == 191{
            arrPicker =  ["Full day","Blackout for time period"]
            txtBlackOutTime.text = arrPicker[row]
            resetAll()
            if row == 0{
                isFullDay = true
                timeSlotModalDay()
                createDateAndTimeViewDay()
            }
            else{
                isFullDay = false
                timeSlotModalTime()
                createDateAndTimeViewSlot()
            }
        }
        
        if PickerSelectedTag == 192 {
            
            arrPicker =  ["Summer Holidays","College Festivals","Convocation","Sports day"]
            txtReasonBlackout.text = arrPicker[row]
            reasonId = row + 1
            if row == 0{
            }
            else{
            }
        }
    }
    
}




// TIME ZONE
extension AddBlackOutDateVC : TimeZoneViewControllerDelegate {
    
    func sendTimeZoneSelected(timeZone: TimeZoneSel) {
        self.txtTimeZone.text = timeZone.displayName
        
    }
    
    
    func setTimeZoneTextField()  {
        if let fontHeavy = UIFont(name: "FontHeavy".localized(), size: Device.FONTSIZETYPE12)
        {
            let strHeader = NSMutableAttributedString.init()
            let strTiTle = NSAttributedString.init(string: "Time Zone"
                , attributes: [NSAttributedString.Key.foregroundColor : ILColor.color(index: 31),NSAttributedString.Key.font : fontHeavy]);
            let strType = NSAttributedString.init(string: "  ⃰"
                , attributes: [NSAttributedString.Key.foregroundColor : UIColor.red,NSAttributedString.Key.font : fontHeavy]);
            let para = NSMutableParagraphStyle.init()
            strHeader.append(strTiTle)
            strHeader.append(strType)
            
            strHeader.addAttribute(NSAttributedString.Key.paragraphStyle, value: para, range: NSMakeRange(0, strHeader.length))
            lblTimeZone.attributedText = strHeader
        }
        
        let fontHeavy1 = UIFont(name: "FontHeavy".localized(), size: Device.FONTSIZETYPE11)
        for timeZone in timeZOneArr{
            if timeZone.offset == GeneralUtility().currentOffset() && timeZone.identifier == GeneralUtility().getCurrentTimeZone(){
                selectedTextZone = timeZone.displayName!
                break
            }
        }
        self.txtTimeZone.text = selectedTextZone
        self.txtTimeZone.font = fontHeavy1
        self.txtTimeZone.layer.borderColor = ILColor.color(index: 27).cgColor
        self.txtTimeZone.layer.borderWidth = 1;
        self.txtTimeZone.layer.cornerRadius = 3;
        txtTimeZone.backgroundColor = ILColor.color(index: 48)
        self.txtTimeZone.rightView = UIImageView.init(image: UIImage.init(named: "Drop-down_arrow"))
        txtTimeZone.rightViewMode = .always;
        timeZoneViewController = TimeZoneViewController.init(nibName: "TimeZoneViewController", bundle: nil)
        timeZoneViewController.delegate = self
        timeZoneViewController.selectedTextZone = selectedTextZone
        timeZoneViewController.viewControllerI = self
        timeZoneViewController.modalPresentationStyle = .overFullScreen
        
        
    }
    
    
    @IBAction func btnSelectTimeZoneTapped(_ sender: UIButton) {
        let frameI =
            txtTimeZone.superview?.convert(txtTimeZone.frame, to: nil)
        
        timeZoneViewController.txtfieldRect = frameI
        self.present(timeZoneViewController, animated: false) {
            self.timeZoneViewController.reloadTableview()
        }
    }
    
    
    
}
