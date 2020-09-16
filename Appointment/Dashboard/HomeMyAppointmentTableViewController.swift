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
        viewControllerI.tblView.dataSource = self
        viewControllerI.tblView.delegate = self
        viewControllerI.tblView.reloadData()
    }
    
    
    
    
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    
}
