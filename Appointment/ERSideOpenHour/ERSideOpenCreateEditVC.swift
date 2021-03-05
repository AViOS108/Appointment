//
//  ERSideOpenCreateEditVC.swift
//  Appointment
//
//  Created by Anurag Bhakuni on 02/12/20.
//  Copyright © 2020 Anurag Bhakuni. All rights reserved.
//


import UIKit


enum viewTypeOpenHour {
    case setEditOpenHour
    case duplicateSetHour
}


struct timeSlotDuplicateModal {
    var timeSlot : String!
    var isSelected : Bool!
    var id : String!
}


struct openHourModalSubmit {
    var userPurposeId : [SearchTextFieldItem]!
    var startTime,endTime : String?
    var timeZone = UserDefaultsDataSource(key: "timeZoneOffset").readData() as! String
    var slotDuration : Int?
    var maximum_meetings_per_day : Int?
    var buffer_after_slot,buffer_before_slot : Int?
    var recurrence : String?
    var open_hours_appointment_approval_process : String?
    var locationType : String?
    var locationValue : String?
    var deadline_days_before :  Int?
    var deadline_time_on_day :  Int?
    var participant = [ParticipantOH]()
}
struct ParticipantOH {
    var entity_id : Int?
    var entity_type : String?
    var is_invited : Int?
}




class ERSideOpenCreateEditVC: SuperViewController,UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate,CalenderViewDelegate {

    
    @IBOutlet weak var btnAdd: UIButton!
    
    @IBAction func btnAddTapped(_ sender: Any) {
        configureStartEndView()
    }
    
    var objviewTypeOpenHour : viewTypeOpenHour!
    
    var arrERStartEndTImeView = [ERStartEndTImeView]()
//    var arrDataStartEndTimeView : Array<Dictionary<String,String>>!
    
    
    
    @IBOutlet weak var lblDate: UILabel!
    
    @IBOutlet weak var txtDateSelected: UITextField!
    
    @IBOutlet weak var btmDateSelected: UIButton!
    
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
    
    var objOpenHourModalSubmit : openHourModalSubmit!
    func dateSelected(calenderModal: CalenderModal,index : Int) {
        
        let dateInRequiredFormate =     GeneralUtility.currentDateDetailType4(emiDate: calenderModal.StrDate!, fromDateF: "yyyy-MM-dd", toDateFormate: "dd/MM/yyyy")
        
        if index == 1{
            txtDateSelected.text = dateInRequiredFormate
            changeForDuplicate()
        }
        else if index == 2{
            txtEndsOnDate.text = dateInRequiredFormate
            changeForDuplicate()

            
        }
        else{
            txtDateDuplicateto.text = dateInRequiredFormate
        }
    }
    
    @IBOutlet weak var viewOuter: UIView!

    @IBOutlet weak var viewHeader: UIView!

    
    @IBOutlet weak var viewInner: UIView!
    @IBOutlet weak var lblStepHeader: UILabel!
    @IBOutlet weak var btnNext: UIButton!
   
    @IBOutlet weak var viewScroll: UIScrollView!
    var dateSelected : Date!
    var frameSelected : CGRect!
    var activeField : UITextField?
    var keyBooradAlreadyShown = false
   
    // DATE FOR DUPLICATE
    
    
    
    @IBOutlet weak var nsLayoutHeightBtnAdd: NSLayoutConstraint!
    @IBOutlet weak var viewDateDuplicate1: UIView!
    
    @IBOutlet weak var viewDuplicate2: UIView!
    
    @IBOutlet weak var lblDuplicateTo: UILabel!
    
    @IBOutlet weak var txtDateDuplicateto: UITextField!
    
    @IBAction func btnDateDuplicateToTapped(_ sender: UIButton) {
        
        let frame = sender.convert(sender.frame, from:AppDelegate.getDelegate().window)
        let viewCalender = CalenderViewController.init(nibName: "CalenderViewController", bundle: nil)
        viewCalender.index = 3
        viewCalender.pointedArrow = false
        viewCalender.viewControllerI = self
        viewCalender.pointSign = CGPoint.init(x: abs(frame.origin.x) + abs(frame.size.width/2), y: abs(frame.origin.y) + abs(frame.size.height/2) + 10 )
        viewCalender.modalPresentationStyle = .overFullScreen
        self.present(viewCalender, animated: false) {
        }
        
    }
    @IBOutlet weak var btnDateDuplicateTo: UIButton!
    // Purpose
    @IBOutlet weak var viewHeightConstraint: NSLayoutConstraint!

    @IBOutlet weak var nslayoutHeightDuplicateToView: NSLayoutConstraint!
    
    
    @IBOutlet weak var viewSelectedContainer: UIView!
    @IBOutlet weak var lblPurpose: UILabel!
    @IBOutlet weak var txtPurpose: LeftPaddedTextField!
    @IBOutlet weak var btnPurpose: UIButton!
   
    
    //Timing
    
    @IBOutlet weak var lblTimingFrom: UILabel!
//    @IBOutlet weak var txtTimingFrom: UITextField!
    @IBOutlet weak var lblTimingTo: UILabel!
//    @IBOutlet weak var txtTimingTo: UITextField!

    // TIMEZONE
    
    @IBOutlet weak var lblTimeZone: UILabel!
    @IBOutlet weak var txtTimeZone: LeftPaddedTextField!
    var   timeZoneViewController : TimeZoneViewController!

    @IBOutlet weak var viewTimezone: UIView!
    //Slot
    @IBOutlet weak var lblSlot: UILabel!
    @IBOutlet weak var txtSlotDuration: LeftPaddedTextField!
    
    //MaximumAppo
    @IBOutlet weak var lblMaximumAppo: UILabel!

    var maxAppoinment = 10;
    
    @IBOutlet weak var viewMaxAppo: UIView!
    //BreakBuffer

    @IBOutlet weak var viewContainerStartEnd: UIView!
    
    //Recurrence
    
    var endsOnTapped = 2;
    var isRecurrenceEnable = false
    @IBOutlet weak var viewRecurrence: UIView!
    
    @IBOutlet weak var btnRecurrenceEnable: UIButton!
    
    @IBOutlet weak var lblRecurrenceLable: UILabel!
    
    @IBOutlet weak var lblRepeat: UILabel!
    
    @IBOutlet weak var txtRepeatCount: UITextField!
    
    @IBOutlet weak var txtCategoryTime: LeftPaddedTextField!
    
    @IBOutlet weak var lblRepeatWeek: UILabel!
    
    var keyBoardHieght : CGFloat = 0.0;
    
    @IBOutlet weak var viewWeekRepeat: UIView!
    @IBOutlet weak var nslayoutRepeatWeekViewHeight: NSLayoutConstraint!
    @IBOutlet var btnRepeatWeekArr: [UIButton]!
    
   
    @IBOutlet weak var lblMonthRepeat: UILabel!
    @IBOutlet weak var txtRepeatMonth: LeftPaddedTextField!
    @IBOutlet weak var nslayoutRepeatMonthViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var viewMonthRepeat: UIView!
    
    @IBOutlet weak var lblEndsOn: UILabel!
    
    @IBOutlet weak var btnNeverEnds: UIButton!
    
 
    
    @IBOutlet weak var lblNeverEnds: UILabel!
    
    @IBOutlet weak var lblEndsOnDate: UILabel!
    
    @IBOutlet weak var btnEndsOnDate: UIButton!
   
    @IBOutlet weak var txtEndsOnDate: UITextField!
    
    @IBOutlet weak var btnAfterEnds: UIButton!
   
    
    var PickerSelectedTag = 0;
    
    @IBOutlet weak var lblAfterEnds: UILabel!
    @IBOutlet weak var txtOccurenceCount: UITextField!
    @IBOutlet weak var lblOccurrenceCountText: UILabel!
    var objERSideCreateEditOHVM : ERSideCreateEditOHVM!
    var dataPurposeModal: ERSidePurposeDetailModalArr?
    var timeZOneArr: [TimeZoneSel]!
    var searchArrayPurpose = [SearchTextFieldItem]()

