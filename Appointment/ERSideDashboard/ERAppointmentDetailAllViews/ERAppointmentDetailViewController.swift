//
//  ERAppointmentDetailViewController.swift
//  Appointment
//
//  Created by Anurag Bhakuni on 13/01/21.
//  Copyright © 2021 Anurag Bhakuni. All rights reserved.
//

import UIKit

class ERAppointmentDetailViewController: SuperViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var viewButtonContainer: UIView!
    @IBOutlet weak var btnFinalAppoinment: UIButton!
    @IBAction func btnFinalAppoinmentTapped(_ sender: Any) {
    }
    @IBAction func btnCancelAppoinmentTapped(_ sender: Any) {
        
        
    }
    @IBOutlet weak var btnCancelAppoinment: UIButton!
    var activityIndicator: ActivityIndicatorView?
    var appoinmentViewModal = ERSideAppoinmentDetailModal()
    var selectedResult : ERSideAppointmentModalNewResult!
    var index = 0;
    var appoinmentDetailAllModalObj: ApooinmentDetailAllNewModal?
    @IBOutlet weak var tblVIew: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = ILColor.color(index: 22)
        activityIndicator = ActivityIndicatorView.showActivity(view: self.view, message: StringConstants.FetchingCoachSelection)
        appoinmentViewModal.selectedResult = self.selectedResult
        appoinmentViewModal.delegate = self
       
        
        
        appoinmentViewModal.detailType = index
        appoinmentViewModal.viewModalCustomized();
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let fontheavy = UIFont(name: "FontHeavy".localized(), size: Device.FONTSIZETYPE14)
        
        if index == 2{
            btnFinalAppoinment.isHidden = true
            UIButton.buttonUIHandling(button: btnCancelAppoinment, text: "Cancel Appointment", backgroundColor: ILColor.color(index: 23), textColor: .white, cornerRadius: 3, fontType: fontheavy)
            // upcoming
        }
        else if index == 3{
            
            if selectedResult.requests?.count ?? 0 > 0{
                
            }
            else{
                btnFinalAppoinment.isHidden = true

            }
            UIButton.buttonUIHandling(button: btnFinalAppoinment, text: "Finalise Appointment", backgroundColor: ILColor.color(index: 23), textColor: .white, cornerRadius: 3, fontType: fontheavy)
            
            UIButton.buttonUIHandling(button: btnCancelAppoinment, text: "Cancel Appointment", backgroundColor: .white, textColor: ILColor.color(index: 23), cornerRadius: 3,  borderColor: ILColor.color(index: 23), borderWidth: 3,  fontType: fontheavy)
            
            // pending
        }
        else{
            btnFinalAppoinment.isHidden = true
            btnCancelAppoinment.isHidden = true
            viewButtonContainer.isHidden = true
            // past
        }
        
    }
    override func viewDidAppear(_ animated: Bool) {
        tblVIew.register(UINib.init(nibName: "NotesAppointmentTableViewCell", bundle: nil), forCellReuseIdentifier: "NotesAppointmentTableViewCell")
        
        tblVIew.register(UINib.init(nibName: "NextStepAppointmentTableViewCell", bundle: nil), forCellReuseIdentifier: "NextStepAppointmentTableViewCell")
        
        tblVIew.register(UINib.init(nibName: "ERAppoDetailFirstTableViewCell", bundle: nil), forCellReuseIdentifier: "ERAppoDetailFirstTableViewCell")
        
        tblVIew.register(UINib.init(nibName: "ERAppoDetailSecondTableViewCell", bundle: nil), forCellReuseIdentifier: "ERAppoDetailSecondTableViewCell")
        tblVIew.register(UINib.init(nibName: "ERAppoDetailThirdTableViewCell", bundle: nil), forCellReuseIdentifier: "ERAppoDetailThirdTableViewCell")
        tblVIew.delegate = self
        tblVIew.dataSource = self
        tblVIew.reloadData()
        GeneralUtility.customeNavigationBarWithOnlyBack(viewController: self,title:"My Appointments");
    }
    
    override func buttonClicked(sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: false)
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ERAppoDetailFirstTableViewCell", for: indexPath) as! ERAppoDetailFirstTableViewCell
            cell.viewController = self
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            cell.appoinmentDetailAllModalObj = self.appoinmentDetailAllModalObj
            cell.customization()
            cell.layoutIfNeeded()
            return cell
        }
        else  if indexPath.row == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ERAppoDetailSecondTableViewCell", for: indexPath) as! ERAppoDetailSecondTableViewCell
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            cell.viewController = self;
            cell.index = self.appoinmentDetailAllModalObj?.status ?? 2;
            cell.appoinmentDetailModalObj = self.appoinmentDetailAllModalObj?.appoinmentDetailModalObj
            cell.customization()
            cell.layoutIfNeeded()
            return cell
            
        }
        else  if indexPath.row == 2{
            if index == 2{
                // upcoming
                let cell = tableView.dequeueReusableCell(withIdentifier: "NotesAppointmentTableViewCell", for: indexPath) as! NotesAppointmentTableViewCell
                cell.selectionStyle = UITableViewCell.SelectionStyle.none
                cell.objNoteViewType = .erType
                cell.appoinmentDetailAllModalObj = self.appoinmentDetailAllModalObj
                cell.viewController = self
                cell.delegate = self
                cell.customization()
                cell.layoutIfNeeded()
                return cell
                
            }
            else if index == 3{
                // pending
                let cell = tableView.dequeueReusableCell(withIdentifier: "NotesAppointmentTableViewCell", for: indexPath) as! NotesAppointmentTableViewCell
                cell.selectionStyle = UITableViewCell.SelectionStyle.none
                cell.objNoteViewType = .erType
                cell.appoinmentDetailAllModalObj = self.appoinmentDetailAllModalObj
                cell.viewController = self
                cell.delegate = self
                cell.customization()
                cell.layoutIfNeeded()
                return cell
            }
            else{
                // past
                let cell = tableView.dequeueReusableCell(withIdentifier: "ERAppoDetailThirdTableViewCell", for: indexPath) as! ERAppoDetailThirdTableViewCell
                cell.selectionStyle = UITableViewCell.SelectionStyle.none
                cell.appoinmentDetailModalObj = self.appoinmentDetailAllModalObj?.appoinmentDetailModalObj
                cell.viewController = self
                cell.customization()
                cell.layoutIfNeeded()
                return cell
            }
            
            
        }
            
        else if indexPath.row == 3{
            if index == 2{
                // upcoming
                let cell = tableView.dequeueReusableCell(withIdentifier: "NextStepAppointmentTableViewCell", for: indexPath) as! NextStepAppointmentTableViewCell
                cell.objNextStepViewType = .erType
                cell.selectionStyle = UITableViewCell.SelectionStyle.none
                cell.nextModalObj = self.appoinmentDetailAllModalObj?.nextModalObj
                cell.viewController = self
                cell.delegate = self
                cell.customization()
                cell.layoutIfNeeded()
                return cell
                
            }
            else if index == 3{
                // pending
                let cell = tableView.dequeueReusableCell(withIdentifier: "NextStepAppointmentTableViewCell", for: indexPath) as! NextStepAppointmentTableViewCell
                cell.objNextStepViewType = .erType
                cell.delegate = self
                cell.selectionStyle = UITableViewCell.SelectionStyle.none
                cell.nextModalObj = self.appoinmentDetailAllModalObj?.nextModalObj
                cell.viewController = self
                cell.customization()
                cell.layoutIfNeeded()
                return cell
            }
            else{
                // past
                let cell = tableView.dequeueReusableCell(withIdentifier: "NotesAppointmentTableViewCell", for: indexPath) as! NotesAppointmentTableViewCell
                cell.selectionStyle = UITableViewCell.SelectionStyle.none
                cell.objNoteViewType = .erType
                cell.appoinmentDetailAllModalObj = self.appoinmentDetailAllModalObj
                cell.viewController = self
                cell.delegate = self
                cell.customization()
                cell.layoutIfNeeded()
                return cell
            }
        }
            
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "NextStepAppointmentTableViewCell", for: indexPath) as! NextStepAppointmentTableViewCell
            cell.objNextStepViewType = .erType
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            cell.nextModalObj = self.appoinmentDetailAllModalObj?.nextModalObj
            cell.delegate = self
            cell.viewController = self
            cell.customization()
            cell.layoutIfNeeded()
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let _ = appoinmentDetailAllModalObj{
            if index == 2{
                return 3 // upcoming
            }
            else if index == 3{
                return 2 // pending
            }
            else{
                return 5 // past
            }
        }
        else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
    }
}


