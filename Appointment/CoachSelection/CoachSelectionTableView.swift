//
//  CoachSelectionTableView.swift
//  Appointment
//
//  Created by Anurag Bhakuni on 04/09/20.
//  Copyright © 2020 Anurag Bhakuni. All rights reserved.
//

import UIKit

class CoachSelectionTableView: UIView, UITableViewDelegate,UITableViewDataSource {
    var tblViewList: UITableView!
    
    var viewControllerI : CoachSelectionViewController!
    var results: [OpenHourCoachModalResult]?
    func  customizeTableView()  {
        tblViewList.register(UINib.init(nibName: "CoachOpenhourTableViewCell", bundle: nil), forCellReuseIdentifier: "CoachOpenhourTableViewCell")

        tblViewList.delegate = self
        tblViewList.dataSource = self
        tblViewList.reloadData()
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CoachOpenhourTableViewCell", for: indexPath) as! CoachOpenhourTableViewCell
        cell.objModal = results![indexPath.row]
        cell.customize()
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if results != nil{
            return results!.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
        self.tblViewList.deselectRow(at: indexPath, animated: false)
        
        let coachConfirmation = CoachConfirmationPopUpFirstViewC.init(nibName: "CoachConfirmationPopUpFirstViewC", bundle: nil)
        coachConfirmation.delegate = viewControllerI as? passDataSecondViewDelegate
        coachConfirmation.dataFeedingModal = viewControllerI.dataFeedingModal
        coachConfirmation.results = self.results?[indexPath.row]
        coachConfirmation.modalPresentationStyle = .overFullScreen
        viewControllerI.present(coachConfirmation, animated: false) {
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath){
        
        
    }
    
    
}
