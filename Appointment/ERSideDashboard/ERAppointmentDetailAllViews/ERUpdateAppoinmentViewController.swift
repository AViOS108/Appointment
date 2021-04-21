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

    }
    override func buttonClicked(sender: UIBarButtonItem) {
              self.navigationController?.popViewController(animated: false)
          }

}

extension ERUpdateAppoinmentViewController: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ERUpdateAppoinmentTableViewCell", for: indexPath) as! ERUpdateAppoinmentTableViewCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.requestStudentDetail = self.results.requests![indexPath.row]
        cell.customization()
        cell.delegate = self
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
       
    }
    
}

extension ERUpdateAppoinmentViewController : ERUpdateAppoinmentTableViewCellDelegate{
    func attendedStatus(requestStudentDetail: Request) {
        var selectedId = results?.requests!.filter({$0.studentID == requestStudentDetail.studentID})[0]
        if requestStudentDetail.hasAttended == 0{
            selectedId?.hasAttended = 1
        }
        else{
            selectedId?.hasAttended = 0
        }
        let index = results?.requests!.firstIndex(where: {$0.studentID == requestStudentDetail.studentID}) ?? 0
        results?.requests!.removeAll(where: {$0.studentID == requestStudentDetail.studentID})
        results?.requests?.insert(selectedId!, at: index)
        viewModal(selectedStudent: requestStudentDetail)
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
        
        
        ERSideAppointmentService().erUpdateAttendence(params: params, studentId: selectedStudent.id ?? 0, { (data) in
            
            let json : Dictionary<String,Bool> = self.dataToJSON(data: data) as! Dictionary<String, Bool>
            if json["status"]! {
                self.reloadData(requestStudentDetail: selectedStudent)
            }
        }) { (error, errorCode) in
            
            
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
