//
//  ERSideStudentListViewController.swift
//  Appointment
//
//  Created by Anurag Bhakuni on 15/12/20.
//  Copyright © 2020 Anurag Bhakuni. All rights reserved.
//

import UIKit


enum StudentListType{
    
    case groupType
    case One2OneType
    
}


protocol ERSideStudentListViewControllerDelegate{
    
    func selectedStudentPrivateHour(objStudentDetailModalSelected : StudentDetailModal)
}


class ERSideStudentListViewController: SuperViewController,UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource,ERFilterViewControllerDelegate {
    
    @IBOutlet weak var lblNoStudent: UILabel!
    
    override   func selectedStudentPrivateHour(sender: UIButton) {
        
    }
    
    var objStudentListType : StudentListType!
    var delegate : ERSideStudentListViewControllerDelegate!
    var objERFilterTag : [ERFilterTag]?
    @IBOutlet weak var viewSearch: UIView!
    
    @IBOutlet weak var viewSelection: UIView!
    @IBOutlet weak var btnSelectAll: UIButton!
    
    var isAllStudentSelected = false
    
    @IBOutlet weak var lblSelectAll: UILabel!
    
    @IBOutlet weak var lblStudentNumber: UILabel!
    
    @IBOutlet weak var btnStudentListPrev: UIButton!
    
    @IBOutlet weak var btnStudentListNext: UIButton!
    var filterAdded = Dictionary<String,Any>()
    
    var offset = 0 ;
    var activityIndicator: ActivityIndicatorView?
    
    @IBOutlet weak var txtSearchBar: UISearchBar!
    
    @IBOutlet weak var btnFilter: UIButton!
    
    @IBAction func btnFilterTapped(_ sender: Any) {
        
        
        let isStudent = UserDefaultsDataSource(key: "student").readData() as? Bool
        if isStudent ?? false {
            let objERFilterViewController = ERFilterViewController.init(nibName: "ERFilterViewController", bundle: nil)
            objERFilterViewController.objERFilterTag = self.objERFilterTag
            objERFilterViewController.delegate = self
            objERFilterViewController.objFilterTypeView = .Student
            
            self.navigationController?.pushViewController(objERFilterViewController, animated: false)
            
        }
        else
        {
            let objERFilterViewController = ERFilterViewController.init(nibName: "ERFilterViewController", bundle: nil)
            objERFilterViewController.objERFilterTag = self.objERFilterTag
            objERFilterViewController.delegate = self
            objERFilterViewController.objFilterTypeView = .ER
            self.navigationController?.pushViewController(objERFilterViewController, animated: false)
        }
    }
    
    var objStudentDetailModalSelected : StudentDetailModal?
    var objStudentDetailModal : StudentDetailModal?
    var objStudentDetailModalCopy : StudentDetailModal?

    var isSearchEnabled = false
    @IBOutlet weak var tblView: UITableView!
    
    @IBOutlet weak var btnAddStudent: UIButton!
    
