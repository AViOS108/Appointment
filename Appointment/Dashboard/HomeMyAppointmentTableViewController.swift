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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    
    func customizaTionMyApointment()  {
        self.view.backgroundColor = .clear
        self.tableView.backgroundColor = .clear
        viewControllerI.tblView.dataSource = self
        viewControllerI.tblView.delegate = self
        viewControllerI.tblView.reloadData()
        
        if viewControllerI.dataFeedingAppointmentModal?.results?.filter({$0.typeERSide == viewControllerI.selectedHorizontal}).count == 0 {
            viewControllerI.tblView.isHidden = true
            viewControllerI.viewZeroState.isHidden = false
            let fontMedium = UIFont(name: "FontMedium".localized(), size: Device.FONTSIZETYPE13)
            viewControllerI.viewZeroState.backgroundColor = ILColor.color(index: 22)
            UILabel.labelUIHandling(label: viewControllerI.lblZeroState, text: "No Appointments available", textColor:ILColor.color(index: 28) , isBold: false, fontType: fontMedium)
            viewControllerI.imageViewZeroState.image = UIImage.init(named: "noAppointment")
        }
        else {
            viewControllerI.tblView.isHidden = false
            viewControllerI.viewZeroState.isHidden = true


        }
    }
    
        
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DashBoardAppointmentTableViewCell", for: indexPath) as! DashBoardAppointmentTableViewCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.delegate = viewControllerI as? DashBoardAppointmentTableViewCellDelegate
        cell.appointmentModal = viewControllerI.dataFeedingAppointmentModal?.results?.filter({$0.typeERSide == viewControllerI.selectedHorizontal})[indexPath.row]
        cell.customize(noAppoinment: false, text: "No cancel")

        return cell
    }
        
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return viewControllerI.dataFeedingAppointmentModal?.results?.filter({$0.typeERSide == viewControllerI.selectedHorizontal}).count ?? 0
        
        

    }
        
        
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewControllerI.redirectAppoinment(openMOdal:  (viewControllerI.dataFeedingAppointmentModal?.results?.filter({$0.typeERSide == viewControllerI.selectedHorizontal})[indexPath.row])!, isFeedback: 2)

    }
    
    
        
        
    override func numberOfSections(in tableView: UITableView) -> Int{
            return 1
        }
        
 
}
