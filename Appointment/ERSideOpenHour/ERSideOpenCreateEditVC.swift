//
//  ERSideOpenCreateEditVC.swift
//  Appointment
//
//  Created by Anurag Bhakuni on 02/12/20.
//  Copyright © 2020 Anurag Bhakuni. All rights reserved.
//





import UIKit

class ERSideOpenCreateEditVC: SuperViewController,UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate,CalenderViewDelegate {
    func dateSelected(calenderModal: CalenderModal) {
        txtEndsOnDate.text = calenderModal.StrDate
    }
    
    @IBOutlet weak var viewSeperator: UIView!
    @IBOutlet weak var viewOuter: UIView!

    @IBOutlet weak var viewInner: UIView!
    @IBOutlet weak var lblStepHeader: UILabel!
    @IBOutlet weak var btnNext: UIButton!
   
    @IBOutlet weak var viewScroll: UIScrollView!
    var dateSelected : Date!
    var frameSelected : CGRect!
    var activeField : UITextField?
    var keyBooradAlreadyShown = false
    // Purpose
    @IBOutlet weak var viewHeightConstraint: NSLayoutConstraint!

    @IBOutlet weak var viewSelectedContainer: UIView!
    @IBOutlet weak var lblPurpose: UILabel!
    @IBOutlet weak var txtPurpose: LeftPaddedTextField!
    @IBOutlet weak var btnPurpose: UIButton!
   
   
    
    //Timing
    
    @IBOutlet weak var lblTimingFrom: UILabel!
    @IBOutlet weak var txtTimingFrom: UITextField!
    @IBOutlet weak var lblTimingTo: UILabel!
    @IBOutlet weak var txtTimingTo: UITextField!

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
    @IBOutlet weak var txtMaximumAppo: UITextField!
    var maxAppoinment = 10;
    
    @IBOutlet weak var viewMaxAppo: UIView!
    //BreakBuffer
    @IBOutlet weak var lblBreakBuffer: UILabel!
    
    @IBOutlet weak var txtBreakBufferBefore: LeftPaddedTextField!
    @IBOutlet weak var txtBreakBufferAfter: LeftPaddedTextField!
    
    @IBOutlet weak var lblBreakBufferBefore: UILabel!
    @IBOutlet weak var lblBreakBufferAfter: UILabel!
    @IBOutlet weak var viewBreakBuffer: UIView!
    
    //Recurrence
    
    var isRecurrenceEnable = true
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
    
    @IBAction func btnRepeatWeekTapped(_ sender: Any) {
    }
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
    @IBOutlet weak var btnNextBottom: UIButton!
    var objERSideCreateEditOHVM : ERSideCreateEditOHVM!
    var dataPurposeModal: ERSidePurposeDetailModalArr?
    var timeZOneArr: [TimeZoneSel]!
    var searchArrayPurpose = [SearchTextFieldItem]()

      let pickerView = UIPickerView()
    
    @IBOutlet var btnIncrease: UIButton!
    @IBOutlet var btnDecrease: UIButton!
    
    var objERSideOpenHourDetail: ERSideOpenHourDetail?

    // NSLAYOUTCONSTRAINT
    
    
    @IBOutlet weak var nslayoutConstraintRecurrence: NSLayoutConstraint!
    
    @IBOutlet weak var nslayoutLayoutBreakBuffer: NSLayoutConstraint!
    
    @IBOutlet weak var nslayoutConstarintMaxAppoi: NSLayoutConstraint!
    
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
        self.viewOuter.backgroundColor =  ILColor.color(index: 22)
        viewSeperator.backgroundColor = ILColor.color(index: 22)

        commonCustomization()
        customizeHeader()
        customizePurpose()
        customizeTiming()
        customizeTimeZone()
        customizSlotDuration()
        customizeReccurrence()
        
