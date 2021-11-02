//
//  ERSideOpenCreateEditSecondVC.swift
//  Appointment
//
//  Created by Anurag Bhakuni on 02/12/20.
//  Copyright © 2020 Anurag Bhakuni. All rights reserved.
//

import UIKit


class ERSideOpenCreateEditSecondVC: SuperViewController,UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate {
    
    
    @IBOutlet weak var viewHeader: UIView!
    var objviewTypeOpenHour : viewTypeOpenHour!
    @IBOutlet weak var lblAppointmentType: UILabel!
    var delegate : ErSideOpenHourTCDelegate!

    @IBOutlet weak var txtApointmentType: LeftPaddedTextField!
    
    @IBOutlet weak var txtGroupLimit: LeftPaddedTextField!
    
    @IBOutlet weak var nslayoutConstraintGroupLimitHeight: NSLayoutConstraint!
    
    var objStudentDetailModalI : StudentDetailModal?
    var objStudentDetailModalSelected : StudentDetailModal?

    var objOpenHourModalSubmit : openHourModalSubmit!
    
    @IBOutlet weak var lblStepHeader: UILabel!
    @IBOutlet weak var btnNext: UIButton!
   
    @IBOutlet weak var viewScroll: UIScrollView!
    
    @IBOutlet weak var viewOuter: UIView!
    
    @IBOutlet weak var viewInner: UIView!
    
    var objERSideOpenHourPrefilledDetail: ERSideOpenHourDetail?
    
    var dateSelected : Date!
    var activityIndicator: ActivityIndicatorView?

    let pickerView = UIPickerView()
    var PickerSelectedTag = 0;
    var activeField : UITextField?
    var keyBooradAlreadyShown = false
    var keyBoardHieght : CGFloat = 0.0;

    
    var totalStudentParticipant = 0;
    

    //ReuestAppro
    @IBOutlet weak var lblReuestAppro: UILabel!
    
    @IBOutlet weak var txtReuestAppro: LeftPaddedTextField!
    
    //LocationType
    
    
    @IBOutlet weak var nslayoutConstarintDefaultHeight: NSLayoutConstraint!
    @IBOutlet weak var viewLocationDefault: UIView!
    
    @IBOutlet weak var lblLocationType: UILabel!
    
    @IBOutlet weak var txtLocationType: LeftPaddedTextField!
    
    @IBOutlet weak var lblDefaultLocatiob: UILabel!
    
    @IBOutlet weak var txtDefaultLocation: LeftPaddedTextField!
    
    @IBOutlet weak var btnDeadlineEnabled: UIButton!
    
    @IBOutlet weak var lblDeadlineEnabled: UILabel!
    
    @IBOutlet weak var nslayoutDeadlineHeaderViewheight: NSLayoutConstraint!
    
    @IBOutlet weak var viewHeaderDeadline: UIView!
    
    @IBOutlet weak var nslayoutConstarintViewPrivateContainer: NSLayoutConstraint!
    
    var calculatedHeightDeadineView : CGFloat!;
    var calculatedHeightPrivateView : CGFloat!;

    @IBOutlet weak var lblDeadlineInfo: UILabel!
    
    @IBOutlet weak var txtDeadline: LeftPaddedTextField!
    
    @IBOutlet weak var lblBefore: UILabel!
    
    @IBOutlet weak var txtDeadlineTime: UITextField!
    
    @IBOutlet weak var lblDeadlineFooter: UILabel!
    
    @IBOutlet weak var btnPrivateOpenHour: UIButton!
    
    
    @IBOutlet weak var viewPrivateContainer: UIView!
    
    @IBOutlet weak var lblPrivateInfo: UILabel!
    
    @IBOutlet weak var lblPrivateOpenHour: UILabel!
    
    @IBOutlet weak var lblPrivateOpenHourHeading: UILabel!
    
    @IBOutlet weak var lblCountStudent: UILabel!
    
    @IBOutlet weak var btnAddStudent: UIButton!
    
   
    
    @IBOutlet weak var viewDeadlineContainer: UIView!
    @IBOutlet weak var nslayoutConstraintDeadlineHeight: NSLayoutConstraint!
   
    
    var objProviderModalArr : [ProviderModal]!
    
    
    var isDeadlineEnabled = false
    var isPrivateEnabled = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewInner.isHidden = true
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM YYYY"
        
