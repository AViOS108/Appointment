//
//  ERSideMyAppointmentVC.swift
//  Appointment
//
//  Created by Anurag Bhakuni on 10/11/20.
//  Copyright © 2020 Anurag Bhakuni. All rights reserved.
//

import Foundation

import UIKit


class ERSideMyAppointmentVC: SuperViewController,UISearchBarDelegate {
    
    
    @IBOutlet weak var viewContainorCV: UIView!
    
    @IBOutlet weak var viewCollection: ERSideMyAppointmentCollectionView!
    
    @IBOutlet weak var tblView: UITableView!
    
    var viewModalupcomming : ERHomeViewModal!;
    var viewModalPending : ERHomeViewModal!;
    var viewModalPast : ERHomeViewModal!;
    
    var dataModalupcomming : ERSideAppointmentModal?
    var dataModalPending : ERSideAppointmentModal?
    var dataModalPast : ERSideAppointmentModal?
    
    
    var tablViewHandler = ERSideMyAppoinmentTableVCViewController()
    var refreshControl = UIRefreshControl()
    var selected : Int = 2;

       
      
       
    
    
    
    override func viewDidLoad() {

        viewModalUpcomingCalling()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        viewCollection.backgroundColor = ILColor.color(index: 23)
        viewCollection.delegateI = self
        viewCollection.customize()
        self.view.backgroundColor = ILColor.color(index: 22)
        GeneralUtility.customeNavigationBarERSideMyAppointment(viewController: self,title:"Appointments");
        
        refreshControl.bounds = CGRect.init(x: refreshControl.bounds.origin.x, y: 10, width: refreshControl.bounds.size.width, height: refreshControl.bounds.size.height)
        refreshControl.tintColor = UIColor(red:0.25, green:0.72, blue:0.85, alpha:1.0)
        refreshControl.attributedTitle = NSAttributedString(string: "")
        refreshControl.addTarget(self, action: #selector(refreshControlAPi), for: .valueChanged)
        
        if #available(iOS 10.0, *) {
            tblView.refreshControl?.beginRefreshing()
        } else {
            // Fallback on earlier versions
        }
        tblView.addSubview(refreshControl)
        
    }
    
    
    
    
         @objc func refreshControlAPi(){
            
            if selected == 2{
                self.viewModalUpcomingCalling();
            }
            else if selected == 3{
                self.viewModalPendingCalling();

            }
            else{
                  self.viewModalPastCalling();
            }
            
             
         }
    
    
    
    @objc override func searchEvent(sender: UIBarButtonItem) {
        
        GeneralUtility.customeNavigationBarTextfield(viewController: self, searchText: "");
        
        
    }
    @objc override func logout(sender: UIButton) {
        
    }
    
    func viewModalUpcomingCalling()  {
        viewModalupcomming = ERHomeViewModal()
        viewModalupcomming.viewController = self
        viewModalupcomming.enumType = .ERSideUpcoming
        viewModalupcomming.delegate = self
        viewModalupcomming.custmoziation();
        
    }
    
    func viewModalPastCalling()  {
        viewModalPast = ERHomeViewModal()
        viewModalPast.viewController = self
        viewModalPast.enumType = .ERSidePast
        viewModalPast.delegate = self
        viewModalPast.custmoziation();
        
    }
    func viewModalPendingCalling()  {
        viewModalPending = ERHomeViewModal()
        viewModalPending.viewController = self
        viewModalPending.enumType = .ERSidePending
        viewModalPending.delegate = self
        viewModalPending.custmoziation();
        
    }
    
    func customizationTVHandler(index : Int)  {
        
        tablViewHandler.viewControllerI = self
        tblView.register(UINib.init(nibName: "ERSideMyAppoinmentTableViewCell", bundle: nil), forCellReuseIdentifier: "ERSideMyAppoinmentTableViewCell")

        
        if index == 2{
            
            tablViewHandler.dataAppoinmentModal = self.dataModalupcomming;
            tablViewHandler.customization()
        
        }
        else if index == 3{
            tablViewHandler.dataAppoinmentModal = self.dataModalPending;
                       tablViewHandler.customization()
            
        }
        else{
            tablViewHandler.dataAppoinmentModal = self.dataModalPast;
                       tablViewHandler.customization()

            
        }
        
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        
        if searchBar.text != ""
        {
            
        }
        searchBar.resignFirstResponder();
    }
    
}


extension ERSideMyAppointmentVC:ERHomeViewModalVMDelegate,ERSideMyAppointmentCollectionViewDelegate{
    
    
    
    func selectedHeaderCV(id: Int) {
        if id == 1{
            selected = 2
            if self.dataModalupcomming != nil{
                
                self.customizationTVHandler(index: 2)
                
                
            }
            else{
                self.viewModalUpcomingCalling()
            }
        }
        else if id == 2{
            selected = 3
            if self.dataModalPending != nil{
                self.customizationTVHandler(index: 3)
                
            }
            else{
                self.viewModalPendingCalling()
            }
        }
        else{
            selected = 4
            if self.dataModalPast != nil{
                self.customizationTVHandler(index: 4)
                
            }
            else{
                self.viewModalPastCalling()
            }
        }
    }
    
    
    func sentDataToERHomeVC(dataAppoinmentModal: ERSideAppointmentModal?, success: Bool, index: Int) {
        self.refreshControl.endRefreshing()
        if success {
            if index == 2{
                self.dataModalupcomming = dataAppoinmentModal
            }
            else if index == 3{
                self.dataModalPending = dataAppoinmentModal
            }
            else{
                self.dataModalPast = dataAppoinmentModal
            }
            
            self.customizationTVHandler(index: index)
        }
        else{
            CommonFunctions().showError(title: "Error", message: ErrorMessages.SomethingWentWrong.rawValue)
        }
        
    }
    
    
}