      let pickerView = UIPickerView()
    
    
    var objERSideOpenHourDetail: ERSideOpenHourDetail?

    // NSLAYOUTCONSTRAINT
    
    
    @IBOutlet weak var nslayoutConstraintRecurrence: NSLayoutConstraint!
    
    
    
    @IBOutlet weak var nslayoutConstraintTimeZone: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        callViewModal()
        self.viewInner.isHidden = true
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM YYYY"
        GeneralUtility.customeNavigationBarWithOnlyBack(viewController: self, title: "Open Hours" + " - " + dateFormatter.string(from: self.dateSelected))
        
        // Do any additional setup after loading the view.
    }
    
      @objc override func buttonClicked(sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: false)
       }
       
    
    
    func callViewModal()
    {
        objERSideCreateEditOHVM = ERSideCreateEditOHVM()
        objERSideCreateEditOHVM.viewController = self
        objERSideCreateEditOHVM.delegate = self
        objERSideCreateEditOHVM.customizeCreateEditOPenHour()
        
    }
    
 
    func customization(){
        self.viewInner.isHidden = false
        self.viewInner.backgroundColor =  .white
        self.viewHeader.backgroundColor =  .white
        self.view.backgroundColor =  ILColor.color(index: 22)
        self.viewOuter.backgroundColor =  ILColor.color(index: 22)
        lblStepHeader.isHidden = false;
        customizeHeader()
        customizePurpose()
        customizeTiming()
        customizeTimeZone()
        customizSlotDuration()
        customizeReccurrence()
        
        if objERSideOpenHourDetail != nil{
            nslayoutConstraintRecurrence.constant = 0
            nslayoutConstraintTimeZone.constant = 0
             viewRecurrence.isHidden = true
            viewMaxAppo.isHidden = true
            viewTimezone.isHidden = true
            lblRecurrenceLable.isHidden = true
            btnRecurrenceEnable.isHidden = true;
        }
        else{
            viewMonthRepeat.isHidden = true
            nslayoutRepeatMonthViewHeight.constant = 0
        }
        
        switch objviewTypeOpenHour {
        case .setEditOpenHour:

            self.configureStartEndView()

            break
        case .duplicateSetHour:
            self.timeSlotDuplicate()
            changeForDuplicate()
            break
        default:
            break
        }
        
        commonCustomization()
        let fontHeavy = UIFont(name: "FontHeavy".localized(), size: Device.FONTSIZETYPE15)
        UIButton.buttonUIHandling(button: btnAdd, text: "Add", backgroundColor: .clear, textColor: ILColor.color(index: 23), fontType: fontHeavy)
       
    }
    
    
    
    func changeForDuplicate() {
        
        if txtDateSelected.text!.isEmpty  && txtDateDuplicateto.text!.isEmpty {
            
            self.txtSlotDuration.isUserInteractionEnabled = false
            self.txtSlotDuration.isEnabled = false
            self.txtSlotDuration.alpha = 0.6
            
            self.txtTimeZone.isUserInteractionEnabled = false
            self.txtTimeZone.isEnabled = false
            self.txtTimeZone.alpha = 0.6
            
            
            lblPurpose.alpha = 0.6
            lblTimeZone.alpha = 0.6;
            lblTimingFrom.alpha = 0.6
            
        }
        else{
            
            self.txtSlotDuration.isUserInteractionEnabled = true
            self.txtSlotDuration.isEnabled = true
            self.txtSlotDuration.alpha = 1
            
            self.txtTimeZone.isUserInteractionEnabled = true
            self.txtTimeZone.isEnabled = true
            self.txtTimeZone.alpha = 1
            
            
            lblPurpose.alpha = 1
            lblTimeZone.alpha = 1;
            lblTimingFrom.alpha = 1
            
            
        }
        
        
    }
    
    
    
    override func actnResignKeyboard() {
        activeField!.resignFirstResponder()
     }
    
    func commonCustomization(){
        
//        self.addInputAccessoryForTextFields(textFields: [txtTimingFrom,txtTimingTo], dismissable: true, previousNextable: true)
        
        
        self.addInputAccessoryForTextFields(textFields: [txtSlotDuration,txtRepeatCount,txtCategoryTime], dismissable: true, previousNextable: true)
        
        self.addInputAccessoryForTextFields(textFields: [txtRepeatMonth], dismissable: true, previousNextable: true)

        
        self.addInputAccessoryForTextFields(textFields: [txtEndsOnDate], dismissable: true, previousNextable: true)
        
        self.addInputAccessoryForTextFields(textFields: [txtOccurenceCount], dismissable: true, previousNextable: true)
        
        
//            btnIncrease.setImage(UIImage.init(named: "Add"), for: .normal)
//            btnDecrease.setImage(UIImage.init(named: "Minus"), for: .normal)
        registerForKeyboardNotifications()
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
    
    
    
    
     // MARK:  Textfield delegate
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
           textField.resignFirstResponder()
           return true
       }
       
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.tag == 191{
            arrPicker = ["15 mins","30 mins","45 mins","60 mins","custom"]
            PickerSelectedTag = 191;

            let pickerSelected = self.arrPicker.firstIndex(where: {$0 == textField.text}) ?? 0

            pickerView.selectRow(pickerSelected, inComponent: 0, animated: false)
            
        }
        else if textField.tag == 192{
            arrPicker = ["0 mins","5 mins","10 mins","15 mins","30 mins","45 mins","60 mins"]
            PickerSelectedTag = 192;
            let pickerSelected = self.arrPicker.firstIndex(where: {$0 == textField.text}) ?? 0

            pickerView.selectRow(pickerSelected, inComponent: 0, animated: false)

            
        }
        else if textField.tag == 193{
            arrPicker = ["0 mins","5 mins","10 mins","15 mins","30 mins","45 mins","60 mins"]
            PickerSelectedTag = 193;
            let pickerSelected = self.arrPicker.firstIndex(where: {$0 == textField.text}) ?? 0

            pickerView.selectRow(pickerSelected, inComponent: 0, animated: false)

            
        }
            
        else if textField.tag == 194{
            arrPicker = ["day","Week","Month","Year"]
            PickerSelectedTag = 194;
            let pickerSelected = self.arrPicker.firstIndex(where: {$0 == textField.text}) ?? 0
            pickerView.selectRow(pickerSelected, inComponent: 0, animated: false)
            
        }
        else if textField.tag == 195{
            arrPicker = getMonthReccureenceArray()
            PickerSelectedTag = 195;
            let pickerSelected = self.arrPicker.firstIndex(where: {$0 == textField.text}) ?? 0
            pickerView.selectRow(pickerSelected, inComponent: 0, animated: false)
        }
        pickerView.reloadAllComponents()
        activeField = textField
    }
       
    func textFieldDidEndEditing(_ textField: UITextField) {
        activeField = nil
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
          guard let currentText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) else { return true }
        
        if  textField == txtRepeatCount || textField == txtOccurenceCount{
        
            if currentText.count > 4 {
                return false
            }
            
        }
        return true
    }
    
    var arrPicker = [String]();
    
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
            arrPicker = ["15 mins","30 mins","45 mins","60 mins","custom"]
            txtSlotDuration.text = arrPicker[row]
        }
        else if PickerSelectedTag == 192{
//            arrPicker = ["0 mins","5 mins","10 mins","15 mins","30 mins","45 mins","60 mins"]
//            txtBreakBufferBefore.text = arrPicker[row]
        }
        else if PickerSelectedTag == 193{
//            arrPicker = ["0 mins","5 mins","10 mins","15 mins","30 mins","45 mins","60 mins"]
//            txtBreakBufferAfter.text = arrPicker[row]
        }
            
        else if PickerSelectedTag == 194{
            arrPicker = ["day","Week","Month","Year"]
        viewVisisblityAccordingtoTimeCategory(tag: row)
           
         txtCategoryTime.text = arrPicker[row]
        }
        else if PickerSelectedTag == 195{
            arrPicker = getMonthReccureenceArray()
            txtRepeatMonth.text = arrPicker[row]
        }
        
        
    }
}


