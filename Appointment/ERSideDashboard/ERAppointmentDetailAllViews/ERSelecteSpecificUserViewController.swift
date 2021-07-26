//
//  ERSelecteSpecificUserViewController.swift
//  Appointment
//
//  Created by Anurag Bhakuni on 20/04/21.
//  Copyright © 2021 Anurag Bhakuni. All rights reserved.
//

import UIKit

protocol ERSelecteSpecificUserViewControllerDelegate {
    func sendselectedUser(objERSideNotesSpecificUserModalSelected :ERSideNotesSpecificUserModal)
}


class ERSelecteSpecificUserViewController: SuperViewController {
    
    @IBOutlet weak var viewSearch: UIView!
    var activityIndicator: ActivityIndicatorView?
    
    @IBOutlet weak var btnSelectAll: UIButton!
    
    var delegate : ERSelecteSpecificUserViewControllerDelegate!
    var isAllStudentSelected = false
    
    @IBOutlet weak var lblSelectAll: UILabel!
    @IBOutlet weak var viewSelectAll: UIView!
    var isSearchEnabled = false
    
    
    @IBOutlet weak var txtSearchBar: UISearchBar!
    @IBOutlet weak var tblView: UITableView!
    
    @IBOutlet weak var btnAddStudent: UIButton!
    
    var objERSideNotesSpecificUserModal : ERSideNotesSpecificUserModal!
    var objERSideNotesSpecificUserModalSelected : ERSideNotesSpecificUserModal!
    
    @IBAction func btnAddStudentTapped(_ sender: Any) {
        
        if self.objERSideNotesSpecificUserModalSelected.items?.count ?? 0>0{
            delegate.sendselectedUser(objERSideNotesSpecificUserModalSelected: objERSideNotesSpecificUserModalSelected)
            
            self.navigationController?.popViewController(animated: true);
        }
        else{
            CommonFunctions().showError(title: "", message: "Please select any student")
        }
        
        
    }
    
    @objc override func actnResignKeyboard() {
           txtSearchBar.resignFirstResponder()
           
          }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addInputAccessoryForSearchbar(textVIew: txtSearchBar)
        if self.objERSideNotesSpecificUserModalSelected != nil{
            
        }
        else{
            self.objERSideNotesSpecificUserModalSelected = ERSideNotesSpecificUserModal.init(items: [ERSideNotesSpecificUserModalItem](), total: 0)               }
        
        tblView.register(UINib.init(nibName: "ERSideSpecificUserTableViewCell", bundle: nil), forCellReuseIdentifier: "ERSideSpecificUserTableViewCell")
        btnAddStudent.isHidden = true
        
