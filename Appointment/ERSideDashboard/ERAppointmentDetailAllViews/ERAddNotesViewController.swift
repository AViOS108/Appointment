//
//  ERAddNotesViewController.swift
//  Appointment
//
//  Created by Anurag Bhakuni on 14/01/21.
//  Copyright © 2021 Anurag Bhakuni. All rights reserved.
//

import UIKit
struct notesHeaderModal {
    var title : String?
    var id : Int?
}
enum viewTypeERAddNotesVC {
    case editNotes
    case AddNew
}

protocol ERAddNotesViewControllerDelegate {
    func refreshTableView()
}


class ERAddNotesViewController: SuperViewController,UITextViewDelegate {
    @IBOutlet weak var tblView: UITableView!
    
    var viewType : viewTypeERAddNotesVC!
    var delegate : ERAddNotesViewControllerDelegate!
    var appoinmentDetailModalObj : AppoinmentDetailModalNew?
    var noteModelResult : NotesModalNewResult!
    var noteModelResultStudent : NotesResult!

    var textViewStr : String = ""
    
    var objERSideRoleSpecificUserModal : ERSideRoleSpecificUserModal!
    var results: ERSideAppointmentModalResult!
    var arrNotesHeaderModal = [notesHeaderModal]()
    var activityIndicator: ActivityIndicatorView?

    var objERSideNotesSpecificUserModalSelected : ERSideNotesSpecificUserModal!
    var arrNameSurvey = [SearchTextFieldItem]()
    let pickerView = UIPickerView()

    
    func callApiErSide()   {
        
        
        var activityIndicator = ActivityIndicatorView.showActivity(view: self.view, message: StringConstants.SubmittingDandCOpenHour)
        
        var arrEntities = Array<Dictionary<String,AnyObject>>()
        
        let entitesObj1 = ["entity_id": "\(self.appoinmentDetailModalObj?.id ?? 0)",
                           "entity_type":"appointment"
            ] as [String : AnyObject]
        
        arrEntities.append(entitesObj1)

        for student in self.arrNameSurvey{
            if student.isSelected {
                let entitesStudent = ["entity_id":"\(student.id ?? 0)",
                                                 "entity_type":"student_user",
                                                 "can_view_note":"1"] as [String : AnyObject]
                           arrEntities.append(entitesStudent)
            }
            
        }
        
        
        if self.objERSideNotesSpecificUserModalSelected != nil {
            
            for specificUser in self.objERSideNotesSpecificUserModalSelected.items!{
                
                let entitesStudent = ["entity_id":"\(specificUser.id ?? 0)",
                                      "entity_type":"community_user",
                                      "can_view_note":"1"] as [String : AnyObject]
                arrEntities.append(entitesStudent)
            }
        }
        
        for specificRole in self.objERSideRoleSpecificUserModal.items!{
            if specificRole.isSelected {
                let entitesStudent = ["entity_id":"\(specificRole.id ?? 0)",
                                      "entity_type":"role",
                                      "can_view_note":"1"] as [String : AnyObject]
                arrEntities.append(entitesStudent)
            }
            
        }
        
        var method = ""
        switch viewType {
        case .AddNew:
            method = "post"
            break
        case .editNotes:
            method = "put"
            break
        default:
            break
        }
        
        let params = [
            "_method" : method,
            "data":textViewStr ,
            "csrf_token" : UserDefaultsDataSource(key: "csrf_token").readData() as! String,
            "entities":arrEntities
            
            ] as Dictionary<String,AnyObject>
        
        
        if noteModelResult != nil{
            ERSideAppointmentService().erSideSubmitNotes(params:params, { (data) in
                activityIndicator.hide()
                self.delegate.refreshTableView()
                self.navigationController?.popViewController(animated: false)
            }, failure: { (error, errorCode) in
                activityIndicator.hide()

            }, noteModelResult: self.noteModelResult)
        }
        else
        {
            ERSideAppointmentService().erSideSubmitNotes(params:params, { (data) in
                activityIndicator.hide()
                self.delegate.refreshTableView()
                self.navigationController?.popViewController(animated: false)
            }, failure: { (error, errorCode) in
                activityIndicator.hide()

            }, noteModelResult: nil)
        }
         
    }
    
    
    func callApiStudentSide()   {
        
        
        var activityIndicator = ActivityIndicatorView.showActivity(view: self.view, message: StringConstants.SubmittingDandCOpenHour)
        
        var arrEntities = Array<Dictionary<String,AnyObject>>()
        
        let entitesObj1 = ["entity_id": "\(self.appoinmentDetailModalObj?.id ?? 0)",
                           "entity_type":"appointment"
            ] as [String : AnyObject]
        
        arrEntities.append(entitesObj1)

    
        var method = ""
        switch viewType {
        case .AddNew:
            method = "post"
            break
        case .editNotes:
            method = "put"
            break
        default:
            break
        }
        
        let params = [
            "_method" : method,
            "data":textViewStr ,
            "csrf_token" : UserDefaultsDataSource(key: "csrf_token").readData() as! String,
            "entities":arrEntities
            
            ] as Dictionary<String,AnyObject>
        
        
        if noteModelResultStudent != nil{
            ERSideAppointmentService().studentSideSubmitNotes(params:params, { (data) in
                activityIndicator.hide()
                self.delegate.refreshTableView()
                self.navigationController?.popViewController(animated: false)
            }, failure: { (error, errorCode) in
                activityIndicator.hide()

            }, noteModelResult: self.noteModelResultStudent)
        }
        else
        {
            ERSideAppointmentService().studentSideSubmitNotes(params:params, { (data) in
                activityIndicator.hide()
                self.delegate.refreshTableView()
                self.navigationController?.popViewController(animated: false)
            }, failure: { (error, errorCode) in
                activityIndicator.hide()

            }, noteModelResult: nil)
        }
         
    }
    