// MARK: Header.

extension ERSideOpenCreateEditVC
{
    
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
            lblStepHeader.attributedText = strHeader
            UIButton.buttonUIHandling(button: btnNext, text: "Next", backgroundColor: .clear, textColor: ILColor.color(index: 23),  fontType: fontHeavy)
        }
        
        
        switch objviewTypeOpenHour {
        case .setEditOpenHour :
            if let fontHeavy = UIFont(name: "FontHeavy".localized(), size: Device.FONTSIZETYPE15)
            {
                let strHeader = NSMutableAttributedString.init()
                let strTiTle = NSAttributedString.init(string: "Date"
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
            nslayoutHeightDuplicateToView.constant = 0;
            self.viewDuplicate2.isHidden = true
            let fontDateRe = UIFont(name: "FontRegular".localized(), size: Device.FONTSIZETYPE13)
            self.txtDateSelected.layer.borderColor = ILColor.color(index: 27).cgColor
                  self.txtDateSelected.layer.borderWidth = 1;

            txtDateSelected.attributedPlaceholder = NSAttributedString(string: "DD/MM/YYYY", attributes: [
                .foregroundColor: ILColor.color(index: 40),
                .font: fontDateRe
            ])
            break
        case .duplicateSetHour:
            if let fontHeavy = UIFont(name: "FontHeavy".localized(), size: Device.FONTSIZETYPE15),  let fontBook =  UIFont(name: "FontBook".localized(), size: Device.FONTSIZETYPE15)
                
            {
                let nextLine1 = NSAttributedString.init(string: "\n")
                
                let strHeader = NSMutableAttributedString.init()
                let strTiTle = NSAttributedString.init(string: "Duplicate From"
                    , attributes: [NSAttributedString.Key.foregroundColor : ILColor.color(index: 31),NSAttributedString.Key.font : fontHeavy]);
                let strType = NSAttributedString.init(string: "  ⃰"
                    , attributes: [NSAttributedString.Key.foregroundColor : UIColor.red,NSAttributedString.Key.font : fontHeavy]);
                
                let strInfo = NSAttributedString.init(string: "( Choose the date whose advising appointment slots you wish to duplicate )"
                    , attributes: [NSAttributedString.Key.foregroundColor : UIColor.red,NSAttributedString.Key.font : fontBook]);
                
                let para = NSMutableParagraphStyle.init()
                //            para.alignment = .center
                strHeader.append(strTiTle)
                strHeader.append(strType)
                strHeader.append(nextLine1)
                strHeader.append(strInfo)
                
                
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
            self.txtDateSelected.layer.borderColor = ILColor.color(index: 27).cgColor
                  self.txtDateSelected.layer.borderWidth = 1;

            txtDateSelected.leftViewMode = .always;
            
            if let fontHeavy = UIFont(name: "FontHeavy".localized(), size: Device.FONTSIZETYPE15),  let fontBook =  UIFont(name: "FontBook".localized(), size: Device.FONTSIZETYPE15)
                
            {
                let nextLine1 = NSAttributedString.init(string: "\n")
                
                let strHeader = NSMutableAttributedString.init()
                let strTiTle = NSAttributedString.init(string: "Duplicate To"
                    , attributes: [NSAttributedString.Key.foregroundColor : ILColor.color(index: 31),NSAttributedString.Key.font : fontHeavy]);
                let strType = NSAttributedString.init(string: "  ⃰"
                    , attributes: [NSAttributedString.Key.foregroundColor : UIColor.red,NSAttributedString.Key.font : fontHeavy]);
                
                let strInfo = NSAttributedString.init(string: "( Choose the date onto which you wish to copy the same appointment slots )"
                    , attributes: [NSAttributedString.Key.foregroundColor : UIColor.red,NSAttributedString.Key.font : fontBook]);
                
                let para = NSMutableParagraphStyle.init()
                //            para.alignment = .center
                strHeader.append(strTiTle)
                strHeader.append(strType)
                strHeader.append(nextLine1)
                strHeader.append(strInfo)
                
                
                strHeader.addAttribute(NSAttributedString.Key.paragraphStyle, value: para, range: NSMakeRange(0, strHeader.length))
                lblDuplicateTo.attributedText = strHeader
            }
            
            txtDateDuplicateto.backgroundColor = ILColor.color(index: 48)
            self.txtDateDuplicateto.font = fontMedium
            self.txtDateDuplicateto.layer.cornerRadius = 3;
            let imageView4 = UIImageView.init(image: UIImage.init(named: "Calendar-1"))
            imageView4.frame = CGRect(x: 0.0, y: 0.0, width: 20, height: 20)
            
            self.txtDateDuplicateto.leftView = imageView4
            txtDateDuplicateto.leftViewMode = .always;
            self.txtDateDuplicateto.layer.borderColor = ILColor.color(index: 27).cgColor
                  self.txtDateDuplicateto.layer.borderWidth = 1;
              
            let fontDateRe = UIFont(name: "FontRegular".localized(), size: Device.FONTSIZETYPE13)
            txtDateDuplicateto.attributedPlaceholder = NSAttributedString(string: "DD/MM/YYYY", attributes: [
                .foregroundColor: ILColor.color(index: 40),
                .font: fontDateRe
            ])
            txtDateSelected.attributedPlaceholder = NSAttributedString(string: "DD/MM/YYYY", attributes: [
                .foregroundColor: ILColor.color(index: 40),
                .font: fontDateRe
            ])
            
            
            break
        default:
            break
        }
        
        
    }
    
    
    @IBAction func btnNextTapped(_ sender: Any) {
        if validatingForm(){
         self.objOpenHourModalSubmit =  formingModal()
            let objERSideOpenCreateEditSecondVC = ERSideOpenCreateEditSecondVC.init(nibName: "ERSideOpenCreateEditSecondVC", bundle: nil)
            objERSideOpenCreateEditSecondVC.objERSideOpenHourDetail = self.objERSideOpenHourDetail
            objERSideOpenCreateEditSecondVC.objOpenHourModalSubmit = self.objOpenHourModalSubmit
            
            objERSideOpenCreateEditSecondVC.dateSelected = self.dateSelected
            self.navigationController?.pushViewController(objERSideOpenCreateEditSecondVC, animated: false)
        }
        
        
    }
    
    
    func changeto24HourFormat(txtTime : String) -> String{
        let dateAsString = txtTime
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"

        let date = dateFormatter.date(from: dateAsString)
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: date!)
    }
    
    
    
    
    
    func formingModal() -> openHourModalSubmit {
        
        
        var objOpenHourModalSubmit = openHourModalSubmit()
        objOpenHourModalSubmit.userPurposeId = self.searchArrayPurpose;
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateI = dateFormatter.string(from: self.dateSelected)
//        let StartTimeArr =  changeto24HourFormat(txtTime: txtTimingFrom.text ?? "11:00 AM")
//        let EndTimeArr =  changeto24HourFormat(txtTime: txtTimingTo.text ?? "1:00 PM")
        
//        objOpenHourModalSubmit.startTime = dateI + " " +  StartTimeArr + ":00"
//        objOpenHourModalSubmit.endTime = dateI + " " +  EndTimeArr + ":00"
//
        let arrPickerSlotDuration = ["15 mins","30 mins","45 mins","60 mins"]
        let arrPickerSlot = [15,30,45,60];
        let indexSelectedSlot = arrPickerSlotDuration.firstIndex(where: {$0 == txtSlotDuration.text})
        objOpenHourModalSubmit.slotDuration = arrPickerSlot[indexSelectedSlot ?? 0] * 60
//        objOpenHourModalSubmit.maximum_meetings_per_day = Int(txtMaximumAppo.text ?? "-1")
        
        let arrPickerBuffer = ["0 mins","5 mins","10 mins","15 mins","30 mins","45 mins","60 mins"];
        let arrPickerBufferI = [0,5,10,15,30,45,60];
//        let indexSelectedAfter = arrPickerBuffer.firstIndex(where: {$0 == txtBreakBufferAfter.text})
//        let indexSelectedBefore = arrPickerBuffer.firstIndex(where: {$0 == txtBreakBufferBefore.text})
        
//        if indexSelectedAfter != nil{
//            objOpenHourModalSubmit.buffer_after_slot = arrPickerBufferI[indexSelectedAfter ?? 0] * 60 ;
//        }
//        else{
//            objOpenHourModalSubmit.buffer_after_slot = -1 ;
//        }
//
//        if indexSelectedBefore != nil{
//            objOpenHourModalSubmit.buffer_before_slot = arrPickerBufferI[indexSelectedBefore ?? 0] * 60 ;
//        }
//        else{
//            objOpenHourModalSubmit.buffer_before_slot = -1 ;
//
//        }
        if isRecurrenceEnable{
            
            var recurrenceText = ""
            let freq = ["DAILY","WEEKLY","MONTHLY","YEARLY"]
            let  arrPickerFreq = ["day","Week","Month","Year"]
            let indexFreq = arrPickerFreq.firstIndex(where: {
                $0 == txtCategoryTime.text
            })
            let frqText = "FREQ=\(freq[indexFreq ?? 0])"
            
            recurrenceText.append(frqText)
            recurrenceText.append(";")
            
            var countText = ""
            
            if endsOnTapped == 2 {
                
                let count = Int(txtOccurenceCount.text ?? "1")
                countText =  "COUNT=\(count ?? 0)"
                recurrenceText.append(countText)
                recurrenceText.append(";")
            }
            else if endsOnTapped == 1{
                countText =  "UNTIL=\(GeneralUtility.dateConvertToUTC(emiDate: (self.txtEndsOnDate.text! + " " + "00:00:00") , withDateFormat: "yyyy-MM-dd HH:mm:ss", todateFormat: "YYYYMMDDTHHMMSSZ"))"
                recurrenceText.append(countText)
                recurrenceText.append(";")
                
            }
            else{
                
            }
            
            let intervalText = "INTERVAL=\(txtRepeatCount.text ?? "")"
            
            recurrenceText.append(intervalText)
            recurrenceText.append(";")
            
            recurrenceText.append("WKST=MO")
            
            
            
            if indexFreq == 1{
                recurrenceText.append(";")
                let arrWeekDay = ["SU","MO","TU","WE","TH","FR","SA"]
                
                var arrSelectedWeek : String = ""
                self.btnRepeatWeekArr.forEach { (btn) in
                                  if btn.isSelected{
                                      arrSelectedWeek.append(arrWeekDay[btn.tag]);
                                      arrSelectedWeek.append(",");
                                  }
                              }
                             
                arrSelectedWeek =  String(arrSelectedWeek.dropLast())
              
                let BYDAY = "BYDAY=\(arrSelectedWeek)"
                recurrenceText.append(BYDAY)
                
            }
            else if indexFreq == 2{
                recurrenceText.append(";")
                let arrMonthRepeatOn = getMonthReccureenceArray();
                let indexFreq = arrMonthRepeatOn.firstIndex(where: {
                    $0 == txtRepeatMonth.text
                })
                if indexFreq == 0 {
                    
                    let textSeleted = arrMonthRepeatOn[indexFreq ?? 0];
                    let arrString = textSeleted.split(separator: " ")
                    let BYDAY = "BYMONTHDAY=\(arrString[3])"
                    recurrenceText.append(BYDAY)
                }
                else{
                    let textSeleted = arrMonthRepeatOn[indexFreq ?? 0];
                    let arrString = textSeleted.split(separator: " ")
                    let arrWeekDay = ["SU","MO","TU","WE","TH","FR","SA"]
                    let weekDayArr =  ["Sunday","Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday" ]
                    let indexSelected =  weekDayArr.firstIndex(where: {$0 == arrString[4]})
                    let BYDAY = "BYSETPOS=-1;BYDAY=\(arrWeekDay[indexSelected ?? 0])"
                    recurrenceText.append(BYDAY)
                }
            }
            objOpenHourModalSubmit.recurrence = recurrenceText
        }
        else{
            objOpenHourModalSubmit.recurrence = "-1"
        }
        return objOpenHourModalSubmit;
    }
    
    
    
    
    func validatingForm()-> Bool{

        if self.searchArrayPurpose.filter({$0.isSelected}) .count <= 0{
        
            CommonFunctions().showError(title: "Error", message: StringConstants.PURPOSEERROR)
            return false
        }
        
//        if txtMaximumAppo.text!.isEmpty {
//
//        }
//        else{
//            if (Int(self.txtMaximumAppo.text!)! > 15){
//
//                CommonFunctions().showError(title: "Error", message: "Maximum Appoinments per day can't be more than 15")
//
//                return false
//            }
//            if (Int(self.txtMaximumAppo.text!)! < 1){
//
//                CommonFunctions().showError(title: "Error", message: "Maximum Appoinments per day should be atleast 1")
//
//                return false
//            }
//
//        }
        
        
        
        if txtRepeatCount.text!.isEmpty {
            
            
            
        }
        else{
            
            if (Int(self.txtRepeatCount.text!)! > 1000){
                
                CommonFunctions().showError(title: "Error", message: "Repeat value must be less than or equal to 1000")
                
                return false
            }
            
            if (Int(self.txtRepeatCount.text!)! < 1){
                
                CommonFunctions().showError(title: "Error", message: "Repeat value must be greater than or equal to 1")
                
                return false
            }
            
            
        }
        
        
        if txtOccurenceCount.text!.isEmpty {
            
            
            
            
        }
        else
        {
            if (Int(self.txtOccurenceCount.text!)! > 1000){
                
                CommonFunctions().showError(title: "Error", message: "Occurrences must be greater than or equal to 1")
                
                return false
            }
            
            if (Int(self.txtOccurenceCount.text!)! < 1){
                
                CommonFunctions().showError(title: "Error", message: "Occurrences must be less than or equal to 1000")
                
                return false
            }
            
        }
        
        
        
        
        
        return true
    }
    
}



