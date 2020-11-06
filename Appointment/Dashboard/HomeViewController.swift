//
//  HomeViewController.swift
//  Appointment
//
//  Created by Anurag Bhakuni on 08/07/20.
//  Copyright © 2020 Anurag Bhakuni. All rights reserved.
//

import UIKit


enum userType {
    case ER
    case Student
    case StudentMyAppointment

}
enum RedirectionType {
    case profile
    case about
    case coachSelection
    case feedback
    case appointmentDetail
    case cancelAppoinment

}




class HomeViewController: SuperViewController,UISearchBarDelegate {
    
    
    var calenderModal: CalenderModal?
    
    @IBOutlet weak var btnSelectMuliple: UIButton!
    var isAnyCoachSelected = false
    
    
    @IBAction func btnSelectMultipleTapped(_ sender: Any) {
        self.redirection(redirectionType: .coachSelection)
        
    }
    
    
    @IBOutlet weak var viewZeroState: UIView!
    @IBOutlet weak var imageViewZeroState: UIImageView!
    @IBOutlet weak var lblZeroState: UILabel!
    var redirectTypeI : RedirectionType!
    @IBOutlet weak var tblView: UITableView!
    var userTypeHome : userType!
    @IBOutlet weak var viewHeader: UIView!
    var dataFeedingModal : DashBoardModel?
    var selectedDataFeedingModal : DashBoardModel?
    
    var dashBoardViewModal = DashBoardViewModel()
    var dashBoardViewStudentApVModal = DashBoardStudentAppointmentVM()
    var selectedAppointmentModal : OpenHourCoachModalResult?
    
    var refreshControl = UIRefreshControl()

    
    var dataFeedingAppointmentModal :OpenHourCoachModal?
    var dataFeedingAppointmentModalConst :OpenHourCoachModal?
    
    var tableviewHandlerAppointment = HomeMyAppointmentTableViewController()
    
    
    
