//
//  ERSideOpenCreateEditSecondVC.swift
//  Appointment
//
//  Created by Anurag Bhakuni on 02/12/20.
//  Copyright © 2020 Anurag Bhakuni. All rights reserved.
//

import UIKit

class ERSideOpenCreateEditSecondVC: SuperViewController,UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate {
    @IBOutlet weak var lblStepHeader: UILabel!
    @IBOutlet weak var btnNext: UIButton!
   
    @IBOutlet weak var viewScroll: UIScrollView!
    
    @IBOutlet weak var viewSeperator: UIView!
    @IBOutlet weak var viewOuter: UIView!
    
    @IBOutlet weak var viewInner: UIView!
    
    var objERSideOpenHourDetail: ERSideOpenHourDetail?
    var dateSelected : Date!
    var activityIndicator: ActivityIndicatorView?

    let pickerView = UIPickerView()
    var PickerSelectedTag = 0;
    var activeField : UITextField?
    var keyBooradAlreadyShown = false
    var keyBoardHieght : CGFloat = 0.0;


    //ReuestAppro
    @IBOutlet weak var lblReuestAppro: UILabel!
    
    @IBOutlet weak var txtReuestAppro: LeftPaddedTextField!
    
    //LocationType
    
    
    @IBOutlet weak var nslayoutConstarintDefaultHeight: NSLayoutConstraint!
    @IBOutlet weak var viewLocationDefault: UIView!
    
    @IBOutlet weak var lblLocationType: UILabel!
    
    @IBOutlet weak var txtLocationType: LeftPaddedTextField!
    
    @IBOutlet weak var lblDefaultLocatiob: UILabel!
    
    @IBOutlet weak var txtDefaultLocation: UITextField!
    
    @IBOutlet weak var btnDeadlineEnabled: UIButton!
    
    @IBOutlet weak var lblDeadlineEnabled: UILabel!
    
   
    
    @IBOutlet weak var lblDeadlineInfo: UILabel!
    
    @IBOutlet weak var txtDeadline: LeftPaddedTextField!
    
    @IBOutlet weak var lblBefore: UILabel!
    
    @IBOutlet weak var txtDeadlineTime: UITextField!
    
    @IBOutlet weak var lblDeadlineFooter: UILabel!
    
    @IBOutlet weak var btnPrivateOpenHour: UIButton!
    
    
   
    
    @IBOutlet weak var lblPrivateOpenHour: UILabel!
    
    @IBOutlet weak var lblPrivateOpenHourHeading: UILabel!
    
    @IBOutlet weak var lblCountStudent: UILabel!
    
    @IBOutlet weak var btnAddStudent: UIButton!
    
   
    
    @IBOutlet weak var btnSave: UIButton!
    
    @IBAction func btnSaveTapped(_ sender: Any) {
    }
    
