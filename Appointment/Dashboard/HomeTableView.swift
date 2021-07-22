//
//  HomeTableView.swift
//  Appointment
//
//  Created by Anurag Bhakuni on 18/08/20.
//  Copyright © 2020 Anurag Bhakuni. All rights reserved.
//

import UIKit

class HomeTableView: UIViewController, UITableViewDelegate,UITableViewDataSource {
    var viewControllerI : HomeViewController!
    //    var modalEvent : EventModal?
    var totalCount : Int?
    //    var callbackVC: ((_ indePath : BtnInterestedGoing) -> Void)?
    var nocoach = false
    func customization()  {
        
        guard viewControllerI != nil else {
                return
        }
        
        if viewControllerI.dataFeedingModal?.items.count ?? 0 <= 0{
            nocoach = true
        }
        else{
            nocoach = false

        }
        
        
        viewControllerI.tblView.delegate = self
        viewControllerI.tblView.dataSource = self
       
        viewControllerI.tblView.reloadData()
        
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CoachListingTableViewCell", for: indexPath) as! CoachListingTableViewCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.delegate = viewControllerI as? CoachListingTableViewCellDelegate
        if !nocoach{
            cell.coachModal = viewControllerI.dataFeedingModal?.items[indexPath.row]

        }
        cell.customization(noCoach: nocoach, text: "No Coach Found !")
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if nocoach {
            return 1
        }
        else{
            return viewControllerI.dataFeedingModal?.items.count ?? 0
        }
       
        
        
    }
    
 
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
        var coachModalArr = viewControllerI.dataFeedingModal?.items
        var coachModal = viewControllerI.dataFeedingModal?.items[indexPath.row]
        coachModal?.isSelected = true
        coachModalArr!.remove(at: indexPath.row)
        coachModalArr!.insert(coachModal!, at: indexPath.row)
        viewControllerI.dataFeedingModal?.items.removeAll()
        viewControllerI.dataFeedingModal?.items = coachModalArr!
        viewControllerI.redirection(redirectionType: .coachSelection)
    }
    
   
    
    
  
    
}
