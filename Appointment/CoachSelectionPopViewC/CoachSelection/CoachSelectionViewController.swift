//
//  CoachSelectionViewController.swift
//  Appointment
//
//  Created by Anurag Bhakuni on 26/08/20.
//  Copyright © 2020 Anurag Bhakuni. All rights reserved.
//

import UIKit
import SwiftyJSON
class CoachSelectionViewController: SuperViewController {
    
    var resueStudentFunctionI : StudentFunctionSurvey = StudentFunctionSurvey()
    var resueStudentIndustryI : [StudentIndustrySurvey] = [StudentIndustrySurvey]()
    
    @IBOutlet weak var imgViewNoOpenHour: UIImageView!
   @IBOutlet weak var noOpenHour: UIView!
    @IBOutlet weak var lblNoOpenHour: UILabel!

    
    var objOpenHourCoachModal :OpenHourCoachModal!
    @IBOutlet weak var viewHorizontalCoachSelection: UIView!
    @IBOutlet weak var nslayoutconstraintWidthCollection: NSLayoutConstraint!
    @IBOutlet weak var nslayoutConstraintHeightCoachSelectionView: NSLayoutConstraint!
    @IBOutlet weak var tblViewList: UITableView!
    @IBOutlet weak var lblheader: UILabel!
    @IBOutlet var viewSeprators: [UIView]!
    var coachSelectionTableView = CoachSelectionTableView()
    @IBOutlet weak var lblMonth: UILabel!
    @IBOutlet weak var lblDay: UILabel!
    @IBOutlet weak var btnLeft: UIButton!
    @IBOutlet weak var btnRight: UIButton!
    @IBOutlet weak var viewCollectionHorizontalSelection: UICollectionView!
    @IBOutlet weak var viewCoachSelectionContainer: UIView!
    var currentIndex = 0
    var SelectedCoachIndex = 0;
    var calenderModal: CalenderModal?
    @IBOutlet weak var viewRestContainer: UIView!
    @IBOutlet weak var btnSelectTimeZOne: UIButton!
    var dashBoardViewModal = DashBoardViewModel()
    @IBOutlet weak var txtTimeZone: LeftPaddedTextField!
    @IBOutlet weak var lblTimeZone: UILabel!
    @IBOutlet weak var lblMore: UILabel!
    var dataFeedingModal : DashBoardModel?
    var selectedDataFeedingModal : DashBoardModel?
    var colectionViewHandler = CoachImageOverlayView();
    var colectionViewHandler2 = CoachImageOverlayView();
    @IBOutlet weak var viewCollection: UICollectionView!
    var selectedTextZone = ""
    @IBOutlet weak var btnCoachSelection: UIButton!
    var   timeZoneViewController : TimeZoneViewController!
    var timeZOneArr = [TimeZoneSel]()
    @IBAction func btnCoacheSelectionTapped(_ sender: UIButton) {
        
        if self.dataFeedingModal != nil{
            
        }
        else{
            return
        }
        
        let frameI =
            sender.superview?.convert(sender.frame.origin, to: nil)
        
        coachAluminiViewController = CoachAluminiViewController.init(nibName: "CoachAluminiViewController", bundle: nil)
        coachAluminiViewController.delegate = self
        coachAluminiViewController.pointSign = CGPoint.init(x: abs(frameI!.x) + abs(sender.frame.width/2), y: abs(frameI!.y) + abs(sender.frame.size.height/2) + 10 )
        coachAluminiViewController.viewControllerI = self
        coachAluminiViewController.modalPresentationStyle = .overFullScreen
        self.present(coachAluminiViewController, animated: false) {
        }
    }
    var coachAluminiViewController : CoachAluminiViewController!
    override func viewDidLoad() {
        super.viewDidLoad()
        GeneralUtility.customeNavigationBarWithBack(viewController: self,title:"Schedule");
        UserDefaultsDataSource(key: "timeZoneOffset").writeData(TimeZone.current.identifier)


        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.view.backgroundColor = ILColor.color(index: 22)

        otherApiHit()
        if (calenderModal != nil){
            
            self.convertNextDate(index: self.dateDifferenceLogic())
        }
        else{
            self.convertNextDate(index: 0)
        }
        self.viewRestContainer.dropShadowER()
        self.viewCoachSelectionContainer.dropShadowER()
        self.viewCoachSelectionContainer.isHidden = true
        self.viewRestContainer.isHidden = true
        dashBoardViewModal.viewController = self
        
        dashBoardViewModal.fetchTimeZoneCall { (timeArr) in
            self.viewCoachSelectionContainer.isHidden = false
            self.viewRestContainer.isHidden = false
            
            self.timeZOneArr = timeArr
            self.coachSelectedCheck()
            self.setTimeZoneTextField()
            self.setTableViewLogic()
            self.formingModal()
            
        }
        
        
        
        btnLeft.setImage(UIImage.init(named: "Left_arrow"), for: .normal)
        btnRight.setImage(UIImage.init(named: "right_arrow"), for: .normal)
        
        
        for viewInner in viewSeprators{
            viewInner.backgroundColor = ILColor.color(index:19);
            if viewInner.tag == 1011{
                viewInner.dropShadowSeprator()
            }
        }
        
    }
    
    
    func coachSelectedCheck(){
        
        if  self.selectedDataFeedingModal != nil &&  self.selectedDataFeedingModal?.coaches.count != 0{
            coachSelectedChanges()
            self.collectionViewDataFeed()
            self.makeModelInSyncWithSelected()
        }
        else
        {
            noCoachSelectedChanges()
            self.customizationLabel()
        }
        
        
        
    }
    
