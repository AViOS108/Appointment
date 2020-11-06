//
//  CoachConfirmationPopUpSecondViewC.swift
//  Appointment
//
//  Created by Anurag Bhakuni on 08/09/20.
//  Copyright © 2020 Anurag Bhakuni. All rights reserved.
//

import UIKit

struct  DocUploadedModal{
    
    var docName : String?
    var docData : Data?
    var isDocUploaded : Bool?
    
}


 
protocol  CoachConfirmationPopUpSecondViewCDelegate{
    func refreshSelectionView(isBack : Bool, results: OpenHourCoachModalResult!)
    
}



class CoachConfirmationPopUpSecondViewC: UIViewController,UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate {
    
    var delegate : CoachConfirmationPopUpSecondViewCDelegate!
    
    var docUploaded : DocUploadedModal!
    
    @IBOutlet weak var viewContainer: UIView!
    var resueStudentFunctionI : StudentFunctionSurvey!
    var resueStudentIndustryI : [StudentIndustrySurvey]!
    var searchArrayFunction = [SearchTextFieldItem]()
    var searchArrayIndustry = [SearchTextFieldItem]()
    var searchArrayPurpose = [SearchTextFieldItem]()

    var searchGlobalCompanies = [SearchTextFieldItem]()

    var descriptionText = ""
    var results: OpenHourCoachModalResult!
    @IBOutlet weak var viewSeperatorVerticale: UIView!
    
    @IBOutlet weak var viewBottom: UIView!
    @IBOutlet weak var btnCancel: UIButton!
    @IBAction func btnCancelTapped(_ sender: UIButton) {
        self.dismiss(animated: false) {
            
        }
    }
    @IBOutlet weak var viewSeperator: UIView!

    @IBOutlet weak var BtnNext: UIButton!
    
    @IBAction func btnNextTapped(_ sender: UIButton) {
        confirmAppointment()
    
    }
    
    @IBOutlet weak var lblHeader: UILabel!
    
    @IBOutlet weak var btnback: UIButton!
    
    @IBAction func btnBAckTapped(_ sender: Any) {
        
        self.dismiss(animated: false) {
            self.delegate.refreshSelectionView(isBack: true, results: self.results)
                   }
        
    }
    
    var arraYHeader = ["Purpose of the Meeting","Description","Target Functions (Max 3)","Target Industries (Max 3)","Target Companies (Max 3)"]
    
    
    
    @IBOutlet weak var tblView: UITableView!
    
    
    override func viewDidDisappear(_ animated: Bool) {
             AppUtility.lockOrientation(.all)
       }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if  (Device.IS_IPAD)
        {
            
        }
        else
        {
            AppUtility.lockOrientation(.portrait, andRotateTo: .portrait)

        }
        tblView.register(UINib.init(nibName: "ConfirmationPopUpFirstTableViewCell", bundle: nil), forCellReuseIdentifier: "ConfirmationPopUpFirstTableViewCell")
        
        tblView.register(UINib.init(nibName: "ConfirmationPopUpSecondTableViewCell", bundle: nil), forCellReuseIdentifier: "ConfirmationPopUpSecondTableViewCell")
        tblView.register(UINib.init(nibName: "ConfirmationPopupFileShareTableViewCell", bundle: nil), forCellReuseIdentifier: "ConfirmationPopupFileShareTableViewCell")
        
        
        self.modalFormation();
        self.tblView.contentInset = UIEdgeInsets(top: 16, left: 0, bottom: 0, right: 0)
        
        docUploaded = DocUploadedModal()
        docUploaded.docName = ""
        docUploaded.isDocUploaded = false
        
        let fontHeavy = UIFont(name: "FontHeavy".localized(), size: Device.FONTSIZETYPE15)
        
        UILabel.labelUIHandling(label: lblHeader, text: "Confirm Appointment", textColor: ILColor.color(index: 40), isBold: false, fontType: fontHeavy)
        
        UIButton.buttonUIHandling(button: btnback, text: "", backgroundColor: .white,  buttonImage: UIImage.init(named: "noun_back_black"))
        viewSeperator.backgroundColor = ILColor.color(index:19);