    var objProviderModalArr : [ProviderModal]!
    
    
    var isDeadlineEnabled = false
    var isPrivateEnabled = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewInner.isHidden = true
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM YYYY"
        GeneralUtility.customeNavigationBarWithOnlyBack(viewController: self, title: "Open Hours" + " - " + dateFormatter.string(from: self.dateSelected))
        callViewModal()
        
    }
    @objc override func buttonClicked(sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: false)
    }
    
    func callViewModal()  {
        viewInner.isHidden = true
        activityIndicator = ActivityIndicatorView.showActivity(view: self.view, message: StringConstants.FetchingCoachSelection)
        ERSideOpenEditSecondVM().fetchProvider({ (data) in
            self.activityIndicator?.hide()
            do {
                self.activityIndicator?.hide()
                self.objProviderModalArr = try
                    JSONDecoder().decode(ProviderModalArr.self, from: data)
                self.customization();
            } catch   {
                print(error)
                self.activityIndicator?.hide()

            }
        }) { (error, errorCode) in
            self.activityIndicator?.hide()
        }
    }
    
    
    func customization()  {
        
        
        self.addInputAccessoryForTextFields(textFields: [txtReuestAppro,txtLocationType], dismissable: true, previousNextable: true)

        self.addInputAccessoryForTextFields(textFields: [txtDeadline,txtDeadlineTime], dismissable: true, previousNextable: true)

        
        
        registerForKeyboardNotifications()

        nslayoutConstarintDefaultHeight.constant = 0
        self.viewLocationDefault.isHidden = true
        self.viewInner.isHidden = false
        self.viewInner.backgroundColor =  .white
        self.viewOuter.backgroundColor =  ILColor.color(index: 22)
        viewSeperator.backgroundColor = ILColor.color(index: 22)
        customizeHeader()
        customRequestApproval()
        customLocation()
        customPrivate()
        customDeadline()
    }
    
    
    
    override func actnResignKeyboard() {
       activeField!.resignFirstResponder()
    }
    
    
    // MARK:  Textfield delegate
       
       
       func textFieldShouldReturn(_ textField: UITextField) -> Bool {
              textField.resignFirstResponder()
              return true
          }
          
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.tag == 191{
            arrPicker = ["Automatic Approval","Manual Approval"]
            PickerSelectedTag = 191;
            let pickerSelected = self.arrPicker.firstIndex(where: {$0 == textField.text}) ?? 0
            pickerView.selectRow(pickerSelected, inComponent: 0, animated: false)
        }
        else  if textField.tag == 192{
            arrPicker = ["Physical Location","Meeting URL","Zoom URL"]
            PickerSelectedTag = 192;
        }
        else  if textField.tag == 193{
            arrPicker = ["1 day before Appointment","2 day before Appointment","3 day before Appointment","4 day before Appointment"]
            PickerSelectedTag = 193;
        }
        pickerView.reloadAllComponents()
        activeField = textField
    }
          
       func textFieldDidEndEditing(_ textField: UITextField) {
           activeField = nil
       }
       
       
       func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
           
             guard let currentText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) else { return true }
           
//           if textField == txtMaximumAppo || textField == txtRepeatCount || textField == txtOccurenceCount{
//
//               if currentText.count > 4 {
//                   return false
//               }
//
//           }
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
            arrPicker = ["Automatic Approval","Manual Approval"]
            txtReuestAppro.text = arrPicker[row]
        }
        else if PickerSelectedTag == 192{
            arrPicker = ["Physical Location","Meeting URL","Zoom URL"]
            txtLocationType.text = arrPicker[row]
            selectedTypeLocation(row: row)
        }
        else if PickerSelectedTag == 193{
            arrPicker = ["1 day before Appointment","2 day before Appointment","3 day before Appointment","4 day before Appointment"]
            txtDeadline.text = arrPicker[row]
        }
    }
    override func removeKeyCommand(_ keyCommand: UIKeyCommand) {
          
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
    
    
}


// MARK: Header.

extension ERSideOpenCreateEditSecondVC
{
    
