//
//  ERSideStudentListViewController.swift
//  Appointment
//
//  Created by Anurag Bhakuni on 15/12/20.
//  Copyright © 2020 Anurag Bhakuni. All rights reserved.
//

import UIKit

class ERSideStudentListViewController: UIViewController,UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource,ERFilterViewControllerDelegate {
    
   var objERFilterTag : [ERFilterTag]?
    @IBOutlet weak var viewSearch: UIView!
    
    @IBOutlet weak var viewSelection: UIView!
    @IBOutlet weak var btnSelectAll: UIButton!
    
    var isAllStudentSelected = false
    
    @IBOutlet weak var lblSelectAll: UILabel!
    
    @IBOutlet weak var lblStudentNumber: UILabel!
    
    @IBOutlet weak var btnStudentListPrev: UIButton!
    
    @IBOutlet weak var btnStudentListNext: UIButton!
    var filterAdded = Dictionary<String,AnyObject>()

    var offset = 0 ;
    var activityIndicator: ActivityIndicatorView?
    
    @IBOutlet weak var txtSearchBar: UISearchBar!
    
    @IBOutlet weak var btnFilter: UIButton!
    
    @IBAction func btnFilterTapped(_ sender: Any) {
        
        let objERFilterViewController = ERFilterViewController.init(nibName: "ERFilterViewController", bundle: nil)
        objERFilterViewController.modalPresentationStyle = .overFullScreen
        objERFilterViewController.objERFilterTag = self.objERFilterTag
        objERFilterViewController.delegate = self
        self.present(objERFilterViewController, animated: false) {
            
        }
    }
    
    var objStudentDetailModalSelected : StudentDetailModal?
    var objStudentDetailModal : StudentDetailModal?
    @IBOutlet weak var tblView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblView.register(UINib.init(nibName: "ERSideStudentListTableViewCell", bundle: nil), forCellReuseIdentifier: "ERSideStudentListTableViewCell")
        
       txtSearchBar.barTintColor = UIColor.clear
        txtSearchBar.backgroundColor = UIColor.clear
        txtSearchBar.isTranslucent = true
        txtSearchBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)

        
        self.viewSearch.isHidden = true
        self.tblView.isHidden = true
        self.viewSelection.isHidden = true
        
        
        txtSearchBar.placeholder = "Search Student"
        txtSearchBar.backgroundColor = .clear
        self.objStudentDetailModalSelected = StudentDetailModal.init(total: 0, items: [StudentDetailModalItem]())
 
       
        
        callViewModal()
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
        
        if objStudentDetailModal?.items!.filter({$0.isSelected == true}).count == 20 {
            isAllStudentSelected = true
        }
        else
        {
             isAllStudentSelected = false
        }
        
        self.allStudentSelectedImage()
    }
    
    
    
    func customization()  {
        self.viewSearch.isHidden = false
        self.tblView.isHidden = false
        self.viewSelection.isHidden = false
        
        btnSelectAll.setImage(UIImage.init(named: "check_box"), for: .normal);
        btnFilter.setImage(UIImage.init(named: "noun_filter_"), for: .normal);
        
        btnStudentListNext.setImage(UIImage.init(named: "forward"), for: .normal);
        btnStudentListPrev.setImage(UIImage.init(named: "back_dark"), for: .normal);
        
        self.viewSelection.borderWithWidth(1, color: ILColor.color(index: 48))
        
        
        
        modalRedefine()
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
            self.allStudentSelectedImage()
           changeStudentSelectedModal(isSelected: isAllStudentSelected)
       }
       
    
    func allStudentSelectedImage(){
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
           self.tblView.reloadData()
           
       }
    
    
    func studentSelected(items: StudentDetailModalItem,isSelectedStudent: Bool) {
      
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
        
        if objStudentDetailModal?.items!.filter({$0.isSelected == true}).count == 20 {
                   isAllStudentSelected = true
               }
               else
               {
                    isAllStudentSelected = false
               }
               
               self.allStudentSelectedImage()
        self.tblView.reloadData()
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        
        if searchBar.text != ""
        {
            
        }
        searchBar.resignFirstResponder();
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ERSideStudentListTableViewCell", for: indexPath) as! ERSideStudentListTableViewCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
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


extension ERSideStudentListViewController{
    
    func makeFilterModal(){
        
        var benchMark = Array<Int>()
        var tag = Array <Dictionary<String,AnyObject>>()
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
        
        if benchMark.count == 0 && tag.isEmpty{
            filterAdded = Dictionary<String,AnyObject>()
        }
        
    }
    
    func passFilter(selectedFilter: [ERFilterTag]?) {
        self.objERFilterTag = selectedFilter;
        makeFilterModal()
        callViewModal()
    }
    
}
