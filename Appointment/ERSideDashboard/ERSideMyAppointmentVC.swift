//
//  ERSideMyAppointmentVC.swift
//  Appointment
//
//  Created by Anurag Bhakuni on 10/11/20.
//  Copyright © 2020 Anurag Bhakuni. All rights reserved.
//

import Foundation

import UIKit
enum indexSelectedEnum {
    case Detail
    case Cancel
    case Accept
    case Decline
    case UpDateStatus
    case viewResume
}


class ERSideMyAppointmentVC: SuperViewController,UISearchBarDelegate,ERFilterViewControllerDelegate,
ERSideMyAppoinmentTableViewCellDelegate{
   
    
   
    
    

    var indexSelected : indexSelectedEnum!;
    
    var objERFilterTag : [ERFilterTag]?
    var filterAdded = Dictionary<String,Any>()
    @IBOutlet weak var txtSearchBar: UISearchBar!
    @IBOutlet weak var btnFilter: UIButton!
    
    var selectedResult : ERSideAppointmentModalNewResult!
    
    
    @IBOutlet weak var viewContainorCV: UIView!
    
    @IBOutlet weak var viewCollection: ERSideMyAppointmentCollectionView!
    
    @IBOutlet weak var tblView: UITableView!
    
    var viewModalupcomming : ERHomeViewModal!;
    var viewModalPending : ERHomeViewModal!;
    var viewModalPast : ERHomeViewModal!;
    
    var dataModalupcomming : ERSideAppointmentModalNew?
    var dataModalPending : ERSideAppointmentModalNew?
    var dataModalPast : ERSideAppointmentModalNew?
    
    var tablViewHandler = ERSideMyAppoinmentTableVCViewController()
    var refreshControl = UIRefreshControl()
    var selected : Int = 2;

       
    @IBOutlet weak var lblNoAppointmentFound: UILabel!
    
    
    override func viewDidLoad() {
        
        viewModalUpcomingCalling()
        
        txtSearchBar.barTintColor = UIColor.clear
        txtSearchBar.backgroundColor = UIColor.clear
        txtSearchBar.isTranslucent = true
        txtSearchBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        txtSearchBar.placeholder = "Search Appoinments"
        txtSearchBar.backgroundColor = .clear
        
    }
    override func viewWillDisappear(_ animated: Bool) {
                self.hidesBottomBarWhenPushed = true;

    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.hidesBottomBarWhenPushed = false;

        viewCollection.backgroundColor = ILColor.color(index: 23)
        viewCollection.delegateI = self
        viewCollection.customize()
        self.view.backgroundColor = ILColor.color(index: 22)
        GeneralUtility.customeNavigationBarERSideMyAppointment(viewController: self,title:"Appointments");
        
        btnFilter.setImage(UIImage.init(named: "noun_filter_"), for: .normal);

        
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
            callViewModal()
             
         }
    
    
    
    @objc override func searchEvent(sender: UIBarButtonItem) {
        
        GeneralUtility.customeNavigationBarTextfield(viewController: self, searchText: "");
        
        
    }
    @objc override func logout(sender: UIButton) {
        
    }
    
    func viewModalUpcomingCalling()  {
        viewModalupcomming = ERHomeViewModal()
        viewModalupcomming.viewController = self
        if dataModalupcomming != nil{
            viewModalupcomming.skip = dataModalupcomming?.results?.count ?? 0
        }
        if !self.filterAdded.isEmpty{
            viewModalupcomming.filterAdded = self.filterAdded
        }
        viewModalupcomming.enumType = .ERSideUpcoming
        viewModalupcomming.delegate = self
        viewModalupcomming.custmoziation();
        
    }
    
    func viewModalPastCalling()  {
        viewModalPast = ERHomeViewModal()
        viewModalPast.viewController = self
        if dataModalPast != nil{
            viewModalPast.skip = dataModalPast?.results?.count ?? 0
        }
        if !self.filterAdded.isEmpty{
            viewModalPast.filterAdded = self.filterAdded
        }
        viewModalPast.enumType = .ERSidePast
        viewModalPast.delegate = self
        viewModalPast.custmoziation();
        
    }
    func viewModalPendingCalling()  {
        viewModalPending = ERHomeViewModal()
        viewModalPending.viewController = self
        if dataModalPending != nil{
                   viewModalPending.skip = dataModalPending?.results?.count ?? 0
               }
        if !self.filterAdded.isEmpty{
            viewModalPending.filterAdded = self.filterAdded
        }
        viewModalPending.enumType = .ERSidePending
        viewModalPending.delegate = self
        viewModalPending.custmoziation();
        
    }
    
    func customizationTVHandler(index : Int)  {
        
        tablViewHandler.viewControllerI = self
        tablViewHandler.delegate = self
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
    
    
}

//Mark : Clickable logics


extension ERSideMyAppointmentVC : ERCancelViewControllerDelegate {
    func refreshTableView() {
        self.resetDataModal()
        self.callViewModal()
    }
    
    func detailCustomize(){
        
        let objERAppointmentDetailViewController = ERAppointmentDetailViewController.init(nibName: "ERAppointmentDetailViewController", bundle: nil)
        objERAppointmentDetailViewController.selectedResult =  self.selectedResult;
        objERAppointmentDetailViewController.index = selected
        
        self.navigationController?.pushViewController(objERAppointmentDetailViewController, animated: false)
        
    }
    
    func acceptCustomize(){
        
        let params = [
            "_method" : "patch",
            "csrf_token" : UserDefaultsDataSource(key: "csrf_token").readData() as! String
            ] as Dictionary<String,AnyObject>
        
        var activityIndicator = ActivityIndicatorView.showActivity(view: self.view, message: StringConstants.AcceptOpenHour)
        ERSideAppointmentService().erSideAppointemntAccept(params: params, id: String(describing: selectedResult.id ?? 0) , { (jsonData) in
            activityIndicator.hide()
            
            GeneralUtility.alertView(title: "", message: "Accepted".localized(), viewController: self, buttons: ["Ok"]);
            self.resetDataModal()
            self.callViewModal()
            
        }) { (error, errorCode) in
            activityIndicator.hide()
            
        }
        
        
    }
    func declineCustomize(){
        let objERCancelViewController = ERCancelViewController.init(nibName: "ERCancelViewController", bundle: nil)
        objERCancelViewController.modalPresentationStyle = .overFullScreen
        objERCancelViewController.results = self.selectedResult
        objERCancelViewController.viewType = .decline
        objERCancelViewController.delegate = self
        self.navigationController?.pushViewController(objERCancelViewController, animated: false)
        
    }
    
    func cancelCustomize(){
        
        let objERCancelViewController = ERCancelViewController.init(nibName: "ERCancelViewController", bundle: nil)
        objERCancelViewController.modalPresentationStyle = .overFullScreen
        objERCancelViewController.results = self.selectedResult
        objERCancelViewController.viewType = .cancel
        objERCancelViewController.delegate = self
        self.navigationController?.pushViewController(objERCancelViewController, animated: false)
        
        
    }
    func UpDateStatusCustomize(){
        let objERUpdateAppoinmentViewController = ERUpdateAppoinmentViewController.init(nibName: "ERUpdateAppoinmentViewController", bundle: nil)
        objERUpdateAppoinmentViewController.results = self.selectedResult
        objERUpdateAppoinmentViewController.delegate = self
        self.navigationController?.pushViewController(objERUpdateAppoinmentViewController, animated: false)
    }
    
    func viewResume()  {
        
        let objERSideResumeListViewController = ERSideResumeListViewController.init(nibName: "ERSideResumeListViewController", bundle: nil)
        objERSideResumeListViewController.modalPresentationStyle = .overFullScreen
        objERSideResumeListViewController.results = self.selectedResult
        self.navigationController?.pushViewController(objERSideResumeListViewController, animated: false)
        
    }
   
    
    func changeInFollowingWith(results: ERSideAppointmentModalNewResult, index: Int?) {
        
        selectedResult = results
        
        if index == 1{
            indexSelected = .Detail
        }
        else if index == 2{
            indexSelected = .Cancel
            
        }
        else if index == 3{
            indexSelected = .Accept
            
            
        }
        else if index == 4{
            indexSelected = .Decline
            
        }
        else if index == 5{
            indexSelected = .UpDateStatus
        }
        else if index == 6 {
            indexSelected = .viewResume
        }
        
        switch indexSelected {
        case .Detail:
            self.detailCustomize()
            break;
        case .Accept:
            self.acceptCustomize()
            break;
        case .Decline:
            self.declineCustomize()
            break;
        case .Cancel:
            self.cancelCustomize()
            break;
        case .UpDateStatus:
            self.UpDateStatusCustomize()
            break;
        case .viewResume:
            self.viewResume()
            break;
            
        default:
            break;
        }
    }
    
    
}


  
   



//Mark : FILTER LOGIC AND SEARCH


extension ERSideMyAppointmentVC {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
       
        if searchBar.tag == 10001 {
            
            if searchBar.text != ""
            {
                if selected == 2{
                }
                else if selected == 3{
                }
                else{
                }
            }
        }
        searchBar.resignFirstResponder();
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.tag == 10001 {
            
            if searchText == "" {
                if selected == 2{
                }
                else if selected == 3{
                }
                else{
                }
                tblView.reloadData()
                searchBar.resignFirstResponder();
            }

        }
        
    }
    
    func resetFilterAndSearchtext(){
        txtSearchBar.text = ""
        filterAdded = Dictionary<String,AnyObject>()
        
    }
    
    
    func makeFilterModal(){
        
        var benchMark = Array<Int>()
        var tag =  Dictionary<String,Array<String>>()
        for objERFlter in self.objERFilterTag!{
            if objERFlter.id == -999{
                let selectedBenchMarkArr =  objERFlter.objTagValue?.filter({ $0.isSelected == true
                })
                if (selectedBenchMarkArr?.count ?? 0) > 0{
                    for selectedBench in selectedBenchMarkArr!{
                        benchMark.append(selectedBench.eRFilterid!)
                    }
                }
            }
            else{
                let selectedTagArr =    objERFlter.objTagValue?.filter({$0.isSelected == true})
                if (selectedTagArr?.count ?? 0) > 0 {
                    var tagSelected = [String]()
                    for selectedTag in selectedTagArr!{
                        tagSelected.append(selectedTag.tagValueText!)
                    }
                   
                    tag[objERFlter.category!] = tagSelected
                }
            }
        }
        if benchMark.count > 0 {
            filterAdded["benchmark"] = benchMark as Any
        }
        if !tag.isEmpty {
            filterAdded["tag"] = tag as Any
        }
        if txtSearchBar.text?.isEmpty ?? true{
            
        }
        else{
            filterAdded["name_email"] = txtSearchBar.text as AnyObject?
        }
        
        if benchMark.count == 0 && tag.isEmpty && (txtSearchBar.text?.isEmpty ?? true) {
            filterAdded = Dictionary<String,AnyObject>()
        }
        
    }
    
   
    
    func callViewModal(){
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
    
    func resetDataModal(){
        
        dataModalPending = nil
        dataModalPast = nil
        dataModalupcomming = nil
    }
    
    
    func passFilter(selectedFilter: [ERFilterTag]?) {
        resetDataModal()
        self.objERFilterTag = selectedFilter;
        makeFilterModal()
        callViewModal()
    }
    
    
    @IBAction func btnFilterTapped(_ sender: Any) {
        
        let objERFilterViewController = ERFilterViewController.init(nibName: "ERFilterViewController", bundle: nil)
        objERFilterViewController.modalPresentationStyle = .overFullScreen
        objERFilterViewController.objERFilterTag = self.objERFilterTag
        objERFilterViewController.delegate = self
        self.navigationController?.pushViewController(objERFilterViewController, animated: false)
      
    }
    
}



extension ERSideMyAppointmentVC:ERHomeViewModalVMDelegate,ERSideMyAppointmentCollectionViewDelegate,ERSideMyAppoinmentTableVCViewControllerDelegate,ERUpdateAppoinmentViewControllerDelegate{
    func refreshData(index: Int) {
                    callViewModal()
    }
    
    func selectedHeaderCV(id: Int) {
        
        filterAdded = Dictionary<String,AnyObject>()
        objERFilterTag =  nil
        if id == 1{
            selected = 2
            if self.dataModalupcomming != nil{
                self.customizationTVHandler(index: 2)
                if dataModalupcomming?.total ?? 0 <= 0{
                    
                    self.tblView.isHidden = true
                    lblNoAppointmentFound.isHidden = false
                }
                else{
                    self.tblView.isHidden = false
                    lblNoAppointmentFound.isHidden = true
                    
                    
                }
                
                if let fontHeavy = UIFont(name: "FontHeavy".localized(), size: Device.FONTSIZETYPE18)
                {
                    UILabel.labelUIHandling(label: lblNoAppointmentFound, text: "No upcoming meetings to show", textColor:ILColor.color(index: 28) , isBold: false, fontType: fontHeavy)
                }
            }
            else{
                self.viewModalUpcomingCalling()
            }
        }
        else if id == 2{
            selected = 3
            if self.dataModalPending != nil{
                self.customizationTVHandler(index: 3)
                if dataModalPending?.total ?? 0 <= 0{
                    self.tblView.isHidden = true
                    lblNoAppointmentFound.isHidden = false
                }
                else{
                    self.tblView.isHidden = false
                    lblNoAppointmentFound.isHidden = true
                }
                
                if let fontHeavy = UIFont(name: "FontHeavy".localized(), size: Device.FONTSIZETYPE18)
                {
                    UILabel.labelUIHandling(label: lblNoAppointmentFound, text: "No pending request to show", textColor:ILColor.color(index: 28) , isBold: false, fontType: fontHeavy)
                }
            }
            else{
                self.viewModalPendingCalling()
            }
        }
        else{
            selected = 4
            if self.dataModalPast != nil{
                self.customizationTVHandler(index: 4)
                
                if dataModalPast?.total ?? 0 <= 0{
                    
                    self.tblView.isHidden = true
                    lblNoAppointmentFound.isHidden = false
                }
                else{
                    self.tblView.isHidden = false
                    lblNoAppointmentFound.isHidden = true
                }
                if let fontHeavy = UIFont(name: "FontHeavy".localized(), size: Device.FONTSIZETYPE18)
                {
                    UILabel.labelUIHandling(label: lblNoAppointmentFound, text: "No past meetings to show", textColor:ILColor.color(index: 28) , isBold: false, fontType: fontHeavy)
                }
            }
            else{
                self.viewModalPastCalling()
            }
        }
    }
    
    
    func changeModal(dataAppoinmentModal : ERSideAppointmentModalNew,index: Int) -> ERSideAppointmentModalNew{
        
        var objdataAppoinmentModal = dataAppoinmentModal
        var results = [ERSideAppointmentModalNewResult]()

        for var resultDataAppoinmentModal in objdataAppoinmentModal.results!{
            
            
            resultDataAppoinmentModal.typeERSide = index
            results.append(resultDataAppoinmentModal)
        }
        
        objdataAppoinmentModal.results?.removeAll()
        objdataAppoinmentModal.results?.append(contentsOf: results)
        
        return objdataAppoinmentModal
        
    }
    
    
    
    
    func sentDataToERHomeVC(dataAppoinmentModal: ERSideAppointmentModalNew?, success: Bool, index: Int) {
        self.refreshControl.endRefreshing()
        if dataAppoinmentModal?.total ?? 0 <= 0{
            self.tblView.isHidden = true
            lblNoAppointmentFound.isHidden = false
        }
        else{
            self.tblView.isHidden = false
            lblNoAppointmentFound.isHidden = true
        }
        
        if success {
            var dataAppoinmentModal = dataAppoinmentModal;
            dataAppoinmentModal =    self.changeModal(dataAppoinmentModal: dataAppoinmentModal!, index: index)
            if index == 2{
               
                if self.dataModalupcomming != nil{
                    self.dataModalupcomming?.results?.append(contentsOf: (dataAppoinmentModal?.results)!);
                }
                else{
                    self.dataModalupcomming = dataAppoinmentModal
                    self.dataModalupcomming?.indexType = index
                    
                    if let fontHeavy = UIFont(name: "FontHeavy".localized(), size: Device.FONTSIZETYPE18)
                           {
                               UILabel.labelUIHandling(label: lblNoAppointmentFound, text: "No upcoming meetings to show", textColor:ILColor.color(index: 28) , isBold: false, fontType: fontHeavy)
                    }
                }
            }
            else if index == 3{
                if self.dataModalPending != nil{
                    self.dataModalPending?.results?.append(contentsOf: (dataAppoinmentModal?.results)!);
                }
                else{
                    self.dataModalPending = dataAppoinmentModal
                    self.dataModalPending?.indexType = index

                    if let fontHeavy = UIFont(name: "FontHeavy".localized(), size: Device.FONTSIZETYPE18)
                    {
                        UILabel.labelUIHandling(label: lblNoAppointmentFound, text: "No pending request to show", textColor:ILColor.color(index: 28) , isBold: false, fontType: fontHeavy)
                    }
                    
                }
                
            }
            else{
                if self.dataModalPast != nil{
                    self.dataModalPast?.results?.append(contentsOf: (dataAppoinmentModal?.results)!);
                }
                else{
                    self.dataModalPast?.indexType = index
                    self.dataModalPast = dataAppoinmentModal
                    if let fontHeavy = UIFont(name: "FontHeavy".localized(), size: Device.FONTSIZETYPE18)
                    {
                        UILabel.labelUIHandling(label: lblNoAppointmentFound, text: "No past meetings to show", textColor:ILColor.color(index: 28) , isBold: false, fontType: fontHeavy)
                    }
                }
            }
            self.customizationTVHandler(index: index)
        }
        else{
            CommonFunctions().showError(title: "Error", message: ErrorMessages.SomethingWentWrong.rawValue)
        }
    }
}