        if objERSideOpenHourDetail != nil{
            nslayoutConstraintRecurrence.constant = 0
            nslayoutLayoutBreakBuffer.constant = 0
            nslayoutConstarintMaxAppoi.constant = 0
            nslayoutConstraintTimeZone.constant = 0
             viewRecurrence.isHidden = true
            viewMaxAppo.isHidden = true
            viewTimezone.isHidden = true
            viewBreakBuffer.isHidden = true
            lblRecurrenceLable.isHidden = true
            btnRecurrenceEnable.isHidden = true;
        }
        else{
            viewMonthRepeat.isHidden = true
            nslayoutRepeatMonthViewHeight.constant = 0
            nslayoutConstraintRecurrence.constant = 340

            
        }
        
       
    }
    
    override func actnResignKeyboard() {
        activeField!.resignFirstResponder()
     }
    
    func commonCustomization(){
        
        self.addInputAccessoryForTextFields(textFields: [txtTimingFrom,txtTimingTo], dismissable: true, previousNextable: true)
        
        self.addInputAccessoryForTextFields(textFields: [txtSlotDuration,txtMaximumAppo,txtBreakBufferBefore,txtBreakBufferAfter,txtRepeatCount,txtCategoryTime], dismissable: true, previousNextable: true)
        
        self.addInputAccessoryForTextFields(textFields: [txtRepeatMonth], dismissable: true, previousNextable: true)

        
        self.addInputAccessoryForTextFields(textFields: [txtEndsOnDate], dismissable: true, previousNextable: true)
        
        self.addInputAccessoryForTextFields(textFields: [txtOccurenceCount], dismissable: true, previousNextable: true)
        
        
            btnIncrease.setImage(UIImage.init(named: "Add"), for: .normal)
            btnDecrease.setImage(UIImage.init(named: "Minus"), for: .normal)
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
            arrPicker = ["15 mins","30 mins","45 mins","60 mins"]
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
        
        if textField == txtMaximumAppo || textField == txtRepeatCount || textField == txtOccurenceCount{
        
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
            arrPicker = ["15 mins","30 mins","45 mins","60 mins"]
            txtSlotDuration.text = arrPicker[row]
        }
        else if PickerSelectedTag == 192{
            arrPicker = ["0 mins","5 mins","10 mins","15 mins","30 mins","45 mins","60 mins"]
            txtBreakBufferBefore.text = arrPicker[row]
        }
        else if PickerSelectedTag == 193{
            arrPicker = ["0 mins","5 mins","10 mins","15 mins","30 mins","45 mins","60 mins"]
            txtBreakBufferAfter.text = arrPicker[row]
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
        
        if let fontHeavy = UIFont(name: "FontHeavy".localized(), size: Device.FONTSIZETYPE15), let fontBook =  UIFont(name: "FontBook".localized(), size: Device.FONTSIZETYPE14)
            
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
        
       
        
    }
    
    
    @IBAction func btnNextTapped(_ sender: Any) {
        if validatingForm(){
            let objERSideOpenCreateEditSecondVC = ERSideOpenCreateEditSecondVC.init(nibName: "ERSideOpenCreateEditSecondVC", bundle: nil)
            objERSideOpenCreateEditSecondVC.objERSideOpenHourDetail = self.objERSideOpenHourDetail
            objERSideOpenCreateEditSecondVC.dateSelected = self.dateSelected
            self.navigationController?.pushViewController(objERSideOpenCreateEditSecondVC, animated: false)
        }
        
        
    }
    
    
    func validatingForm()-> Bool{
        
        
        if txtMaximumAppo.text!.isEmpty {
            
        }
        else{
            if (Int(self.txtMaximumAppo.text!)! > 15){
                
                CommonFunctions().showError(title: "Error", message: "Maximum Appoinments per day can't be more than 15")
                
                return false
            }
            if (Int(self.txtMaximumAppo.text!)! < 1){
                
                CommonFunctions().showError(title: "Error", message: "Maximum Appoinments per day should be atleast 1")
                
                return false
            }
            
        }
        
        
        
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
                
                if (sumWidth + view.frame.width + 8 < self.view.frame.width)
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
            txtTimingFrom.text = dateFormatter.string(from: sender.date);
        }
        else{
            let dateFormatter = DateFormatter.init();
            dateFormatter.dateFormat = "hh:mm a"
            txtTimingTo.text = dateFormatter.string(from: sender.date);
            
        }
        
        
        
    }
    
    
    
    
    func customizeTiming()  {
        
        datePickerTiming(txtInput: txtTimingFrom, tag: 998)
        datePickerTiming(txtInput: txtTimingTo, tag: 999)
        
        if let fontHeavy = UIFont(name: "FontHeavy".localized(), size: Device.FONTSIZETYPE15)
        {
            let strHeader = NSMutableAttributedString.init()
            let strTiTle = NSAttributedString.init(string: "From"
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
            let strTiTle = NSAttributedString.init(string: "To"
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
        
        let fontMedium = UIFont(name: "FontMediumWithoutNext".localized(), size: Device.FONTSIZETYPE13)
        txtTimingFrom.backgroundColor = ILColor.color(index: 48)
        self.txtTimingFrom.font = fontMedium
        self.txtTimingFrom.layer.borderColor = ILColor.color(index: 27).cgColor
        self.txtTimingFrom.layer.borderWidth = 1;
        self.txtTimingFrom.layer.cornerRadius = 3;
        let imageView = UIImageView.init(image: UIImage.init(named: "Calendar-1"))
        imageView.frame = CGRect(x: 0.0, y: 0.0, width: 20, height: 20)
        
        self.txtTimingFrom.leftView = imageView
        txtTimingFrom.leftViewMode = .always;
        
        
        txtTimingTo.backgroundColor = ILColor.color(index: 48)
        self.txtTimingTo.font = fontMedium
        self.txtTimingTo.layer.borderColor = ILColor.color(index: 27).cgColor
        self.txtTimingTo.layer.borderWidth = 1;
        self.txtTimingTo.layer.cornerRadius = 3;
        let imageView1 = UIImageView.init(image: UIImage.init(named: "Calendar-1"))
        
        imageView1.frame = CGRect(x: 0.0, y: 0.0, width: 20, height: 20)
        
        self.txtTimingTo.leftView = imageView1
        txtTimingTo.leftViewMode = .always;
        if self.objERSideOpenHourDetail != nil
        {
            
            self.txtTimingFrom.isEnabled = false
            self.txtTimingTo.isEnabled = false
            self.txtTimingFrom.isUserInteractionEnabled = false
            self.txtTimingTo.isUserInteractionEnabled = false

            self.txtTimingFrom.text =  GeneralUtility.currentDateDetailType3(emiDate: (self.objERSideOpenHourDetail?.startDatetimeUTC)!)
            
            self.txtTimingTo.text =  GeneralUtility.currentDateDetailType3(emiDate: (self.objERSideOpenHourDetail?.endDatetimeUTC)!)
            self.txtTimingTo.alpha = 0.6
            self.txtTimingFrom.alpha = 0.6

        }
        else {
            self.txtTimingFrom.isEnabled = true
            self.txtTimingTo.isEnabled = true
            self.txtTimingFrom.isUserInteractionEnabled = true
            self.txtTimingTo.isUserInteractionEnabled = true
            
            self.txtTimingTo.alpha = 1
            self.txtTimingFrom.alpha = 1
            
            
            self.txtTimingFrom.text = "11:00 AM"
            self.txtTimingTo.text = "1:00 PM"
            
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
            txtMaximumAppo.text = "\(maxAppoinment)"
        }
    }
    
    @IBAction func TappedToDecrease(_ sender: UIButton) {
        
        if maxAppoinment == 1{
            
        }
        else{
            
            maxAppoinment = maxAppoinment - 1;
            txtMaximumAppo.text = "\(maxAppoinment)"
            
        }
        
        
        
    }
    
    
    
    
    
    func customizSlotDuration(){
        
        
        pickerViewSetUp(txtInput: txtSlotDuration, tag: 191)
        
        
        
        let fontHeavy1 = UIFont(name: "FontHeavy".localized(), size: Device.FONTSIZETYPE11)
        UILabel.labelUIHandling(label: lblSlot, text: "Slot Duration", textColor: ILColor.color(index: 40), isBold: false, fontType: fontHeavy1)
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
        
        
        
        UILabel.labelUIHandling(label: lblMaximumAppo, text: "Maximum Appointments per day", textColor: ILColor.color(index: 40), isBold: false, fontType: fontHeavy1)
        txtMaximumAppo.backgroundColor = ILColor.color(index: 48)
        self.txtMaximumAppo.font = fontMedium
        self.txtSlotDuration.layer.cornerRadius = 3;
        self.txtMaximumAppo.placeholder = "10"
        
        let fontBook =  UIFont(name: "FontBook".localized(), size: Device.FONTSIZETYPE11)
        
        UILabel.labelUIHandling(label: lblBreakBuffer, text: "Break Buffers", textColor: ILColor.color(index: 40), isBold: false, fontType: fontHeavy1)
        
        UILabel.labelUIHandling(label: lblBreakBufferBefore, text: "Before Appointments", textColor: ILColor.color(index: 40), isBold: false, fontType: fontBook)
        
        UILabel.labelUIHandling(label: lblBreakBufferAfter, text: "After Appointments", textColor: ILColor.color(index: 40), isBold: false, fontType: fontBook)
        
        
        
        txtBreakBufferAfter.backgroundColor = ILColor.color(index: 48)
        self.txtBreakBufferAfter.font = fontMedium
        self.txtBreakBufferAfter.layer.cornerRadius = 3;
        self.txtBreakBufferAfter.placeholder = "Break After Buffers"
        
        self.txtBreakBufferAfter.rightView = UIImageView.init(image: UIImage.init(named: "Drop-down_arrow"))
        txtBreakBufferAfter.rightViewMode = .always;
        self.txtBreakBufferAfter.text = "0"
        
        pickerViewSetUp(txtInput: txtBreakBufferAfter, tag: 193)
        pickerViewSetUp(txtInput: txtBreakBufferBefore, tag: 192)
        
        
        txtBreakBufferBefore.backgroundColor = ILColor.color(index: 48)
        self.txtBreakBufferBefore.rightView = UIImageView.init(image: UIImage.init(named: "Drop-down_arrow"))
        txtBreakBufferBefore.rightViewMode = .always;
        
        self.txtBreakBufferBefore.font = fontMedium
        self.txtBreakBufferBefore.layer.cornerRadius = 3;
        self.txtBreakBufferBefore.placeholder = "Break Before Buffers"
        self.txtBreakBufferBefore.text = "0"
        
        
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
    
    
    @IBAction func btnShowCalenderTapped(_ sender: UIButton) {
            
        let frame = sender.convert(sender.frame, from:AppDelegate.getDelegate().window)
        let viewCalender = CalenderViewController.init(nibName: "CalenderViewController", bundle: nil)
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

    
    @IBAction func btnAfterEndsTapped(_ sender: Any) {
        
        btnNeverEnds.setImage(UIImage.init(named: "Radio"), for: .normal);
        btnEndsOnDate.setImage(UIImage.init(named: "Radio"), for: .normal);
        btnAfterEnds.setImage(UIImage.init(named: "Radio_filled"), for: .normal);

        
        
    }
    @IBAction func btnNeverEndsTapped(_ sender: Any) {
        
        btnNeverEnds.setImage(UIImage.init(named: "Radio_filled"), for: .normal);
        btnEndsOnDate.setImage(UIImage.init(named: "Radio"), for: .normal);
        btnAfterEnds.setImage(UIImage.init(named: "Radio"), for: .normal);

        
    }
    @IBAction func btnEndsOnDateTapped(_ sender: Any) {
        
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
        let fontHeavy1 = UIFont(name: "FontHeavy".localized(), size: Device.FONTSIZETYPE11)
        
        UILabel.labelUIHandling(label: lblRecurrenceLable, text: "Add Reccurence", textColor: ILColor.color(index: 40), isBold: false, fontType: fontHeavy1)
        btnRecurrenceEnable.setImage(UIImage.init(named: "check_box"), for: .normal)
        
        UILabel.labelUIHandling(label: lblRepeat, text: "Repeat Every", textColor: ILColor.color(index: 40), isBold: false, fontType: fontHeavy1)
        
        txtRepeatCount.backgroundColor = ILColor.color(index: 48)
        self.txtBreakBufferAfter.layer.cornerRadius = 3;
        
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

        UIButton.buttonUIHandling(button: btnNextBottom, text: "Next", backgroundColor: ILColor.color(index: 23), textColor: .white, cornerRadius: 3,  fontType: fontHeavy2)
        
        
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