    @IBAction func btnAddStudentTapped(_ sender: Any) {
        
        if self.objStudentDetailModalSelected != nil && self.objStudentDetailModalSelected?.items?.count ?? 0 > 0{
            
            delegate.selectedStudentPrivateHour(objStudentDetailModalSelected: self.objStudentDetailModalSelected!)
            
            self.navigationController?.popViewController(animated: true)
            
            
        }
        else{
            
            let isStudent = UserDefaultsDataSource(key: "student").readData() as? Bool
            if isStudent ?? false{

                CommonFunctions().showError(title: "", message: "Please select atleast one Community Member")

                txtSearchBar.placeholder = "Select Community Member"

            }
            else{
                CommonFunctions().showError(title: "", message: "Please select atleast one student")

            }
           
            
        }
        
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblView.register(UINib.init(nibName: "ERSideStudentListTableViewCell", bundle: nil), forCellReuseIdentifier: "ERSideStudentListTableViewCell")
        btnAddStudent.isHidden = true
        
        txtSearchBar.barTintColor = UIColor.clear
        txtSearchBar.backgroundColor = UIColor.clear
        txtSearchBar.isTranslucent = true
        txtSearchBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        txtSearchBar.backgroundColor = .clear
        
        self.viewSearch.isHidden = true
        self.tblView.isHidden = true
        self.viewSelection.isHidden = true
        
       
        txtSearchBar.backgroundColor = .clear
        
        if self.objStudentDetailModalSelected != nil{
            
        }
        else{
            self.objStudentDetailModalSelected = StudentDetailModal.init(total: 0, items: [StudentDetailModalItem]())
        }
        self.customization();
        self.modalRedefine()
        
        
        let isStudent = UserDefaultsDataSource(key: "student").readData() as? Bool
        if isStudent ?? false{

            lblStudentNumber.isHidden = true
            btnStudentListNext.isHidden = true
            btnStudentListPrev.isHidden = true
            txtSearchBar.placeholder = "Select Community Member"

        }
        else{
            txtSearchBar.placeholder = "Search Student"

        }
       

        // Do any additional setup after loading the view.
    }
    
    
    
    @IBAction func btnStudentListPrevTapped(_ sender: Any) {
        offset = offset - 20;
        self.callViewModal();
        btnEnableDisable()
        
    }
    @IBAction func btnStudentListNextTapped(_ sender: Any) {
        
        offset = offset + 20;
        self.callViewModal();
        btnEnableDisable()
        
    }
    
    
    func callingViewModal(isbackGroundHit : Bool)  {
        
        let csrftoken = UserDefaultsDataSource(key: "csrf_token").readData() as! String

        var param = [ ParamName.PARAMCSRFTOKEN : csrftoken] as [String : AnyObject]
        if filterAdded.isEmpty{
            
        }
        else{
            param["filters"] = self.filterAdded as AnyObject
        }
        
        var dashBoardViewModal = DashBoardViewModel()
        dashBoardViewModal.viewController = self
        dashBoardViewModal.isbackGroundHit = isbackGroundHit
        dashBoardViewModal.fetchCall(params: param,success: { (dashboardModel) in
            self.objStudentDetailModal =   self.modelMapping(objdataFeedingModal: dashboardModel)
            self.objStudentDetailModalSelected =  self.modelMappingSelected(objStudentDetailModal:  self.objStudentDetailModal!)
            
            self.customization()
            self.modalRedefine()


            
        }) { (error, errorCode) in
            
        }
    }
    
    
    func modelMappingSelected(objStudentDetailModal : StudentDetailModal) -> StudentDetailModal{
    
        var studentDetailModalI = objStudentDetailModal;
        studentDetailModalI.items = objStudentDetailModal.items?.filter({$0.isSelected == true})
        return studentDetailModalI
    }
    
    func modelMapping(objdataFeedingModal : DashBoardModel) -> StudentDetailModal{
        
        var objStudentDetailModal = StudentDetailModal()
        objStudentDetailModal.total = objdataFeedingModal.count
        var itemsArr =  [StudentDetailModalItem]()

        for items in objdataFeedingModal.items{
            
            var roles = ""
            var index = 0
            for role in items.roles{
                roles.append(role.displayName ?? "")
                index = index + 1;
                if items.roles.count > 1{
                    if index == items.roles.count{
                    }
                    else{
                        roles.append(", ")
                    }
                }
            }
            var objStudentDetailModalItem = StudentDetailModalItem.init(id: items.id, firstName: items.name, lastName: "", email: nil, invitationID:nil, benchmark: Benchmark.init(name: roles, id: 1), tags: nil)
            objStudentDetailModalItem.isSelected = items.isSelected;
            itemsArr.append(objStudentDetailModalItem)
        }
        objStudentDetailModal.items = itemsArr
        
        return objStudentDetailModal
    }
    
