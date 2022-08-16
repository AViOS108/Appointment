//
//  AdhocFlowSecondViewController.swift
//  Appointment
//
//  Created by Anurag Bhakuni on 08/05/21.
//  Copyright © 2021 Anurag Bhakuni. All rights reserved.
//

import UIKit


//typealias clouser = (_ a:Int,_ b:Int) -> ()

class AdhocFlowSecondViewController: SuperViewController {
    
    @IBOutlet weak var viewOuter: UIView!
    var objOpenHourModalSubmit : openHourModalSubmit!
    
    
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var viewInner: UIView!
    @IBOutlet weak var lblStudentSelect: UILabel!
    var dateSelected : Date!
    @IBOutlet weak var txtStudentSelect: LeftPaddedTextField!
    @IBOutlet weak var btnStudentSelect: UIButton!
    @IBOutlet weak var viewScroll: UIScrollView!
    @IBOutlet weak var lblStepHeader: UILabel!
    @IBOutlet weak var btnNext: UIButton!
    var objStudentDetailModalSelected : StudentDetailModal?
    var objStudentDetailModalI : StudentDetailModal?
    var objProviderModalArr : ProviderModalArr!
    let pickerView = UIPickerView()
    var arrPicker = [String]();

    @IBAction func btnNextTapped(_ sender: Any) {
        if validatingForm(){
            submitAdhocAppointment()
        }
        
//   
    }
    
    
    func validatingForm() -> Bool {
        
        if self.txtStudentSelect.text?.isEmpty ?? true {
            CommonFunctions().showError(title: "Error", message: StringConstants.STUDENTERROR)
                                 return false
        }
        if self.searchArrayPurpose.filter({$0.isSelected}) .count <= 0{
                      CommonFunctions().showError(title: "Error", message: StringConstants.PURPOSEERROR)
                      return false
                  }
        if txtLocationType.text?.isEmpty ?? true{
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
        
        return true
    }
    
    
    
    
    @IBAction func btnStudentSelectTapped(_ sender: Any) {
        
        if self.objOpenHourModalSubmit.open_hours_appointment_approval_process == "1"{
            let objERSideStudentListViewController = ERSideStudentListViewController.init(nibName: "ERSideStudentListViewController", bundle: nil)
            objERSideStudentListViewController.objStudentDetailModal = self.objStudentDetailModalI
            objERSideStudentListViewController.objStudentDetailModalSelected = self.objStudentDetailModalSelected
            objERSideStudentListViewController.delegate = self
            objERSideStudentListViewController.objStudentListType = .One2OneType
            
            self.navigationController?.pushViewController(objERSideStudentListViewController, animated: false)
        }
        else{
            let objERSideStudentListViewController = ERSideStudentListViewController.init(nibName: "ERSideStudentListViewController", bundle: nil)
            objERSideStudentListViewController.objStudentDetailModal = self.objStudentDetailModalI
            objERSideStudentListViewController.objStudentDetailModalSelected = self.objStudentDetailModalSelected
            objERSideStudentListViewController.delegate = self
            objERSideStudentListViewController.objStudentListType = .groupType
            
            self.navigationController?.pushViewController(objERSideStudentListViewController, animated: false)
        }
        
    }
    
    
    
    
    var dataPurposeModal: ERSidePurposeDetailModalArr?
    var activeField : UITextField?
    var keyBooradAlreadyShown = false
    
    var keyBoardHieght : CGFloat = 0.0;
    
    @IBOutlet weak var viewSelectedContainer: UIView!
    @IBOutlet weak var lblPurpose: UILabel!
    @IBOutlet weak var txtPurpose: LeftPaddedTextField!
    @IBOutlet weak var btnPurpose: UIButton!
    
    @IBOutlet weak var lblLocationType: UILabel!
    
    @IBOutlet weak var txtLocationType: LeftPaddedTextField!
    
    @IBOutlet weak var lblDefaultLocatiob: UILabel!
    
    @IBOutlet weak var txtDefaultLocation: LeftPaddedTextField!
    var searchArrayPurpose = [SearchTextFieldItem]()
    var objERSideADHOCAPISecondVC = ERSideADHOCAPISecondVC()
    
    override func viewWillAppear(_ animated: Bool) {
        GeneralUtility.customeNavigationBarWithOnlyBack(viewController: self, title: " Ad hoc Appointment")
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewInner.isHidden = true
        self.viewHeader.isHidden = true
               callViewModal()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
       registerForKeyboardNotifications()
        viewOuter.backgroundColor = .white
        viewOuter.cornerRadius = 3
        
        viewHeader.backgroundColor = .white
        viewHeader.cornerRadius = 3
        
        view.backgroundColor = ILColor.color(index: 22)
    }
    override func viewDidDisappear(_ animated: Bool) {
        deRegisterKeyboardNotifications()
    }
    
    override func actnResignKeyboard() {
        activeField!.resignFirstResponder()
    }
    @objc override func buttonClicked(sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func  callViewModal()
    {
        objERSideADHOCAPISecondVC.viewController = self
        objERSideADHOCAPISecondVC.delegate = self
        objERSideADHOCAPISecondVC.customAPI()
    }
    
    func customization(){
        customizeHeader()
        customizeStudentSelect()
        customizePurpose()
        customizationLocation()
         self.addInputAccessoryForTextFields(textFields: [txtLocationType], dismissable: true, previousNextable: true)
        self.addInputAccessoryForTextFields(textFields: [txtDefaultLocation], dismissable: true, previousNextable: true)

        
    }
    
   
    func formingModal(){
        
        prepareParticipatModal()
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
    
    func submitAdhocAppointment(){
        formingModal()
        let csrftoken = UserDefaultsDataSource(key: "csrf_token").readData() as! String
        var localTimeZoneAbbreviation: String { return TimeZone.current.description }
        let selectedUserPurposeArr = self.searchArrayPurpose.filter({$0.isSelected == true})
        var user_purpose_ids = [String]()
        for purpose in selectedUserPurposeArr{
            user_purpose_ids.append(purpose.title )
        }
        
        let arrLocation = ["Physical Location","Meeting URL"]
        let arrLocationI = ["physical_location","webinar_link"]
        
        let indexLocation = arrLocation.firstIndex(where: {$0 == txtLocationType.text})
        
        self.objOpenHourModalSubmit.locationType = arrLocationI[indexLocation ?? 0]
        self.objOpenHourModalSubmit.locationValue = self.txtDefaultLocation.text
        
        var   param = [
            "location_type": objOpenHourModalSubmit.locationType ?? "",
            "location": objOpenHourModalSubmit.locationValue ?? "",
            "timezone" : localTimeZoneAbbreviation,
            ParamName.PARAMCSRFTOKEN : csrftoken,
            ParamName.PARAMMETHODKEY : "post",
            "purposes" : user_purpose_ids
            ] as [String : Any]
        if objOpenHourModalSubmit.selectedSlotID != nil{
            param["open_hour_identifier"] = "\(objOpenHourModalSubmit.selectedSlotID ?? 0)"
        }
        else{
            let dicTime = objOpenHourModalSubmit.slotArr[0];
            param["start_datetime_utc"] = dicTime["start_datetime"]
            param["end_datetime_utc"] = dicTime["end_datetime"]
            
        }
        var participants = [Int]()
        for participantI in self.objOpenHourModalSubmit.participant{
            
            participants.append(participantI.entity_id!)
        }
        param["participants"] = participants
        
        
        let activityIndicator = ActivityIndicatorView.showActivity(view: self.view, message: StringConstants.FetchingCoachSelection)
        
        ERSideAppointmentService().erSideSubmitAdhocAppoiment(params: param as Dictionary<String,AnyObject>, { (jsonData) in
            activityIndicator.hide()
            
              GeneralUtility.alertViewPopOutViewController(title: "Success", message: "Adhoc Appointment Created Successfully !!!", viewController: self, buttons: ["Ok"])
            
            
            
        }) { (error, errorCode) in
            activityIndicator.hide()
            
        }
        
    }
    
}


extension AdhocFlowSecondViewController: ERSideADHOCAPISecondVCDelegate, ERSideStudentListViewControllerDelegate {
    
    
    func selectedStudentPrivateHour(objStudentDetailModalSelected: StudentDetailModal) {
        self.objStudentDetailModalSelected = objStudentDetailModalSelected
        
        if self.objOpenHourModalSubmit.open_hours_appointment_approval_process == "1"{
            txtStudentSelect.text = ((objStudentDetailModalSelected.items?[0].firstName ?? "")
                + (objStudentDetailModalSelected.items?[0].lastName ?? ""))

        }
        else{
            
            var count = objStudentDetailModalSelected.items?.count ?? 0
            if count > 1{
                txtStudentSelect.text = ((objStudentDetailModalSelected.items?[0].firstName ?? "")
                    + (objStudentDetailModalSelected.items?[0].lastName ?? "")) + " + " + "\(count - 1)"

            }
            else{
                txtStudentSelect.text = ((objStudentDetailModalSelected.items?[0].firstName ?? "")
                    + (objStudentDetailModalSelected.items?[0].lastName ?? ""))

            }
            

        }
        
    }
    
    func sendDataERSideADHOCAPISecondVC(objERSideADHOCAPISecondModal: ERSideADHOCAPISecondModal, isSuccess: Bool) {
        
        if isSuccess {
            self.dataPurposeModal = objERSideADHOCAPISecondModal.purposeArr
            self.objStudentDetailModalI = objERSideADHOCAPISecondModal.objStudentDetailModal
            self.objProviderModalArr = objERSideADHOCAPISecondModal.objProviderModalArr
            customization()
            self.viewInner.isHidden = false
            self.viewHeader.isHidden = false
        }
        else
        {
            
        }
        
    }
    
    
    
    func customizeHeader(){
        
        if let fontHeavy = UIFont(name: "FontHeavy".localized(), size: Device.FONTSIZETYPE14), let fontBook =  UIFont(name: "FontBook".localized(), size: Device.FONTSIZETYPE14)
            
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
    func customizeStudentSelect()  {
        if let fontHeavy = UIFont(name: "FontHeavy".localized(), size: Device.FONTSIZETYPE15)
        {
            let strHeader = NSMutableAttributedString.init()
            let strTiTle = NSAttributedString.init(string: "Select Student"
                , attributes: [NSAttributedString.Key.foregroundColor : ILColor.color(index: 31),NSAttributedString.Key.font : fontHeavy]);
            let strType = NSAttributedString.init(string: " ⃰"
                , attributes: [NSAttributedString.Key.foregroundColor : UIColor.red,NSAttributedString.Key.font : fontHeavy]);
            let para = NSMutableParagraphStyle.init()
            //            para.alignment = .center
            strHeader.append(strTiTle)
            strHeader.append(strType)
            
            strHeader.addAttribute(NSAttributedString.Key.paragraphStyle, value: para, range: NSMakeRange(0, strHeader.length))
            lblStudentSelect.attributedText = strHeader
            self.txtStudentSelect.backgroundColor = ILColor.color(index: 48)
            let fontMedium = UIFont(name: "FontMediumWithoutNext".localized(), size: Device.FONTSIZETYPE13)
            self.txtStudentSelect.font = fontMedium
            self.txtStudentSelect.layer.borderColor = ILColor.color(index: 27).cgColor
            self.txtStudentSelect.placeholder = "Select Student"
            self.txtStudentSelect.layer.borderWidth = 1;
            self.txtStudentSelect.layer.cornerRadius = 3;
            self.txtStudentSelect.rightView = UIImageView.init(image: UIImage.init(named: "Drop-down_arrow"))
        }
        
        
        
    }
    
}

extension AdhocFlowSecondViewController: SearchViewControllerDelegate {
    
    
    func customizationLocation(){
        if let fontHeavy = UIFont(name: "FontHeavy".localized(), size: Device.FONTSIZETYPE15)
        {
            let strHeader = NSMutableAttributedString.init()
            let strTiTle = NSAttributedString.init(string: "Location Type"
                , attributes: [NSAttributedString.Key.foregroundColor : ILColor.color(index: 31),NSAttributedString.Key.font : fontHeavy]);
            let strType = NSAttributedString.init(string: " ⃰"
                , attributes: [NSAttributedString.Key.foregroundColor : UIColor.red,NSAttributedString.Key.font : fontHeavy]);
            let para = NSMutableParagraphStyle.init()
            //            para.alignment = .center
            strHeader.append(strTiTle)
            strHeader.append(strType)
            
            strHeader.addAttribute(NSAttributedString.Key.paragraphStyle, value: para, range: NSMakeRange(0, strHeader.length))
            lblLocationType.attributedText = strHeader
             let fontMedium = UIFont(name: "FontMediumWithoutNext".localized(), size: Device.FONTSIZETYPE13)
            self.txtLocationType.backgroundColor = ILColor.color(index: 48)
            self.txtLocationType.font = fontMedium
            self.txtLocationType.placeholder = "Select location type"
            self.txtLocationType.layer.borderColor = ILColor.color(index: 27).cgColor
            self.txtLocationType.layer.borderWidth = 1;
            self.txtLocationType.layer.cornerRadius = 3;
            self.txtLocationType.rightView = UIImageView.init(image: UIImage.init(named: "Drop-down_arrow"))
        }
        
        if let fontHeavy = UIFont(name: "FontHeavy".localized(), size: Device.FONTSIZETYPE15)
        {
            let strHeader = NSMutableAttributedString.init()
            let strTiTle = NSAttributedString.init(string: "Location/Meeting Link"
                , attributes: [NSAttributedString.Key.foregroundColor : ILColor.color(index: 31),NSAttributedString.Key.font : fontHeavy]);
            let strType = NSAttributedString.init(string: " ⃰"
                , attributes: [NSAttributedString.Key.foregroundColor : UIColor.red,NSAttributedString.Key.font : fontHeavy]);
            let para = NSMutableParagraphStyle.init()
            //            para.alignment = .center
            strHeader.append(strTiTle)
            strHeader.append(strType)
            
            strHeader.addAttribute(NSAttributedString.Key.paragraphStyle, value: para, range: NSMakeRange(0, strHeader.length))
            lblDefaultLocatiob.attributedText = strHeader
             let fontMedium = UIFont(name: "FontMediumWithoutNext".localized(), size: Device.FONTSIZETYPE13)
            self.txtDefaultLocation.backgroundColor = ILColor.color(index: 48)
            self.txtDefaultLocation.font = fontMedium
            self.txtDefaultLocation.layer.borderColor = ILColor.color(index: 27).cgColor
            self.txtDefaultLocation.layer.borderWidth = 1;
            self.txtDefaultLocation.layer.cornerRadius = 3;
            self.txtDefaultLocation.placeholder = "Enter Location/Meeting Link"

            self.txtDefaultLocation.rightView = UIImageView.init(image: UIImage.init(named: "Drop-down_arrow"))
        }
        pickerViewSetUp(txtInput: txtLocationType, tag: 192)
    }
    
    
    func customizePurpose()  {
        
        var indexID = 0
        
        for purpose in dataPurposeModal!{
            let searchItem = SearchTextFieldItem()
            searchItem.title = purpose.displayName!
            searchItem.id  = indexID
            searchArrayPurpose.append(searchItem)
            indexID = indexID + 1;
        }
        
        
        if let fontHeavy = UIFont(name: "FontHeavy".localized(), size: Device.FONTSIZETYPE15)
        {
            let strHeader = NSMutableAttributedString.init()
            let strTiTle = NSAttributedString.init(string: "Purpose"
                , attributes: [NSAttributedString.Key.foregroundColor : ILColor.color(index: 31),NSAttributedString.Key.font : fontHeavy]);
            let strType = NSAttributedString.init(string: " ⃰"
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
        
        
    }
    
    
    
    
    @IBAction func btnPurposeTapped(_ sender: UIButton)
    {
        
        //         self.viewScroll.contentOffset = CGPoint.init(x:  0, y:  0)
        activeField = txtPurpose
        let searchViewController = SearchViewController.init(nibName: "SearchViewController", bundle: nil)
        searchViewController.modalPresentationStyle = .overFullScreen
        searchViewController.maxHeight = 200;
        searchViewController.isCreateNew = true
        
        let frameI =
            sender.superview?.convert(sender.frame, to: nil)
        var changedFrame = frameI
        
        self.viewScroll.contentOffset = CGPoint.init(x:  self.viewScroll.contentOffset.x, y:  self.viewScroll.contentOffset.y + (frameI!.origin.y - 140))
        changedFrame = CGRect.init(x: (changedFrame?.origin.x)!, y: ((changedFrame?.origin.y)! - (frameI!.origin.y - 140)), width: (changedFrame?.size.width)!, height: (changedFrame?.size.height)!)
        
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
        //        self.viewHeightConstraint.constant = 0
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
                        //
                        viewSelectedContainer.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-2-[view]", options: NSLayoutConstraint.FormatOptions(rawValue : 0), metrics: nil, views: ["view" :view ]))
                    }
                    
                    
                }
                else
                {
                    
                    viewSelectedContainer.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-8-[view]", options: NSLayoutConstraint.FormatOptions(rawValue : 0), metrics: nil, views: ["viewPrevius":viewPrevius!,"view" :view ]))
                    viewSelectedContainer.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[viewPrevius]-8-[view]", options: NSLayoutConstraint.FormatOptions(rawValue : 0), metrics: nil, views: ["viewPrevius":viewPrevius!,"view" :view ]))
                    view.layoutIfNeeded();
                    if (view.frame.width  >= self.view.frame.width){
                        viewSelectedContainer.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[view]-8-|", options: NSLayoutConstraint.FormatOptions(rawValue : 0), metrics: nil, views: ["view" :view ]))
                    }
                    
                    
                    //                    self.viewHeightConstraint.constant = self.viewHeightConstraint.constant + 35;
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
                viewSelectedContainer.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-2-[view]", options: NSLayoutConstraint.FormatOptions(rawValue : 0), metrics: nil, views: ["view" :view ]))
                viewPrevius = view;
                //                self.viewHeightConstraint.constant = self.viewHeightConstraint.constant + 35;
                view.layoutIfNeeded();
                if (view.frame.width  >= self.view.frame.width){
                    viewSelectedContainer.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[view]-8-|", options: NSLayoutConstraint.FormatOptions(rawValue : 0), metrics: nil, views: ["view" :view ]))
                }
            }
            index = index + 1
        }
        if viewPrevius != nil {
            viewSelectedContainer.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[view]-(8)-|", options: NSLayoutConstraint.FormatOptions(rawValue : 0), metrics: nil, views: ["view" :viewPrevius ]))
        }
        viewSelectedContainer.layoutIfNeeded()
        
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
        
        //        if sender.tag == -1000{
        //            let index = self.searchArrayPurpose.firstIndex(where: {$0.id == sender.tag}) ?? 0
        //            self.searchArrayPurpose.remove(at: index)
        //        }
        //        else{
        let selectedId = searchArrayPurpose.filter({$0.id == sender.tag})[0]
        selectedId.isSelected = false
        let index = self.searchArrayPurpose.firstIndex(where: {$0.id == sender.tag}) ?? 0
        self.searchArrayPurpose.removeAll(where: {$0.id == sender.tag})
        self.searchArrayPurpose.insert(selectedId, at: index)
        //        }
        
        
        setDynamicView()
    }
    
    func sendSelectedItem(item: SearchTextFieldItem) {
        
        let searchPurposeSelected =  self.searchArrayPurpose.filter({$0.isSelected == true});
        
        for selectedSearchItem in searchPurposeSelected {
            
            if selectedSearchItem.title == item.title{
                return
            }
            
        }
        if item.id == -1000{
            let selectedItem = item
            item.id = searchArrayPurpose.count + 1 ;
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
        //   viewSelectedContainer.layoutIfNeeded()
        
        
    }
    
    
}

extension AdhocFlowSecondViewController{
    
    func deRegisterKeyboardNotifications() {
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
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
    
}


extension AdhocFlowSecondViewController:UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate{
    
 
    
    // MARK:  Textfield delegate
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        arrPicker = ["Physical Location","Meeting URL"]
        
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
            return false

        }
        else{
            guard let currentText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) else { return true }
        
            return true
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
        arrPicker = ["Physical Location","Meeting URL"]
        txtLocationType.text = arrPicker[row]
        selectedTypeLocation(row: row)
        
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
                
            }
            
            return
        }
        
    }
    
}