// MARK: Purpose.
extension ERSideOpenCreateEditVC : SearchViewControllerDelegate
{
    
    func customizePurpose()  {
        
        
        
        for purpose in dataPurposeModal!{
            let searchItem = SearchTextFieldItem()
            searchItem.title = purpose.displayName!
            searchItem.id  = purpose.id
            searchArrayPurpose.append(searchItem)
        }
        self.setDynamicView()
        
        if let fontHeavy = UIFont(name: "FontHeavy".localized(), size: Device.FONTSIZETYPE15)
        {
            let strHeader = NSMutableAttributedString.init()
            let strTiTle = NSAttributedString.init(string: "Purpose"
                , attributes: [NSAttributedString.Key.foregroundColor : ILColor.color(index: 31),NSAttributedString.Key.font : fontHeavy]);
            let strType = NSAttributedString.init(string: "  ⃰"
                , attributes: [NSAttributedString.Key.foregroundColor : UIColor.red,NSAttributedString.Key.font : fontHeavy]);
            let para = NSMutableParagraphStyle.init()
            //            para.alignment = .center
            strHeader.append(strTiTle)
            strHeader.append(strType)
            
            strHeader.addAttribute(NSAttributedString.Key.paragraphStyle, value: para, range: NSMakeRange(0, strHeader.length))
            lblPurpose.attributedText = strHeader
        }
        let fontMedium = UIFont(name: "FontMediumWithoutNext".localized(), size: Device.FONTSIZETYPE13)
        txtPurpose.backgroundColor = ILColor.color(index: 48)
        self.txtPurpose.font = fontMedium
        self.txtPurpose.placeholder = "Search or create new"
        self.txtPurpose.layer.borderColor = ILColor.color(index: 27).cgColor
        self.txtPurpose.layer.borderWidth = 1;
        self.txtPurpose.layer.cornerRadius = 3;
        let imageView = UIImageView.init(image: UIImage.init(named: "Drop-down_arrow"))
        imageView.frame = CGRect(x: 0.0, y: 0.0, width: 20, height: 20)
        
        self.txtPurpose.rightView = imageView
        txtPurpose.rightViewMode = .always;
        if self.objERSideOpenHourDetail != nil
        {
            self.setPrefilledPurposeValue()
        }
    }
    