    func callViewModal()  {
        
        let arrayInclude = ["invitation_id","benchmark","tags"]
        
        var param = [ "_method" : "post",
                      "offset" : offset,
                      "limit" : 20,
                      "includes" : arrayInclude,
                      "csrf_token" : UserDefaultsDataSource(key: "csrf_token").readData() as! String
        ] as [String : AnyObject]
        if filterAdded.isEmpty{
            
        }
        else{
            param["filters"] = filterAdded as AnyObject
        }
        
        activityIndicator = ActivityIndicatorView.showActivity(view: self.view, message: StringConstants.FetchingCoachSelection)
        ERSideStudentListViewModal().fetchStudentList(prameter:param  , { (data) in
            self.activityIndicator?.hide()
            do {
                self.activityIndicator?.hide()
                self.objStudentDetailModal = try
                JSONDecoder().decode(StudentDetailModal.self, from: data)
                
                self.customization();
                self.modalRedefine()
            } catch   {
                print(error)
                self.activityIndicator?.hide()
                
            }
        }) { (error, errorCode) in
            self.activityIndicator?.hide()
        }
    }
    
    
    
    func modalRedefine(){
        
        let arrStudentListView = self.objStudentDetailModal!.items!
        let arrStudentSelectedListView = self.objStudentDetailModalSelected!.items!
        
        _ =    arrStudentListView.filter({
            let item = $0;
            let arrFiltered =  arrStudentSelectedListView.filter({
                $0.id == item.id
            })
            if arrFiltered.count > 0{
                var selectedId = objStudentDetailModal?.items!.filter({$0.id == arrFiltered[0].id})[0]
                selectedId!.isSelected = true
                let index = self.objStudentDetailModal?.items!.firstIndex(where: {$0.id == arrFiltered[0].id}) ?? 0
                self.objStudentDetailModal?.items!.removeAll(where: {$0.id == arrFiltered[0].id})
                self.objStudentDetailModal?.items!.insert(selectedId!, at: index)
                return true
            }
            else{
                return false
            }
        })
        
        self.allStudentSelectedImage()
        
        self.objStudentDetailModalCopy = self.objStudentDetailModal
        
    }
    
    
    
    @objc override func buttonClicked(sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
        
        
    }
    
    
    
    
    