    @IBOutlet weak var btnSubmit: UIButton!
    @IBAction func btnSubmitTapped(_ sender: Any) {
        let isStudent = UserDefaultsDataSource(key: "student").readData() as? Bool
        if isStudent ?? false {
            callApiStudentSide()

        }
        else
        {
            callApiErSide()
        }
       
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GeneralUtility.customeNavigationBarWithOnlyBack(viewController: self,title:"Add Notes");

        let isStudent = UserDefaultsDataSource(key: "student").readData() as? Bool
        if isStudent ?? false {
            createStudentSpeecificLogic()
            self.assignTblViewDataSource()

        }
        else
        {
            callViewModal()
            setNeedSearchTextField()
        }
        
      
        // Do any additional setup after loading the view.
    }
    
    func setNeedSearchTextField() {
        
        for requestI in (self.appoinmentDetailModalObj?.requests)!{
            let objSearchTextFieldItem  = SearchTextFieldItem()
            objSearchTextFieldItem.title =  requestI.studentDetails?.name ?? ""
            objSearchTextFieldItem.id =  requestI.studentDetails?.id
            objSearchTextFieldItem.isSelected  = false
            arrNameSurvey.append(objSearchTextFieldItem);
        }
    }
    
    
    
    @objc override func buttonClicked(sender: UIBarButtonItem) {
           self.navigationController?.popViewController(animated: true)
           

             }
    override func viewWillAppear(_ animated: Bool) {
        customize()
    }
    