    func customizeHeader(){
        if let fontHeavy = UIFont(name: "FontHeavy".localized(), size: Device.FONTSIZETYPE15), let fontBook =  UIFont(name: "FontBook".localized(), size: Device.FONTSIZETYPE14)
            
        {
            let strHeader = NSMutableAttributedString.init()
            let strTiTle = NSAttributedString.init(string: "Step 2"
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
            UIButton.buttonUIHandling(button: btnNext, text: "Save", backgroundColor: .clear, textColor: ILColor.color(index: 23),  fontType: fontHeavy)
          
            UIButton.buttonUIHandling(button: btnSave, text: "Next", backgroundColor: ILColor.color(index: 23), textColor: .white, cornerRadius: 3,  fontType: fontHeavy)
  
            
        }
        
    }
    
    
    @IBAction func btnNextTapped(_ sender: Any) {
        if validatingForm(){
           
        }
        
        
    }
    
    
    func validatingForm()-> Bool{
        
        return true
    }
    
}


// MARK: Request Approval.

extension ERSideOpenCreateEditSecondVC{
    
    
    func customRequestApproval()  {
        pickerViewSetUp(txtInput: txtReuestAppro, tag: 191)
        
        let fontHeavy1 = UIFont(name: "FontHeavy".localized(), size: Device.FONTSIZETYPE11)
        UILabel.labelUIHandling(label: lblReuestAppro, text: "Request Approval", textColor: ILColor.color(index: 40), isBold: false, fontType: fontHeavy1)
        let fontMedium = UIFont(name: "FontMediumWithoutNext".localized(), size: Device.FONTSIZETYPE13)
        
        txtReuestAppro.backgroundColor = ILColor.color(index: 48)
        self.txtReuestAppro.font = fontMedium
        self.txtReuestAppro.layer.borderColor = ILColor.color(index: 27).cgColor
        self.txtReuestAppro.layer.borderWidth = 1;
        self.txtReuestAppro.layer.cornerRadius = 3;
        self.txtReuestAppro.text = "Automatic Approval"
        self.txtReuestAppro.rightView = UIImageView.init(image: UIImage.init(named: "Drop-down_arrow"))
        txtReuestAppro.rightViewMode = .always;
        
        if objERSideOpenHourDetail != nil{
            prefilledValueRequestApproval()
        }
        
    }
    
    
    func prefilledValueRequestApproval()  {
        
    }
    
}


// MARK: Location.
extension ERSideOpenCreateEditSecondVC{
    
    
    func customLocation()  {
        pickerViewSetUp(txtInput: txtLocationType, tag: 192)
        
        if let fontHeavy = UIFont(name: "FontHeavy".localized(), size: Device.FONTSIZETYPE15)
        {
            let strHeader = NSMutableAttributedString.init()
            let strTiTle = NSAttributedString.init(string: "Location"
                , attributes: [NSAttributedString.Key.foregroundColor : ILColor.color(index: 31),NSAttributedString.Key.font : fontHeavy]);
            let strType = NSAttributedString.init(string: "  ⃰"
                , attributes: [NSAttributedString.Key.foregroundColor : UIColor.red,NSAttributedString.Key.font : fontHeavy]);
            let para = NSMutableParagraphStyle.init()
            //            para.alignment = .center
            strHeader.append(strTiTle)
            strHeader.append(strType)
            
            strHeader.addAttribute(NSAttributedString.Key.paragraphStyle, value: para, range: NSMakeRange(0, strHeader.length))
            lblLocationType.attributedText = strHeader
        }
        let fontMedium = UIFont(name: "FontMediumWithoutNext".localized(), size: Device.FONTSIZETYPE13)
        
        txtLocationType.backgroundColor = ILColor.color(index: 48)
        self.txtLocationType.font = fontMedium
        self.txtLocationType.layer.borderColor = ILColor.color(index: 27).cgColor
        self.txtLocationType.layer.borderWidth = 1;
        self.txtLocationType.layer.cornerRadius = 3;
        self.txtLocationType.rightView = UIImageView.init(image: UIImage.init(named: "Drop-down_arrow"))
        txtLocationType.rightViewMode = .always;
        
    }
    
    
    func selectedTypeLocation(row: Int){
        
        var notFound = -1
        for provider in  self.objProviderModalArr {
            if provider.provider == "physical_location" && provider.isAvailable == false{
                if row == 0 {
                    notFound = 0
                    break ;
                }
                
            }
                
            else if provider.provider == "webinar_link" && provider.isAvailable == false{
                if row == 1 {
                    notFound = 1
                    break ;
                }
            }
                
            else if provider.provider == "zoom_link" && provider.isAvailable == false{
                if row == 2 {
                    notFound = 2
                    break ;
                }
            }
        }
        
        if notFound == row{
            
            if notFound == 0{
                CommonFunctions().showError(title: "Error", message: "")
                
            }
            else if notFound == 1{
                CommonFunctions().showError(title: "Error", message: "")
                
            }
            else if notFound == 2 {
                CommonFunctions().showError(title: "Error", message: "Zoom is not connected with your account. Visit the Zoom Integration Web Page to connect your account.")
                nslayoutConstarintDefaultHeight.constant = 0
                self.viewLocationDefault.isHidden = true
                
            }
            viewInner.layoutIfNeeded()
            viewScroll.layoutIfNeeded()
            
            viewScroll.contentSize = CGSize(width: viewScroll.contentSize.width, height: viewInner.frame.height + keyBoardHieght)
            viewScroll.layoutIfNeeded()
            
            return
        }
        
        nslayoutConstarintDefaultHeight.constant = 84
        self.viewLocationDefault.isHidden = false
        
        
        viewInner.layoutIfNeeded()
        viewScroll.layoutIfNeeded()
        
        viewScroll.contentSize = CGSize(width: viewScroll.contentSize.width, height: viewInner.frame.height + keyBoardHieght)
        viewScroll.layoutIfNeeded()
        
        let fontMedium = UIFont(name: "FontMediumWithoutNext".localized(), size: Device.FONTSIZETYPE13)
        
        txtDefaultLocation.backgroundColor = ILColor.color(index: 48)
        self.txtDefaultLocation.font = fontMedium
        self.txtDefaultLocation.layer.borderColor = ILColor.color(index: 27).cgColor
        self.txtDefaultLocation.layer.borderWidth = 1;
        self.txtDefaultLocation.layer.cornerRadius = 3;
        
        let fontHeavy1 = UIFont(name: "FontHeavy".localized(), size: Device.FONTSIZETYPE11)
        
        
        if row == 0  {
            UILabel.labelUIHandling(label: lblDefaultLocatiob, text: "Custom Address or Location", textColor: ILColor.color(index: 40), isBold: false, fontType: fontHeavy1)
            txtDefaultLocation.placeholder = "Building 111, R103"
            
            
        }
        else if row == 1{
            UILabel.labelUIHandling(label: lblDefaultLocatiob, text: "Custom Meeting URL", textColor: ILColor.color(index: 40), isBold: false, fontType: fontHeavy1)
            txtDefaultLocation.placeholder = "https://www.web.com/link"
        }
        else
        {
            UILabel.labelUIHandling(label: lblDefaultLocatiob, text: "Web Conference", textColor: ILColor.color(index: 40), isBold: false, fontType: fontHeavy1)
            txtDefaultLocation.placeholder = "Zoom Link"
            
        }
        
        
    }
    
}
// MARK: Deadline.
extension ERSideOpenCreateEditSecondVC{
    
    
    @IBAction func btnEnabledTapped(_ sender: Any) {
        isDeadlineEnabled = !isDeadlineEnabled
        if isDeadlineEnabled{
            btnDeadlineEnabled.setImage(UIImage.init(named: "Radio_filled"), for: .normal);
            enableDeadline()
        }
        else{
            btnDeadlineEnabled.setImage(UIImage.init(named: "Radio"), for: .normal);
            disabledDeadline()
        }
    }
    