    func  noCoachSelectedChanges()  {
        
        nslayoutConstraintHeightCoachSelectionView.constant = 0
        self.viewHorizontalCoachSelection.isHidden = true
        self.noOpenHour.isHidden = false
        imgViewNoOpenHour.image = UIImage.init(named: "noopenhour")
        
        let fontHeavy1 = UIFont(name: "FontHeavy".localized(), size: Device.FONTSIZETYPE15)
        UILabel.labelUIHandling(label: lblNoOpenHour, text: "No Open hours", textColor:ILColor.color(index: 28) , isBold: false, fontType: fontHeavy1)
        self.tblViewList.isHidden = true
        lblheader.text = ""
    }
    
    
    func noCoachSelectedView(){
        self.noOpenHour.isHidden = false
        imgViewNoOpenHour.image = UIImage.init(named: "noopenhour")
        
        let fontHeavy1 = UIFont(name: "FontHeavy".localized(), size: Device.FONTSIZETYPE15)
        UILabel.labelUIHandling(label: lblNoOpenHour, text: "No Open hours", textColor:ILColor.color(index: 28) , isBold: false, fontType: fontHeavy1)
        self.tblViewList.isHidden = true
        lblheader.text = ""
        
    }
    func CoachSelectedView(){
        self.noOpenHour.isHidden = true
        self.tblViewList.isHidden = false
        let fontMedium = UIFont(name: "FontMedium".localized(), size: Device.FONTSIZETYPE16)
        UILabel.labelUIHandling(label: lblheader, text: "Click on slot to proceed next", textColor:ILColor.color(index: 4) , isBold: false, fontType: fontMedium)
        
    }
    
    
    
    
    
    func coachSelectedChanges(){
        nslayoutConstraintHeightCoachSelectionView.constant = 60
        self.viewHorizontalCoachSelection.isHidden = false
        self.noOpenHour.isHidden = true
        self.tblViewList.isHidden = false
        let fontMedium = UIFont(name: "FontMedium".localized(), size: Device.FONTSIZETYPE16)
        UILabel.labelUIHandling(label: lblheader, text: "Click on slot to proceed next", textColor:ILColor.color(index: 4) , isBold: false, fontType: fontMedium)
    }
    
    
    func setTimeZoneTextField()  {
        let fontHeavy = UIFont(name: "FontHeavy".localized(), size: Device.FONTSIZETYPE17)
        let fontHeavy1 = UIFont(name: "FontHeavy".localized(), size: Device.FONTSIZETYPE11)
        UILabel.labelUIHandling(label: lblTimeZone, text: "TimeZone", textColor:ILColor.color(index: 28) , isBold: false, fontType: fontHeavy)
        for timeZone in timeZOneArr{
            if timeZone.offset == GeneralUtility().currentOffset() && timeZone.identifier == GeneralUtility().getCurrentTimeZone(){
                selectedTextZone = timeZone.displayName!
                break
            }
        }
        self.txtTimeZone.text = selectedTextZone
        self.txtTimeZone.font = fontHeavy1
        self.txtTimeZone.layer.borderColor = ILColor.color(index: 27).cgColor
        self.txtTimeZone.layer.borderWidth = 1;
        self.txtTimeZone.layer.cornerRadius = 3;
        self.txtTimeZone.rightView = UIImageView.init(image: UIImage.init(named: "dropdown"))
        txtTimeZone.rightViewMode = .always;
        
        timeZoneViewController = TimeZoneViewController.init(nibName: "TimeZoneViewController", bundle: nil)
        timeZoneViewController.delegate = self
        timeZoneViewController.selectedTextZone = selectedTextZone
        timeZoneViewController.viewControllerI = self
        timeZoneViewController.modalPresentationStyle = .overFullScreen
        
        
    }
    
    
    
