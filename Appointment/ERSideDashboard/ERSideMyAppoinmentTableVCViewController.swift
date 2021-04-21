//
//  ERSideMyAppoinmentTableVCViewController.swift
//  Appointment
//
//  Created by Anurag Bhakuni on 20/11/20.
//  Copyright © 2020 Anurag Bhakuni. All rights reserved.
//

import UIKit


protocol ERSideMyAppoinmentTableVCViewControllerDelegate {
    func refreshData(index:Int)
}




class ERSideMyAppoinmentTableVCViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    
    var viewControllerI : ERSideMyAppointmentVC!
    //    var modalEvent : EventModal?
    var totalCount : Int?
    //    var callbackVC: ((_ indePath : BtnInterestedGoing) -> Void)?
    var nocoach = false,noAlumini = false
    
    var delegate : ERSideMyAppoinmentTableVCViewControllerDelegate!
    var dataAppoinmentModal: ERSideAppointmentModalNew?
    var isWaiting = false
    
    func customization()  {
                
        guard viewControllerI != nil else {
            return
        }
        isWaiting = false
        viewControllerI.tblView.delegate = self
        viewControllerI.tblView.dataSource = self
        viewControllerI.tblView.reloadData()
//         viewControllerI.tblView.estimatedRowHeight = 1000

        
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ERSideMyAppoinmentTableViewCell", for: indexPath) as! ERSideMyAppoinmentTableViewCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.delegate = (viewControllerI as! ERSideMyAppoinmentTableViewCellDelegate)
        cell.results = self.dataAppoinmentModal?.results![indexPath.row]
        cell.customize()
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataAppoinmentModal?.results?.count ?? 0
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if dataAppoinmentModal?.indexType != 3{
            viewControllerI.changeInFollowingWith(results: (dataAppoinmentModal?.results![indexPath.row])!, index: 1)
        }
    }
    
   
    
    func numberOfSections(in tableView: UITableView) -> Int{
        return 1;
        
    }
    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//
//        if dataAppoinmentModal?.sectionHeaderERMyAppo != nil{
//            let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "ERSideHomeSectionHeader") as! ERSideHomeSectionHeader
//            headerView.objsectionHeaderER = self.dataAppoinmentModal?.sectionHeaderER?[section];
//            headerView.customization()
//            return headerView
//        }
//        else{
//            return nil;
//        }
//        return nil;
//    }
     func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath){
       
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let indexpaths = viewControllerI.tblView.indexPathsForVisibleRows
        if (self.dataAppoinmentModal?.results?.count ?? 0) <= (indexpaths?.last?.row) ?? 0 + 1  && !isWaiting {
            
            if self.dataAppoinmentModal?.total ?? 0 <= (self.dataAppoinmentModal?.results?.count ?? 0){
                
            }
            else{
                isWaiting = true
                self.delegate.refreshData(index: self.dataAppoinmentModal?.indexType ?? 2)
            }
        }
    }
    
    
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        if dataAppoinmentModal?.sectionHeaderERMyAppo != nil{
//            return 35
//        }
//        else{
//            return 0;
//        }
//
//    }
}