    func customize()  {
        
        let fontheavy = UIFont(name: "FontHeavy".localized(), size: Device.FONTSIZETYPE14)
        
        UIButton.buttonUIHandling(button: btnSubmit, text: "Submit", backgroundColor: ILColor.color(index: 23), textColor: .white, cornerRadius: 3 , fontType: fontheavy)
        
        tblView.register(UINib.init(nibName: "ERNotesTextViewTableViewCell", bundle: nil), forCellReuseIdentifier: "ERNotesTextViewTableViewCell")

        tblView.register(UINib.init(nibName: "ERNoteSelectableTypeTableViewCell", bundle: nil), forCellReuseIdentifier: "ERNoteSelectableTypeTableViewCell")

        tblView.register(UINib.init(nibName: "ERNotesHeaderTypeTableViewCell", bundle: nil), forCellReuseIdentifier: "ERNotesHeaderTypeTableViewCell")
         tblView.register(UINib.init(nibName: "ERNotesStudentSelectTableViewCell", bundle: nil), forCellReuseIdentifier: "ERNotesStudentSelectTableViewCell")
        

    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let currentText = (textView.text as NSString?)?.replacingCharacters(in: range, with: text)
        
        if currentText?.count ?? 0 > 0{
            btnSubmit.isEnabled = true
        }
        else{
            btnSubmit.isEnabled = false
            
        }
        
        return true
    }
    
    
    override func actnResignKeyboard() {
        
    }
    
    
    func createNotesHeaderModal(){
        arrNotesHeaderModal =  [notesHeaderModal]()
        var firstAdditionObject = notesHeaderModal()
        firstAdditionObject.title = "With User Roles"
        firstAdditionObject.id  = -999
        var secondAdditionObject = notesHeaderModal()
        
        if let selected = self.objERSideNotesSpecificUserModalSelected{
            let selectedCount = selected.items?.count ?? 0
            if selectedCount  > 0{
                 secondAdditionObject.title = "Specific User :  (\(selectedCount) Selected) "
            }
            else {
                 secondAdditionObject.title = "Specific User"
            }
        }
        else{
             secondAdditionObject.title = "Specific User"
        }
        secondAdditionObject.id  = -1999
        arrNotesHeaderModal.append(firstAdditionObject)
        arrNotesHeaderModal.append(secondAdditionObject)
    }

    
    func createNotesSpecificModal(){
        createNotesHeaderModal()
        var firstAdditionObject = Role()
        firstAdditionObject.displayName = "Community Member"
        firstAdditionObject.id  = -999
        self.objERSideRoleSpecificUserModal.items?.insert(firstAdditionObject, at: 0)
        
        switch viewType {
        case .AddNew:
            break;
        case .editNotes:
            let data = self.noteModelResult?.data
            textViewStr = data ?? ""
            
            break;
      
        case .none:
            break
        }

    }
    
    
    
    func createStudentSpeecificLogic(){
            
        switch viewType {
        case .AddNew:
            break;
        case .editNotes:
            let data = self.noteModelResultStudent?.data
            textViewStr = data ?? ""
            
            break;
      
        case .none:
            break
        }

    }
    
    
    func assignTblViewDataSource(){
        self.tblView.delegate = self
        self.tblView.dataSource = self
        tblView.reloadData()
    }
    func callViewModal(){
        activityIndicator = ActivityIndicatorView.showActivity(view: self.navigationController!.view, message: StringConstants.FetchingCoachSelection)
          
        ERSideAppointmentService().erSideRoleList({ (data) in
             self.activityIndicator?.hide()
            do {
                self.objERSideRoleSpecificUserModal = try JSONDecoder().decode(ERSideRoleSpecificUserModal    .self, from: data)
                self.createNotesSpecificModal()
                self.assignTblViewDataSource()
                
            } catch  {
                
                CommonFunctions().showError(title: "Error", message: ErrorMessages.SomethingWentWrong.rawValue)
            }
            
            
        }) {
            (error, errorCode) in
             self.activityIndicator?.hide()
            self.assignTblViewDataSource()
        };
        
    }
    
}



extension ERAddNotesViewController: UITableViewDelegate,UITableViewDataSource,ERNotesTextViewTableViewCellDelegate,ERNoteSelectableTypeTableViewCellDelegate,ERSelecteSpecificUserViewControllerDelegate,ERNotesStudentSelectTableViewCellDelegate{
    
    func changeModal(searchItem: SearchTextFieldItem,  isAdded: Bool) {
        let selectedItem =  self.arrNameSurvey.filter{$0.id == searchItem.id}[0]
        selectedItem.isSelected = isAdded
        let indexSelected = self.arrNameSurvey.firstIndex(where: {$0.id == searchItem.id})
        self.arrNameSurvey.remove(at: indexSelected ?? 00)
        self.arrNameSurvey.insert(selectedItem, at: indexSelected ?? 0)
        tblView.reloadData()
    }
    
    
    