    func customization()  {
        self.viewSearch.isHidden = false
        
        if self.objStudentDetailModal?.items?.count ?? 0 > 0{
            self.tblView.isHidden = false
            self.lblNoStudent.isHidden = true
            
        }
        else{
            self.lblNoStudent.isHidden = false
            self.tblView.isHidden = true
            let fontHeavy1 = UIFont(name: "FontHeavy".localized(), size: Device.FONTSIZETYPE15)
            UILabel.labelUIHandling(label: lblNoStudent, text: "No Student found", textColor:ILColor.color(index: 28) , isBold: false, fontType: fontHeavy1)
        }
        
        self.viewSelection.isHidden = false
        
        btnSelectAll.setImage(UIImage.init(named: "check_box"), for: .normal);
        btnFilter.setImage(UIImage.init(named: "noun_filter_"), for: .normal);
        
        btnStudentListNext.setImage(UIImage.init(named: "forward"), for: .normal);
        btnStudentListPrev.setImage(UIImage.init(named: "back_dark"), for: .normal);
        
        self.viewSelection.borderWithWidth(1, color: ILColor.color(index: 48))
        let isStudent = UserDefaultsDataSource(key: "student").readData() as? Bool
        if isStudent ?? false{
            GeneralUtility.customeNavigationBarWithBackAndSelectedStudent(viewController: self, title: "Select Community Member", numberStudent: "\((self.objStudentDetailModalSelected?.items?.count) ?? 0)")

        }
        else{
            GeneralUtility.customeNavigationBarWithBackAndSelectedStudent(viewController: self, title: "Select Student", numberStudent: "\((self.objStudentDetailModalSelected?.items?.count) ?? 0)")

        }
        
        let fontHeavy = UIFont(name: "FontHeavy".localized(), size: Device.FONTSIZETYPE16)
        UIButton.buttonUIHandling(button: btnAddStudent, text: "Add", backgroundColor: ILColor.color(index: 23), textColor: .white, cornerRadius: 3, fontType: fontHeavy)
        
        btnAddStudent.isHidden = false
        
        
        if let fontHeavy = UIFont(name: "FontHeavy".localized(), size: Device.FONTSIZETYPE13),  let fontMedium = UIFont(name: "FontMedium".localized(), size: Device.FONTSIZETYPE13)
        {
            UILabel.labelUIHandling(label: lblSelectAll, text: "Select all", textColor:ILColor.color(index: 28) , isBold: false, fontType: fontMedium)
            var end = offset + 20
            if offset + 20 >= self.objStudentDetailModal?.total ?? 0 {
                end = self.objStudentDetailModal?.total ?? 0
            }
            let studentNumber = "\(offset + 1 )-\(end) of \(self.objStudentDetailModal?.total ?? 0)"
            
            UILabel.labelUIHandling(label: lblStudentNumber, text: studentNumber, textColor:ILColor.color(index: 28) , isBold: false, fontType: fontMedium)
        }
        
        btnEnableDisable()
        self.tblView.reloadData()
        
        
        switch self.objStudentListType {
        case .groupType:
            
            break
        case .One2OneType:
            
            btnSelectAll.isUserInteractionEnabled = false
            btnSelectAll.alpha = 0.6
            lblSelectAll.alpha = 0.6
            break
            
            
        default:
            break
        }
        
        
    }
    
    
    func btnEnableDisable()  {
        if offset <= 0 {
            btnStudentListPrev.alpha = 0.6
            btnStudentListPrev.isUserInteractionEnabled = false
        }
        else{
            btnStudentListPrev.alpha = 1
            btnStudentListPrev.isUserInteractionEnabled = true
        }
        if offset + 20 >= self.objStudentDetailModal?.total ?? 0  {
            btnStudentListNext.alpha = 0.6
            btnStudentListNext.isUserInteractionEnabled = false
        }
        else{
            btnStudentListNext.alpha = 1
            btnStudentListNext.isUserInteractionEnabled = true
        }
    }
    
    
}
// MARK: TableView,Searchbar DataSource and Delegate.


extension ERSideStudentListViewController: ERSideStudentListTableViewCellDelegate{
    