        if let fontMedium = UIFont(name: "FontMedium".localized(), size: Device.FONTSIZETYPE13)
        {
            UILabel.labelUIHandling(label: lblSelectAll, text: "Select all", textColor:ILColor.color(index: 28) , isBold: false, fontType: fontMedium)
        }
        txtSearchBar.barTintColor = UIColor.clear
        txtSearchBar.backgroundColor = UIColor.clear
        txtSearchBar.isTranslucent = true
        txtSearchBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        
        txtSearchBar.placeholder = "Search Student"
        txtSearchBar.backgroundColor = .clear
        self.customization();
        callViewModal()
        // Do any additional setup after loading the view.
    }
    
    @objc override func buttonClicked(sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func customization()  {
        
        btnSelectAll.setImage(UIImage.init(named: "check_box"), for: .normal);
        
        self.viewSelectAll.borderWithWidth(1, color: ILColor.color(index: 48))
        
        if let selected = self.objERSideNotesSpecificUserModalSelected{
           let selectedCount = selected.items?.count ?? 0
            if selectedCount > 0 {
                GeneralUtility.customeNavigationBarWithBackAndSelectedStudent(viewController: self, title: "Select User", numberStudent: "\(selectedCount)")
            }
            else{
                GeneralUtility.customeNavigationBarWithBackAndSelectedStudent(viewController: self, title: "Select User", numberStudent: "0")
            }
        }
        else{
            GeneralUtility.customeNavigationBarWithBackAndSelectedStudent(viewController: self, title: "Select User", numberStudent: "0")
        }
        let fontHeavy = UIFont(name: "FontHeavy".localized(), size: Device.FONTSIZETYPE16)
        UIButton.buttonUIHandling(button: btnAddStudent, text: "Add", backgroundColor: ILColor.color(index: 23), textColor: .white, cornerRadius: 3, fontType: fontHeavy)
        
        btnAddStudent.isHidden = false
        
        self.tblView.reloadData()
    }
    
    func modalRedefine(){
        
        let arrStudentListView = self.objERSideNotesSpecificUserModal!.items!
        let arrStudentSelectedListView = self.objERSideNotesSpecificUserModalSelected!.items!
        
        _ =    arrStudentListView.filter({
            let item = $0;
            let arrFiltered =  arrStudentSelectedListView.filter({
                $0.id == item.id
            })
            if arrFiltered.count > 0{
                var selectedId = objERSideNotesSpecificUserModal?.items!.filter({$0.id == arrFiltered[0].id})[0]
                selectedId!.isSelected = true
                let index = self.objERSideNotesSpecificUserModal?.items!.firstIndex(where: {$0.id == arrFiltered[0].id}) ?? 0
                self.objERSideNotesSpecificUserModal?.items!.removeAll(where: {$0.id == arrFiltered[0].id})
                self.objERSideNotesSpecificUserModal?.items!.insert(selectedId!, at: index)
                return true
            }
            else{
                return false
            }
        })
        self.allStudentSelectedImage()
    }
    
    func assignTblViewDataSource(){
        self.tblView.delegate = self
        self.tblView.dataSource = self
        tblView.reloadData()
    }
    
    func callViewModal(){
        activityIndicator = ActivityIndicatorView.showActivity(view: self.navigationController!.view, message: StringConstants.FetchingCoachSelection)
        
        let csrftoken = UserDefaultsDataSource(key: "csrf_token").readData() as! String
        let params = ["_method" : "post",
                      "brief":true,
                      ParamName.PARAMFILTERSEL:["keyword":txtSearchBar.text],
                      ParamName.PARAMCSRFTOKEN : csrftoken
            
            ] as [String : AnyObject]
        
        
        ERSideAppointmentService().erSideSpecifcList(params: params,  { (data) in
            self.activityIndicator?.hide()
            
            do {
                self.objERSideNotesSpecificUserModal = try JSONDecoder().decode(ERSideNotesSpecificUserModal    .self, from: data)
                self.modalRedefine();
                self.assignTblViewDataSource()
            } catch  {
                CommonFunctions().showError(title: "Error", message: ErrorMessages.SomethingWentWrong.rawValue)
                
            }
        }) { (error, errorCode) in
            self.activityIndicator?.hide()
        }
        
        
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}


// MARK: TableView,Searchbar DataSource and Delegate.


extension ERSelecteSpecificUserViewController: ERSideSpecificUserTableViewCellDelegate,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate{
    
    
    
    
    func specificUserSelected(items: ERSideNotesSpecificUserModalItem) {
        
        var selectedId = objERSideNotesSpecificUserModal?.items!.filter({$0.id == items.id})[0]
        selectedId!.isSelected = !items.isSelected
        let index = self.objERSideNotesSpecificUserModal?.items!.firstIndex(where: {$0.id == items.id}) ?? 0
        self.objERSideNotesSpecificUserModal?.items!.removeAll(where: {$0.id == items.id})
        self.objERSideNotesSpecificUserModal?.items!.insert(selectedId!, at: index)
        self.allStudentSelectedImage()
        
        
        if !items.isSelected {
            self.objERSideNotesSpecificUserModalSelected.items?.append(items)
        }
        else{
            let index = self.objERSideNotesSpecificUserModalSelected?.items!.firstIndex(where: {$0.id == items.id}) ?? 0
            self.objERSideNotesSpecificUserModalSelected.items?.remove(at: index)
        }
        
        
        GeneralUtility.customeNavigationBarWithBackAndSelectedStudent(viewController: self, title: "Select User", numberStudent: "\(self.objERSideNotesSpecificUserModalSelected.items?.count ?? 0)")
//        delegate.sendselectedUser(objERSideNotesSpecificUserModalSelected: objERSideNotesSpecificUserModalSelected)

        
        self.tblView.reloadData()
    }
    
    
    @IBAction func btnSelectAllTapped(_ sender: Any) {
        
        isAllStudentSelected  = !isAllStudentSelected;
        changeStudentSelectedModal(isSelected: isAllStudentSelected)
        if isAllStudentSelected {
            btnSelectAll.setImage(UIImage.init(named: "Check_box_selected"), for: .normal);
            
        }
        else{
            btnSelectAll.setImage(UIImage.init(named: "check_box"), for: .normal);
        }
        
        if let selected = self.objERSideNotesSpecificUserModalSelected{
                         let selectedCount = selected.items?.count ?? 0
                          if selectedCount > 0 {
                              GeneralUtility.customeNavigationBarWithBackAndSelectedStudent(viewController: self, title: "Select User", numberStudent: "\(selectedCount)")
                          }
                          else{
                              GeneralUtility.customeNavigationBarWithBackAndSelectedStudent(viewController: self, title: "Select User", numberStudent: "0")
                          }
                      }
                      else{
                          GeneralUtility.customeNavigationBarWithBackAndSelectedStudent(viewController: self, title: "Select User", numberStudent: "0")
                      }
        
    }
    
    
    func allStudentSelectedImage(){
        if ((objERSideNotesSpecificUserModal?.items!.filter({$0.isSelected == true}).count) == objERSideNotesSpecificUserModal.items?.count) {
            isAllStudentSelected = true
        }
        else
        {
            isAllStudentSelected = false
        }
        if isAllStudentSelected {
            btnSelectAll.setImage(UIImage.init(named: "Check_box_selected"), for: .normal);
            
        }
        else{
            btnSelectAll.setImage(UIImage.init(named: "check_box"), for: .normal);
        }
     

    }
    
    func changeStudentSelectedModal(isSelected : Bool){
        
//        GeneralUtility.customeNavigationBarWithBackAndSelectedStudent(viewController: self, title: "Select Candidates", numberStudent: "0")
        
        let arrStudentListView = self.objERSideNotesSpecificUserModal!.items!
               let arrStudentSelectedListView = self.objERSideNotesSpecificUserModalSelected!.items!
               _ =    arrStudentListView.filter({
                   let item = $0;
                   let arrFiltered =  arrStudentSelectedListView.filter({
                       $0.id == item.id
                   })
                   if arrFiltered.count > 0{
                       
                       var selectedId = objERSideNotesSpecificUserModal?.items!.filter({$0.id == arrFiltered[0].id})[0]
                       selectedId!.isSelected = false
                       let index = self.objERSideNotesSpecificUserModal?.items!.firstIndex(where: {$0.id == arrFiltered[0].id}) ?? 0
                       self.objERSideNotesSpecificUserModal?.items!.removeAll(where: {$0.id == arrFiltered[0].id})
                       self.objERSideNotesSpecificUserModal?.items!.insert(selectedId!, at: index)
                       
                       self.objERSideNotesSpecificUserModalSelected?.items!.removeAll(where: {$0.id == arrFiltered[0].id})
                       return true
                   }
                   else{
                       return false
                   }
               })
               
               if isSelected{
                   let arrStudentListView = self.objERSideNotesSpecificUserModal!.items!
                   var index = 0
                   for var objStudentDetailModalItem in arrStudentListView{
                       self.objERSideNotesSpecificUserModalSelected?.items?.append(objStudentDetailModalItem)
                       objStudentDetailModalItem.isSelected = true
                       self.objERSideNotesSpecificUserModal?.items?.remove(at: index);
                       self.objERSideNotesSpecificUserModal?.items?.insert(objStudentDetailModalItem, at: index)
                       index = index + 1;
                   }
               }
          
        self.tblView.reloadData()
        
    }
    
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        
        if searchBar.text != ""
        {
            callViewModal()
            searchBar.resignFirstResponder();
            
        }
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            callViewModal()
             searchBar.resignFirstResponder();
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ERSideSpecificUserTableViewCell", for: indexPath) as! ERSideSpecificUserTableViewCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.items = self.objERSideNotesSpecificUserModal?.items?[indexPath.row]
        cell.delegateI = self
        cell.customization()
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  self.objERSideNotesSpecificUserModal?.items?.count ?? 0
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
        
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
