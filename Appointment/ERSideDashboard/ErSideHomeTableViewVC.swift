//
//  ErSideHomeTableViewVC.swift
//  Appointment
//
//  Created by Anurag Bhakuni on 13/11/20.
//  Copyright © 2020 Anurag Bhakuni. All rights reserved.
//

import UIKit

class ErSideHomeTableViewVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
   
    
    var viewControllerI : ERSideHomeViewController!
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ERSideAppointmentTableViewCell", for: indexPath) as! ERSideAppointmentTableViewCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        
        let appoinment = self.customizationModalBool(section: indexPath.section);
        
        if appoinment{
            cell.objERSideAppointmentModalResult = self.customizationModal(section: indexPath.section)![indexPath.row]
              cell.customization(isAppoinment: appoinment)
        }
        else{
              cell.customization(isAppoinment: appoinment)
        }
        
        if indexPath.section == 0
        {
        }
        else{
            
            
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return 1
    }
    
    
//    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableView.automaticDimension
//    }
    
    
    
    
    func customizationModal(section : Int) -> [ERSideAppointmentModalResult]?{
        
        return   self.dataAppoinmentModal?.results?.filter({
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let str = $0.startDatetimeUTC
            let date = dateFormatter.date(from: str!)
            
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let resultString = dateFormatter.string(from: date!)
            return dateFormatter.date(from: resultString) == (self.dataAppoinmentModal?.sectionHeaderER![section].date)!
            
        })
        
    }
    
    
    
    func customizationModalBool(section : Int) -> Bool{
           
        let arrAppointment =  self.dataAppoinmentModal?.results?.filter({
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let str = $0.startDatetimeUTC
            let date = dateFormatter.date(from: str!)
            
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let resultString = dateFormatter.string(from: date!)
            
            
            return dateFormatter.date(from: resultString) == (self.dataAppoinmentModal?.sectionHeaderER![section].date)!
            
        })
        
        if let arr = arrAppointment{
            if arr.count != 0{
                return true
            }
            
        }
           return false
           
       }
    
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
//        viewControllerI.redirection(redirectionType: .coachSelection)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath){
        
        
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int{
        return dataAppoinmentModal?.sectionHeaderER?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "ERSideHomeSectionHeader") as! ERSideHomeSectionHeader
        headerView.objsectionHeaderER = self.dataAppoinmentModal?.sectionHeaderER?[section];
        headerView.customization()
        return headerView
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35
    }
    
    
}
