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



class CoachConfirmationPopUpSecondViewC: SuperViewController,UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate {
    
    var delegate : CoachConfirmationPopUpSecondViewCDelegate!
    
    var docUploaded : DocUploadedModal!
    
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var viewOuter: UIView!

    var resueStudentFunctionI : StudentFunctionSurvey!
    var resueStudentIndustryI : [StudentIndustrySurvey]!
    var searchArrayFunction = [SearchTextFieldItem]()
    var searchArrayIndustry = [SearchTextFieldItem]()
    var searchArrayPurpose = [SearchTextFieldItem]()
    var selectedCoach : Item?

    var searchGlobalCompanies = [SearchTextFieldItem]()

    var descriptionText = ""
    var results: OpenHourCoachModalResult!
   
    @IBOutlet weak var btnCancel: UIButton!
    @IBAction func btnCancelTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: false)

    }
  
    @IBOutlet weak var btnConfirm: UIButton!
    
    @IBAction func btnConfirmTapped(_ sender: UIButton) {
        confirmAppointment()
    
    }
    
    var arraYHeader = ["Purpose of the Meeting","Description","Target Functions (Max 3)","Target Industries (Max 3)","Target Companies (Max 3)"]
    
    
    
    @IBOutlet weak var tblView: UITableView!
    
    // Design Changes
    
    @IBOutlet weak var lblTimingFrom: UILabel!
    @IBOutlet weak var lblTimingTo: UILabel!
    @IBOutlet weak var lblAvailableSlots: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    

    @IBOutlet weak var lblImageView: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblDescribtion: UILabel!

    
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
      
        // Do any additional setup after loading the view.
    }
    
    
    func modalFormation(){
        
        var index = 0;
        for purpose in results.purposes{
            let searchItem = SearchTextFieldItem()
            searchItem.title = purpose.purposeText ?? ""
            searchItem.id = index;
            searchArrayPurpose.append(searchItem)
            index = index + 1;
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
        let fontMedium = UIFont(name: "FontMedium".localized(), size: Device.FONTSIZETYPE13)
        let fontHeavy = UIFont(name: "FontHeavy".localized(), size: Device.FONTSIZETYPE13)

        UIButton.buttonUIHandling(button: btnCancel, text: "Cancel", backgroundColor:.white , textColor: ILColor.color(index: 23), fontType: fontHeavy)
        UIButton.buttonUIHandling(button: btnConfirm, text: "Confirm", backgroundColor:.white , textColor: ILColor.color(index: 23), fontType: fontHeavy)
        
        GeneralUtility.customeNavigationBarWithOnlyBack(viewController: self,title:"Schedule");
    }
    
    @objc override func buttonClicked(sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: false)
    }
    override func viewDidAppear(_ animated: Bool) {
        self.view.backgroundColor = ILColor.color(index: 22)
        self.coachInfo()
        self.customizationTimeSlot()
        self.customizationLocation()

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
        
        self.viewOuter.frame = CGRect.init(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
       
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
        self.viewOuter.frame = CGRect.init(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)

        
    }
   
    
    func makeStrForDescription(array: [SearchTextFieldItem]) -> [String] {
        let selectedArrayPaased = array.filter({$0.isSelected == true})
        var arrSelected = [String]()
        for strFunctionname in selectedArrayPaased{
            arrSelected.append(strFunctionname.title)
        }
      
        return arrSelected
    }
    
    
    
    
    
    func confirmAppointment()  {
        
        
        let selectedPurpose = searchArrayPurpose.filter({$0.isSelected == true})
        if selectedPurpose.count == 0 {
            CommonFunctions().showError(title: "Error", message: StringConstants.PURPOSEERROR)
            return
        }
        
        var strDescription = ""

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
            userPurposeId.append(userID.title)
        }
        
       
        let strtitle = "Meeting:" + " " + finalName + " with" + " " + results.createdBy.name!
        let csrftoken = UserDefaultsDataSource(key: "csrf_token").readData() as! String

          var localTimeZoneAbbreviation: String { return TimeZone.current.abbreviation() ?? "" }

        var params = [
            "title" : strtitle,
            "in_timezone" : localTimeZoneAbbreviation,
            "purposes": userPurposeId,
            ParamName.PARAMCSRFTOKEN : csrftoken

        ]  as [String : Any]
        
      
        if  searchArrayFunction.filter({$0.isSelected == true}).count > 0{
            params["target_functions"] =  self.makeStrForDescription(array: searchArrayFunction)
          }
        
        if  searchArrayFunction.filter({$0.isSelected == true}).count > 0{
            params["target_companies"] =  self.makeStrForDescription(array: searchGlobalCompanies)
          }
        
        if  searchArrayFunction.filter({$0.isSelected == true}).count > 0{
            params["target_industries"] =  self.makeStrForDescription(array: searchArrayIndustry)
          }
        
        
        
        if let doc = docUploaded.docData{
            let convertedString = String(data: doc, encoding: .utf8) // the data will be converted to the string

            params["attachments_public"] = [doc]
        }
        

        let  activityIndicator = ActivityIndicatorView.showActivity(view: self.view, message: StringConstants.CONFIRMAPPOINTMENT)
             
        CoachSelectionService().confirmAppointment(identifier: results.identifier, params: params as Dictionary<String, AnyObject>, { (data) in
            activityIndicator.hide()
            
            self.delegate.refreshSelectionView(isBack: false, results: self.results)
            self.navigationController?.popViewController(animated: false)
            

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

// Design Changes
extension CoachConfirmationPopUpSecondViewC{
    
    func customizationTimeSlot(){
        
        let fontHeavy = UIFont(name: "FontHeavy".localized(), size: Device.FONTSIZETYPE12)
        UILabel.labelUIHandling(label: lblAvailableSlots, text: "Available Slots", textColor: ILColor.color(index: 59), isBold: true, fontType: fontHeavy)
        
        if let fontMediumI =  UIFont(name: "FontMediumWithoutNext".localized(), size: Device.FONTSIZETYPE14), let fontMedium =  UIFont(name: "FontMediumWithoutNext".localized(), size: Device.FONTSIZETYPE12)
        {
            let strHeader = NSMutableAttributedString.init()
            let strTiTle = NSAttributedString.init(string: "Start Time"
                , attributes: [NSAttributedString.Key.foregroundColor : ILColor.color(index: 42),NSAttributedString.Key.font : fontMedium]);
            let nextLine1 = NSAttributedString.init(string: "\n")

            let strTime = NSAttributedString.init(string: GeneralUtility.currentDateDetailType3(emiDate: results.startDatetimeUTC)
                , attributes: [NSAttributedString.Key.foregroundColor : ILColor.color(index: 53),NSAttributedString.Key.font : fontMediumI]);
            
            
            let para = NSMutableParagraphStyle.init()
            //            para.alignment = .center
            strHeader.append(strTiTle)
            strHeader.append(nextLine1)
            strHeader.append(strTime)
            
            strHeader.addAttribute(NSAttributedString.Key.paragraphStyle, value: para, range: NSMakeRange(0, strHeader.length))
            
            
            
            lblTimingFrom.attributedText = strHeader
        }
        if let fontMediumI =  UIFont(name: "FontMediumWithoutNext".localized(), size: Device.FONTSIZETYPE14),let fontMedium =  UIFont(name: "FontMediumWithoutNext".localized(), size: Device.FONTSIZETYPE12)
        {
            let strHeader = NSMutableAttributedString.init()
            let nextLine1 = NSAttributedString.init(string: "\n")

            let strTiTle = NSAttributedString.init(string: "End Time"
                , attributes: [NSAttributedString.Key.foregroundColor : ILColor.color(index: 42),NSAttributedString.Key.font : fontMedium]);
            let strTime = NSAttributedString.init(string: GeneralUtility.currentDateDetailType3(emiDate: results.endDatetimeUTC)
                , attributes: [NSAttributedString.Key.foregroundColor : ILColor.color(index: 53),NSAttributedString.Key.font : fontMediumI]);
            let para = NSMutableParagraphStyle.init()
            strHeader.append(strTiTle)
            strHeader.append(nextLine1)
            strHeader.append(strTime)
            strHeader.addAttribute(NSAttributedString.Key.paragraphStyle, value: para, range: NSMakeRange(0, strHeader.length))
            lblTimingTo.attributedText = strHeader
        }

    }
    
    func customizationLocation(){
        
        if   let fontHeavy = UIFont(name: "FontHeavy".localized(), size: Device.FONTSIZETYPE12),let fontBook =  UIFont(name: "FontBook".localized(), size: Device.FONTSIZETYPE12)
        {
            let strHeader = NSMutableAttributedString.init()
            let nextLine1 = NSAttributedString.init(string: "\n")
            
            let strTiTle = NSAttributedString.init(string: "Location/ Meeting Link"
                                                   , attributes: [NSAttributedString.Key.foregroundColor : ILColor.color(index: 59),NSAttributedString.Key.font : fontHeavy]);
            let strlocation = NSAttributedString.init(string: self.results.location
                                                      , attributes: [NSAttributedString.Key.foregroundColor : ILColor.color(index: 34),NSAttributedString.Key.font : fontBook]);
            let para = NSMutableParagraphStyle.init()
            strHeader.append(strTiTle)
            strHeader.append(nextLine1)
            strHeader.append(strlocation)
            strHeader.addAttribute(NSAttributedString.Key.paragraphStyle, value: para, range: NSMakeRange(0, strHeader.length))
            lblLocation.attributedText = strHeader
        }
        
    }
    
    func coachInfo(){
        
        let radius =  (Int)(lblImageView.frame.height)/2
        if let urlImage = URL.init(string: self.selectedCoach?.profilePicURL ?? "") {
            self.imgView
                .setImageWith(urlImage, placeholderImage: UIImage.init(named: "Placeeholderimage"))
            
            self.imgView?.cornerRadius = CGFloat(radius)
            imgView?.clipsToBounds = true
            //                self.imgView.layer.borderColor = UIColor.black.cgColor
            //                self.imgView.layer.borderWidth = 1
            self.imgView?.layer.masksToBounds = true;
        }
        else{
            self.imgView.image = UIImage.init(named: "Placeeholderimage");
            //            self.imgView.contentMode = .scaleAspectFit;
            
        }
        if self.selectedCoach?.profilePicURL == nil ||
            GeneralUtility.optionalHandling(_param: self.selectedCoach?.profilePicURL?.isBlank, _returnType: Bool.self)
        {
            
            self.imgView?.isHidden = true
            self.lblImageView.isHidden = false
            
            var stringImg = GeneralUtility.startNameCharacter(stringName: self.selectedCoach?.name ?? " ")
            if let fontMedium = UIFont(name: "FontMedium".localized(), size: Device.FONTSIZETYPE15)
            {
                
                UILabel.labelUIHandling(label: lblImageView, text: GeneralUtility.optionalHandling(_param: stringImg, _returnType: String.self), textColor:.black , isBold: false , fontType: fontMedium, isCircular: true,  backgroundColor:.white ,cornerRadius: radius,borderColor:UIColor.black,borderWidth: 1 )
                lblImageView.textAlignment = .center
                lblImageView.layer.borderColor = UIColor.black.cgColor
            }
            
            
        }
        else
        {
            self.lblImageView.isHidden = true
            self.imgView?.isHidden = false
            
        }
        
        let strHeader = NSMutableAttributedString.init()
        
        if let fontHeavy = UIFont(name: "FontHeavy".localized(), size: Device.FONTSIZETYPE13), let fontBook =  UIFont(name: "FontBook".localized(), size: Device.FONTSIZETYPE14)
        
        {
            let strTiTle = NSAttributedString.init(string: GeneralUtility.optionalHandling(_param: self.selectedCoach?.name, _returnType: String.self)
                                                   , attributes: [NSAttributedString.Key.foregroundColor : ILColor.color(index:13),NSAttributedString.Key.font : fontHeavy]);
            let nextLine1 = NSAttributedString.init(string: "\n")
            
            var roles = ""
            var index = 0
            for role in self.selectedCoach!.roles{
                roles.append(role.displayName ?? "")
                index = index + 1;
                if self.selectedCoach!.roles.count > 1{
                    if index == self.selectedCoach?.roles.count{
                    }
                    else{
                        roles.append(" etc")
                        break
                    }
                }
            }
            
            let strType = NSAttributedString.init(string: GeneralUtility.optionalHandling(_param: roles, _returnType: String.self)
                                                  , attributes: [NSAttributedString.Key.foregroundColor : ILColor.color(index: 13),NSAttributedString.Key.font : fontBook]);
            
            let para = NSMutableParagraphStyle.init()
            //            para.alignment = .center
            para.lineSpacing = 4
            
            strHeader.append(strTiTle)
            
            strHeader.append(nextLine1)
            strHeader.append(strType)
         
            strHeader.addAttribute(NSAttributedString.Key.paragraphStyle, value: para, range: NSMakeRange(0, strHeader.length))
            lblDescribtion.attributedText = strHeader
        }
        
        
        
        
    }
    
    
}