    var dataFeedingModalConst : DashBoardModel?
    var tableviewHandler = HomeTableView()
    override func viewDidLoad() {
        super.viewDidLoad()
        UserDefaultsDataSource(key: "timeZoneOffset").writeData(TimeZone.current.identifier)

        switch userTypeHome {
        case .Student:
            self.callingViewModal(isbackGroundHit: false)
                         break;
        case .StudentMyAppointment:
            
            self.studentAppoimnetViewModal(isbackGroundHit: false)
            break;
            
            
        default:
            break;
        }
        
        
        self.view.backgroundColor = ILColor.color(index: 41)
        
       
        // Do any additional setup after loading the view.
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: nil, completion: { (_) in
            
            switch self.userTypeHome {
            case .Student:
                if self.viewHeader.subviews.count > 0
                {
                    
                    (self.viewHeader.subviews[0] as! HorizontalCalender).backToBasic()
                    (self.viewHeader.subviews[0] as! HorizontalCalender).viewCollection.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
                    
                    let layout : UICollectionViewFlowLayout =  (self.viewHeader.subviews[0] as! HorizontalCalender).viewCollection.collectionViewLayout as! UICollectionViewFlowLayout
                    let frame = (self.viewHeader.subviews[0] as! HorizontalCalender).viewCollection.frame
                    layout.itemSize = CGSize(width: frame.width, height: frame.height)
                    layout.invalidateLayout()
                    
                    
                }
                break;
            case .StudentMyAppointment:
                break;
            default:
                break;
            }
        })
        
    }

    
    override func searchEvent(sender: UIBarButtonItem) {
        
        
        switch userTypeHome {
        case .Student:
            
            guard dataFeedingModalConst != nil else {
               
                return
            }
            
            GeneralUtility.customeNavigationBarTextfield(viewController: self, searchText: "");
            break;
        case .StudentMyAppointment:
            
            guard dataFeedingAppointmentModalConst != nil else {
                return
            }
            
            
            GeneralUtility.customeNavigationBarTextfield(viewController: self, searchText: "");
            
            break;
            
        default:
            break;
        }
        
        
    }
    
    override  func calenderClicked(sender: UIButton) {
        
        switch userTypeHome {
        case .Student:
            guard dataFeedingModalConst != nil else {
                return
            }
            break;
        case .StudentMyAppointment:
            guard dataFeedingAppointmentModalConst != nil else {
                return
            }
            break;
        default:
            break;
        }
        let frame = sender.convert(sender.frame, from:AppDelegate.getDelegate().window)
        let viewCalender = CalenderViewController.init(nibName: "CalenderViewController", bundle: nil)
        viewCalender.viewControllerI = self
        viewCalender.pointSign = CGPoint.init(x: abs(frame.origin.x) + abs(frame.size.width/2), y: abs(frame.origin.y) + abs(frame.size.height/2) + 10 )
        viewCalender.modalPresentationStyle = .overFullScreen
        self.present(viewCalender, animated: false) {
        }
    }
    
    override func logout(sender: UIButton) {
        
        GeneralUtility.alertViewLogout(title: "".localized(), message: "LOGOUT".localized(), viewController: self, buttons: ["Cancel","Ok"]);
        
        
    }
    override func changeNavigation(sender: UIBarButtonItem) {
        GeneralUtility.customeNavigationBar(viewController: self,title:"Schedule");
        self.dataFeedingModal = self.dataFeedingModalConst
        self.zeroStateLogic()
        self.reloadTablviewCocahList()
        
    }
    
    
    func zeroStateLogic()  {
        if self.dataFeedingModal?.coaches.count == 0
        {
            let fontMedium = UIFont(name: "FontMedium".localized(), size: Device.FONTSIZETYPE13)
            
            self.viewZeroState.isHidden = false
            self.viewZeroState.backgroundColor = ILColor.color(index: 22)
            
            self.tblView.isHidden = true
            UILabel.labelUIHandling(label: lblZeroState, text: "No Coach/Alumni available for schedule", textColor:ILColor.color(index: 28) , isBold: false, fontType: fontMedium)
            self.imageViewZeroState.image = UIImage.init(named: "nocoach_Alumni")
        }
        else{
            self.viewZeroState.isHidden = true
            self.tblView.isHidden = false
            
        }
    }
    
    func isCoachSelected()  {
        
        
        isAnyCoachSelected = false
        guard self.dataFeedingModal != nil else {
            return
        }
        for Coach in self.dataFeedingModal!.coaches{
            if Coach.isSelected{
                isAnyCoachSelected = true
                break
            }
        }
        
        self.changeBottomBtn(isVisible: isAnyCoachSelected)
    }
    
    
    func reloadTablviewCocahList()  {
        tableviewHandler.customization()
        if  isAnyCoachSelected{
            self.tblView.contentSize.height = self.tblView.contentSize.height + 100
        }
    }
    
    
    
    @objc func refreshControlAPi(){
        switch userTypeHome {
        case .Student:
            self.callingViewModal(isbackGroundHit: true)
            break;
        case .StudentMyAppointment:
            
            self.studentAppoimnetViewModal(isbackGroundHit: true)
            break;
            
            
        default:
            break;
        }
        
    }
    
    
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        
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
        
        
        
        
        
        AppUtility.lockOrientation(.all)
        switch userTypeHome {
        case .Student:
            studentBottomLogic()
            GeneralUtility.customeNavigationBar(viewController: self,title:"Schedule");
            
            self.dataFeedingModal = self.dataFeedingModalConst
            self.zeroStateLogic()
            self.reloadTablviewCocahList()
            isCoachSelected()
            
            
            break;
        case .StudentMyAppointment:
            GeneralUtility.customeNavigationBarMyAppoinment(viewController: self,title:"My Appointments");
            
            break;
            
        default:
            break;
        }
        
        
    }
    
    func studentBottomLogic()  {
        btnSelectMuliple.isHidden = true
        let fontHeavy2 = UIFont(name: "FontHeavy".localized(), size: Device.FONTSIZETYPE15)
        
        btnSelectMuliple.layoutIfNeeded()
        UIButton.buttonUIHandling(button: btnSelectMuliple, text: "Schedule an Appointment", backgroundColor:ILColor.color(index: 24)  , textColor:.white , cornerRadius: 5, isUnderlined: false, fontType: fontHeavy2)
        
        self.isCoachSelected()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        self.dataFeedingModal = self.dataFeedingModalConst
        if searchBar.text != ""
        {
            let filterdcoahes =  self.dataFeedingModal?.coaches.filter{
                $0.name.lowercased().contains(searchBar.text!.lowercased())
            }
            self.dataFeedingModal?.coaches = filterdcoahes!
            self.zeroStateLogic()
            self.reloadTablviewCocahList()
        }
        searchBar.resignFirstResponder();
    }
    
    
    func callingViewModal(isbackGroundHit : Bool)  {
        
        let param : Dictionary<String, AnyObject> = ["roles":["external_coach","career_coach"]] as Dictionary<String, AnyObject>
        
        dashBoardViewModal.viewController = self
        dashBoardViewModal.isbackGroundHit = isbackGroundHit
        dashBoardViewModal.fetchCall(params: param,success: { (dashboardModel) in
            self.dataFeedingModal = dashboardModel
            self.refreshControl.endRefreshing()

            var sectionHeaderI = [sectionHead]()
            let section1 = sectionHead.init(name: "Select all Coaches", id:"career_coach", selectAll: false, seeAll: false)
            sectionHeaderI.append(section1);
            
            let section2 = sectionHead.init(name: "Select all Alumni", id:"external_coach", selectAll: false, seeAll: false)
            sectionHeaderI.append(section2);
            self.dataFeedingModal?.sectionHeader = sectionHeaderI
            self.dataFeedingModalConst = self.dataFeedingModal;
            self.zeroStateLogic()
            self.customization()
            
            
            
        }) { (error, errorCode) in
            
            
        }
    }
    
    
    
    
    func customization()  {
        switch userTypeHome {
        case .ER:
            break
        case .Student:
            let myView = Bundle.loadView(fromNib: "HorizontalCalender", withType: HorizontalCalender.self)
            myView.frame = CGRect.init(x: 0, y: 0, width: viewHeader.frame.width, height: viewHeader.frame.height);
            viewHeader.addSubview(myView);
            myView.enumHeadType = .student
            myView.customize()
        default:
            break
        }
        tableviewHandler.viewControllerI = self
        tblView.register(UINib.init(nibName: "CoachListingTableViewCell", bundle: nil), forCellReuseIdentifier: "CoachListingTableViewCell")
        let headerNib = UINib.init(nibName: "HeaderSectionCoach", bundle: Bundle.main)
        tblView.register(headerNib, forHeaderFooterViewReuseIdentifier: "HeaderSectionCoach")
        tableviewHandler.customization()
    }
    
    
    
    
}