    @objc func datePickerValueChanged(sender:UIDatePicker)  {
        let dateFormatter = DateFormatter.init();
        dateFormatter.dateFormat = "hh:mm a"
        txtDeadlineTime.text = dateFormatter.string(from: sender.date);
        
    }
    
    
    
    func datePickerTiming(txtInput : UITextField)  {
        
        let  dbDatePickerFromTiming = UIDatePicker.init()
        dbDatePickerFromTiming.tag = 100
        dbDatePickerFromTiming.addTarget(self, action: #selector(datePickerValueChanged(sender:)), for: .valueChanged)
        dbDatePickerFromTiming.timeZone = NSTimeZone.default;
        dbDatePickerFromTiming.datePickerMode = .time
        txtInput.inputView = dbDatePickerFromTiming;
        
        let string = "5:00 PM"
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        let date = formatter.date(from: string)
        
        dbDatePickerFromTiming.setDate(date!, animated: false)
        
        
        
    }
    
    func disabledDeadline()  {
        
        txtDeadline.isUserInteractionEnabled = false
        txtDeadline.isEnabled = false
        self.txtDeadline.alpha = 0.6
        
        txtDeadlineTime.isUserInteractionEnabled = false
        txtDeadlineTime.isEnabled = false
        self.txtDeadlineTime.alpha = 0.6
        
    }
    
    func enableDeadline(){
        
        
        txtDeadline.isUserInteractionEnabled = true
        txtDeadline.isEnabled = true
        self.txtDeadline.alpha = 1
        
        txtDeadlineTime.isUserInteractionEnabled = true
        txtDeadlineTime.isEnabled = true
        self.txtDeadlineTime.alpha = 1
        
        
    }
    
    
    
    func customDeadline()  {
        pickerViewSetUp(txtInput: txtDeadline, tag: 193)
        
        
        UIButton.buttonUIHandling(button: btnDeadlineEnabled, text: "", backgroundColor: .clear, textColor: .clear, buttonImage: UIImage.init(named: "Radio"))
        
        let fontHeavy1 = UIFont(name: "FontHeavy".localized(), size: Device.FONTSIZETYPE11)
        UILabel.labelUIHandling(label: lblDeadlineEnabled, text: "Add Deadline", textColor: ILColor.color(index: 40), isBold: false, fontType: fontHeavy1)
        
        
        let fontBook =  UIFont(name: "FontBook".localized(), size: Device.FONTSIZETYPE14)
        
        UILabel.labelUIHandling(label: lblDeadlineInfo, text: "Deadline for candidates to book appointment slot", textColor: ILColor.color(index: 40), isBold: false, fontType: fontBook)
        
        UILabel.labelUIHandling(label: lblBefore, text: "Before", textColor: ILColor.color(index: 40), isBold: false, fontType: fontBook)
        
        UILabel.labelUIHandling(label: lblDeadlineFooter, text: "Eg: For appointment at 11:00 AM, 18th Dec 2020, candidates will have to book this particular slot by 05:00 PM, 17th Dec 2020", textColor: ILColor.color(index: 40), isBold: false, fontType: fontBook)
        
        
        let fontMedium = UIFont(name: "FontMediumWithoutNext".localized(), size: Device.FONTSIZETYPE13)
        
        txtDeadline.backgroundColor = ILColor.color(index: 48)
        self.txtDeadline.font = fontMedium
        self.txtDeadline.layer.borderColor = ILColor.color(index: 27).cgColor
        self.txtDeadline.layer.borderWidth = 1;
        self.txtDeadline.layer.cornerRadius = 3;
        self.txtDeadline.text = "1 day before Appointment"
        self.txtDeadline.rightView = UIImageView.init(image: UIImage.init(named: "Drop-down_arrow"))
        txtDeadline.rightViewMode = .always;
        
        
        
        
        txtDeadlineTime.backgroundColor = ILColor.color(index: 48)
        self.txtDeadlineTime.font = fontMedium
        self.txtDeadlineTime.layer.cornerRadius = 3;
        self.txtDeadlineTime.layer.borderColor = ILColor.color(index: 27).cgColor
        self.txtDeadlineTime.layer.borderWidth = 1;

        let imageView3 = UIImageView.init(image: UIImage.init(named: "Calendar-1"))
        imageView3.frame = CGRect(x: 0.0, y: 0.0, width: 20, height: 20)
        self.txtDeadlineTime.leftView = imageView3
        txtDeadlineTime.leftViewMode = .always;
        datePickerTiming(txtInput: txtDeadlineTime)
        
        self.disabledDeadline()
        
    }
}

// MARK: Private.
extension ERSideOpenCreateEditSecondVC{
    