    func collectionViewDataFeed()  {
        self.customizationLabel()
        colectionViewHandler.viewcontrollerI = self
        colectionViewHandler.viewCollection = self.viewCollection
        colectionViewHandler.customize();
        colectionViewHandler2.viewcontrollerI = self
        colectionViewHandler2.delegate = self
        colectionViewHandler2.viewCollection = self.viewCollectionHorizontalSelection
        colectionViewHandler2.customize();
        
    }
    
    
    
    
    func makeModelInSyncWithSelected(){
        for coach in selectedDataFeedingModal!.coaches{
            let index = self.dataFeedingModal?.coaches.firstIndex(where: {$0.id == coach.id}) ?? 0
            self.dataFeedingModal?.coaches.removeAll(where: {$0.id == coach.id })
            self.dataFeedingModal?.coaches.insert(coach, at: index)
        }
    }
    
    
    
    func customizationLabel()
    {
        btnCoachSelection.setImage(UIImage.init(named: "coachSelection"), for: .normal)
        let fontHeavy = UIFont(name: "FontHeavy".localized(), size: Device.FONTSIZETYPE13)
        
        if  self.selectedDataFeedingModal != nil &&  selectedDataFeedingModal?.coaches.count != 0{
            nslayoutconstraintWidthCollection.constant = 146
            self.viewCollection.isHidden = false
            var coachText = selectedDataFeedingModal?.coaches[0].name
            if (selectedDataFeedingModal?.coaches.count ?? 0) > 1
            {
                coachText!.append(" +\((selectedDataFeedingModal?.coaches.count)! - 1 ) more")
            }
            var coachType = ""
            if selectedDataFeedingModal?.coaches[0].roleMachineName.rawValue == "career_coach"{
                coachType = "Career Coach"
            }
            else{
                coachType = "Alumni"
            }
            let strHeader = NSMutableAttributedString.init()
            if let fontHeavy = UIFont(name: "FontHeavy".localized(), size: Device.FONTSIZETYPE13), let fontBook =  UIFont(name: "FontBook".localized(), size: Device.FONTSIZETYPE14)
                
            {
                let strTiTle = NSAttributedString.init(string: GeneralUtility.optionalHandling(_param: coachText, _returnType: String.self)
                    , attributes: [NSAttributedString.Key.foregroundColor : ILColor.color(index:13),NSAttributedString.Key.font : fontHeavy]);
                let nextLine1 = NSAttributedString.init(string: "\n")
                let strType = NSAttributedString.init(string: GeneralUtility.optionalHandling(_param: coachType, _returnType: String.self)
                    , attributes: [NSAttributedString.Key.foregroundColor : ILColor.color(index: 13),NSAttributedString.Key.font : fontBook]);
                let para = NSMutableParagraphStyle.init()
                //            para.alignment = .center
                para.lineSpacing = 1
                strHeader.append(strTiTle)
                strHeader.append(nextLine1)
                strHeader.append(strType)
                strHeader.append(nextLine1)
                strHeader.addAttribute(NSAttributedString.Key.paragraphStyle, value: para, range: NSMakeRange(0, strHeader.length))
                lblMore.attributedText = strHeader
            }
            lblMore.layoutIfNeeded()
        }
        else{
            nslayoutconstraintWidthCollection.constant = 0
            self.viewCollection.isHidden = true
            UILabel.labelUIHandling(label: lblMore, text: "No Coach Selected", textColor:ILColor.color(index: 28) , isBold: false, fontType: fontHeavy)
            GeneralUtility.customeNavigationBarWithBack(viewController: self,title:"Schedule");

        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let coachCarrerCoach = Coach.init(id: -1, name: "Select All", email: "", profilePicURL: "", summary: "", headline: "", roleID: -1, roleMachineName: .careerCoach, requestedResumes: nil,isSelected: false)
        let coachExternalCoach = Coach.init(id: -1, name: "Select All", email: "", profilePicURL: "", summary: "", headline: "", roleID: -1, roleMachineName: .externalCoach, requestedResumes: nil,isSelected: false)
        self.dataFeedingModal?.coaches.insert(coachCarrerCoach, at: 0)
        self.dataFeedingModal?.coaches.insert(coachExternalCoach, at: 0)
    }
    
    
    override  func calenderClicked(sender: UIButton) {
        
        let frame = sender.convert(sender.frame, from:AppDelegate.getDelegate().window)
        
        let viewCalender = CalenderViewController.init(nibName: "CalenderViewController", bundle: nil)
        viewCalender.index = 1

        viewCalender.viewControllerI = self
        viewCalender.pointSign = CGPoint.init(x: abs(frame.origin.x) + abs(frame.size.width/2), y: abs(frame.origin.y) + abs(frame.size.height/2) + 10 )
        viewCalender.modalPresentationStyle = .overFullScreen
        self.present(viewCalender, animated: false) {
        }
        
    }
    override func buttonClicked(sender: UIBarButtonItem) {
        
        self.navigationController?.popViewController(animated: false)
        
    }
    
}
extension CoachSelectionViewController:CoachAluminiSelectionTableViewCellDelegate,CoachAluminiViewControllerDelegate{
    
