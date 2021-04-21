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


class ERAddNotesViewController: SuperViewController,UITextViewDelegate {
    @IBOutlet weak var tblView: UITableView!
    
    var objERSideRoleSpecificUserModal : ERSideRoleSpecificUserModal!
    var results: ERSideAppointmentModalResult!
    var arrNotesHeaderModal = [notesHeaderModal]()
    var activityIndicator: ActivityIndicatorView?

    var objERSideNotesSpecificUserModalSelected : ERSideNotesSpecificUserModal!
    
    func callApi()   {
        
        //
        //        var activityIndicator = ActivityIndicatorView.showActivity(view: self.view, message: StringConstants.SubmittingDandCOpenHour)
        //
        //        var arrEntities = Array<Dictionary<String,AnyObject>>()
        //
        //        let entitesObj1 = ["entity_id":results.participants![0].id,
        //                           "entity_type":"student_user",
        //                           "can_view_note":isFooter1Selected] as [String : AnyObject]
        //
        //        let entitesObj2 = ["entity_id":results.id,
        //                           "entity_type":"community",
        //                           "can_view_note":isFooter2Selected] as [String : AnyObject]
        //        let entitesObj3 = ["entity_id":results.identifier,
        //                                  "entity_type":"event"] as [String : AnyObject]
        //
        //        arrEntities.append(entitesObj1)
        //        arrEntities.append(entitesObj2)
        //        arrEntities.append(entitesObj3)
        //
        //
        //        let params = [
        //            "_method" : "post",
        //            "data":txtView.text ?? "",
        //            "csrf_token" : UserDefaultsDataSource(key: "csrf_token").readData() as! String,
        //            "appointment_cancellation_reason" :txtView.text ?? "",
        //            "entities":arrEntities
        //
        //            ] as Dictionary<String,AnyObject>
        //
        //
        //
        //        ERSideAppointmentService().erSideAppointemntSaveNotes(params: params, { (data) in
        //
        //            activityIndicator.hide()
        //
        //
        //        }) { (error, errorCode) in
        //
        //            activityIndicator.hide()
        //
        //        }
        //
        
        
    }
    
    
    @IBOutlet weak var btnSubmit: UIButton!
    @IBAction func btnSubmitTapped(_ sender: Any) {
        callApi()
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GeneralUtility.customeNavigationBarWithOnlyBack(viewController: self,title:"Add Notes");

        callViewModal()
        // Do any additional setup after loading the view.
    }
    
    @objc override func buttonClicked(sender: UIBarButtonItem) {
           self.navigationController?.popViewController(animated: true)
           

             }
    override func viewWillAppear(_ animated: Bool) {
        customize()
    }
    
    func customize()  {
        
        
        tblView.register(UINib.init(nibName: "ERNotesTextViewTableViewCell", bundle: nil), forCellReuseIdentifier: "ERNotesTextViewTableViewCell")

        tblView.register(UINib.init(nibName: "ERNoteSelectableTypeTableViewCell", bundle: nil), forCellReuseIdentifier: "ERNoteSelectableTypeTableViewCell")

        tblView.register(UINib.init(nibName: "ERNotesHeaderTypeTableViewCell", bundle: nil), forCellReuseIdentifier: "ERNotesHeaderTypeTableViewCell")

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
        
        var lastAdditionObject = Role()
        lastAdditionObject.displayName = "Students"
        lastAdditionObject.id  = -1999
        
        self.objERSideRoleSpecificUserModal.items?.insert(firstAdditionObject, at: 0)
        let lastCount = self.objERSideRoleSpecificUserModal.items?.count
        self.objERSideRoleSpecificUserModal.items?.insert(lastAdditionObject, at: (lastCount ?? 1))

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



extension ERAddNotesViewController: UITableViewDelegate,UITableViewDataSource,ERNotesTextViewTableViewCellDelegate,ERNoteSelectableTypeTableViewCellDelegate,ERSelecteSpecificUserViewControllerDelegate{
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
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ERNotesTextViewTableViewCell", for: indexPath) as! ERNotesTextViewTableViewCell;
            cell.selectionStyle = UITableViewCell.SelectionStyle.none;
            cell.delegate = self;
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
        else if indexPath.row >= 3 &&  indexPath.row < ((self.objERSideRoleSpecificUserModal.items?.count ?? 0) + 1 ){
            let cell = tableView.dequeueReusableCell(withIdentifier: "ERNoteSelectableTypeTableViewCell", for: indexPath) as! ERNoteSelectableTypeTableViewCell
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            cell.delegate = self

            cell.items = self.objERSideRoleSpecificUserModal.items?[indexPath.row - 2]
            cell.customization()
            return cell
            
        }
        else if indexPath.row == ((self.objERSideRoleSpecificUserModal.items?.count ?? 0) + 1 ){
            let cell = tableView.dequeueReusableCell(withIdentifier: "ERNotesHeaderTypeTableViewCell", for: indexPath) as! ERNotesHeaderTypeTableViewCell
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            cell.objNotesHeaderModal = self.arrNotesHeaderModal[1];
            cell.customization()
            return cell
            
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ERNoteSelectableTypeTableViewCell", for: indexPath) as! ERNoteSelectableTypeTableViewCell
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            let totolCount = self.objERSideRoleSpecificUserModal.items?.count
            cell.delegate = self

            cell.items = self.objERSideRoleSpecificUserModal.items?[(totolCount ?? 1) - 1]
            cell.customization()
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if objERSideRoleSpecificUserModal != nil && objERSideRoleSpecificUserModal.items?.count ?? 0 > 0{
            return objERSideRoleSpecificUserModal.items!.count + 3
        }
        else {
            return 0
        }
           
    }
    
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if indexPath.row == ((self.objERSideRoleSpecificUserModal.items?.count ?? 0) + 1 ) {
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