extension HomeViewController : CoachListingTableViewCellDelegate,HeaderSectionCoachDelegate{
    
    func withSeeAll(modal: sectionHead, seeMore: Bool)  {
        
        let index =    self.dataFeedingModal?.sectionHeader?.firstIndex(where: {$0.id == modal.id})
        
        var selectedHeader =   self.dataFeedingModal?.sectionHeader!.filter{
            $0.id == modal.id
            }[0];
        let selectedHeaderI = selectedHeader;
        
        let selectedCoach =   self.dataFeedingModal?.coaches.filter{
            $0.roleMachineName.rawValue == modal.id
        };
        
        if selectedHeaderI!.selectAll {
            var coachArr = [Coach]()
            for var coaches in selectedCoach!{
                coaches.isSelected = false
                coachArr.append(coaches);
            }
            self.dataFeedingModal?.coaches.removeAll(where: {
                $0.roleMachineName.rawValue == modal.id
                
            })
            self.dataFeedingModal?.coaches.append(contentsOf: coachArr);
        }
        else
        {
            var coachArr = [Coach]()
            for var coaches in selectedCoach!{
                coaches.isSelected = true
                coachArr.append(coaches);
            }
            self.dataFeedingModal?.coaches.removeAll(where: {
                $0.roleMachineName.rawValue == modal.id
                
            });
            self.dataFeedingModal?.coaches.append(contentsOf: coachArr);
        }
        selectedHeader?.selectAll = !selectedHeaderI!.selectAll
        
        self.dataFeedingModal?.sectionHeader?.remove(at: index!)
        self.dataFeedingModal?.sectionHeader?.insert(selectedHeader!, at: index!)
        self.zeroStateLogic()
        isCoachSelected()
        self.reloadTablviewCocahList()
        
        
        
    }
    