    func sendselectedUser(objERSideNotesSpecificUserModalSelected: ERSideNotesSpecificUserModal) {
        
        self.objERSideNotesSpecificUserModalSelected = objERSideNotesSpecificUserModalSelected
        
        createNotesHeaderModal()
        tblView.reloadData()
    }
    
    
    func selectedNotes(items: Role) {
        let coachModalArr = self.objERSideRoleSpecificUserModal.items? .filter({$0.id == items.id})
        var selectedRoles = coachModalArr?[0];
        selectedRoles?.isSelected = !items.isSelected
        let index = self.objERSideRoleSpecificUserModal.items?.firstIndex(where: { $0.id == items.id})
        self.objERSideRoleSpecificUserModal.items?.remove(at: index ?? 0)
        self.objERSideRoleSpecificUserModal.items?.insert(selectedRoles!, at: index ?? 0)
        tblView.reloadData()
    }
    
    
   
    func sendDescription(strText: String) {
        textViewStr = strText
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ERNotesTextViewTableViewCell", for: indexPath) as! ERNotesTextViewTableViewCell;
            cell.selectionStyle = UITableViewCell.SelectionStyle.none;
            cell.delegate = self;
            cell.txtView.text = textViewStr
            cell.customization();
            return cell
        }
        else if indexPath.row == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ERNoteSelectableTypeTableViewCell", for: indexPath) as! ERNoteSelectableTypeTableViewCell
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            cell.delegate = self
            cell.items = self.objERSideRoleSpecificUserModal.items?[0]
            cell.customization()
            return cell
            
        }
        else if indexPath.row == 2{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ERNotesHeaderTypeTableViewCell", for: indexPath) as! ERNotesHeaderTypeTableViewCell
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            cell.objNotesHeaderModal = self.arrNotesHeaderModal[0];
            cell.customization()
            return cell
            
        }
        else if (indexPath.row >= 3) && indexPath.row < ((self.objERSideRoleSpecificUserModal.items?.count ?? 0) + 2) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ERNoteSelectableTypeTableViewCell", for: indexPath) as! ERNoteSelectableTypeTableViewCell
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            cell.delegate = self
            cell.items = self.objERSideRoleSpecificUserModal.items?[indexPath.row - 2]
            cell.customization()
            return cell
            
        }
        else if indexPath.row == ((self.objERSideRoleSpecificUserModal.items?.count ?? 0) + 2 ){
            let cell = tableView.dequeueReusableCell(withIdentifier: "ERNotesHeaderTypeTableViewCell", for: indexPath) as! ERNotesHeaderTypeTableViewCell
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            cell.objNotesHeaderModal = self.arrNotesHeaderModal[1];
            cell.customization()
            return cell
            
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ERNotesStudentSelectTableViewCell", for: indexPath) as! ERNotesStudentSelectTableViewCell
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            cell.arrNameSurvey = arrNameSurvey
            cell.viewControllerI = self
            cell.delegate = self
            cell.tblview = self.tblView
            cell.customization()
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        let isStudent = UserDefaultsDataSource(key: "student").readData() as? Bool
        if isStudent ?? false {
            return 1
        }
        else
        {
            if objERSideRoleSpecificUserModal != nil && objERSideRoleSpecificUserModal.items?.count ?? 0 > 0{
                return objERSideRoleSpecificUserModal.items!.count + 4

            }
            else {
                return 0
            }
            
        }
        
           
    }
    
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
         if indexPath.row == ((self.objERSideRoleSpecificUserModal.items?.count ?? 0) + 2 ){
            let objERSelecteSpecificUserViewController = ERSelecteSpecificUserViewController.init(nibName: "ERSelecteSpecificUserViewController", bundle: nil)

            objERSelecteSpecificUserViewController.delegate = self
            if let selected = objERSideNotesSpecificUserModalSelected
            {
                objERSelecteSpecificUserViewController.objERSideNotesSpecificUserModalSelected = selected
            }
            
            self.navigationController?.pushViewController(objERSelecteSpecificUserViewController, animated: false)
        }
        
    }
    
}

// MARK: - KeyBoard Function


extension ERAddNotesViewController {
    
    func deRegisterKeyboardNotifications() {
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    func registerForKeyboardNotifications()  {
        
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown2(aNotification:)), name: UIResponder.keyboardDidShowNotification, object: nil)
//
//          NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
//

    }
    
    
    
    
    
}
