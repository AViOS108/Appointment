//
//  HomeMyAppointmentTableViewController.swift
//  Appointment
//
//  Created by Anurag Bhakuni on 16/09/20.
//  Copyright © 2020 Anurag Bhakuni. All rights reserved.
//

import UIKit

class HomeMyAppointmentTableViewController: UITableViewController {

    var viewControllerI : HomeViewController!
    var noPastAppo = false,noUpcommingAppo = false

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    
    func customizaTionMyApointment()  {
        self.view.backgroundColor = .clear
        self.tableView.backgroundColor = .clear
        viewControllerI.tblView.dataSource = self
        viewControllerI.tblView.delegate = self
        if viewControllerI.dataFeedingAppointmentModal?.results?.filter({$0.isPastAppointment == false}).count == 0
        {
            noUpcommingAppo = true
        }
        else
        {
            noUpcommingAppo = false
            
        }
        
        if viewControllerI.dataFeedingAppointmentModal?.results?.filter({$0.isPastAppointment == true}).count == 0
        {
            noPastAppo = true
        }
        else{
            noPastAppo = false
            
        }
        viewControllerI.tblView.reloadData()
    }
    
    
    

        
        
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DashBoardAppointmentTableViewCell", for: indexPath) as! DashBoardAppointmentTableViewCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.delegate = viewControllerI as? DashBoardAppointmentTableViewCellDelegate
        if indexPath.section == 0
        {
            if noUpcommingAppo {
                
            }
            else
            {
                cell.appointmentModal = viewControllerI.dataFeedingAppointmentModal?.results?.filter({$0.isPastAppointment == false})[indexPath.row]
                
                
                
            }
            cell.customize(noAppoinment: noUpcommingAppo, text: "No Appointment found!")
            
            
        }
        else{
            
            if noPastAppo {
                
            }
            else
            {
                cell.appointmentModal = viewControllerI.dataFeedingAppointmentModal?.results?.filter({$0.isPastAppointment == true})[indexPath.row]
            }
            cell.customize(noAppoinment: noPastAppo, text: "No Appointment found!")
            
            
        }
        return cell
    }
        
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return viewControllerI.dataFeedingAppointmentModal?.results?.count ?? 0

    }
        
        
    
        
        
    override func numberOfSections(in tableView: UITableView) -> Int{
            return 2
        }
        
 
}
