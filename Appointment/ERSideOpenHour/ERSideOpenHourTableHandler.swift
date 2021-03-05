//
//  ERSideOpenHourTableHandler.swift
//  Appointment
//
//  Created by Anurag Bhakuni on 26/11/20.
//  Copyright © 2020 Anurag Bhakuni. All rights reserved.
//

import UIKit

class ERSideOpenHourTableHandler: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var dateSelected : Date!

    var viewControllerI : ERSideOpenHourListVC!
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ErSideOpenHourTC", for: indexPath) as! ErSideOpenHourTC
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.viewController = self.viewControllerI
        cell.delegate = self.viewControllerI
        cell.results = self.dataAppoinmentModal?.results![indexPath.row]
        cell.customize()
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataAppoinmentModal?.results?.count ?? 0
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let erSideOHDetail = ERSideOHDetailViewController.init(nibName: "ERSideOHDetailViewController", bundle: nil)
        erSideOHDetail.identifier = self.dataAppoinmentModal?.results![indexPath.row].identifier
        erSideOHDetail.viewControllerType = 1
        erSideOHDetail.viewControllerI = viewControllerI
        erSideOHDetail.modalPresentationStyle = .overFullScreen
        erSideOHDetail.dateSelected = self.dateSelected
        viewControllerI.navigationController?.pushViewController(erSideOHDetail, animated: false)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath){
        
        
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int{
       
            return 1;
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
  
        return nil;
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            return 0;
       
    }
    
    
}