    func withSeeLess(modal: sectionHead, seeMore: Bool)  {
        let index =    self.dataFeedingModal?.sectionHeader?.firstIndex(where: {$0.id == modal.id})
        var selectedHeader =   self.dataFeedingModal?.sectionHeader!.filter{
            $0.id == modal.id
            }[0];
        let selectedHeaderI = selectedHeader;
        
        let selectedCoach =   self.dataFeedingModal?.coaches.filter{
            $0.roleMachineName.rawValue == modal.id
        }.prefix(2);
        
        if selectedHeaderI!.selectAll {
            var coachArr = [Coach]()
            for var coaches in selectedCoach!{
                coaches.isSelected = false
                coachArr.append(coaches);
            }
            
            
            var array =   self.dataFeedingModal?.coaches.filter{
                $0.roleMachineName.rawValue == modal.id
            }
            
            let range = 0...1
            array!.removeSubrange(range)
            array?.insert(contentsOf: coachArr, at: 0)
            
            self.dataFeedingModal?.coaches.removeAll(where: {
                $0.roleMachineName.rawValue == modal.id
                
            })
            
            self.dataFeedingModal?.coaches.insert(contentsOf: array!, at: 0)
        }
        else
        {
            var coachArr = [Coach]()
            for var coaches in selectedCoach!{
                coaches.isSelected = true
                coachArr.append(coaches);
            }
            
            var array =   self.dataFeedingModal?.coaches.filter{
                $0.roleMachineName.rawValue == modal.id
            }
            let range = 0...1
            array!.removeSubrange(range)
            array?.insert(contentsOf: coachArr, at: 0)
            self.dataFeedingModal?.coaches.removeAll(where: {
                $0.roleMachineName.rawValue == modal.id
                
            })
            self.dataFeedingModal?.coaches.insert(contentsOf: array!, at: 0)
        }
        selectedHeader?.selectAll = !selectedHeaderI!.selectAll
        self.dataFeedingModal?.sectionHeader?.remove(at: index!)
        self.dataFeedingModal?.sectionHeader?.insert(selectedHeader!, at: index!)
        self.zeroStateLogic()
        isCoachSelected()
        self.reloadTablviewCocahList()
        
    }
    
    func changeModal(modal: sectionHead, seeMore: Bool) {
        
        if modal.id == "-10" || modal.id == "-09"{
            // MY APPOINTMENT LOGIC
            let index =    self.dataFeedingAppointmentModal?.sectionHeader?.firstIndex(where: {$0.id == modal.id})
            var selectedHeader =   self.dataFeedingAppointmentModal?.sectionHeader!.filter{
                $0.id == modal.id
                }[0];
            var selectedHeaderI = selectedHeader;
            selectedHeaderI!.seeAll = !selectedHeader!.seeAll
            self.dataFeedingAppointmentModal?.sectionHeader?.remove(at: index ?? 0)
            self.dataFeedingAppointmentModal?.sectionHeader?.insert(selectedHeaderI!, at: index ?? 0)
            self.zeroStateLogicAppointment()
            tableviewHandlerAppointment.customizaTionMyApointment()
            
        }
        else{
            
            
            let index =    self.dataFeedingModal?.sectionHeader?.firstIndex(where: {$0.id == modal.id})
            var selectedHeader =   self.dataFeedingModal?.sectionHeader!.filter{
                $0.id == modal.id
                }[0];
            let selectedHeaderI = selectedHeader;
            
            if seeMore{
                selectedHeader?.seeAll = !selectedHeaderI!.seeAll
                self.dataFeedingModal?.sectionHeader?.remove(at: index!)
                self.dataFeedingModal?.sectionHeader?.insert(selectedHeader!, at: index!)
                self.zeroStateLogic()
                isCoachSelected()
                self.reloadTablviewCocahList()
                
            }
            else
            {
                
                if (self.dataFeedingModal?.coaches.filter({$0.roleMachineName.rawValue == modal.id}).count ?? 0) <= 0{
                    return
                }
                
                
                
                if selectedHeaderI!.seeAll{
                    self.withSeeAll(modal: modal, seeMore: seeMore)
                }
                else
                {
                    if (self.dataFeedingModal?.coaches.count)! < 2
                    {
                        self.withSeeAll(modal: modal, seeMore: seeMore)
                    }
                    else{
                        self.withSeeLess(modal: modal, seeMore: seeMore)
                    }
                    
                }
            }
        }
    }
    
    
    func changeModal(modal:Coach,seeMore:Bool ){
        let index = self.dataFeedingModal?.coaches.firstIndex(where: {$0.id == modal.id})
        var selectedCoach =   self.dataFeedingModal?.coaches.filter{
            $0.id == modal.id
            }[0];
        let selectedCoachI = selectedCoach;
        if seeMore {
            selectedCoach?.isExpanded = !selectedCoachI!.isExpanded
        }
        else
        {
            selectedCoach?.isSelected = !selectedCoachI!.isSelected
        }
        self.dataFeedingModal?.coaches.remove(at: index!)
        self.dataFeedingModal?.coaches.insert(selectedCoach!, at: index!)
        self.zeroStateLogic()
        isCoachSelected()
        self.reloadTablviewCocahList()
    }
    
