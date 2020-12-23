//
//  ERSideMyAppoinmentTableVCViewController.swift
//  Appointment
//
//  Created by Anurag Bhakuni on 20/11/20.
//  Copyright © 2020 Anurag Bhakuni. All rights reserved.
//

import UIKit

class ERSideMyAppoinmentTableVCViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    
    var viewControllerI : ERSideMyAppointmentVC!
    //    var modalEvent : EventModal?
    var totalCount : Int?
    //    var callbackVC: ((_ indePath : BtnInterestedGoing) -> Void)?
    var nocoach = false,noAlumini = false
    
    var dataAppoinmentModal: ERSideAppointmentModal?
    
    
    func customization()  {
        
        guard viewControllerI != nil else {
            return
        }
        viewControllerI.tblView.delegate = self
        viewControllerI.tblView.dataSource = self
        viewControllerI.tblView.reloadData()
        
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ERSideMyAppoinmentTableViewCell", for: indexPath) as! ERSideMyAppoinmentTableViewCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.results = self.dataAppoinmentModal?.results![indexPath.row]
        cell.customize()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataAppoinmentModal?.results?.count ?? 0
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
        //        viewControllerI.redirection(redirectionType: .coachSelection)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath){
        
        
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int{
        if dataAppoinmentModal?.sectionHeaderERMyAppo != nil{
            return dataAppoinmentModal?.sectionHeaderERMyAppo?.count ?? 0
        }
        else{
            return 1;
        }
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if dataAppoinmentModal?.sectionHeaderERMyAppo != nil{
//            let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "ERSideHomeSectionHeader") as! ERSideHomeSectionHeader
//            headerView.objsectionHeaderER = self.dataAppoinmentModal?.sectionHeaderER?[section];
//            headerView.customization()
//            return headerView
        }
        else{
            return nil;
        }
        return nil;
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if dataAppoinmentModal?.sectionHeaderERMyAppo != nil{
            return 35
        }
        else{
            return 0;
        }
       
    }
    
    
}