    func setPrefilledPurposeValue()  {
        
        // self.txtPurpose =
        
        
        
        
        for purpose in (self.objERSideOpenHourDetail?.purposes)!{
            
            let selectedId = searchArrayPurpose.filter({$0.id == purpose.userPurposeID})[0]
            selectedId.isSelected = true
            let index = self.searchArrayPurpose.firstIndex(where: {$0.id == purpose.userPurposeID}) ?? 0
            self.searchArrayPurpose.removeAll(where: {$0.id == purpose.userPurposeID})
            self.searchArrayPurpose.insert(selectedId, at: index)
        }
        
        setDynamicView()
        
        
        
        
        
    }
    
    
    
    @IBAction func btnPurposeTapped(_ sender: UIButton)
    {
        let searchViewController = SearchViewController.init(nibName: "SearchViewController", bundle: nil)
        searchViewController.modalPresentationStyle = .overFullScreen
        searchViewController.maxHeight = 200;
        searchViewController.isCreateNew = true
        let frameI =
            sender.superview?.convert(sender.frame, to: nil)
        let changedFrame = frameI
        searchViewController.placeholder = "Search or create new"
        searchViewController.arrNameSurvey = self.searchArrayPurpose.filter({$0.isSelected == false});
            
        searchViewController.txtfieldRect = changedFrame
        searchViewController.isAPiHIt = false
        searchViewController.delegate = self

        self.present(searchViewController, animated: false) {
        }
    }
    
    func setDynamicView()
    {
        for view in   self.viewSelectedContainer.subviews
        {
            view.removeFromSuperview()
        }
        var viewPrevius : UIView?;
        var viewPreviusC : UIView?;
        self.viewHeightConstraint.constant = 0
        var sumWidth : CGFloat = 0.0
        let arrView = self.searchArrayPurpose.filter({$0.isSelected == true})
        var index = 0
        for searchItem in arrView{
            let view = UIView();
            view.backgroundColor =  ColorCode.applicationBlue
            viewSelectedContainer.addSubview(view);
            view.translatesAutoresizingMaskIntoConstraints = false
            view.tag = searchItem.id!;
            self.innverView(viewC: view, str: arrView[index].title);
            if (viewPrevius != nil)
            {
                view.layoutIfNeeded();
                viewPrevius!.layoutIfNeeded();
                sumWidth = sumWidth + (viewPrevius?.frame.width)! + 8
                view.cornerRadius = 5;
                
                if (sumWidth + view.frame.width + 28 < self.view.frame.width)
                {
                    viewSelectedContainer.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[viewPrevius]-8-[view]", options: NSLayoutConstraint.FormatOptions(rawValue : 0), metrics: nil, views: ["viewPrevius":viewPrevius!,"view" :view ]))
                    if (viewPreviusC != nil)
                    {
                        viewSelectedContainer.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[viewPreviusC]-8-[view]", options: NSLayoutConstraint.FormatOptions(rawValue : 0), metrics: nil, views: ["viewPreviusC":viewPreviusC!,"view" :view ]))
                    }
                    else
                    {
                        viewSelectedContainer.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[view]", options: NSLayoutConstraint.FormatOptions(rawValue : 0), metrics: nil, views: ["view" :view ]))
                    }
                }
                else
                {
                    viewSelectedContainer.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-8-[view]", options: NSLayoutConstraint.FormatOptions(rawValue : 0), metrics: nil, views: ["viewPrevius":viewPrevius!,"view" :view ]))
                    viewSelectedContainer.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[viewPrevius]-8-[view]", options: NSLayoutConstraint.FormatOptions(rawValue : 0), metrics: nil, views: ["viewPrevius":viewPrevius!,"view" :view ]))
                    self.viewHeightConstraint.constant = self.viewHeightConstraint.constant + 35;
                    viewPreviusC = viewPrevius
                    sumWidth = 0;
                }
                viewPrevius = view;
            }
            else
            {
                view.layoutIfNeeded();
                view.cornerRadius = 5;
                viewSelectedContainer.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-8-[view]", options: NSLayoutConstraint.FormatOptions(rawValue : 0), metrics: nil, views: ["view" :view ]))
                viewSelectedContainer.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[view]", options: NSLayoutConstraint.FormatOptions(rawValue : 0), metrics: nil, views: ["view" :view ]))
                viewPrevius = view;
                self.viewHeightConstraint.constant = self.viewHeightConstraint.constant + 35;
            }
            index = index + 1
        }
    }
    
    func  innverView(viewC : UIView,str: String)  {
        let fontNextMedium = UIFont(name: "FontMedium".localized(), size: Device.FONTSIZETYPE13)
        
        let viewLbl = UILabel();
        viewC.addSubview(viewLbl);
        viewLbl.text = str;
        viewLbl.font = fontNextMedium!
        viewLbl.textColor = UIColor.white
        viewLbl.translatesAutoresizingMaskIntoConstraints = false
        
        
        viewC.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(6)-[viewLbl]-(6)-|", options: NSLayoutConstraint.FormatOptions(rawValue : 0), metrics: nil, views: ["viewLbl" :viewLbl ]))
        
        
        let viewBtn = UIButton();
        viewC.addSubview(viewBtn);
        viewBtn.tag = viewC.tag
        viewBtn.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "noun_Cross")
        viewBtn.setImage(image, for: .normal)
        viewBtn.imageEdgeInsets = UIEdgeInsets.init(top: 3, left: 3, bottom: 3, right: 3)
        viewBtn.imageView?.tintColor = UIColor.white
        
        viewBtn.imageView?.contentMode = .center
        
        viewC.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(10)-[viewLbl]-(4)-[viewBtn(==18)]-(8)-|", options: NSLayoutConstraint.FormatOptions(rawValue : 0), metrics: nil, views: ["viewLbl" :viewLbl,"viewBtn" :viewBtn ]))
        
        let verticalCentre = NSLayoutConstraint.init(item: viewBtn, attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: NSLayoutConstraint.Relation.equal, toItem: viewC, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: 1, constant: 0)
        
        viewC.addConstraints([verticalCentre]);
        
        viewC.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[viewBtn(==18)]", options: NSLayoutConstraint.FormatOptions(rawValue : 0), metrics: nil, views: ["viewBtn" :viewBtn ]))
        viewBtn.tag = viewC.tag
        viewBtn.addTarget(self, action: #selector(deleteButtonTapped(_:)), for: .touchUpInside)
        
        
    }
    
    @objc func deleteButtonTapped(_ sender: UIButton){
        
        if sender.tag == -1000{
            
            let index = self.searchArrayPurpose.firstIndex(where: {$0.id == sender.tag}) ?? 0
            self.searchArrayPurpose.remove(at: index)
            
        }
        else{
            let selectedId = searchArrayPurpose.filter({$0.id == sender.tag})[0]
            selectedId.isSelected = false
            let index = self.searchArrayPurpose.firstIndex(where: {$0.id == sender.tag}) ?? 0
            self.searchArrayPurpose.removeAll(where: {$0.id == sender.tag})
            self.searchArrayPurpose.insert(selectedId, at: index)
        }
        
        
        setDynamicView()
    }
    
