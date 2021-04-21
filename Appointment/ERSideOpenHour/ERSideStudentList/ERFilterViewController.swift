//
//  ERFilterViewController.swift
//  Appointment
//
//  Created by Anurag Bhakuni on 17/12/20.
//  Copyright © 2020 Anurag Bhakuni. All rights reserved.
//

import UIKit
import SwiftyJSON

protocol ERFilterViewControllerDelegate {
    func passFilter( selectedFilter : [ERFilterTag]?)
}


class ERFilterViewController: SuperViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var viewFilter: UIView!
    
    var delegate : ERFilterViewControllerDelegate!
    @IBOutlet weak var btnReset: UIButton!
    @IBAction func btnResetTapped(_ sender: Any) {
        
        var objERFilterI = [ERFilterTag]()
        
        for var objFilterCat in self.objERFilterTag!{
            var objtagValueArr = [TagValueObject]()
            for var strTag in objFilterCat.objTagValue!{
                strTag.isSelected = false ;
                objtagValueArr.append(strTag);
            }
            objFilterCat.objTagValue = objtagValueArr
            objERFilterI.append(objFilterCat);
        }
        
        self.objERFilterTag = objERFilterI;
        self.tblView.reloadData()
        
        
    }
    @IBOutlet weak var btnCancel: UIButton!
    @IBAction func btnCancelTapped(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: false)
    }
    @IBOutlet weak var btnApply: UIButton!
    @IBAction func btnApplyTapped(_ sender: Any) {
        
        self.delegate.passFilter(selectedFilter: self.objERFilterTag)
        self.navigationController?.popViewController(animated: false)
        
        
    }
    var activityIndicator: ActivityIndicatorView?
    var objERFilterTag : [ERFilterTag]?
    @IBOutlet weak var tblView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewFilter.isHidden = true
        viewFilter.backgroundColor = ILColor.color(index: 49)
        
        let headerNib = UINib.init(nibName: "ERSideFilterHeaderView", bundle: Bundle.main)
        tblView.register(headerNib, forHeaderFooterViewReuseIdentifier: "ERSideFilterHeaderView")
        
        GeneralUtility.customeNavigationBarWithOnlyBack(viewController: self, title: "Filters")
        tblView.register(UINib.init(nibName: "ERSideFilterTableViewCell", bundle: nil), forCellReuseIdentifier: "ERSideFilterTableViewCell")
        
        if objERFilterTag != nil{
            self.customization();
        }
        else{
            callViewModal()
        }
        
        // Do any additional setup after loading the view.
    }
    
     override func buttonClicked(sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func callViewModal()  {
        activityIndicator = ActivityIndicatorView.showActivity(view: self.view, message: StringConstants.FetchingCoachSelection)
        ERSideStudentListViewModal().fetchTags({ (data) in
            self.activityIndicator?.hide()
            do {
                self.activityIndicator?.hide()
                self.objERFilterTag = try
                    JSONDecoder().decode(ERFilterTagArr.self, from: data)
                self.customization();
                self.redfineModalWithTag()
            } catch   {
                print(error)
                self.activityIndicator?.hide()
                
            }
        }) { (error, errorCode) in
            self.activityIndicator?.hide()
        }
    }
    
    func redfineModalWithTag()  {
        var objERFilterCat =   [ERFilterTag]()
        for var objFilterCat in self.objERFilterTag!{
            objFilterCat.categoryTitle = "Tag With " + objFilterCat.category!
            objFilterCat.objTagValue = [TagValueObject]()
            let arrTags = objFilterCat.tagValues?.components(separatedBy: "@##")
            for strTag in arrTags!{
                var objtagValue = TagValueObject()
                objtagValue.tagValueText = strTag ;
                objtagValue.isSelected = false ;
                objtagValue.eRFilterid = objFilterCat.id
                objtagValue.isTag = true;
                objFilterCat.objTagValue?.append(objtagValue);
            }
            objERFilterCat.append(objFilterCat);
        }
        self.objERFilterTag?.removeAll();
        self.objERFilterTag?.append(contentsOf: objERFilterCat);
        
        
        let arrayBenchMark = UserDefaultsDataSource(key:
            "benchmarksER").readData() as! Array<[String:AnyObject]> ;
        
        var objBenchark =   ERFilterTag.init(id: -999)
        objBenchark.categoryTitle = "Filter by Audience"
        
        objBenchark.objTagValue = [TagValueObject]()
        for benchMark in arrayBenchMark{
            var objtagValue = TagValueObject()
            objtagValue.tagValueText = benchMark["name"] as? String ;
            objtagValue.eRFilterid = benchMark["id"] as? Int;
            objtagValue.isSelected = false ;
            objtagValue.isTag = false;
            objBenchark.objTagValue?.append(objtagValue);
        }
        self.objERFilterTag?.insert(objBenchark, at: 0)
        self.tblView.reloadData()
        
    }
    
    
    func customization()  {
        
        let fontMedium = UIFont(name: "FontMedium".localized(), size: Device.FONTSIZETYPE13)
        viewFilter.isHidden = false
        
        btnReset.selectedButton(title: " Reset", iconName: "noun_filter_")
        
        btnCancel.setTitle("Cancel", for: .normal)
        btnCancel.titleLabel?.font = fontMedium
        btnApply.setTitle("Apply", for: .normal)
        btnApply.titleLabel?.font = fontMedium
        btnApply.backgroundColor = .clear
        btnCancel.backgroundColor = .clear
        btnReset.backgroundColor = .clear
        
        btnCancel.setTitleColor(ILColor.color(index: 39), for: .normal)
        btnReset.setTitleColor(ILColor.color(index: 50), for: .normal)
        btnApply.setTitleColor(ILColor.color(index: 23), for: .normal)
    }
    
}