    @IBAction func btnSelectAllTapped(_ sender: Any) {
        
        isAllStudentSelected  = !isAllStudentSelected;
        changeStudentSelectedModal(isSelected: isAllStudentSelected)
        if isAllStudentSelected {
            btnSelectAll.setImage(UIImage.init(named: "Check_box_selected"), for: .normal);
            
        }
        else{
            btnSelectAll.setImage(UIImage.init(named: "check_box"), for: .normal);
        }
    }
       
    
    func allStudentSelectedImage(){
        if objStudentDetailModal?.items!.filter({$0.isSelected == true}).count == objStudentDetailModalCopy?.items?.count {
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
           let arrStudentListView = self.objStudentDetailModal!.items!
           let arrStudentSelectedListView = self.objStudentDetailModalSelected!.items!
           _ =    arrStudentListView.filter({
               let item = $0;
               let arrFiltered =  arrStudentSelectedListView.filter({
                   $0.id == item.id
               })
               if arrFiltered.count > 0{
                   
                   var selectedId = objStudentDetailModal?.items!.filter({$0.id == arrFiltered[0].id})[0]
                   selectedId!.isSelected = false
                   let index = self.objStudentDetailModal?.items!.firstIndex(where: {$0.id == arrFiltered[0].id}) ?? 0
                   self.objStudentDetailModal?.items!.removeAll(where: {$0.id == arrFiltered[0].id})
                   self.objStudentDetailModal?.items!.insert(selectedId!, at: index)
                   
                   self.objStudentDetailModalSelected?.items!.removeAll(where: {$0.id == arrFiltered[0].id})
                   return true
               }
               else{
                   return false
               }
           })
           
           if isSelected{
               let arrStudentListView = self.objStudentDetailModal!.items!
               var index = 0
               for var objStudentDetailModalItem in arrStudentListView{
                   self.objStudentDetailModalSelected?.items?.append(objStudentDetailModalItem)
                   objStudentDetailModalItem.isSelected = true
                   self.objStudentDetailModal?.items?.remove(at: index);
                   self.objStudentDetailModal?.items?.insert(objStudentDetailModalItem, at: index)
                   index = index + 1;
               }
           }
        
        if isSearchEnabled {
                   makeCopyModalInSync()
               }
        
           let isStudent = UserDefaultsDataSource(key: "student").readData() as? Bool
           if isStudent ?? false{
               GeneralUtility.customeNavigationBarWithBackAndSelectedStudent(viewController: self, title: "Select Community Member", numberStudent: "\((self.objStudentDetailModalSelected?.items?.count) ?? 0)")
           }
           else{
               GeneralUtility.customeNavigationBarWithBackAndSelectedStudent(viewController: self, title: "Select Student", numberStudent: "\((self.objStudentDetailModalSelected?.items?.count) ?? 0)")
           }
        
           self.tblView.reloadData()
           
       }
    
    
    func makeCopyModalInSync(){
        
        
        let arrStudentListView = self.objStudentDetailModal!.items!
        
        _ =    arrStudentListView.filter({
            let item = $0;
            let arrFiltered =  objStudentDetailModalCopy!.items!.filter({
                $0.id == item.id
            })
            if arrFiltered.count > 0{
                
                var selectedId = objStudentDetailModalCopy?.items!.filter({$0.id == item.id})[0]
                selectedId!.isSelected = item.isSelected
                
                let index = self.objStudentDetailModalCopy?.items!.firstIndex(where: {$0.id == item.id}) ?? 0
                
                self.objStudentDetailModalCopy?.items!.removeAll(where: {$0.id == item.id})
                self.objStudentDetailModalCopy?.items!.insert(selectedId!, at: index)
                return true
            }
            else{
                return false
            }
        })
        
        
    }
    
    
    
    func studentSelected(items: StudentDetailModalItem,isSelectedStudent: Bool) {
        
        
        switch  self.objStudentListType {
        case .groupType:
             
                  if isSelectedStudent{
                      objStudentDetailModalSelected?.total = self.objStudentDetailModal?.total
                      objStudentDetailModalSelected?.items?.append(items)
                      
                      var selectedId = objStudentDetailModal?.items!.filter({$0.id == items.id})[0]
                      selectedId!.isSelected = true
                      let index = self.objStudentDetailModal?.items!.firstIndex(where: {$0.id == items.id}) ?? 0
                      self.objStudentDetailModal?.items!.removeAll(where: {$0.id == items.id})
                      self.objStudentDetailModal?.items!.insert(selectedId!, at: index)
                      
                  }
                  else{
                      self.objStudentDetailModalSelected?.items!.removeAll(where: {$0.id == items.id})
                      var selectedId = objStudentDetailModal?.items!.filter({$0.id == items.id})[0]
                      selectedId!.isSelected = false
                      let index = self.objStudentDetailModal?.items!.firstIndex(where: {$0.id == items.id}) ?? 0
                      self.objStudentDetailModal?.items!.removeAll(where: {$0.id == items.id})
                      self.objStudentDetailModal?.items!.insert(selectedId!, at: index)
                      
                  }
                  self.allStudentSelectedImage()
                  
                  if isSearchEnabled {
                      makeCopyModalInSync()
                  }
            
            let isStudent = UserDefaultsDataSource(key: "student").readData() as? Bool
            if isStudent ?? false{
                GeneralUtility.customeNavigationBarWithBackAndSelectedStudent(viewController: self, title: "Select Community Member", numberStudent: "\((self.objStudentDetailModalSelected?.items?.count) ?? 0)")
            }
            else{
                GeneralUtility.customeNavigationBarWithBackAndSelectedStudent(viewController: self, title: "Select Student", numberStudent: "\((self.objStudentDetailModalSelected?.items?.count) ?? 0)")
            }
            
                  self.tblView.reloadData()
            break
            
        case .One2OneType:
            
            if isSelectedStudent{
                
                self.objStudentDetailModalSelected = StudentDetailModal.init(total: 0, items: [StudentDetailModalItem]())
                
                objStudentDetailModalSelected?.total = self.objStudentDetailModal?.total
                objStudentDetailModalSelected?.items?.append(items)
                
                var deSelectID = objStudentDetailModal?.items!.filter({$0.isSelected == true})
                if deSelectID?.count ?? 0 > 0{
                    var deSelect = deSelectID?[0]
                    let index = self.objStudentDetailModal?.items!.firstIndex(where: {$0.isSelected == true}) ?? 0
                    self.objStudentDetailModal?.items!.removeAll(where: {$0.isSelected == true})
                    deSelect?.isSelected = false
                    self.objStudentDetailModal?.items!.insert(deSelect!, at: index)
                    
                }
                
                var selectedId = objStudentDetailModal?.items!.filter({$0.id == items.id})[0]
                selectedId!.isSelected = true
                let index = self.objStudentDetailModal?.items!.firstIndex(where: {$0.id == items.id}) ?? 0
                self.objStudentDetailModal?.items!.removeAll(where: {$0.id == items.id})
                self.objStudentDetailModal?.items!.insert(selectedId!, at: index)
                let isStudent = UserDefaultsDataSource(key: "student").readData() as? Bool
                if isStudent ?? false{
                    GeneralUtility.customeNavigationBarWithBackAndSelectedStudent(viewController: self, title: "Select Community Member", numberStudent: "\((self.objStudentDetailModalSelected?.items?.count) ?? 0)")

                }
                else{
                    GeneralUtility.customeNavigationBarWithBackAndSelectedStudent(viewController: self, title: "Select Student", numberStudent: "\((self.objStudentDetailModalSelected?.items?.count) ?? 0)")
                }
                

                self.tblView.reloadData()

            }
            else{
              
                
            }
            
            
            
            break
            
        default:
            break
        }
        
      
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        
        if searchBar.text != ""
        {
            let isStudent = UserDefaultsDataSource(key: "student").readData() as? Bool

            if isStudent ?? false{
                self.objStudentDetailModal = self.objStudentDetailModalCopy
                if searchBar.text != ""
                {
                    let filteredItems =  self.objStudentDetailModal?.items!.filter{
                        let emailPrimary = $0.email?.primary ?? ""
                        let emailSecondary = $0.email?.secondary ?? ""
                        return   ( $0.firstName!.lowercased().contains(searchBar.text!.lowercased())  || $0.lastName!.lowercased().contains(searchBar.text!.lowercased()) || emailPrimary.lowercased().contains(searchBar.text!.lowercased()) || emailSecondary.lowercased().contains(searchBar.text!.lowercased())  )
                    }
                    self.objStudentDetailModal?.items = filteredItems
                    self.customization();

                }
                
            }
            else{
                makeFilterModal()

            }
        }
        txtSearchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            isSearchEnabled = false
            let isStudent = UserDefaultsDataSource(key: "student").readData() as? Bool
            if isStudent ?? false{
                self.objStudentDetailModal = self.objStudentDetailModalCopy
                self.customization();
            }
            else{
                makeFilterModal()
                
            }
            txtSearchBar.resignFirstResponder()

        }
       
        
    }
        

    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ERSideStudentListTableViewCell", for: indexPath) as! ERSideStudentListTableViewCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.objStudentListType = self.objStudentListType
        cell.items = self.objStudentDetailModal?.items?[indexPath.row]
        cell.delegateI = self
        cell.customization()
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  self.objStudentDetailModal?.items?.count ?? 0
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


extension ERSideStudentListViewController{
    
