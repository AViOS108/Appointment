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
                cell.customization()
                cell.layoutIfNeeded()
                return cell
                
            }
            else if index == 3{
                // pending
                let cell = tableView.dequeueReusableCell(withIdentifier: "NextStepAppointmentTableViewCell", for: indexPath) as! NextStepAppointmentTableViewCell
                cell.objNextStepViewType = .erType
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
            cell.viewController = self
            cell.customization()
            cell.layoutIfNeeded()
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let _ = appoinmentDetailAllModalObj{
            if index == 2{
                return 4 // upcoming
            }
            else if index == 3{
                return 4 // pending
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


extension ERAppointmentDetailViewController : NotesAppointmentTableViewCellDelegate,NoteCollectionViewCellDelegate,EditNotesViewControllerDelegate{
    func addNotes() {
        let objERAddNotesViewController = ERAddNotesViewController.init(nibName: "ERAddNotesViewController", bundle: nil)
        
        self.navigationController?.pushViewController(objERAddNotesViewController, animated: false)
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
//            objEditViewController.delegate = self
//            objEditViewController.identifier = appoinmentDetailAllModalObj?.appoinmentDetailModalObj?.identifier
//            objEditViewController.modalPresentationStyle = .overFullScreen
            self.present(objEditViewController, animated: false, completion: nil)
        }
        
    }
     
    func refreshApi(){
        
        activityIndicator = ActivityIndicatorView.showActivity(view: self.navigationController!.view, message: StringConstants.FetchingCoachSelection)

        appoinmentViewModal.viewModalCustomized();
    }
}

