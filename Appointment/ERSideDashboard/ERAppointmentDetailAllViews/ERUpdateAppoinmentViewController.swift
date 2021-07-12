//
//  ERUpdateAppoinmentViewController.swift
//  Appointment
//
//  Created by Anurag Bhakuni on 14/04/21.
//  Copyright © 2021 Anurag Bhakuni. All rights reserved.
//

import UIKit

protocol ERUpdateAppoinmentViewControllerDelegate {
    func refreshData(index:Int)
}

class ERUpdateAppoinmentViewController: SuperViewController {
    var results: ERSideAppointmentModalNewResult!
    var delegate  : ERUpdateAppoinmentViewControllerDelegate!
    
    
    @IBOutlet weak var tblView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        GeneralUtility.customeNavigationBarWithOnlyBack(viewController: self, title: "Update Attendance Status")
        tblView.register(UINib.init(nibName: "ERUpdateAppoinmentTableViewCell", bundle: nil), forCellReuseIdentifier: "ERUpdateAppoinmentTableViewCell")
        self.perform(#selector(ERUpdateAppoinmentViewController.swipeFirstCell), with: nil, afterDelay: 0.1)

    }
    override func buttonClicked(sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: false)
    }
    
    @objc func swipeFirstCell()  {
        tblView.layoutIfNeeded();
        let firstCell = (tblView.cellForRow(at: IndexPath(row: 0, section: 0)) as! ERUpdateAppoinmentTableViewCell);
        let viewContainer = firstCell.viewContainer!
        firstCell.viewSwipeLook.isHidden = false
        firstCell.layoutIfNeeded()
        UIView.animate(withDuration:  0.3, animations: {
            viewContainer.frame = CGRect(x: viewContainer.frame.origin.x - 100, y: viewContainer.frame.origin.y, width: viewContainer.bounds.size.width , height: viewContainer.bounds.size.height)
        }) { (finished) in
            UIView.animate(withDuration: 0.3, animations: {
                viewContainer.frame = CGRect(x: viewContainer.frame.origin.x + 100, y: viewContainer.frame.origin.y, width: viewContainer.bounds.size.width, height: viewContainer.bounds.size.height)
                

            }, completion: { (finished) in
                firstCell.viewSwipeLook.isHidden = true
            })
        }
    }
    
}

extension ERUpdateAppoinmentViewController: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ERUpdateAppoinmentTableViewCell", for: indexPath) as! ERUpdateAppoinmentTableViewCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.requestStudentDetail = self.results.requests![indexPath.row]
        cell.customization()
//        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.results != nil
        {
            return self.results.requests?.count ?? 0
        }
        else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
    
    func tableView(_ tableView: UITableView,
                   leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive,
                                        title: "Not Attended") { [weak self] (action, view, completionHandler) in
            self?.attendedStatus(requestStudentDetail: (self?.results.requests![indexPath.row])!, status: 0)
            
            completionHandler(true)
        }
        action.backgroundColor = ILColor.color(index: 57)
        action.image = UIImage.init(named: "notattendedCross")
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive,
                                        title: "Attended") { [weak self] (action, view, completionHandler) in
            self?.attendedStatus(requestStudentDetail: (self?.results.requests![indexPath.row])!, status: 1)
            completionHandler(true)
        }
        action.backgroundColor = ILColor.color(index: 58)
        action.image = UIImage.init(named: "attenededtick")
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    
    
}

extension ERUpdateAppoinmentViewController {
    func attendedStatus(requestStudentDetail: Request,status: Int) {
        var selectedId = results?.requests!.filter({$0.studentID == requestStudentDetail.studentID})[0]
        selectedId?.hasAttended = status

        let index = results?.requests!.firstIndex(where: {$0.studentID == requestStudentDetail.studentID}) ?? 0
        results?.requests!.removeAll(where: {$0.studentID == requestStudentDetail.studentID})
        results?.requests?.insert(selectedId!, at: index)
        viewModal(selectedStudent: selectedId!)
    }

    
    func reloadData(requestStudentDetail: Request)  {
      
         self.tblView.reloadData()
        delegate.refreshData(index: 4)
    }
    
    func viewModal(selectedStudent : Request){
        let csrftoken = UserDefaultsDataSource(key: "csrf_token").readData() as! String

        let params  = ["_method": "post",
                       "has_attended": selectedStudent.hasAttended,
                       "appointment_id" :selectedStudent.appointmentID,
                       "csrf_token" : csrftoken
            ] as [String : AnyObject]
        
        let  activityIndicator = ActivityIndicatorView.showActivity(view: self.navigationController!.view, message: StringConstants.FetchingCoachSelection)

        ERSideAppointmentService().erUpdateAttendence(params: params, studentId: selectedStudent.id ?? 0, { (data) in
            activityIndicator.hide()
            let json : Dictionary<String,Bool> = self.dataToJSON(data: data) as! Dictionary<String, Bool>
            if json["status"]! {
                self.reloadData(requestStudentDetail: selectedStudent)
            }
        }) { (error, errorCode) in
            activityIndicator.hide()

            
        }
    }
    
    func dataToJSON(data: Data) -> Any? {
       do {
           return try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
       } catch let myJSONError {
           print(myJSONError)
       }
       return nil
    }
    
    
}