    func changeBottomBtn(isVisible: Bool)  {
        btnSelectMuliple.isHidden = !isVisible
        
    }
    
    func scheduleAppoinment(modal: Coach) {
        self.redirection(redirectionType: .coachSelection)
        
    }
    
    
    
}

extension HomeViewController : HomeViewcontrollerRedirection{
    
    func selectedModal() -> DashBoardModel?  {
        
        if (self.dataFeedingModal?.coaches.count ?? 0) > 0 {
            
        }
        else{
            return nil
        }
        
        var selectedModal = self.dataFeedingModal;
        var coachesI = [Coach]()
        var index = 0;
        
        let coachSelected = self.dataFeedingModal?.coaches.filter({$0.isSelected == true})
        
        for var coaches in coachSelected!
        {
            if index == 0{
                coaches.isExpanded = true
            }
            else
            {
                coaches.isExpanded = false
                
            }
            coachesI.append(coaches)
            index += 1
        }
        selectedModal?.coaches.removeAll()
        selectedModal?.coaches.append(contentsOf: coachesI)
        return selectedModal!
    }
    
    func redirectToParticularViewController(type : RedirectionType)  {
        slideMenuController()?.closeLeft();
        switch type {
        case .profile:
            //            let wvc = UIStoryboard.profileView()
            //            self.navigationController?.pushViewController(wvc, animated: true)
            break
        case .about:
            break
        default:
            break
        }
    }
    
}

extension HomeViewController: CalenderViewDelegate,feedbackViewControllerDelegate{
    func feedbackSucessFullySent() {
        dashBoardViewStudentApVModal.customizeVM();

    }
    
    func dateSelected(calenderModal: CalenderModal) {
        self.calenderModal = calenderModal
        self.redirection(redirectionType: .coachSelection)
        
    }
    
    
    
}



extension HomeViewController{
    func redirection(redirectionType : RedirectionType)  {
        switch redirectionType {
        case .about:
            break
        case .coachSelection:
            
            isCoachSelected()
            self.reloadTablviewCocahList()
            let coachSelectionViewController = CoachSelectionViewController.init(nibName: "CoachSelectionViewController", bundle: nil)
            coachSelectionViewController.selectedDataFeedingModal = self.selectedModal()
            if self.calenderModal != nil{
                coachSelectionViewController.calenderModal = self.calenderModal
                
            }
            coachSelectionViewController.dataFeedingModal = self.dataFeedingModalConst
            self.navigationController?.pushViewController(coachSelectionViewController, animated: false)
            
            break
        case .profile:
            break
            
        case .feedback:
            let objFeedbackViewController = FeedbackViewController.init(nibName: "FeedbackViewController", bundle: nil)
            
            objFeedbackViewController.delegate = self
            objFeedbackViewController.selectedAppointmentModal = selectedAppointmentModal
            
            objFeedbackViewController.modalPresentationStyle = .overFullScreen
            self.present(objFeedbackViewController, animated: false, completion: nil)
            
            
            break
        case .appointmentDetail:
            
            let appoinmentDetailViewController = AppointmentDetailViewController.init(nibName: "AppointmentDetailViewController", bundle: nil)
            
            appoinmentDetailViewController.selectedAppointmentModal = selectedAppointmentModal
            self.navigationController?.pushViewController(appoinmentDetailViewController, animated: false)
            
            
            break
            
        case .cancelAppoinment:
            
            let appoinmentCancelViewController = AppointmentCancelViewController.init(nibName: "AppointmentCancelViewController", bundle: nil)
            appoinmentCancelViewController.selectedAppointmentModal = selectedAppointmentModal
            appoinmentCancelViewController.delegate = self
            appoinmentCancelViewController.modalPresentationStyle = .overFullScreen
            self.present(appoinmentCancelViewController, animated: false, completion: nil)
            
            break
            
            
            
        default:
            break
        }
    }
    
}