    func syncSelectedModal(){
        let coachSelected = self.dataFeedingModal?.coaches.filter({$0.isSelected == true})
      
        var coachTemp = [Coach](),index = 0,inex1=0
        for var coachRemove in coachSelected!{
            if index == inex1{
                coachRemove.isExpanded = true
            
            }
            else
            {
                coachRemove.isExpanded = false

            }
            if coachRemove.id == -1
            {
                inex1 = 1
            }
            else{
                coachTemp.append(coachRemove)
            }
            index += 1
        }
        selectedDataFeedingModal?.coaches.removeAll();
        selectedDataFeedingModal?.coaches.append(contentsOf: coachTemp);
        SelectedCoachIndex = 0
    }
    
    func changeModal(modal: Coach, row: Int) {
        let dataFeedingModalLocal = self.dataFeedingModal;
        if row == 0
        {
            var coachArr = [Coach]()
            let selectedCoach =   self.dataFeedingModal?.coaches
            for var coaches in selectedCoach!{
                if coaches.roleMachineName.rawValue == modal.roleMachineName.rawValue{
                    coaches.isSelected = !modal.isSelected
                }
                   coachArr.append(coaches);
                
            }
            self.dataFeedingModal?.coaches.removeAll()
            self.dataFeedingModal?.coaches.append(contentsOf: coachArr);
        }
        else
        {
            let index = self.dataFeedingModal?.coaches.firstIndex(where: {$0.id == modal.id})
            var selectedCoach =   self.dataFeedingModal?.coaches.filter{
                $0.id == modal.id
                }[0];
            let selectedCoachI = selectedCoach;
            selectedCoach?.isSelected = !selectedCoachI!.isSelected
            
            self.dataFeedingModal?.coaches.remove(at: index!)
            self.dataFeedingModal?.coaches.insert(selectedCoach!, at: index!)
        }
        
       
            syncSelectedModal()
            coachAluminiViewController.customize()
    }
    