        // Do any additional setup after loading the view.
    }
    
    
    func modalFormation(){
        
        for purpose in results.purposes!{
            let searchItem = SearchTextFieldItem()
            searchItem.title = purpose.userPurpose?.displayName! as! String
            searchItem.id  = purpose.userPurposeID
            searchArrayPurpose.append(searchItem)
            
        }
        
        
        for result in resueStudentFunctionI.results{
            let searchItem = SearchTextFieldItem()
            searchItem.title = result.name;
            searchItem.id = result.id;
            searchItem.isSelected = false
            searchItem.maxValue = 3;
            searchArrayFunction.append(searchItem)
        }
        for result in resueStudentIndustryI{
            let searchItem = SearchTextFieldItem()
            searchItem.title = result.name;
            searchItem.id = result.id;
            searchItem.maxValue = 3;
            searchItem.isSelected = false
            searchArrayIndustry.append(searchItem)
        }
        
    }
    
    func makeModal(indexpath : IndexPath)->[SearchTextFieldItem]{
        
        if indexpath.row == 0{
            return searchArrayPurpose
        }
        
        if indexpath.row == 2{
            return searchArrayFunction
        }
        else if indexpath.row == 3{
            
            return searchArrayIndustry
        }
        else if indexpath.row == 4{
            
            return searchGlobalCompanies
        }
        else{
            return [SearchTextFieldItem]()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if  (Device.IS_IPAD)
        {
            
        }
        else
        {
            AppUtility.lockOrientation(.portrait, andRotateTo: .portrait)

        }
        tblView.delegate = self
        tblView.dataSource = self
        self.viewContainer.cornerRadius = 3;
        viewSeperatorVerticale.backgroundColor = ILColor.color(index:19);
        viewBottom.backgroundColor = ILColor.color(index:19);
        let fontMedium = UIFont(name: "FontMedium".localized(), size: Device.FONTSIZETYPE13)
        let fontHeavy = UIFont(name: "FontHeavy".localized(), size: Device.FONTSIZETYPE13)

        UIButton.buttonUIHandling(button: btnCancel, text: "Cancel", backgroundColor:.white , textColor: ILColor.color(index: 23), fontType: fontMedium)
        UIButton.buttonUIHandling(button: BtnNext, text: "Submit", backgroundColor:.white , textColor: ILColor.color(index: 23), fontType: fontHeavy)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.view.tag = 19682
        self.viewContainer.tag = 19683
        tapGesture()
        view.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.2)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view?.isDescendant(of: self.view) == true  && touch.view?.tag != 19682  {
                self.view.resignFirstResponder()
           
            return false
        }
        return true
    }
    
    func tapGesture()  {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        tap.delegate = self
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(tap)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        self.dismiss(animated: false) {
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row != 1 && indexPath.row != arraYHeader.count{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ConfirmationPopUpFirstTableViewCell", for: indexPath) as! ConfirmationPopUpFirstTableViewCell
            cell.indexPath = indexPath
            cell.delegate = self
            cell.arrNameSurvey = self.makeModal(indexpath: indexPath)
            cell.tblview = self.tblView
            cell.viewController = self.tblView
            if indexPath.row == 4{
                cell.isAPiHIt = true
            }
            else{
                cell.isAPiHIt = false

            }
            cell.viewControllerI = self
            cell.customization()
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell
        }
        else if indexPath.row == arraYHeader.count{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ConfirmationPopupFileShareTableViewCell", for: indexPath) as! ConfirmationPopupFileShareTableViewCell
            cell.viewControllerI = self
            cell.docUploaded = self.docUploaded
            cell.delegate = self
            cell.customization()
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell
        }
        else{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ConfirmationPopUpSecondTableViewCell", for: indexPath) as! ConfirmationPopUpSecondTableViewCell
            cell.customization()
            cell.delegate = self
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arraYHeader.count + 1;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath){
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}


extension CoachConfirmationPopUpSecondViewC: changeModalConfirmationPopUpDelegate,SendDEscriptionConfirmationPopUpSecondDelegate{
    func sendDescription(strText: String) {
        descriptionText = strText;
    }
    
    
    
    
    
    func sendApiResult(item: [SearchTextFieldItem],isApi: Bool) {
        if isApi{
            if item.count > 0 {
                let selected = searchGlobalCompanies.filter({$0.isSelected == true})
                self.searchGlobalCompanies = item
                self.searchGlobalCompanies.append(contentsOf: selected)
                        self.tblView.reloadData();
            }
             self.tblView.reloadData();
        }
        else{
             self.tblView.reloadData();
        }
        
        
       
    }
    
    
    
    
    func changeModal(searchItem: SearchTextFieldItem, indexPAth: IndexPath, isAdded: Bool) {
        
        
        if indexPAth.row == 0{
            let selectedId = searchArrayPurpose.filter({$0.id == searchItem.id})[0]
            selectedId.isSelected = isAdded
            let index = self.searchArrayPurpose.firstIndex(where: {$0.id == searchItem.id}) ?? 0
            self.searchArrayPurpose.removeAll(where: {$0.id == searchItem.id})
            self.searchArrayPurpose.insert(selectedId, at: index)
        }
        
       else if indexPAth.row == 2{
            let selectedId = searchArrayFunction.filter({$0.id == searchItem.id})[0]
            selectedId.isSelected = isAdded
            let index = self.searchArrayFunction.firstIndex(where: {$0.id == searchItem.id}) ?? 0
            self.searchArrayFunction.removeAll(where: {$0.id == searchItem.id})
            self.searchArrayFunction.insert(selectedId, at: index)
        }
        else if indexPAth.row == 3{
            let selectedId = searchArrayIndustry.filter({$0.id == searchItem.id})[0]
            selectedId.isSelected = isAdded
            let index = self.searchArrayIndustry.firstIndex(where: {$0.id == searchItem.id}) ?? 0
            self.searchArrayIndustry.removeAll(where: {$0.id == searchItem.id})
            self.searchArrayIndustry.insert(selectedId, at: index)
            
        }
        else if indexPAth.row == 4{
            let selectedId = searchGlobalCompanies.filter({$0.id == searchItem.id})[0]
            selectedId.isSelected = isAdded
            let index = self.searchGlobalCompanies.firstIndex(where: {$0.id == searchItem.id}) ?? 0
            self.searchGlobalCompanies.removeAll(where: {$0.id == searchItem.id})
            self.searchGlobalCompanies.insert(selectedId, at: index)
            
        }
        
        
        self.tblView.reloadData();
        
    }
   
    
    func makeStrForDescription(param: String,array: [SearchTextFieldItem]) -> String {
        var str = param
        let selectedFunction = array.filter({$0.isSelected == true})
        var index = 0;
        for strFunctionname in selectedFunction{
            str.append(contentsOf: " ")
            str.append(contentsOf: strFunctionname.title)
            index = index + 1;
            if index == selectedFunction.count{
                str.append(";")
                
            }
            else{
                str.append(",")
                
            }
        }
        if selectedFunction.count == 0{
            str.append(";")
        }
        return str
    }
    
    
    
    
    
    func confirmAppointment()  {
        
        
        let selectedPurpose = searchArrayPurpose.filter({$0.isSelected == true})

        
        if selectedPurpose.count == 0 {
            CommonFunctions().showError(title: "Error", message: StringConstants.PURPOSEERROR)

            return
        }
        
        
        
        var strDescription = ""
        
      if  searchArrayFunction.filter({$0.isSelected == true}).count > 0{
             strDescription.append(contentsOf:self.makeStrForDescription(param: "Functions:", array: searchArrayFunction))
        }
        
       if  searchArrayIndustry.filter({$0.isSelected == true}).count > 0{
             strDescription.append(contentsOf: self.makeStrForDescription(param: "Industries:", array: searchArrayIndustry))
       }
        
        if  searchGlobalCompanies.filter({$0.isSelected == true}).count > 0{
                   strDescription.append(contentsOf: self.makeStrForDescription(param: "Companies:", array: searchGlobalCompanies))
              }
        
        if descriptionText.isEmpty{
            
        }
        else{
           strDescription.append(descriptionText)
        }
        
       
       
        
        
        var firstName = ""
        if let fn = UserDefaults.standard.object(forKey: "firstName"){
            firstName = fn as! String
        }
        var finalName = ""
        if let lastName = UserDefaults.standard.object(forKey: "lastName") {
            finalName = "\(firstName) \(lastName)"
        }else{
            finalName = "\(firstName)"
        }
        
        var userPurposeId = [String]()
        
        for userID in selectedPurpose{
            userPurposeId.append("\(userID.id!)")
        }
        
       
        
        let strtitle = "Meeting:" + " " + finalName + " with" + " " + results.createdBy.name!
        let csrftoken = UserDefaultsDataSource(key: "csrf_token").readData() as! String

        var params = [
            "title" : strtitle,
            "in_timezone" : "Asia/Kolkata",
            "user_purpose_ids": userPurposeId,
            ParamName.PARAMCSRFTOKEN : csrftoken

        ]  as [String : Any]
        
        if strDescription != "" {
            params["description"] = strDescription
            
        }
        
        
        if let doc = docUploaded.docData{
            let convertedString = String(data: doc, encoding: .utf8) // the data will be converted to the string

            params["attachments_public"] = [doc]
        }
        

        let  activityIndicator = ActivityIndicatorView.showActivity(view: self.view, message: StringConstants.CONFIRMAPPOINTMENT)
             
        CoachSelectionService().confirmAppointment(identifier: results.identifier!, params: params as Dictionary<String, AnyObject>, { (data) in
            activityIndicator.hide()
            
            self.dismiss(animated: false) {
                self.delegate.refreshSelectionView(isBack: false, results: self.results)
            }
            

        }) { (error, errorCode) in

            activityIndicator.hide()
            CommonFunctions().showError(title: "Error", message: error)
        }
        
    }
    
    
    
}
extension CoachConfirmationPopUpSecondViewC: ConfirmationPopupFileShareTableViewCellDelegate{
    func sendDocument(data: DocUploadedModal) {
        
        self.docUploaded = data
        tblView.reloadData()
        
    }
    
    
    
    
}