    func makeFilterModal(){
        
        let isStudent = UserDefaultsDataSource(key: "student").readData() as? Bool
        if isStudent ?? false {
        
            if let tags = self.objERFilterTag{
                self.filterAdded = Dictionary<String,Any>()
                
                
                for filter in tags{
                    if  filter.id == 1 {
                        let roles =       filter.objTagValue?.filter({
                            $0.isSelected == true
                        })
                        if (roles?.count ?? 0) > 0 {
                            var roleID = [String]()
                            for selectedTag in roles!{
                                roleID.append(selectedTag.machineName)
                            }
                            self.filterAdded["roles"] = roleID
                        }
                    }
                    else if filter.id == 2{
                        let industries =       filter.objTagValue?.filter({
                            $0.isSelected == true
                        })
                        if (industries?.count ?? 0) > 0 {
                            var industriesSelected = [Dictionary<String,Any>]()
                            for selectedTag in industries!{
                                var dicIndustries = Dictionary<String,Any>()
                                dicIndustries = ["display_name": selectedTag.tagValueText,"id":selectedTag.id]
                                industriesSelected.append(dicIndustries)
                            }
                            self.filterAdded["industries"] = industriesSelected
                        }
                    }
                    else if filter.id == 3{
                        let expertise =       filter.objTagValue?.filter({
                            $0.isSelected == true
                        })
                        if (expertise?.count ?? 0) > 0 {
                            var expertisesSelected = [Dictionary<String,Any>]()
                            for selectedTag in expertise!{
                                var dicexpertise = Dictionary<String,Any>()
                                dicexpertise = ["display_name": selectedTag.tagValueText,"id":selectedTag.id]
                                expertisesSelected.append(dicexpertise)
                            }
                            self.filterAdded["expertise"] = expertisesSelected
                        }
                    }
                    else if filter.id == 4{
                        let clubs =       filter.objTagValue?.filter({
                            $0.isSelected == true
                        })
                        if (clubs?.count ?? 0) > 0 {
                            var clubIDs = [Int]()
                            for selectedTag in clubs!{
                                clubIDs.append(selectedTag.id)
                            }
                            self.filterAdded["clubs"] = clubIDs
                        }
                    }
                }
            }
            
            if txtSearchBar.text?.isEmpty ?? true{
                if filterAdded["name_email"] != nil{
                    filterAdded.removeValue(forKey: "name_email")
                }
            }
            else{
                filterAdded["name_email"] = txtSearchBar.text as AnyObject?
            }
            
            
            self.callingViewModal(isbackGroundHit: false)

        }
        
        else{
            var benchMark = Array<Int>()
            var tag = Array <Dictionary<String,AnyObject>>()
            if let objTags  = self.objERFilterTag{
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
                            let category  = ["category" : objERFlter.category ?? "",
                                             "values" : tagSelected] as [String : AnyObject]
                            tag.append(category);
                        }
                    }
                }
                if benchMark.count > 0 {
                    filterAdded["benchmarks"] = benchMark as AnyObject
                }
                if !tag.isEmpty {
                    filterAdded["tags"] = tag as AnyObject
                }
                
            }
         
            if txtSearchBar.text?.isEmpty ?? true{
                if filterAdded["name_email"] != nil{
                    filterAdded.removeValue(forKey: "name_email")
                }
            }
            else{
                filterAdded["name_email"] = txtSearchBar.text as AnyObject?
            }
            
            if benchMark.count == 0 && tag.isEmpty && (txtSearchBar.text?.isEmpty ?? true) {
                filterAdded = Dictionary<String,AnyObject>()
            }
            callViewModal()
        }
        
    }
    
    
   
    func passFilter(selectedFilter: [ERFilterTag]?) {
        self.objERFilterTag = selectedFilter;
        makeFilterModal()
        
    }
    
}