    func reloadCollectionView()
    {
        if selectedDataFeedingModal != nil && self.selectedDataFeedingModal?.coaches.count != 0{
            coachSelectedChanges()
            self.collectionViewDataFeed()
            self.makeModelInSyncWithSelected()
        }
        else
        {
            noCoachSelectedChanges()
            self.customizationLabel()
        }
        self.formingModal()
    }
}


extension CoachSelectionViewController{
    // Time Zone
    @IBAction func btnSelectTimeZoneTapped(_ sender: UIButton) {
        let frameI =
        txtTimeZone.superview?.convert(txtTimeZone.frame, to: nil)
        
        timeZoneViewController.txtfieldRect = frameI
        self.present(timeZoneViewController, animated: false) {
            self.timeZoneViewController.reloadTableview()
        }
    }
}


extension CoachSelectionViewController: TimeZoneViewControllerDelegate{
    func sendTimeZoneSelected(timeZone: TimeZoneSel) {
        self.txtTimeZone.text = timeZone.displayName
        formingModal()
        
        
    }
    
}


extension CoachSelectionViewController: CoachImageOverlayViewDelegate{
    func selectedDifferentCoach(coach: Coach) {
        var coachaI = [Coach]()
        var index = 0
        for var coaches in selectedDataFeedingModal!.coaches{
            if coaches.id == coach.id
            {
                coaches.isExpanded = true
                SelectedCoachIndex = index
            }
            else
            {
                coaches.isExpanded = false
            }
            coachaI.append(coaches)
            index += 1
        }
        self.selectedDataFeedingModal?.coaches.removeAll()
        self.selectedDataFeedingModal?.coaches.append(contentsOf: coachaI)
        colectionViewHandler2.customize()
        
       
        coachSelectionTableView.results = objOpenHourCoachModal.results?.filter({
            GeneralUtility.optionalHandling(_param: $0.createdByID, _returnType: String.self) == "\(coach.id)"
        })
        coachSelectionTableView.customizeTableView()

        if coachSelectionTableView.results?.count == 0{
            noCoachSelectedView()
        }
        else{
            CoachSelectedView()
        }
        
        
    }
}

extension CoachSelectionViewController {
    
    @IBAction func btnleftTapped(_ sender: UIButton) {
        currentIndex -= 1
        self.convertNextDate(index: currentIndex)
         self.formingModal()
    }
       
    @IBAction func btnRightTapped(_ sender: UIButton) {
        currentIndex += 1
        self.convertNextDate(index: currentIndex)
         self.formingModal()
    }
    
    
    
    func convertNextDate(index : Int){
        let weekDay = ["Sun","Mon","Tue","Wed","Thu","Fri","Sat"]
        let monthI   = ["Jan","Feb","Mar","Apr","May","Jun","July","Aug","Sep","Oct","Nov","Dec"]
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let tomorrow = Calendar.current.date(byAdding: .day, value: index, to: Date())
        
        let components = tomorrow!.get(.day, .month, .year,.weekday)
        let fontMedium = UIFont(name: "FontMedium".localized(), size: Device.FONTSIZETYPE16)
        let fontHeavy1 = UIFont(name: "FontHeavy".localized(), size: Device.FONTSIZETYPE15)

        
        
        if let day = components.day, let month = components.month, let year = components.year,let weekday = components.weekday {
            UILabel.labelUIHandling(label: lblDay, text: "\(weekDay[weekday-1]) " + "\(day)", textColor:ILColor.color(index: 4) , isBold: false, fontType: fontHeavy1)
            
            UILabel.labelUIHandling(label: lblMonth, text: "\(monthI[month-1]), " + "\(year)", textColor:ILColor.color(index: 4) , isBold: false, fontType: fontHeavy1)
        }
        
        var calenderModal = CalenderModal()
        calenderModal.StrDate = dateFormatter.string(from: tomorrow!)
        self.calenderModal = calenderModal
        
    }
}


extension CoachSelectionViewController: CalenderViewDelegate{
    func dateSelected(calenderModal: CalenderModal,index : Int) {
        self.calenderModal = calenderModal;
        self.convertNextDate(index: self.dateDifferenceLogic())
        self.formingModal()
        
    }
    
    func dateDifferenceLogic()-> Int{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        let date = dateFormatter.date(from: (calenderModal?.StrDate)!)
        let currentCalendar = Calendar.current
        let end  = currentCalendar.ordinality(of: .day, in: .era, for: date!)
        let  start = currentCalendar.ordinality(of: .day, in: .era, for: Date())
        
        currentIndex = end! - start!
        return (end! - start!)
    }

     
    
    
    
}

//Mark : ViewModalLogic

extension CoachSelectionViewController:CoachSelectionViewModalDelegate{
    