    func sendSelectedItem(item: SearchTextFieldItem) {
        
        if item.id == -1000{
            let selectedItem = item
            selectedItem.title = item.title.slice(from:"'",to:"'") ?? " "
            self.searchArrayPurpose.insert(selectedItem, at: 0)
        }
        else
        { let selectedId = searchArrayPurpose.filter({$0.id == item.id})[0]
            selectedId.isSelected = true
            let index = self.searchArrayPurpose.firstIndex(where: {$0.id == item.id}) ?? 0
            self.searchArrayPurpose.removeAll(where: {$0.id == item.id})
            self.searchArrayPurpose.insert(selectedId, at: index)
        }
        
        setDynamicView()
        
    }
    
}


// MARK: TIMING FROM AND TO.

extension ERSideOpenCreateEditVC{
    
    
    
    func customizeTiming()  {
        
        switch self.objviewTypeOpenHour {
        case .duplicateSetHour:
            lblMaximumAppo.isHidden = true;
            lblMaximumAppo.text = ""
            btnAdd.isHidden = true
            nsLayoutHeightBtnAdd.constant = 0;
            lblTimingTo.isHidden = true;
            lblTimingTo.text = ""
            if let fontHeavy = UIFont(name: "FontHeavy".localized(), size: Device.FONTSIZETYPE15)
            {
                let strHeader = NSMutableAttributedString.init()
                let strTiTle = NSAttributedString.init(string: "Time Slots"
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
            
            
            
            break;
        case .setEditOpenHour:
            
            let fontHeavy1 = UIFont(name: "FontHeavy".localized(), size: Device.FONTSIZETYPE15)
            
            UILabel.labelUIHandling(label: lblMaximumAppo, text: "Set Time", textColor: ILColor.color(index: 40), isBold: false, fontType: fontHeavy1)
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
            
            
            break;
        default:
            break;
        }
        
        
    }
    
    
  
    
    
    
    
}

// MARK: TIMEZone.
extension ERSideOpenCreateEditVC: TimeZoneViewControllerDelegate{
    func sendTimeZoneSelected(timeZone: TimeZoneSel) {
        self.txtTimeZone.text = timeZone.displayName
        
    }
    
    
    func customizeTimeZone()  {
        let fontHeavy1 = UIFont(name: "FontHeavy".localized(), size: Device.FONTSIZETYPE11)
        if let fontHeavy = UIFont(name: "FontHeavy".localized(), size: Device.FONTSIZETYPE15)
        {
            let strHeader = NSMutableAttributedString.init()
            let strTiTle = NSAttributedString.init(string: "TimeZone"
                , attributes: [NSAttributedString.Key.foregroundColor : ILColor.color(index: 31),NSAttributedString.Key.font : fontHeavy]);
            let strType = NSAttributedString.init(string: "  ⃰"
                , attributes: [NSAttributedString.Key.foregroundColor : UIColor.red,NSAttributedString.Key.font : fontHeavy]);
            let para = NSMutableParagraphStyle.init()
            //            para.alignment = .center
            strHeader.append(strTiTle)
            strHeader.append(strType)
            
            strHeader.addAttribute(NSAttributedString.Key.paragraphStyle, value: para, range: NSMakeRange(0, strHeader.length))
            lblTimeZone.attributedText = strHeader
        }
        
        var selectedTextZone : String = ""
        for timeZone in self.timeZOneArr{
            if timeZone.offset == GeneralUtility().currentOffset() && timeZone.identifier == GeneralUtility().getCurrentTimeZone(){
                selectedTextZone = timeZone.displayName!
                break
            }
        }
        self.txtTimeZone.backgroundColor = ILColor.color(index: 48)
        self.txtTimeZone.text = selectedTextZone
        self.txtTimeZone.font = fontHeavy1
        self.txtTimeZone.layer.borderColor = ILColor.color(index: 27).cgColor
        self.txtTimeZone.layer.borderWidth = 1;
        self.txtTimeZone.layer.cornerRadius = 3;
        self.txtTimeZone.rightView = UIImageView.init(image: UIImage.init(named: "Drop-down_arrow"))
        
        txtTimeZone.rightViewMode = .always;
        
        
    }
    
    
    @IBAction func btnSelectTimeZoneTapped(_ sender: UIButton) {
        
        var selectedTextZone : String = ""
        for timeZone in self.timeZOneArr{
            if timeZone.offset == GeneralUtility().currentOffset() && timeZone.identifier == GeneralUtility().getCurrentTimeZone(){
                selectedTextZone = timeZone.displayName!
                break
            }
        }
        timeZoneViewController = TimeZoneViewController.init(nibName: "TimeZoneViewController", bundle: nil)
        timeZoneViewController.delegate = self
        timeZoneViewController.selectedTextZone = selectedTextZone
        timeZoneViewController.viewControllerI = self
        timeZoneViewController.modalPresentationStyle = .overFullScreen
        
        let frameI =
            sender.superview?.convert(sender.frame, to: nil)
        timeZoneViewController.txtfieldRect = frameI
        self.present(timeZoneViewController, animated: false) {
            self.timeZoneViewController.reloadTableview()
        }
    }
    
    
    
}

// MARK: Slot Duration, Maxi .
extension ERSideOpenCreateEditVC{
    
    @IBAction func TappedToIncrease(_ sender: UIButton) {
        
        if maxAppoinment == 15
        {
            
        }
        else{
            maxAppoinment = maxAppoinment + 1;
//            txtMaximumAppo.text = "\(maxAppoinment)"
        }
    }
    
    @IBAction func TappedToDecrease(_ sender: UIButton) {
        
        if maxAppoinment == 1{
            
        }
        else{
            
            maxAppoinment = maxAppoinment - 1;
//            txtMaximumAppo.text = "\(maxAppoinment)"
            
        }
        
    }
    
    
    func customizSlotDuration(){
        
        customAfterEndsOcc()
        pickerViewSetUp(txtInput: txtSlotDuration, tag: 191)
        
        let fontHeavy1 = UIFont(name: "FontHeavy".localized(), size: Device.FONTSIZETYPE15)
        UILabel.labelUIHandling(label: lblSlot, text: "Appointment Duration", textColor: ILColor.color(index: 40), isBold: false, fontType: fontHeavy1)
        let fontMedium = UIFont(name: "FontMediumWithoutNext".localized(), size: Device.FONTSIZETYPE13)
        txtSlotDuration.backgroundColor = ILColor.color(index: 48)
        self.txtSlotDuration.font = fontMedium
        self.txtSlotDuration.layer.borderColor = ILColor.color(index: 27).cgColor
        self.txtSlotDuration.layer.borderWidth = 1;
        self.txtSlotDuration.layer.cornerRadius = 3;
        self.txtSlotDuration.placeholder = "Slot Duration"
        self.txtSlotDuration.text = "30 mins"
        
        
        self.txtSlotDuration.rightView = UIImageView.init(image: UIImage.init(named: "Drop-down_arrow"))
        txtSlotDuration.rightViewMode = .always;
        
        if self.objERSideOpenHourDetail != nil{
            let slotDurationValue = Int(self.objERSideOpenHourDetail?.slotDuration ?? "0")!/30
            self.txtSlotDuration.isUserInteractionEnabled = false
            self.txtSlotDuration.isEnabled = false
            self.txtSlotDuration.text =  "\(slotDurationValue) mins"
            self.txtSlotDuration.alpha = 0.6
        }
        else{
            self.txtSlotDuration.isUserInteractionEnabled = true
            self.txtSlotDuration.isEnabled = true
            self.txtSlotDuration.alpha = 1
        }
        
    }
    
    
}


// MARK: Add Reccurrence.

extension ERSideOpenCreateEditVC{
    
    @IBAction func btnRepeatWeekTapped(_ sender: UIButton) {
    
        self.btnRepeatWeekArr.forEach { (btnRepeat) in
            
            if sender.tag == btnRepeat.tag
            {
                btnRepeat.isSelected = !btnRepeat.isSelected
                
                if btnRepeat.isSelected {
                    
                    btnRepeat.setTitleColor(.white, for: .normal)
                    btnRepeat.backgroundColor = ILColor.color(index: 23)
                }
                else{
                    
                    btnRepeat.setTitleColor(ILColor.color(index: 40), for: .normal)
                    btnRepeat.backgroundColor = ILColor.color(index: 48)
                    
                }
                
            }
           
        }
        
    
    }
    
    
    
    
    @IBAction func btnShowCalenderTapped(_ sender: UIButton) {
            
        let frame = sender.convert(sender.frame, from:AppDelegate.getDelegate().window)
        let viewCalender = CalenderViewController.init(nibName: "CalenderViewController", bundle: nil)
        viewCalender.index = 2
        viewCalender.pointedArrow = false
        viewCalender.viewControllerI = self
        viewCalender.pointSign = CGPoint.init(x: abs(frame.origin.x) + abs(frame.size.width/2), y: abs(frame.origin.y) + abs(frame.size.height/2) + 10 )
        viewCalender.modalPresentationStyle = .overFullScreen
        self.present(viewCalender, animated: false) {
        }
        
        
    }
    
    
    
    func viewVisisblityAccordingtoTimeCategory(tag : Int){
           
        if tag == 1 {
            self.nslayoutRepeatMonthViewHeight.constant = 0
            self.nslayoutRepeatWeekViewHeight.constant = 76
            self.nslayoutConstraintRecurrence.constant = 340
            self.viewWeekRepeat.isHidden = false
            self.viewMonthRepeat.isHidden = true
        }
        else  if tag == 2{
            self.nslayoutRepeatMonthViewHeight.constant = 94
            self.nslayoutRepeatWeekViewHeight.constant = 0
            self.nslayoutConstraintRecurrence.constant = 358
            self.viewWeekRepeat.isHidden = true
            self.viewMonthRepeat.isHidden = false
        }
        else
        {
            self.nslayoutRepeatMonthViewHeight.constant = 0
            self.nslayoutRepeatWeekViewHeight.constant = 0
            self.nslayoutConstraintRecurrence.constant = 264
            self.viewWeekRepeat.isHidden = true
            self.viewMonthRepeat.isHidden = true
        }
        
        viewInner.layoutIfNeeded()
        viewScroll.layoutIfNeeded()

        viewScroll.contentSize = CGSize(width: viewScroll.contentSize.width, height: viewInner.frame.height + keyBoardHieght)
        viewScroll.layoutIfNeeded()

    }

    
    func customAfterEndsOcc(){
        endsOnTapped = 2
        btnNeverEnds.setImage(UIImage.init(named: "Radio"), for: .normal);
        btnEndsOnDate.setImage(UIImage.init(named: "Radio"), for: .normal);
        btnAfterEnds.setImage(UIImage.init(named: "Radio_filled"), for: .normal);
    }
    
    
    @IBAction func btnAfterEndsTapped(_ sender: Any) {
        self.customAfterEndsOcc()
        
    }
    @IBAction func btnNeverEndsTapped(_ sender: Any) {
        
        endsOnTapped = 0

        btnNeverEnds.setImage(UIImage.init(named: "Radio_filled"), for: .normal);
        btnEndsOnDate.setImage(UIImage.init(named: "Radio"), for: .normal);
        btnAfterEnds.setImage(UIImage.init(named: "Radio"), for: .normal);

        
    }
    @IBAction func btnEndsOnDateTapped(_ sender: Any) {
        
        endsOnTapped = 1

        btnNeverEnds.setImage(UIImage.init(named: "Radio"), for: .normal);
        btnEndsOnDate.setImage(UIImage.init(named: "Radio_filled"), for: .normal);
        btnAfterEnds.setImage(UIImage.init(named: "Radio"), for: .normal);

    }
    
    
    
    
    func getMonthReccureenceArray () -> Array<String> {
        
        
        var dateCompStartChange = DateComponents()
        
        let comp: DateComponents = Calendar.current.dateComponents([.year, .month], from: dateSelected)
        var startOfMonth = Calendar.current.date(from: comp)!
        
        let  firstWeekDay = dateSelected.get_WeekDay()
        let numberOFDays = dateSelected.get_Day()
        let dateTh = dateSelected.get_Date()
        
        
        var dayNumber = 0
        
        let arrDayNumber = ["First","Second","Third","Fourth","fifth"];
        
        for day in 1...numberOFDays {
            
            dateCompStartChange.month = day ;
            startOfMonth = Calendar.current.date(byAdding: dateCompStartChange, to: startOfMonth)!
            
            
            
            if  startOfMonth.get_WeekDay() == numberOFDays {
                dayNumber = dayNumber + 1;
            }
            
            if startOfMonth == dateSelected{
                break;
            }
        }
        
        let weekDay =  ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
        
        return  ["Monthly on day \(dateTh)", "Monthly on the \(arrDayNumber[dayNumber]) \(weekDay[firstWeekDay]) "]
        
    }
    
    
    
    @IBAction func btnRecurrenceEnableTapped(_ sender: Any) {
        
         isRecurrenceEnable = !isRecurrenceEnable
        
        if isRecurrenceEnable {
             btnRecurrenceEnable.setImage(UIImage.init(named: "Check_box_selected"), for: .normal)
            viewRecurrence.isHidden = false
            nslayoutConstraintRecurrence.constant = 290
            
        }
        else{
             btnRecurrenceEnable.setImage(UIImage.init(named: "check_box"), for: .normal)
            viewRecurrence.isHidden = true
            nslayoutConstraintRecurrence.constant = 0
        }
        
        
    }
    func customizeReccurrence()  {
        
        switch self.objviewTypeOpenHour {
        case .duplicateSetHour:
            
            viewRecurrence.isHidden = true
            nslayoutConstraintRecurrence.constant = 0
            
            btnRecurrenceEnable.isHidden = true
            lblRecurrenceLable.isHidden = true
            
            break
        case .setEditOpenHour:
            
            let fontHeavy1 = UIFont(name: "FontHeavy".localized(), size: Device.FONTSIZETYPE13)
            
            UILabel.labelUIHandling(label: lblRecurrenceLable, text: "Add Recurrence", textColor: ILColor.color(index: 40), isBold: false, fontType: fontHeavy1)
            btnRecurrenceEnable.setImage(UIImage.init(named: "check_box"), for: .normal)
            
            UILabel.labelUIHandling(label: lblRepeat, text: "Repeat Every", textColor: ILColor.color(index: 40), isBold: false, fontType: fontHeavy1)
            
            txtRepeatCount.backgroundColor = ILColor.color(index: 48)
            //        self.txtBreakBufferAfter.layer.cornerRadius = 3;
            
            txtRepeatCount.placeholder = "1"
            txtCategoryTime.backgroundColor = ILColor.color(index: 48)
            let fontMedium = UIFont(name: "FontMediumWithoutNext".localized(), size: Device.FONTSIZETYPE13)
            pickerViewSetUp(txtInput: txtCategoryTime, tag: 194)
            
            
            self.txtCategoryTime.font = fontMedium
            self.txtCategoryTime.layer.cornerRadius = 3;
            let imageView1 = UIImageView.init(image: UIImage.init(named: "Drop-down_arrow"))
            
            imageView1.frame = CGRect(x: 0.0, y: 0.0, width: 20, height: 20)
            
            self.txtCategoryTime.rightView = imageView1
            txtCategoryTime.rightViewMode = .always;
            
            self.txtCategoryTime.text = "Week"
            
            UILabel.labelUIHandling(label: lblRepeatWeek, text: "Repeat On", textColor: ILColor.color(index: 40), isBold: false, fontType: fontHeavy1)
            
            let arrWeekDay = ["S","M","T","W","T","F","S"]
            
            self.btnRepeatWeekArr.forEach { (btn) in
                btn.setTitle(arrWeekDay[btn.tag], for: .normal)
                btn.setTitleColor(ILColor.color(index: 40), for: .normal)
                btn.backgroundColor = ILColor.color(index: 48)
                btn.cornerRadius = 3;
            }
            
            UILabel.labelUIHandling(label: lblMonthRepeat, text: "Repeat On", textColor: ILColor.color(index: 40), isBold: false, fontType: fontHeavy1)
            
            txtRepeatMonth.backgroundColor = ILColor.color(index: 48)
            
            self.txtRepeatMonth.font = fontMedium
            self.txtRepeatMonth.layer.cornerRadius = 3;
            let imageView2 = UIImageView.init(image: UIImage.init(named: "Drop-down_arrow"))
            pickerViewSetUp(txtInput: txtRepeatMonth, tag: 195)
            
            
            self.txtRepeatMonth.rightView = imageView2
            txtRepeatMonth.rightViewMode = .always;
            UILabel.labelUIHandling(label: lblEndsOn, text: "Ends On", textColor: ILColor.color(index: 40), isBold: false, fontType: fontHeavy1)
            
            btnNeverEnds.setImage(UIImage.init(named: "Radio"), for: .normal);
            btnEndsOnDate.setImage(UIImage.init(named: "Radio"), for: .normal);
            btnAfterEnds.setImage(UIImage.init(named: "Radio"), for: .normal);
            
            let fontBook =  UIFont(name: "FontBook".localized(), size: Device.FONTSIZETYPE14)
            UILabel.labelUIHandling(label: lblNeverEnds, text: "Never", textColor: ILColor.color(index: 40), isBold: false, fontType: fontBook)
            
            UILabel.labelUIHandling(label: lblEndsOnDate, text: "On", textColor: ILColor.color(index: 40), isBold: false, fontType: fontBook)
            UILabel.labelUIHandling(label: lblAfterEnds, text: "After", textColor: ILColor.color(index: 40), isBold: false, fontType: fontBook)
            
            UILabel.labelUIHandling(label: lblOccurrenceCountText, text: "Occurence", textColor: ILColor.color(index: 40), isBold: false, fontType: fontBook)
            
            
            txtEndsOnDate.backgroundColor = ILColor.color(index: 48)
            
            self.txtEndsOnDate.font = fontMedium
            self.txtEndsOnDate.layer.cornerRadius = 3;
            let imageView3 = UIImageView.init(image: UIImage.init(named: "Calendar-1"))
            
            imageView3.frame = CGRect(x: 0.0, y: 0.0, width: 20, height: 20)
            
            self.txtEndsOnDate.leftView = imageView3
            txtEndsOnDate.leftViewMode = .always;
            
            txtOccurenceCount.backgroundColor = ILColor.color(index: 48)
            self.txtOccurenceCount.font = fontMedium
            self.txtOccurenceCount.layer.cornerRadius = 3;
            txtOccurenceCount.placeholder = "12"
            let fontHeavy2 = UIFont(name: "FontHeavy".localized(), size: Device.FONTSIZETYPE15)
            
            viewRecurrence.isHidden = true
            nslayoutConstraintRecurrence.constant = 0
            
            
            break
        default:
            break
        }
        
        
        
        
        
    }
    
    
}

// MARK: StartAndEndTime View


extension ERSideOpenCreateEditVC:DeleteParticularStartTimeViewDelegate,RefreshSelectedTimeSlotDelegate {
    func refreshSelectedTS(id: String) {
        
    }
    
    func timeSlotDuplicate(){
        
        var viewPrevious : UIView?
        for index in [1,2,3]{
            let objERSideTimeSlotDuplicate =  ERSideTimeSlotDuplicate().loadView() as! ERSideTimeSlotDuplicate
            objERSideTimeSlotDuplicate.viewconTroller = self
            objERSideTimeSlotDuplicate.delegate = self
            objERSideTimeSlotDuplicate.translatesAutoresizingMaskIntoConstraints = false
            objERSideTimeSlotDuplicate.customization()
            self.viewContainerStartEnd.addSubview(objERSideTimeSlotDuplicate)
            if viewPrevious == nil{
                
                viewContainerStartEnd.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[view]-0-|", options: NSLayoutConstraint.FormatOptions(rawValue : 0), metrics: nil, views: ["view" :objERSideTimeSlotDuplicate ]))
                
                viewContainerStartEnd.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[view(==34)]", options: NSLayoutConstraint.FormatOptions(rawValue : 0), metrics: nil, views: ["view" :objERSideTimeSlotDuplicate ]))
                
            }
            else{
                viewContainerStartEnd.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[view]-0-|", options: NSLayoutConstraint.FormatOptions(rawValue : 0), metrics: nil, views: ["view" :objERSideTimeSlotDuplicate ]))
                
                viewContainerStartEnd.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[viewPrevious]-4-[view(==34)]", options: NSLayoutConstraint.FormatOptions(rawValue : 0), metrics: nil, views: ["viewPrevious":viewPrevious!,"view" :objERSideTimeSlotDuplicate ]))
                
            }
            viewPrevious = objERSideTimeSlotDuplicate
        }
        
         viewContainerStartEnd.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[viewPrevious(==34)]-(4)-|", options: NSLayoutConstraint.FormatOptions(rawValue : 0), metrics: nil, views: ["viewPrevious":viewPrevious!]))
    }

    
    
    
    
    
    
    
    
    
    
    
    func addValueToDicModal(tag: Int, data: String) {
        
        if tag == 998{
            let dicStartEndTime = [ "StartTime" : "HH:MM",
                                    "EndTime" : "HH:MM"
            ]
            //                  arrDataStartEndTimeView.append(dicStartEndTime)
        }
        else{
            
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
        
    func  configureStartEndView(){
        
        let dicStartEndTime = [ "StartTime" : "HH:MM",
                                "EndTime" : "HH:MM"
        ]
        
        //        arrDataStartEndTimeView.append(dicStartEndTime)
        
        if arrERStartEndTImeView.count != 0{
            for view  in  self.viewContainerStartEnd.subviews{
                view.removeFromSuperview()
            }
            
            var index = 1
            var viewPrevious : UIView!
            for viewAlreadyAdded in self.arrERStartEndTImeView{
                viewAlreadyAdded.translatesAutoresizingMaskIntoConstraints = false
                self.viewContainerStartEnd.addSubview(viewAlreadyAdded)
                
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
            
            let startEndTime = ERStartEndTImeView().loadView() as! ERStartEndTImeView
            startEndTime.viewconTroller = self
            startEndTime.delegate = self
            
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
        else{
            let startEndTime = ERStartEndTImeView().loadView() as! ERStartEndTImeView
            
            startEndTime.tag = 1
            startEndTime.btnDelete.tag = 1
            
            startEndTime.delegate = self
            
            startEndTime.viewconTroller = self
            startEndTime.customization()
            
            startEndTime.translatesAutoresizingMaskIntoConstraints = false
            self.viewContainerStartEnd.addSubview(startEndTime)
            viewContainerStartEnd.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[view]-0-|", options: NSLayoutConstraint.FormatOptions(rawValue : 0), metrics: nil, views: ["view" :startEndTime ]))
            viewContainerStartEnd.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[view]-0-|", options: NSLayoutConstraint.FormatOptions(rawValue : 0), metrics: nil, views: ["view" :startEndTime ]))
            arrERStartEndTImeView.append(startEndTime)
            
            self.addInputAccessoryForTextFields(textFields: [startEndTime.txtStartTime,startEndTime.txtEndTime], dismissable: true, previousNextable: true)
            
            
        }
        viewContainerStartEnd.layoutIfNeeded()
        
    }
}




// MARK: VIEWMODAL

extension ERSideOpenCreateEditVC : ERSideCreateEditOHVMDelegate{
    
    
    
    func sentDataToERSideCreateEditOHVC(dataPurposeModal: ERSidePurposeDetailModalArr?, timeZOneArr: [TimeZoneSel]?, success: Bool) {
        if success{
            
            self.timeZOneArr = timeZOneArr
            self.dataPurposeModal = dataPurposeModal
            self.customization()
            
        }
        else{
            CommonFunctions().showError(title: "Error", message: ErrorMessages.SomethingWentWrong.rawValue)
        }
        
    }
    
}
