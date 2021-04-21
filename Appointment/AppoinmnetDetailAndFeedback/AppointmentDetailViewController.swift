//
//  AppointmentDetailViewController.swift
//  Appointment
//
//  Created by Anurag Bhakuni on 22/09/20.
//  Copyright © 2020 Anurag Bhakuni. All rights reserved.
//

import UIKit

class AppointmentDetailViewController: SuperViewController,UITableViewDelegate,UITableViewDataSource {
    
    var activityIndicator: ActivityIndicatorView?
    var appoinmentViewModal = AppoinmentdetailViewModal()
    var selectedAppointmentModal : OpenHourCoachModalResult?
    var appoinmentDetailAllModalObj: ApooinmentDetailAllModal?
    @IBOutlet weak var tblVIew: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator = ActivityIndicatorView.showActivity(view: self.view, message: StringConstants.FetchingCoachSelection)
        appoinmentViewModal.selectedAppointmentModal = self.selectedAppointmentModal
        appoinmentViewModal.delegate = self
        appoinmentViewModal.viewModalCustomized();
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.view.backgroundColor = ILColor.color(index: 41)

    }
    override func viewDidAppear(_ animated: Bool) {
        tblVIew.register(UINib.init(nibName: "NotesAppointmentTableViewCell", bundle: nil), forCellReuseIdentifier: "NotesAppointmentTableViewCell")
        tblVIew.register(UINib.init(nibName: "NextStepAppointmentTableViewCell", bundle: nil), forCellReuseIdentifier: "NextStepAppointmentTableViewCell")
        tblVIew.register(UINib.init(nibName: "AppoinmentDescriptionTableViewCell", bundle: nil), forCellReuseIdentifier: "AppoinmentDescriptionTableViewCell")
        tblVIew.register(UINib.init(nibName: "AppoinmentPurposeTableViewCell", bundle: nil), forCellReuseIdentifier: "AppoinmentPurposeTableViewCell")
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
            let cell = tableView.dequeueReusableCell(withIdentifier: "AppoinmentDescriptionTableViewCell", for: indexPath) as! AppoinmentDescriptionTableViewCell
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            cell.appoinmentDetailModalObj = self.appoinmentDetailAllModalObj?.appoinmentDetailModalObj
            cell.customization()
            cell.layoutIfNeeded()
            return cell
        }
        else  if indexPath.row == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "AppoinmentPurposeTableViewCell", for: indexPath) as! AppoinmentPurposeTableViewCell
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            cell.viewController = self;
            cell.appoinmentDetailModalObj = self.appoinmentDetailAllModalObj?.appoinmentDetailModalObj
            cell.customization()
            cell.layoutIfNeeded()
            return cell
            
        }
        else  if indexPath.row == 2{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "NotesAppointmentTableViewCell", for: indexPath) as! NotesAppointmentTableViewCell
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
//            cell.appoinmentDetailAllModalObj = self.appoinmentDetailAllModalObj
            cell.viewController = self
            cell.delegate = self
            cell.customization()
            cell.layoutIfNeeded()
            return cell
        }
            
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "NextStepAppointmentTableViewCell", for: indexPath) as! NextStepAppointmentTableViewCell
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
//            cell.nextModalObj = self.appoinmentDetailAllModalObj?.nextModalObj
            cell.viewController = self
            cell.customization()
            cell.layoutIfNeeded()
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let _ = appoinmentDetailAllModalObj{
           return 4
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


extension AppointmentDetailViewController : AppoinmentdetailViewModalDeletgate{
    func sendAppoinmentData(appoinmentDetailModalObj: ApooinmentDetailAllModal?, isSucess: Bool) {
        self.activityIndicator?.hide()
        if isSucess{
            self.appoinmentDetailAllModalObj = appoinmentDetailModalObj;
            self.tblVIew.reloadData()
        }
        else{
            CommonFunctions().showError(title: "Error", message: ErrorMessages.SomethingWentWrong.rawValue)
            
        }
    }
    
    
}


extension AppointmentDetailViewController : NotesAppointmentTableViewCellDelegate,NoteCollectionViewCellDelegate,EditNotesViewControllerDelegate{
    func addNotes() {
        
    }
    
   
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
           
           super.viewWillTransition(to: size, with: coordinator)
           coordinator.animate(alongsideTransition: nil, completion: { (_) in
            self.tblVIew.reloadData()
           })
           
       }
    
    
    func editDeleteFunctionality(objModel : NotesModalNewResult?, isMyNotes: Bool?,isDeleted:Bool) {
        if isDeleted{
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
//            objAppointment.deleteNotes(objnoteModal: objModel)
        }
        else{
            let objEditViewController = EditNotesViewController.init(nibName: "EditNotesViewController", bundle: nil)
//            objEditViewController.objNoteModal = objModel
            objEditViewController.delegate = self
            objEditViewController.identifier = appoinmentDetailAllModalObj?.appoinmentDetailModalObj?.identifier
            objEditViewController.modalPresentationStyle = .overFullScreen
            self.present(objEditViewController, animated: false, completion: nil)
        }
        
    }
    
   
    
   
    
    func refreshApi(){
        
        activityIndicator = ActivityIndicatorView.showActivity(view: self.navigationController!.view, message: StringConstants.FetchingCoachSelection)

        appoinmentViewModal.viewModalCustomized();
    }
}