// MARK: TableView, DataSource and Delegate.


extension ERFilterViewController: ERSideFilterTableViewCellDelegate{
    func tagSelected(tag: TagValueObject, isSelectedStudent: Bool) {
        
        if tag.isTag {
            
            var tagValue = self.objERFilterTag?.filter({
                $0.id == tag.eRFilterid
            })[0]
            let index = self.objERFilterTag?.firstIndex(where: { $0.id == tag.eRFilterid}) ?? 0
            var tagSelectedObj = tagValue?.objTagValue?.filter({
                $0 == tag
            })[0];
            
            if isSelectedStudent{
                tagSelectedObj?.isSelected = true;
            }
            else{
                tagSelectedObj?.isSelected = false;
                
            }
            let tagSelectedIndex = tagValue?.objTagValue!.firstIndex(where: {  $0 == tag}) ?? 0
            tagValue?.objTagValue?.remove(at: tagSelectedIndex);
            tagValue?.objTagValue?.insert(tagSelectedObj!, at: tagSelectedIndex)
            self.objERFilterTag?.remove(at: index)
            self.objERFilterTag?.insert(tagValue!, at: index)
            
            
        }
        else{
            
            var tagValue = self.objERFilterTag?.filter({
                $0.id == -999
            })[0]
            let index = self.objERFilterTag?.firstIndex(where: { $0.id == tag.eRFilterid}) ?? 0
            var tagSelectedObj = tagValue?.objTagValue?.filter({
                $0 == tag
            })[0];
            
            if isSelectedStudent{
                tagSelectedObj?.isSelected = true;
            }
            else{
                tagSelectedObj?.isSelected = false;
                
            }
            let tagSelectedIndex = tagValue?.objTagValue!.firstIndex(where: {  $0 == tag}) ?? 0
            tagValue?.objTagValue?.remove(at: tagSelectedIndex);
            tagValue?.objTagValue?.insert(tagSelectedObj!, at: tagSelectedIndex)
            self.objERFilterTag?.remove(at: index)
            self.objERFilterTag?.insert(tagValue!, at: index)
            
            
        }
        
        self.tblView.reloadData()
    }
    
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ERSideFilterTableViewCell", for: indexPath) as! ERSideFilterTableViewCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.delegateI = self
        cell.objTagValue = self.objERFilterTag?[indexPath.section].objTagValue?[indexPath.row];
        cell.customize()
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if objERFilterTag != nil{
            if objERFilterTag![section].isExpand {
                return  self.objERFilterTag?[section].objTagValue?.count ?? 0
            }
                else{
                  return 0
            }
        }
        else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
        
    }
  
    
    func numberOfSections(in tableView: UITableView) -> Int{
        
        return  objERFilterTag?.count ?? 0
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "ERSideFilterHeaderView") as! ERSideFilterHeaderView
        headerView.delegate = self
        headerView.objERFilterTag = self.objERFilterTag![section];
        headerView.customizeHeaderView()
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50;
    }
}


extension ERFilterViewController : ERSideFilterHeaderViewDelegate{
    func expandCollapse(objERFilterTag: ERFilterTag,isExpand : Bool) {
        var tagValue = self.objERFilterTag?.filter({
            $0.id == objERFilterTag.id
        })[0]
        let index = self.objERFilterTag?.firstIndex(where: { $0.id == objERFilterTag.id}) ?? 0
        tagValue?.isExpand = isExpand
        self.objERFilterTag?.remove(at: index)
        self.objERFilterTag?.insert(tagValue!, at: index)
        self.tblView.reloadData()
        
    }
}