        switch self.objviewTypeOpenHour {
        case .setOpenHour:
            GeneralUtility.customeNavigationBarWithOnlyBack(viewController: self, title: "Open Hours" + " - " + dateFormatter.string(from: self.dateSelected))
            break;
        case .duplicateSetHour:
            
           GeneralUtility.customeNavigationBarWithOnlyBack(viewController: self, title: "Duplicate Schedules")
            
            break;
        case .editOpenHour:
            GeneralUtility.customeNavigationBarWithOnlyBack(viewController: self, title: "Open Hours" + " - " + dateFormatter.string(from: self.dateSelected))
            break;
        default:
            break;
        }
        callViewModal()
        

        
    }
    @objc override func buttonClicked(sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: false)
    }
    
    
   
    
    func redefindUserPurposeModal(objNewUserPurposeModalArr:NewUserPurposeModalArr )
    {
        var userpurpose = [SearchTextFieldItem]() ;
        
        for var purpose in self.objOpenHourModalSubmit.userPurposeId{
            
            if purpose.id == -1000{
            
                var seletcedPurpose = objNewUserPurposeModalArr.filter({
                    $0.displayName == purpose.title
                })[0];
                
                purpose.id = seletcedPurpose.id
            }
            userpurpose.append(purpose)
        }
        
        self.objOpenHourModalSubmit.userPurposeId = userpurpose
        
    }
    
    
    
    func callViewModal()  {
        viewInner.isHidden = true
        activityIndicator = ActivityIndicatorView.showActivity(view: self.view, message: StringConstants.FetchingCoachSelection)
        ERSideOpenEditSecondVM().fetchProvider({ (data) in
            do {
                self.objProviderModalArr = try
                    JSONDecoder().decode(ProviderModalArr.self, from: data)
                self.callViewModalStudentList()
               
            } catch   {
                print(error)
                self.activityIndicator?.hide()

            }
        }) { (error, errorCode) in
            self.activityIndicator?.hide()
        }
    }
    
    
    func callViewModalStudentList()  {
        
        let arrayInclude = ["invitation_id","benchmark","tags"]
        let param = [ "_method" : "post",
                      "offset" : 0,
                      "limit" : 20,
                      "includes" : arrayInclude,
                      "csrf_token" : UserDefaultsDataSource(key: "csrf_token").readData() as! String
            ] as [String : AnyObject]
        
        ERSideStudentListViewModal().fetchStudentList(prameter:param  , { (data) in
            self.activityIndicator?.hide()
            do {
                self.activityIndicator?.hide()
                self.objStudentDetailModalI = try
                    JSONDecoder().decode(StudentDetailModal.self, from: data)
                
                self.totalStudentParticipant = self.objStudentDetailModalI?.total ?? 0
                
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
        self.addInputAccessoryForTextFields(textFields: [txtGroupLimit], dismissable: true, previousNextable: true)

        self.addInputAccessoryForTextFields(textFields: [txtApointmentType , txtReuestAppro,txtLocationType], dismissable: true, previousNextable: true)

        self.addInputAccessoryForTextFields(textFields: [txtDeadline,txtDeadlineTime], dismissable: true, previousNextable: true)

        registerForKeyboardNotifications()

        nslayoutConstarintDefaultHeight.constant = 0
        self.viewLocationDefault.isHidden = true
        self.viewInner.isHidden = false
        self.viewInner.backgroundColor =  .white
        self.viewOuter.backgroundColor =  ILColor.color(index: 22)
        self.viewHeader.backgroundColor =  .white
        
        customizeHeader()
        customizeAppointmentTypeView()
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
        }
        else  if textField.tag == 192{
            arrPicker = ["Physical Location","Meeting URL"]
            PickerSelectedTag = 192;
        }
        else  if textField.tag == 193{
            arrPicker = ["1 day before Appointment","2 day before Appointment","3 day before Appointment","4 day before Appointment"]
            PickerSelectedTag = 193;
        }
        else  if textField.tag == 194{
            arrPicker = ["1 on 1 Appointment","Group Appointment"]
            PickerSelectedTag = 194;
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
            arrPicker = ["Physical Location","Meeting URL"]
            txtLocationType.text = arrPicker[row]
            selectedTypeLocation(row: row)
        }
        else if PickerSelectedTag == 193{
            arrPicker = ["1 day before Appointment","2 day before Appointment","3 day before Appointment","4 day before Appointment"]
            txtDeadline.text = arrPicker[row]
        }
            
        else if PickerSelectedTag == 194{
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
        
        viewHeader.isHidden = false;
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
        }
    }
    
    @IBAction func btnNextTapped(_ sender: Any) {
       createNewOpenHourModal()
    }
   
    
}


// MARK: Appointment Type.

extension ERSideOpenCreateEditSecondVC
{
    
    func customizeAppointmentTypeView(){
        
        
        switch self.objviewTypeOpenHour {
        case .setOpenHour:
            
            pickerViewSetUp(txtInput: txtApointmentType, tag: 194)
            let fontHeavy = UIFont(name: "FontHeavy".localized(), size: Device.FONTSIZETYPE15)
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
            
            
            break
        case .duplicateSetHour:
            pickerViewSetUp(txtInput: txtApointmentType, tag: 194)
            let fontHeavy = UIFont(name: "FontHeavy".localized(), size: Device.FONTSIZETYPE15)
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
            
            break
        case .editOpenHour:
            pickerViewSetUp(txtInput: txtApointmentType, tag: 194)
            let fontHeavy = UIFont(name: "FontHeavy".localized(), size: Device.FONTSIZETYPE15)
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
                prefilledValueAppointmentType()
            break
        default:
            break
        }
        
        
    }
    
    
    func prefilledValueAppointmentType()  {
        
        var appointmentType  = ""
        if let groupSise = self.objERSideOpenHourPrefilledDetail?.appointmentConfig?.groupSizeLimit
        {
            if Int(groupSise) == 1{
                appointmentType = "1 on 1 Appointment"
            }
            else{
                appointmentType =  "Group Appointment"
            }
        }
        self.txtApointmentType.text = appointmentType
        
        self.txtApointmentType.isUserInteractionEnabled = false
        self.txtApointmentType.isUserInteractionEnabled = false
        self.txtApointmentType.alpha = 0.6
        lblAppointmentType.alpha = 0.6
    }
}

// MARK: Request Approval.

extension ERSideOpenCreateEditSecondVC{
    
    func customRequestApproval()  {
        
        switch self.objviewTypeOpenHour {
        case .setOpenHour:
            
            pickerViewSetUp(txtInput: txtReuestAppro, tag: 191)
            let fontHeavy = UIFont(name: "FontHeavy".localized(), size: Device.FONTSIZETYPE15)
            
            UILabel.labelUIHandling(label: lblReuestAppro, text: "Request Approval", textColor: ILColor.color(index: 40), isBold: false, fontType: fontHeavy)
            let fontMedium = UIFont(name: "FontMediumWithoutNext".localized(), size: Device.FONTSIZETYPE13)
            
            txtReuestAppro.backgroundColor = ILColor.color(index: 48)
            self.txtReuestAppro.font = fontMedium
            self.txtReuestAppro.layer.borderColor = ILColor.color(index: 27).cgColor
            self.txtReuestAppro.layer.borderWidth = 1;
            self.txtReuestAppro.layer.cornerRadius = 3;
            self.txtReuestAppro.text = "Automatic Approval"
            self.txtReuestAppro.rightView = UIImageView.init(image: UIImage.init(named: "Drop-down_arrow"))
            txtReuestAppro.rightViewMode = .always;
            
            
            break
            
        case .duplicateSetHour:
            
            pickerViewSetUp(txtInput: txtReuestAppro, tag: 191)
            let fontHeavy = UIFont(name: "FontHeavy".localized(), size: Device.FONTSIZETYPE15)
            
            UILabel.labelUIHandling(label: lblReuestAppro, text: "Request Approval", textColor: ILColor.color(index: 40), isBold: false, fontType: fontHeavy)
            let fontMedium = UIFont(name: "FontMediumWithoutNext".localized(), size: Device.FONTSIZETYPE13)
            
            txtReuestAppro.backgroundColor = ILColor.color(index: 48)
            self.txtReuestAppro.font = fontMedium
            self.txtReuestAppro.layer.borderColor = ILColor.color(index: 27).cgColor
            self.txtReuestAppro.layer.borderWidth = 1;
            self.txtReuestAppro.layer.cornerRadius = 3;
            self.txtReuestAppro.text = "Automatic Approval"
            self.txtReuestAppro.rightView = UIImageView.init(image: UIImage.init(named: "Drop-down_arrow"))
            txtReuestAppro.rightViewMode = .always;
            
           
            break
            
        case .editOpenHour:
            
            pickerViewSetUp(txtInput: txtReuestAppro, tag: 191)
            let fontHeavy = UIFont(name: "FontHeavy".localized(), size: Device.FONTSIZETYPE15)
            
            UILabel.labelUIHandling(label: lblReuestAppro, text: "Request Approval", textColor: ILColor.color(index: 40), isBold: false, fontType: fontHeavy)
            let fontMedium = UIFont(name: "FontMediumWithoutNext".localized(), size: Device.FONTSIZETYPE13)
            
            txtReuestAppro.backgroundColor = ILColor.color(index: 48)
            self.txtReuestAppro.font = fontMedium
            self.txtReuestAppro.layer.borderColor = ILColor.color(index: 27).cgColor
            self.txtReuestAppro.layer.borderWidth = 1;
            self.txtReuestAppro.layer.cornerRadius = 3;
            self.txtReuestAppro.text = "Automatic Approval"
            self.txtReuestAppro.rightView = UIImageView.init(image: UIImage.init(named: "Drop-down_arrow"))
            txtReuestAppro.rightViewMode = .always;
                prefilledValueRequestApproval()
            break
        default:
            break
        }
             
    }
    
    
    func prefilledValueRequestApproval()  {
        
        var requestType = ""
        if let requestApprovalType = self.objERSideOpenHourPrefilledDetail?.appointmentConfig?.requestApprovalType
        {
            if requestApprovalType == "manual"{
                requestType = "Manual Approval"
            }
            else{
                requestType =  "Automatic Approval"
            }
        }
        self.txtReuestAppro.text = requestType
       

        
    }
    
}


// MARK: Location.
extension ERSideOpenCreateEditSecondVC{
    
    
    func customLocation()  {
        
        switch self.objviewTypeOpenHour {
        case .setOpenHour:
            
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
            txtLocationType.placeholder = "Search locations"

            
            
            break;
            
        case .duplicateSetHour:
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
            break
            
        case .editOpenHour :
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
            prefilledValueLocation()
            break
            
        default:
            break
        }
    }
    
    func prefilledValueLocation()  {
        let arrLocation = ["Physical Location","Meeting URL"]
        let arrLocationI = ["physical_location","webinar_link"]
        let indexLocation = arrLocationI.firstIndex(where: {$0 == self.objERSideOpenHourPrefilledDetail?.locationType})
        txtLocationType.text = arrLocation[indexLocation ?? 0] ;
        txtDefaultLocation.text = self.objERSideOpenHourPrefilledDetail?.location
        selectedTypeLocation(row: indexLocation ?? 0)
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
        
        let fontHeavy1 = UIFont(name: "FontHeavy".localized(), size: Device.FONTSIZETYPE15)
        
        
        if row == 0  {
            UILabel.labelUIHandling(label: lblDefaultLocatiob, text: "Custom Address or Location", textColor: ILColor.color(index: 40), isBold: false, fontType: fontHeavy1)
            txtDefaultLocation.placeholder = " Building 111, R103"
            
            
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
            btnDeadlineEnabled.setImage(UIImage.init(named: "Check_box_selected"), for: .normal);
            enableDeadline()
            
            
            
        }
        else{
            btnDeadlineEnabled.setImage(UIImage.init(named: "check_box"), for: .normal);
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
        if #available(iOS 13.4, *) {
            dbDatePickerFromTiming.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
        txtInput.inputView = dbDatePickerFromTiming;
        
        let string = "5:00 PM"
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        let date = formatter.date(from: string)
        
        dbDatePickerFromTiming.setDate(date!, animated: false)
        
        
        
    }
    
    func disabledDeadline()  {
        
        //        txtDeadline.isUserInteractionEnabled = false
        //        txtDeadline.isEnabled = false
        //        self.txtDeadline.alpha = 0.6
        //
        //        txtDeadlineTime.isUserInteractionEnabled = false
        //        txtDeadlineTime.isEnabled = false
        //        self.txtDeadlineTime.alpha = 0.6
        
        nslayoutConstraintDeadlineHeight.constant = 0
        self.viewDeadlineContainer.isHidden = true
        
    }
    
    func enableDeadline(){
        
        nslayoutConstraintDeadlineHeight.constant = calculatedHeightDeadineView
        self.viewDeadlineContainer.isHidden = false
        
        
        //        txtDeadline.isUserInteractionEnabled = true
        //        txtDeadline.isEnabled = true
        //        self.txtDeadline.alpha = 1
        //
        //        txtDeadlineTime.isUserInteractionEnabled = true
        //        txtDeadlineTime.isEnabled = true
        //        self.txtDeadlineTime.alpha = 1
        
        
    }
    
    
    
    func customDeadline()  {
        
        switch self.objviewTypeOpenHour {
        case .editOpenHour:
                self.nslayoutConstraintDeadlineHeight.priority = UILayoutPriority(rawValue: 1);
                nslayoutConstraintDeadlineHeight.priority = UILayoutPriority(rawValue: 1000)
                nslayoutConstraintDeadlineHeight.constant = 0
                self
                    .viewDeadlineContainer.isHidden = true
                
                self.viewHeaderDeadline.isHidden = true
                
                nslayoutDeadlineHeaderViewheight.priority = UILayoutPriority(rawValue: 1000)
                nslayoutDeadlineHeaderViewheight.constant = 0
            break
        case .setOpenHour:
           
                self.nslayoutConstraintDeadlineHeight.priority = UILayoutPriority(rawValue: 1);
                
                pickerViewSetUp(txtInput: txtDeadline, tag: 193)
                
                
                UIButton.buttonUIHandling(button: btnDeadlineEnabled, text: "", backgroundColor: .clear, textColor: .clear, buttonImage: UIImage.init(named: "check_box"))
                
                let fontHeavy1 = UIFont(name: "FontHeavy".localized(), size: Device.FONTSIZETYPE15)
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
                
                
                
                self.viewDeadlineContainer.layoutIfNeeded();
                
                nslayoutConstraintDeadlineHeight.priority = UILayoutPriority(rawValue: 1000)
                
                calculatedHeightDeadineView =   self.viewDeadlineContainer.frame.size.height
                
                self.disabledDeadline()
          
            break
        case .duplicateSetHour:
                self.nslayoutConstraintDeadlineHeight.priority = UILayoutPriority(rawValue: 1);
                pickerViewSetUp(txtInput: txtDeadline, tag: 193)
                UIButton.buttonUIHandling(button: btnDeadlineEnabled, text: "", backgroundColor: .clear, textColor: .clear, buttonImage: UIImage.init(named: "check_box"))
                let fontHeavy1 = UIFont(name: "FontHeavy".localized(), size: Device.FONTSIZETYPE15)
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
                
                
                
                self.viewDeadlineContainer.layoutIfNeeded();
                
                nslayoutConstraintDeadlineHeight.priority = UILayoutPriority(rawValue: 1000)
                
                calculatedHeightDeadineView =   self.viewDeadlineContainer.frame.size.height
                
                self.disabledDeadline()
            
            break
        default:
            break
        }
        
    }
}

// MARK: Private.
extension ERSideOpenCreateEditSecondVC{
    
    @IBAction func btnPrivateOpenHourTapped(_ sender: Any) {
        let fontBook =  UIFont(name: "FontBook".localized(), size: Device.FONTSIZETYPE14)
        isPrivateEnabled = !isPrivateEnabled
        
        
        if isPrivateEnabled{
            btnPrivateOpenHour.setImage(UIImage.init(named: "Check_box_selected"), for: .normal);
            
            btnAddStudent.isHidden = false
            viewPrivateContainer.isHidden = false
            nslayoutConstarintViewPrivateContainer.constant = calculatedHeightPrivateView
        }
        else
        {
            btnAddStudent.isHidden = true
            viewPrivateContainer.isHidden = true
            nslayoutConstarintViewPrivateContainer.constant = 0
            
            btnPrivateOpenHour.setImage(UIImage.init(named: "check_box"), for: .normal);
        }
    }
    
    
    
    @IBAction func BtnAddAStudentTapped(_ sender: Any) {
        
        let objERSideStudentListViewController = ERSideStudentListViewController.init(nibName: "ERSideStudentListViewController", bundle: nil)
        objERSideStudentListViewController.objStudentDetailModal = self.objStudentDetailModalI
        objERSideStudentListViewController.objStudentDetailModalSelected = self.objStudentDetailModalSelected
        objERSideStudentListViewController.delegate = self
        objERSideStudentListViewController.objStudentListType = .groupType
        
        self.navigationController?.pushViewController(objERSideStudentListViewController, animated: false)
        
    }
    
    
    
    func isPrivateEnabledAlready()  {
        if self.totalStudentParticipant == self.objERSideOpenHourPrefilledDetail?.participants?.count{
            isPrivateEnabled = false
        }
        else{
            isPrivateEnabled = true
            
            if (self.objStudentDetailModalI?.items?.count ?? 0) > 0
            {
                
                self.objStudentDetailModalSelected = StudentDetailModal()
                self.objStudentDetailModalSelected?.total = self.objERSideOpenHourPrefilledDetail?.participants?.count
                 self.objStudentDetailModalSelected?.items = [StudentDetailModalItem]()
                for student in (self.objStudentDetailModalI?.items)!{
                    var studentSelected = self.objERSideOpenHourPrefilledDetail?.participants?.filter({$0.studentID == student.invitationID});
                    
                    if studentSelected?.count ?? 0 > 0{
                        self.objStudentDetailModalSelected?.items?.append(student)

                    }
                    else{
                    }
                }
                
            }
            
        }
        
    }
    
    
    func customPrivate()  {
        
        switch self.objviewTypeOpenHour {
        case .editOpenHour:
            let fontHeavy = UIFont(name: "FontHeavy".localized(), size: Device.FONTSIZETYPE15)
            let fontBook =  UIFont(name: "FontBook".localized(), size: Device.FONTSIZETYPE14)
            let fontMedium = UIFont(name: "FontMediumWithoutNext".localized(), size: Device.FONTSIZETYPE13)
            UIButton.buttonUIHandling(button: btnPrivateOpenHour, text: "", backgroundColor: .clear, textColor: .clear, buttonImage: UIImage.init(named: "check_box"))
            UILabel.labelUIHandling(label: lblPrivateOpenHour, text: "Private Open Hours", textColor: ILColor.color(index: 40), isBold: false, fontType: fontHeavy)
            if let fontHeavy = UIFont(name: "FontHeavy".localized(), size: Device.FONTSIZETYPE15), let fontBook =  UIFont(name: "FontBook".localized(), size: Device.FONTSIZETYPE14)
                
            {
                let strHeader = NSMutableAttributedString.init()
                let strTiTle = NSAttributedString.init(string: "Open hours will be visible only to the selected candidates"
                    , attributes: [NSAttributedString.Key.foregroundColor : ILColor.color(index:40),NSAttributedString.Key.font : fontBook]);
                
                let para = NSMutableParagraphStyle.init()
                //            para.alignment = .center
                para.lineSpacing = 4
                strHeader.append(strTiTle)
                strHeader.addAttribute(NSAttributedString.Key.paragraphStyle, value: para, range: NSMakeRange(0, strHeader.length))
                lblPrivateOpenHourHeading.attributedText = strHeader
                UIButton.buttonUIHandling(button: btnNext, text: "Save", backgroundColor: .clear, textColor: ILColor.color(index: 23),  fontType: fontHeavy)
            }
            UILabel.labelUIHandling(label: lblCountStudent, text: "0", textColor: ILColor.color(index: 23), isBold: false, fontType: fontBook)
            UIButton.buttonUIHandling(button: btnAddStudent, text: "Edit", backgroundColor: .clear, textColor: ILColor.color(index: 23),  fontType: fontBook)
            //        btnAddStudent.isHidden = true
            let fontMedium1 = UIFont(name: "FontMediumWithoutNext".localized(), size: Device.FONTSIZETYPE10)
            UILabel.labelUIHandling(label: lblPrivateInfo, text: "Total candidates visible for this open hour", textColor: ILColor.color(index: 40), isBold: false, fontType: fontMedium1)
            nslayoutConstarintViewPrivateContainer.priority = UILayoutPriority(rawValue: 1000)
            calculatedHeightPrivateView = viewPrivateContainer.frame.height
            self.isPrivateEnabledAlready()
            if isPrivateEnabled{
                viewPrivateContainer.isHidden = false
                nslayoutConstarintViewPrivateContainer.constant = calculatedHeightPrivateView
                self.lblCountStudent.text = "\(objERSideOpenHourPrefilledDetail?.participants?.count ?? 0)"
                btnPrivateOpenHour.setImage(UIImage.init(named: "Check_box_selected"), for: .normal);

            }
            else{
                btnPrivateOpenHour.setImage(UIImage.init(named: "check_box"), for: .normal);
                viewPrivateContainer.isHidden = true
                nslayoutConstarintViewPrivateContainer.constant = 0
            }
            break
        case .setOpenHour:
            let fontHeavy = UIFont(name: "FontHeavy".localized(), size: Device.FONTSIZETYPE15)
            let fontBook =  UIFont(name: "FontBook".localized(), size: Device.FONTSIZETYPE14)
            
            let fontMedium = UIFont(name: "FontMediumWithoutNext".localized(), size: Device.FONTSIZETYPE13)
            
            
            UIButton.buttonUIHandling(button: btnPrivateOpenHour, text: "", backgroundColor: .clear, textColor: .clear, buttonImage: UIImage.init(named: "check_box"))
            UILabel.labelUIHandling(label: lblPrivateOpenHour, text: "Private Open Hours", textColor: ILColor.color(index: 40), isBold: false, fontType: fontHeavy)
            if let fontHeavy = UIFont(name: "FontHeavy".localized(), size: Device.FONTSIZETYPE15), let fontBook =  UIFont(name: "FontBook".localized(), size: Device.FONTSIZETYPE14)
                
            {
                let strHeader = NSMutableAttributedString.init()
                let strTiTle = NSAttributedString.init(string: "Open hours will be visible only to the selected candidates"
                    , attributes: [NSAttributedString.Key.foregroundColor : ILColor.color(index:40),NSAttributedString.Key.font : fontBook]);
                
                let para = NSMutableParagraphStyle.init()
                //            para.alignment = .center
                para.lineSpacing = 4
                strHeader.append(strTiTle)
                strHeader.addAttribute(NSAttributedString.Key.paragraphStyle, value: para, range: NSMakeRange(0, strHeader.length))
                lblPrivateOpenHourHeading.attributedText = strHeader
                UIButton.buttonUIHandling(button: btnNext, text: "Save", backgroundColor: .clear, textColor: ILColor.color(index: 23),  fontType: fontHeavy)
            }
            UILabel.labelUIHandling(label: lblCountStudent, text: "0", textColor: ILColor.color(index: 23), isBold: false, fontType: fontBook)
            UIButton.buttonUIHandling(button: btnAddStudent, text: "Edit", backgroundColor: .clear, textColor: ILColor.color(index: 23),  fontType: fontBook)
            //        btnAddStudent.isHidden = true
            let fontMedium1 = UIFont(name: "FontMediumWithoutNext".localized(), size: Device.FONTSIZETYPE10)
            UILabel.labelUIHandling(label: lblPrivateInfo, text: "Total candidates visible for this open hour", textColor: ILColor.color(index: 40), isBold: false, fontType: fontMedium1)
            nslayoutConstarintViewPrivateContainer.priority = UILayoutPriority(rawValue: 1000)
            calculatedHeightPrivateView = viewPrivateContainer.frame.height
            viewPrivateContainer.isHidden = true
            nslayoutConstarintViewPrivateContainer.constant = 0
            break
        case .duplicateSetHour:
            let fontHeavy = UIFont(name: "FontHeavy".localized(), size: Device.FONTSIZETYPE15)
            let fontBook =  UIFont(name: "FontBook".localized(), size: Device.FONTSIZETYPE14)
            
            let fontMedium = UIFont(name: "FontMediumWithoutNext".localized(), size: Device.FONTSIZETYPE13)
            
            
            UIButton.buttonUIHandling(button: btnPrivateOpenHour, text: "", backgroundColor: .clear, textColor: .clear, buttonImage: UIImage.init(named: "check_box"))
            UILabel.labelUIHandling(label: lblPrivateOpenHour, text: "Private Open Hours", textColor: ILColor.color(index: 40), isBold: false, fontType: fontHeavy)
            if let fontHeavy = UIFont(name: "FontHeavy".localized(), size: Device.FONTSIZETYPE15), let fontBook =  UIFont(name: "FontBook".localized(), size: Device.FONTSIZETYPE14)
                
            {
                let strHeader = NSMutableAttributedString.init()
                let strTiTle = NSAttributedString.init(string: "Open hours will be visible only to the selected candidates"
                    , attributes: [NSAttributedString.Key.foregroundColor : ILColor.color(index:40),NSAttributedString.Key.font : fontBook]);
                
                let para = NSMutableParagraphStyle.init()
                //            para.alignment = .center
                para.lineSpacing = 4
                strHeader.append(strTiTle)
                strHeader.addAttribute(NSAttributedString.Key.paragraphStyle, value: para, range: NSMakeRange(0, strHeader.length))
                lblPrivateOpenHourHeading.attributedText = strHeader
                UIButton.buttonUIHandling(button: btnNext, text: "Save", backgroundColor: .clear, textColor: ILColor.color(index: 23),  fontType: fontHeavy)
            }
            UILabel.labelUIHandling(label: lblCountStudent, text: "0", textColor: ILColor.color(index: 23), isBold: false, fontType: fontBook)
            UIButton.buttonUIHandling(button: btnAddStudent, text: "Edit", backgroundColor: .clear, textColor: ILColor.color(index: 23),  fontType: fontBook)
            //        btnAddStudent.isHidden = true
            let fontMedium1 = UIFont(name: "FontMediumWithoutNext".localized(), size: Device.FONTSIZETYPE10)
            UILabel.labelUIHandling(label: lblPrivateInfo, text: "Total candidates visible for this open hour", textColor: ILColor.color(index: 40), isBold: false, fontType: fontMedium1)
            nslayoutConstarintViewPrivateContainer.priority = UILayoutPriority(rawValue: 1000)
            calculatedHeightPrivateView = viewPrivateContainer.frame.height
            viewPrivateContainer.isHidden = true
            nslayoutConstarintViewPrivateContainer.constant = 0
            break
            
        default:
            break
        }
        
        
    }
    
}



extension ERSideOpenCreateEditSecondVC: ERSideStudentListViewControllerDelegate {
    
    
    func selectedStudentPrivateHour(objStudentDetailModalSelected: StudentDetailModal) {
        
        self.objStudentDetailModalSelected = objStudentDetailModalSelected
        self.lblCountStudent.text = "\(objStudentDetailModalSelected.items?.count ?? 0)"
       
    }
    
    func prepareParticipatModal(){
        for items in self.objStudentDetailModalSelected!.items!{
            var participantSelected = ParticipantOH();
            participantSelected.entity_id = items.invitationID;
            participantSelected.entity_type = "student_user";
            participantSelected.is_invited = 0;
            self.objOpenHourModalSubmit.participant.append(participantSelected)
        }
        
    }
    
    
    func formingmodal()
    {
        
        let arrApprovalProcess = ["Automatic Approval","Manual Approval"]
        let arrApprovalProcessI = ["automatic","manual"]

        let indexApppProcess = arrApprovalProcess.firstIndex(where: {$0 == txtReuestAppro.text})
        
        self.objOpenHourModalSubmit.open_hours_appointment_approval_process = arrApprovalProcessI[indexApppProcess ?? 0]
        
        
        let arrLocation = ["Physical Location","Meeting URL"]
        let arrLocationI = ["physical_location","webinar_link"]

        let indexLocation = arrLocation.firstIndex(where: {$0 == txtLocationType.text})
        
        self.objOpenHourModalSubmit.locationType = arrLocationI[indexLocation ?? 0]
        self.objOpenHourModalSubmit.locationValue = self.txtDefaultLocation.text
        
        if isDeadlineEnabled{
            let deadline_days_before = ["1 day before Appointment","2 day before Appointment","3 day before Appointment","4 day before Appointment"]
            let deadline_days_beforeI = ["1","2","3","4"]
            let indexLocation = deadline_days_before.firstIndex(where: {$0 == txtDeadline.text})
            self.objOpenHourModalSubmit.deadline_days_before = deadline_days_beforeI[indexLocation ?? 0]
            
            let sec =     GeneralUtility.differenceBetweenTwoDateInSec(dateFirst: txtDeadlineTime.text!, dateSecond: "12:00 AM", dateformatter: "hh:mm a")
            
            
            self.objOpenHourModalSubmit.deadline_time_on_day = abs(sec)
            
        }
        if isPrivateEnabled{
            prepareParticipatModal();
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
    
    
    func validation() -> Bool {
        
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
        
        if  txtLocationType.text?.isEmpty ?? true{
            CommonFunctions().showError(title: "Error", message: StringConstants.LOCATIONERROR)
             return false
        }
        if txtDefaultLocation.text?.isEmpty ?? true{
             CommonFunctions().showError(title: "Error", message: StringConstants.LOCATIONERROR)
            return false
        }
        
        if txtLocationType.text == "Meeting URL"{
            if   GeneralUtility.verifyUrl(urlString: txtDefaultLocation.text){
                
            }
            else{
                CommonFunctions().showError(title: "Error", message: StringConstants.URLERROR)
                                    return false
            }
        }

        
        
        if isDeadlineEnabled{
            
            if txtDeadlineTime.text?.isEmpty ?? true{
                
                 CommonFunctions().showError(title: "Error", message: StringConstants.DEADLINEERROR)
                
                return false
            }
            
        }
        
        if isPrivateEnabled {
            
            if self.objStudentDetailModalSelected?.items?.count ?? 0 <= 0{
                
                CommonFunctions().showError(title: "Error", message: StringConstants.STUDENTERROR)
                
                return false
            }
            
        }
        return true
        
        
    }
    
    
    
    
    
    func dataFeeding() -> Dictionary<String,AnyObject> {
        
        
        switch objviewTypeOpenHour {
        case .setOpenHour:
            var isPRivate = 1
            
            if isPrivateEnabled{
                isPRivate = 1
            }
            else{
                isPRivate = 0
                
            }
            
            
            
            var  user_purpose_ids = [String]()
            
            let selectedUserPurposeArr = self.objOpenHourModalSubmit.userPurposeId.filter({$0.isSelected == true})
            
            for purpose in selectedUserPurposeArr{
                user_purpose_ids.append(purpose.title )
            }
            
            
            
            
            var params = ["_method" : "post",
                          "is_private": isPRivate,
                          "timezone":self.objOpenHourModalSubmit.timeZone,
                          "location_type" :  self.objOpenHourModalSubmit.locationType ?? "physical_location",
                          "location" : self.txtDefaultLocation.text ?? "",
                          "purposes":user_purpose_ids,
                          "description":"default",
                          "slots": self.objOpenHourModalSubmit.slotArr!,
                          "csrf_token" : UserDefaultsDataSource(key: "csrf_token").readData() as! String
                
                ] as [String : Any]
            
            //                      "participants": participants,
            
            if isPrivateEnabled{
                
                var participants = [Int]()
                for participantI in self.objOpenHourModalSubmit.participant{
                    
                    participants.append(participantI.entity_id!)
                }
                params["participants"] = participants
                
                
            }
            var groupSize = "0"
            
            if nslayoutConstraintGroupLimitHeight.constant != 0 {
                groupSize = txtGroupLimit.text ?? "0"
            }
            else{
                groupSize = "1"
                
            }
            
            var paramsInner = [ "group_size_limit" : groupSize,
                                "request_approval_type":self.objOpenHourModalSubmit.open_hours_appointment_approval_process!
                ] as [String : Any]
            
            if isDeadlineEnabled{
                paramsInner["booking_deadline_days_before"]   =  self.objOpenHourModalSubmit.deadline_days_before;
                paramsInner["booking_deadline_time_on_day"]  = "\(self.objOpenHourModalSubmit.deadline_time_on_day ?? 0)";
            }
            
            params["appointment_config"] = paramsInner
            
            
            if self.objOpenHourModalSubmit.recurrence != "-1"{
                params["recurrence"] = self.objOpenHourModalSubmit.recurrence
            }
            
            return params as Dictionary<String,AnyObject>
            
            
            break
        case .duplicateSetHour:
            var isPRivate = 1
               
               if isPrivateEnabled{
                   isPRivate = 1
               }
               else{
                   isPRivate = 0
                   
               }
               
               
               
               var  user_purpose_ids = [String]()
               
               let selectedUserPurposeArr = self.objOpenHourModalSubmit.userPurposeId.filter({$0.isSelected == true})
               
               for purpose in selectedUserPurposeArr{
                   user_purpose_ids.append(purpose.title )
               }
               
               
               
               
               var params = ["_method" : "post",
                             "is_private": isPRivate,
                             "timezone":self.objOpenHourModalSubmit.timeZone,
                             "location_type" :  self.objOpenHourModalSubmit.locationType ?? "physical_location",
                             "location" : self.txtDefaultLocation.text ?? "",
                             "purposes":user_purpose_ids,
                             "description":"default",
                             "slots": self.objOpenHourModalSubmit.slotArr!,
                             "csrf_token" : UserDefaultsDataSource(key: "csrf_token").readData() as! String
                   
                   ] as [String : Any]
               
               //                      "participants": participants,
               
               if isPrivateEnabled{
                   
                   var participants = [Int]()
                   for participantI in self.objOpenHourModalSubmit.participant{
                       
                       participants.append(participantI.entity_id!)
                   }
                   params["participants"] = participants
                   
                   
               }
               var groupSize = "0"
               
               if nslayoutConstraintGroupLimitHeight.constant != 0 {
                   groupSize = txtGroupLimit.text ?? "0"
               }
               else{
                   groupSize = "1"
                   
               }
               
               var paramsInner = [ "group_size_limit" : groupSize,
                                   "request_approval_type":self.objOpenHourModalSubmit.open_hours_appointment_approval_process!
                   ] as [String : Any]
               
               if isDeadlineEnabled{
                   paramsInner["booking_deadline_days_before"]   =  self.objOpenHourModalSubmit.deadline_days_before;
                   paramsInner["booking_deadline_time_on_day"]  = "\(self.objOpenHourModalSubmit.deadline_time_on_day ?? 0)";
               }
               
               params["appointment_config"] = paramsInner
               
               
               if self.objOpenHourModalSubmit.recurrence != "-1"{
                   params["recurrence"] = self.objOpenHourModalSubmit.recurrence
               }
               
               return params as Dictionary<String,AnyObject>
            
            break
        case .editOpenHour :
            var isPRivate = 1
               
               if isPrivateEnabled{
                   isPRivate = 1
               }
               else{
                   isPRivate = 0
                   
               }
               
               
               
               var  user_purpose_ids = [String]()
               
               let selectedUserPurposeArr = self.objOpenHourModalSubmit.userPurposeId.filter({$0.isSelected == true})
               
               for purpose in selectedUserPurposeArr{
                   user_purpose_ids.append(purpose.title )
               }
               
               
               
               
               var params = ["_method" : "patch",
                             "is_private": isPRivate,
                             "timezone":self.objOpenHourModalSubmit.timeZone,
                             "location_type" :  self.objOpenHourModalSubmit.locationType ?? "physical_location",
                             "location" : self.txtDefaultLocation.text ?? "",
                             "purposes":user_purpose_ids,
                             "slots": self.objOpenHourModalSubmit.slotArr!,
                             "csrf_token" : UserDefaultsDataSource(key: "csrf_token").readData() as! String,
                    "open_hour_identifier" : "\(objERSideOpenHourPrefilledDetail?.id ?? 0)"
                   ] as [String : Any]
               
               //                      "participants": participants,
               
               if isPrivateEnabled{
                   
                   var participants = [Int]()
                   for participantI in self.objOpenHourModalSubmit.participant{
                       
                       participants.append(participantI.entity_id!)
                   }
                   params["participants"] = participants
                   
                   
               }
               var groupSize = "0"
               
               if nslayoutConstraintGroupLimitHeight.constant != 0 {
                   groupSize = txtGroupLimit.text ?? "0"
               }
               else{
                   groupSize = "1"
                   
               }
               
               var paramsInner = [ "group_size_limit" : groupSize,
                                   "request_approval_type":self.objOpenHourModalSubmit.open_hours_appointment_approval_process!
                   ] as [String : Any]
               
               if isDeadlineEnabled{
                   paramsInner["booking_deadline_days_before"]   =  self.objOpenHourModalSubmit.deadline_days_before;
                   paramsInner["booking_deadline_time_on_day"]  = "\(self.objOpenHourModalSubmit.deadline_time_on_day ?? 0)";
               }
               
               params["appointment_config"] = paramsInner
               
               
            
               
               return params as Dictionary<String,AnyObject>
            
            break
        default:
            return Dictionary<String,AnyObject>()
            break
        }
        
        
   
        
        
    }
    
    func hitFinalApi()  {
        
        activityIndicator = ActivityIndicatorView.showActivity(view: self.view, message:
                                                                StringConstants.FetchingCoachSelection)
        
        switch self.objviewTypeOpenHour {
        case .duplicateSetHour:
            
            ERSideStudentListViewModal().submitNewOpenHour(prameter: dataFeeding(), { (data) in
                do {
                    if self.delegate != nil{
                        self.delegate.deleteDelgateRefresh();
                    }
                    
                    let index = self.navigationController?.viewControllers.firstIndex(where: { $0.isKind(of: ERSideOpenHourListVC.self) })
                    if index != nil{
                        GeneralUtility.alertViewPopOutToParticularViewController(title: "Success", message: "Open Hour Created Successfully !!!", viewController: self, buttons: ["Ok"], index: index ?? 1)
                        
                    }
                    else{
                        GeneralUtility.alertViewPopOutViewController(title: "Success", message: "Open Hour Created Successfully !!!", viewController: self, buttons: ["Ok"])
                    }
                    
                    
                    
                    
                } catch   {
                    print(error)
                    self.activityIndicator?.hide()
                    
                }
                
            }) { (error, errorCode) in
                self.activityIndicator?.hide()
            }
            
            break;
            
        case .editOpenHour:
            
            ERSideStudentListViewModal().submitEditedOpenHour(prameter: dataFeeding(), id: "\(objERSideOpenHourPrefilledDetail?.id ?? 0)", { (data) in
                do {
                    if self.delegate != nil{
                        self.delegate.deleteDelgateRefresh();
                    }
                    
                    let index = self.navigationController?.viewControllers.firstIndex(where: { $0.isKind(of: ERSideOpenHourListVC.self) })
                    if index != nil{
                        GeneralUtility.alertViewPopOutToParticularViewController(title: "Success", message: "Open Hour Created Successfully !!!", viewController: self, buttons: ["Ok"], index: index ?? 1)
                        
                    }
                    else{
                        GeneralUtility.alertViewPopOutViewController(title: "Success", message: "Open Hour Created Successfully !!!", viewController: self, buttons: ["Ok"])
                    }
                    
                    
                    
                    
                } catch   {
                    print(error)
                    self.activityIndicator?.hide()
                    
                }
                
            }) { (error, errorCode) in
                self.activityIndicator?.hide()
            }
            
            break;
            
        case .setOpenHour :
            ERSideStudentListViewModal().submitNewOpenHour(prameter: dataFeeding(), { (data) in
                do {
                    if self.delegate != nil{
                        self.delegate.deleteDelgateRefresh();
                    }
                    
                    let index = self.navigationController?.viewControllers.firstIndex(where: { $0.isKind(of: ERSideOpenHourListVC.self) })
                    if index != nil{
                        GeneralUtility.alertViewPopOutToParticularViewController(title: "Success", message: "Open Hour Created Successfully !!!", viewController: self, buttons: ["Ok"], index: index ?? 1)
                        
                    }
                    else{
                        GeneralUtility.alertViewPopOutViewController(title: "Success", message: "Open Hour Created Successfully !!!", viewController: self, buttons: ["Ok"])
                    }
                    
                    
                    
                    
                } catch   {
                    print(error)
                    self.activityIndicator?.hide()
                    
                }
                
            }) { (error, errorCode) in
                
                CommonFunctions().showError(title: "Error", message:error)
                self.activityIndicator?.hide()
            }
            
            break
            
        default:
            break
        }
        
        
    }
    
    
    
    func createNewOpenHourModal()  {
        if !validation(){
            return
        }
        formingmodal()
        hitFinalApi()
    }
        
}