extension ERAppointmentDetailViewController : ERSideAppoinmentDetailModalDeletgate{
    func sendAppoinmentData(appoinmentDetailModalObj: ApooinmentDetailAllNewModal?, isSucess: Bool) {
        self.activityIndicator?.hide()
        if isSucess{
            self.appoinmentDetailAllModalObj = appoinmentDetailModalObj;
            self.appoinmentDetailAllModalObj?.status = index
            
            self.tblVIew.reloadData()
        }
        else{
            CommonFunctions().showError(title: "Error", message: ErrorMessages.SomethingWentWrong.rawValue)
            
        }
    }
}
import MessageUI

extension ERAppointmentDetailViewController : NotesAppointmentTableViewCellDelegate,NoteCollectionViewCellDelegate,EditNotesViewControllerDelegate,ERAddNotesViewControllerDelegate,NextStepAppointmentTableViewCelldelegate,ERUpdateStatusAddNextStepViewControllerDelegate,ERSideFIrstTypeCollectionViewDelegate,ERCancelViewControllerDelegate,MFMailComposeViewControllerDelegate{
    func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
               let mail = MFMailComposeViewController()
               mail.mailComposeDelegate = self
               mail.setToRecipients([])
               mail.setMessageBody("", isHTML: true)
               present(mail, animated: true)
           } else {
               // show failure alert
           }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
  
    
    func markCompleteStatus(id: String) {
        let csrftoken = UserDefaultsDataSource(key: "csrf_token").readData() as! String

        let params = [
            "_method" : "patch",
            "is_completed" :"1",
            "csrf_token" : csrftoken
        ] as Dictionary<String,AnyObject>
        
        let activityIndicator = ActivityIndicatorView.showActivity(view: self.view, message: StringConstants.NEXTSTEPCOMPLETION)
        
        ERSideAppointmentService().erSideAppointemntNextComplete(params: params, id: id , { (jsonData) in
            activityIndicator.hide()
           
            GeneralUtility.alertView(title: "", message: "Completed".localized(), viewController: self, buttons: ["Ok"]);
            self.refreshTableView()
            
        }) { (error, errorCode) in
            activityIndicator.hide()
            
        }
    }
    
    func acceptDeclineApi(isAccept: Bool) {
        if isAccept{
            acceptCustomize()
        }
        else{
            declineCustomize()
        }
    }
    
    
    
    func acceptApi(){
        let params = [
            "_method" : "post",
            "csrf_token" : UserDefaultsDataSource(key: "csrf_token").readData() as! String,
            "appointment_id": selectedResult.id ?? "0"
        ] as Dictionary<String,AnyObject>
        
        let activityIndicator = ActivityIndicatorView.showActivity(view: self.view, message: StringConstants.AcceptOpenHour)
        ERSideAppointmentService().erSideAppointemntAccept(params: params, id: String(describing: selectedResult.requests?[0].id ?? 0) , { (jsonData) in
            activityIndicator.hide()
           
            GeneralUtility.alertView(title: "", message: "Accepted".localized(), viewController: self, buttons: ["Ok"]);
            self.refreshTableView()
            
        }) { (error, errorCode) in
            activityIndicator.hide()
            
        }
        
    }
    
    func acceptCustomize(){
        
        
        GeneralUtility.alertViewWithClousre(title: "", message: "Are you sure to accept this Appoinment", viewController: self, buttons: ["Cancel","Ok"]) {
            self.acceptApi()
        }
        
    }
    func declineCustomize(){
        let objERCancelViewController = ERCancelViewController.init(nibName: "ERCancelViewController", bundle: nil)
        objERCancelViewController.modalPresentationStyle = .overFullScreen
        objERCancelViewController.results = self.selectedResult
        objERCancelViewController.viewType = .decline
        objERCancelViewController.delegate = self
        self.navigationController?.pushViewController(objERCancelViewController, animated: false)
        
    }
    
    
    
    
    
    func addNextStep() {
        let objERUpdateStatusAddNextStepViewController = ERUpdateStatusAddNextStepViewController.init(nibName: "ERUpdateStatusAddNextStepViewController", bundle: nil)
        objERUpdateStatusAddNextStepViewController.appoinmentDetailModalObj = self.appoinmentDetailAllModalObj?.appoinmentDetailModalObj
        objERUpdateStatusAddNextStepViewController.delegate = self
        
        self.navigationController?.pushViewController(objERUpdateStatusAddNextStepViewController, animated: false)
    }
    
    
    func refreshTableView() {
        activityIndicator = ActivityIndicatorView.showActivity(view: self.view, message: StringConstants.FetchingCoachSelection)
        appoinmentViewModal.selectedResult = self.selectedResult
        appoinmentViewModal.delegate = self
        appoinmentViewModal.viewModalCustomized();
    }
    
    func addEditNotes(isEdit: Bool) {
        if isEdit {
            let objERAddNotesViewController = ERAddNotesViewController.init(nibName: "ERAddNotesViewController", bundle: nil)
            objERAddNotesViewController.appoinmentDetailModalObj = self.appoinmentDetailAllModalObj?.appoinmentDetailModalObj;
            objERAddNotesViewController.delegate = self
            objERAddNotesViewController.viewType = .editNotes
            self.navigationController?.pushViewController(objERAddNotesViewController, animated: false)
        }
        else{
            let objERAddNotesViewController = ERAddNotesViewController.init(nibName: "ERAddNotesViewController", bundle: nil)
            objERAddNotesViewController.appoinmentDetailModalObj = self.appoinmentDetailAllModalObj?.appoinmentDetailModalObj;
            objERAddNotesViewController.delegate = self
            objERAddNotesViewController.viewType = .AddNew
            self.navigationController?.pushViewController(objERAddNotesViewController, animated: false)
            
        }
        
    }
    
    
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: nil, completion: { (_) in
            self.tblVIew.reloadData()
        })
        
    }
    
    
    
    func deleteNotesLOgic(objModel : NotesModalNewResult?){
        
        GeneralUtility.alertViewWithClousre(title: "", message: "Are you sure, you want to delete this note?", viewController: self, buttons: ["cancel","Ok"]) {
            self.hitDeleteApi(objModel: objModel)
        }
       
    }
    
    func hitDeleteApi(objModel : NotesModalNewResult?)  {
        
        let objAppointment = AppoinmentdetailViewModal()
        activityIndicator = ActivityIndicatorView.showActivity(view: self.view, message: StringConstants.DeletingNotes)
        objAppointment.callbackVC = {
            (success:Bool) in
            self.activityIndicator?.hide()
            if success{
                
                CommonFunctions().showError(title: "", message: "Successfully Deleted")
                
                self.refreshApi()
            }
        }
        objAppointment.deleteNotes(objnoteModal: objModel)
    }
    
    
    
    func editDeleteFunctionality(objModel : NotesModalNewResult?, isMyNotes: Bool?,isDeleted:Bool) {
        if isDeleted{
            deleteNotesLOgic(objModel: objModel)
        }
        else{
            let objERAddNotesViewController = ERAddNotesViewController.init(nibName: "ERAddNotesViewController", bundle: nil)
            objERAddNotesViewController.appoinmentDetailModalObj = self.appoinmentDetailAllModalObj?.appoinmentDetailModalObj;
            objERAddNotesViewController.delegate = self
            objERAddNotesViewController.noteModelResult = objModel
            objERAddNotesViewController.viewType = .editNotes
            self.navigationController?.pushViewController(objERAddNotesViewController, animated: false)
        }
        
    }
    
    func refreshApi(){
        
        activityIndicator = ActivityIndicatorView.showActivity(view: self.navigationController!.view, message: StringConstants.FetchingCoachSelection)
        
        appoinmentViewModal.viewModalCustomized();
    }
}