    func completeModal(coachOpenHourModal: OpenHourCoachModal) {
            
        objOpenHourCoachModal = coachOpenHourModal
        let firstSelected = self.selectedDataFeedingModal?.coaches[SelectedCoachIndex];
        coachSelectionTableView.results = objOpenHourCoachModal.results?.filter({
            GeneralUtility.optionalHandling(_param: $0.createdByID, _returnType: String.self) == "\(firstSelected!.id)"
        })
    
        
        coachSelectionTableView.customizeTableView()
        if coachSelectionTableView.results?.count == 0{
            noCoachSelectedView()
        }
        else{
            CoachSelectedView()
        }
        
        
    }
    func formingModal()  {
        if self.selectedDataFeedingModal != nil &&  self.selectedDataFeedingModal?.coaches.count != 0{
            let coachSelectionViewModal = CoachSelectionViewModal()
            coachSelectionViewModal.selectedDataModal = self.selectedDataFeedingModal
            coachSelectionViewModal.dateStirng = self.calenderModal?.StrDate;
            coachSelectionViewModal.delegate = self
            coachSelectionViewModal.viewController = self
            coachSelectionViewModal.apiLogic()
        }
        else
        {
//            CommonFunctions().showError(title: "Error", message: StringConstants.cantDeselectAll)
        }
    }
}

// Mark : TableView Logic


extension CoachSelectionViewController{
    func setTableViewLogic()  {
        coachSelectionTableView.tblViewList = self.tblViewList
        coachSelectionTableView.viewControllerI = self
        coachSelectionTableView.customizeTableView()
       
    }
    
}


// Other APis

extension CoachSelectionViewController:passDataSecondViewDelegate,
CoachConfirmationPopUpSecondViewCDelegate
{
    func refreshSelectionView(isBack : Bool, results: OpenHourCoachModalResult!) {
        if isBack{
            
            let coachConfirmation = CoachConfirmationPopUpFirstViewC.init(nibName: "CoachConfirmationPopUpFirstViewC", bundle: nil)
            coachConfirmation.delegate = self
            coachConfirmation.dataFeedingModal = self.dataFeedingModal
            coachConfirmation.results = results
            coachConfirmation.modalPresentationStyle = .overFullScreen
            self.present(coachConfirmation, animated: false) {
                
            }
        }
        else
        {
            self.formingModal()
        }
        
        
    }
    
    func passData(results: OpenHourCoachModalResult) {
        
        let coachConfirmation = CoachConfirmationPopUpSecondViewC.init(nibName: "CoachConfirmationPopUpSecondViewC", bundle: nil)
        coachConfirmation.resueStudentFunctionI = self.resueStudentFunctionI
        coachConfirmation.resueStudentIndustryI = self.resueStudentIndustryI
        coachConfirmation.delegate = self
        
        coachConfirmation.results = results
        coachConfirmation.modalPresentationStyle = .overFullScreen
        self.present(coachConfirmation, animated: false) {
            
        }
    }
    
    func studentHit()
    {
        IndustriesFunctionViewModal().studentFunction({ (response) in
            
            do {
                if response["results"].exists() && response["results"].count > 0 {
                    try self.setupStudentFunction(response: response)
                }
                else
                {
                    //                    self.studentHit()
                }
            } catch  {
                //                self.studentHit()
            }
            
            
        }) { (error, errorCode) in
            
        }
        
    }
    
    
    func studentIndustries()
    {
        IndustriesFunctionViewModal().studentIndustries({ (response) in
            do {
                try self.setupStudentIndustries(response: response);
            } catch {
                //                self.studentIndustries()
            }
            
        }) { (error, errorCode) in
            //            self.studentIndustries()
        }
    }
    
    
    
    func otherApiHit(){
        self.studentHit()
        self.studentIndustries()
    }
    
    
    func setupStudentFunction(response : JSON)  throws{
        var resueStudentFunction : StudentFunctionSurvey = StudentFunctionSurvey()
        resueStudentFunction.results = [Result]()
        for (_,result) in response["results"]{
            var resultI = Result();
            resultI.id = result["id"].int ?? 0
            resultI.name = result["name"].string ?? ""
            resultI.isPopular = result["is_popular"].string ?? ""
            resueStudentFunction.results.append(resultI);
        }
        self.resueStudentFunctionI = resueStudentFunction;
    }
    
    func setupStudentIndustries(response : JSON)  throws{
        var resueStudentIndustry : [StudentIndustrySurvey] = [StudentIndustrySurvey]()
        for (_,industry) in response{
            var industryI = StudentIndustrySurvey();
            industryI.id = industry["id"].int ?? 0
            industryI.name = industry["name"].string ?? ""
            resueStudentIndustry.append(industryI);
        }
        self.resueStudentIndustryI = resueStudentIndustry;
        
        
    }
    
    
    
}