    @IBAction func btnPrivateOpenHourTapped(_ sender: Any) {
        let fontBook =  UIFont(name: "FontBook".localized(), size: Device.FONTSIZETYPE14)
        
        isPrivateEnabled = !isPrivateEnabled
        
        if isPrivateEnabled{
              btnDeadlineEnabled.setImage(UIImage.init(named: "Radio_filled"), for: .normal);
            btnAddStudent.isHidden = false
            UILabel.labelUIHandling(label: lblCountStudent, text: "0", textColor: ILColor.color(index: 23), isBold: false, fontType: fontBook)
            
        }
        else
        {
            btnAddStudent.isHidden = true
            btnDeadlineEnabled.setImage(UIImage.init(named: "Radio"), for: .normal);
            UILabel.labelUIHandling(label: lblCountStudent, text: "2", textColor: ILColor.color(index: 23), isBold: false, fontType: fontBook)
            
        }
    
    
    }
    
    
    
    @IBAction func BtnAddAStudentTapped(_ sender: Any) {
        
        let objERSideStudentListViewController = ERSideStudentListViewController.init(nibName: "ERSideStudentListViewController", bundle: nil)
        self.navigationController?.pushViewController(objERSideStudentListViewController, animated: false)
        
        
    }
    
    
    
    func customPrivate()  {
        
        let fontHeavy = UIFont(name: "FontHeavy".localized(), size: Device.FONTSIZETYPE15)
        let fontBook =  UIFont(name: "FontBook".localized(), size: Device.FONTSIZETYPE14)
        
        let fontMedium = UIFont(name: "FontMediumWithoutNext".localized(), size: Device.FONTSIZETYPE13)
        
        
        UIButton.buttonUIHandling(button: btnPrivateOpenHour, text: "", backgroundColor: .clear, textColor: .clear, buttonImage: UIImage.init(named: "Radio"))
        UILabel.labelUIHandling(label: lblPrivateOpenHour, text: "Private Open Hours", textColor: ILColor.color(index: 40), isBold: false, fontType: fontHeavy)
        if let fontHeavy = UIFont(name: "FontHeavy".localized(), size: Device.FONTSIZETYPE15), let fontBook =  UIFont(name: "FontBook".localized(), size: Device.FONTSIZETYPE14),let fontMedium = UIFont(name: "FontMediumWithoutNext".localized(), size: Device.FONTSIZETYPE13)
            
        {
            let strHeader = NSMutableAttributedString.init()
            let nextLine1 = NSAttributedString.init(string: "\n")
            
            let strTiTle = NSAttributedString.init(string: "Open hours will be visible only to the selected candidates"
                , attributes: [NSAttributedString.Key.foregroundColor : ILColor.color(index:40),NSAttributedString.Key.font : fontBook]);
            let strType = NSAttributedString.init(string: "Total candidates visible for this open hour"
                , attributes: [NSAttributedString.Key.foregroundColor : ILColor.color(index: 40),NSAttributedString.Key.font : fontHeavy]);
            let para = NSMutableParagraphStyle.init()
            //            para.alignment = .center
            para.lineSpacing = 4
            strHeader.append(strTiTle)
            strHeader.append(nextLine1)
            strHeader.append(nextLine1)

            strHeader.append(strType)
            strHeader.addAttribute(NSAttributedString.Key.paragraphStyle, value: para, range: NSMakeRange(0, strHeader.length))
            lblPrivateOpenHourHeading.attributedText = strHeader
            UIButton.buttonUIHandling(button: btnNext, text: "Save", backgroundColor: .clear, textColor: ILColor.color(index: 23),  fontType: fontHeavy)
        }
        UILabel.labelUIHandling(label: lblCountStudent, text: "2", textColor: ILColor.color(index: 23), isBold: false, fontType: fontBook)
        
        UIButton.buttonUIHandling(button: btnAddStudent, text: "Edit", backgroundColor: .clear, textColor: ILColor.color(index: 23),  fontType: fontBook)
        btnAddStudent.isHidden = true
        
    }
    
}