// ALL STUDENT APPOINMENT LOGIC

extension HomeViewController:DashBoardStudentAppointmentVMDelegate,DashBoardAppointmentTableViewCellDelegate,EditNotesViewControllerDelegate{
    func refreshApi() {
                dashBoardViewStudentApVModal.customizeVM();
    }
    
    
    // 1 : - Feedback
    // 2 :- View Detail
    // 3:- Cancel
    
    
    func redirectAppoinment(openMOdal: OpenHourCoachModalResult, isFeedback: Int) {
        selectedAppointmentModal = openMOdal;
        if isFeedback == 1{
            self.redirection(redirectionType: .feedback)

        }
         else if isFeedback == 2{
            self.redirection(redirectionType: .appointmentDetail)

        }
        else {
            self.redirection(redirectionType: .cancelAppoinment)
        }
        
    }
    
    
    
    
    func sentDataViewController(dataAppoinmentModal: OpenHourCoachModal) {
        
        self.refreshControl.endRefreshing()
        
        self.dataFeedingAppointmentModal = dataAppoinmentModal
        var sectionHeaderI = [sectionHead]()
        let section1 = sectionHead.init(name: "Upcoming Appointments", id:"-09", selectAll: false, seeAll: false)
        sectionHeaderI.append(section1);
        let section2 = sectionHead.init(name: "Past Appointments", id:"-10", selectAll: false, seeAll: false)
        sectionHeaderI.append(section2);
        self.dataFeedingAppointmentModal?.sectionHeader = sectionHeaderI
        self.dataFeedingAppointmentModalConst = self.dataFeedingAppointmentModal;
        self.zeroStateLogicAppointment()
        self.customizationAppointment()
        
        
    }
    
    
    
    func zeroStateLogicAppointment()  {
        if self.dataFeedingAppointmentModal?.results?.count == 0
        {
            let fontMedium = UIFont(name: "FontMedium".localized(), size: Device.FONTSIZETYPE13)
            
            self.viewZeroState.isHidden = false
            self.viewZeroState.backgroundColor = ILColor.color(index: 41)
            
            self.tblView.isHidden = true
            UILabel.labelUIHandling(label: lblZeroState, text: "No Appointments available", textColor:ILColor.color(index: 28) , isBold: false, fontType: fontMedium)
            self.imageViewZeroState.image = UIImage.init(named: "nocoach_Alumni")
        }
        else{
            self.viewZeroState.isHidden = true
            self.tblView.isHidden = false
            
        }
    }
    
    func customizationAppointment()  {
        btnSelectMuliple.isHidden = true
        
        let myView = Bundle.loadView(fromNib: "HorizontalCalender", withType: HorizontalCalender.self)
        myView.frame = CGRect.init(x: 0, y: 0, width: viewHeader.frame.width, height: viewHeader.frame.height);
        viewHeader.addSubview(myView);
        myView.enumHeadType = .student
        myView.customize()
        
        tableviewHandlerAppointment.viewControllerI = self
        tblView.register(UINib.init(nibName: "DashBoardAppointmentTableViewCell", bundle: nil), forCellReuseIdentifier: "DashBoardAppointmentTableViewCell")
        
        let headerNib = UINib.init(nibName: "HeaderSectionCoach", bundle: Bundle.main)
        tblView.register(headerNib, forHeaderFooterViewReuseIdentifier: "HeaderSectionCoach")
        tableviewHandlerAppointment.customizaTionMyApointment()
    }
    
    
    
    func studentAppoimnetViewModal(isbackGroundHit: Bool)  {
        dashBoardViewStudentApVModal.viewController = self
        dashBoardViewStudentApVModal.isbackGroundHit =  isbackGroundHit
        dashBoardViewStudentApVModal.delegate = self
        let viewcontrollerfirst = ((self.tabBarController?.viewControllers![0])! as! HomeViewController)
        if viewcontrollerfirst.dataFeedingModalConst != nil{
            dashBoardViewStudentApVModal.dashBoardModal = viewcontrollerfirst.dataFeedingModalConst
        }
        dashBoardViewStudentApVModal.customizeVM();
        
    }
    
}





