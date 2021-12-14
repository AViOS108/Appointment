//
//  HomeViewController.swift
//  Appointment
//
//  Created by Anurag Bhakuni on 08/07/20.
//  Copyright © 2020 Anurag Bhakuni. All rights reserved.
//

import UIKit


enum userType {
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
    case logOut
    case blackout

    case adhoc
    case setAppo


}




class HomeViewController: SuperViewController,UISearchBarDelegate {
    
    @IBOutlet weak var nslayoutMarkAllViewheight: NSLayoutConstraint!
    @IBOutlet weak var viewMarkAll: UIView!
    @IBOutlet weak var btnMarkAll: UIButton!
    var markAllSelected = false
    @IBAction func btnMarkAllTapped(_ sender: UIButton) {
        
    
        if markAllSelected{
            
            let allCoach  = self.dataFeedingModal?.items.map{  dataItem -> Item  in
                var itemSelected = dataItem
                itemSelected.isSelected = false
                return itemSelected
            }
            
            self.dataFeedingModal?.items.removeAll()
            self.dataFeedingModal?.items.append(contentsOf: allCoach!)
            self.zeroStateLogic()
            isCoachSelected()
            self.reloadTablviewCocahList()
        }
        else{
            
            let allCoach  = self.dataFeedingModal?.items.map{  dataItem -> Item  in
                var itemSelected = dataItem
                itemSelected.isSelected = true
                return itemSelected
            }
            
            self.dataFeedingModal?.items.removeAll()
            self.dataFeedingModal?.items.append(contentsOf: allCoach!)
            self.zeroStateLogic()
            isCoachSelected()
            self.reloadTablviewCocahList()
        }
        
        markAllSelected = !markAllSelected
    }
    
    @IBOutlet weak var lblMarkIndividual: UILabel!
    
    
    var calenderModal: CalenderModal?
    
    @IBOutlet weak var btnSelectMuliple: UIButton!
    var isAnyCoachSelected = false
    
    var viewCalender : CalenderViewController!
    @IBAction func btnSelectMultipleTapped(_ sender: Any) {
        self.redirection(redirectionType: .coachSelection)
        
    }
    
    
    var filterAdded = Dictionary<String,Any>()
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
    
    var refreshControl = UIRefreshControl()
    var selectedAppointmentModal : ERSideAppointmentModalNewResult!
    
    var dataFeedingAppointmentModal :ERSideAppointmentModalNew?
    var dataFeedingAppointmentModalConst :ERSideAppointmentModalNew?
    
    var tableviewHandlerAppointment = HomeMyAppointmentTableViewController()
    
    // Search Bar and Horizontal Selection
    
    @IBOutlet weak var viewSearchBar: UIView!
    @IBOutlet weak var nslayutSearchBarHeight: NSLayoutConstraint!
    var objERFilterTag : [ERFilterTag]?
      @IBOutlet weak var txtSearchBar: UISearchBar!
      @IBOutlet weak var btnFilter: UIButton!
    @IBOutlet weak var viewHorizontalSelection: UIView!
    @IBOutlet weak var nslayoutHorizSelectionViewHeight: NSLayoutConstraint!
    @IBOutlet var btnsHorizontalSelection: [UIButton]!
    @IBOutlet var viewsHorizontalSelection: [UIView]!
    
    var selectedHorizontal : Int = 1;
    @IBAction func btnHorizontalSelectionTapped(_ sender: UIButton) {
        
        selectedHorizontal = sender.tag
        tableviewHandlerAppointment.customizaTionMyApointment()

        btnsHorizontalSelection.forEach { (btn) in
            if btn.tag == sender.tag{
                btn.setTitleColor(ILColor.color(index: 23), for: .normal)
            }
            else{
                btn.setTitleColor(ILColor.color(index: 42), for: .normal)
            }

        }
        viewsHorizontalSelection.forEach { (view) in
            if view.tag == sender.tag{
                view.isHidden = false
                view.backgroundColor = ILColor.color(index: 23)
            }
            else{
                view.isHidden = true
            }
            
        }
        
        
      
    }
    
    var dataFeedingModalConst : DashBoardModel?
    var tableviewHandler = HomeTableView()
    override func viewDidLoad() {
        super.viewDidLoad()
        UserDefaultsDataSource(key: "timeZoneOffset").writeData(TimeZone.current.identifier)
        viewMarkAll.isHidden = true
        viewSearchBar.isHidden = true
        nslayutSearchBarHeight.constant = 0
        
        viewHorizontalSelection.isHidden = true
        nslayoutHorizSelectionViewHeight.constant = 0
        
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
        if self.viewCalender != nil{
            self.viewCalender.dismiss(animated: false) {
                
            }
        }
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
         viewCalender = CalenderViewController.init(nibName: "CalenderViewController", bundle: nil)
        viewCalender.viewControllerI = self
        viewCalender.index = 1;
        viewCalender.pointSign = CGPoint.init(x: abs(frame.origin.x) + abs(frame.size.width/2), y: abs(frame.origin.y) + abs(frame.size.height/2) + 10 )
        viewCalender.modalPresentationStyle = .overFullScreen
        self.present(viewCalender, animated: false) {
        }
    }
    
    @objc  override func humbergerCilcked(sender: UIBarButtonItem) {
        slideMenuController()?.openLeft();
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
        if self.dataFeedingModal?.items.count == 0
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
        for Coach in self.dataFeedingModal!.items{
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
            let fontMedium = UIFont(name: "FontMediumWithoutNext".localized(), size: Device.FONTSIZETYPE12)
            let fontBook =  UIFont(name: "FontBook".localized(), size: Device.FONTSIZETYPE10)
            UIButton.buttonUIHandling(button: btnMarkAll, text: "Mark All", backgroundColor: .clear, textColor: ILColor.color(index: 23),fontType: fontMedium)
            
            UILabel.labelUIHandling(label: lblMarkIndividual, text: "Tap to mark individually", textColor: ILColor.color(index: 42), isBold: false, fontType: fontBook)
            nslayoutMarkAllViewheight.constant = 60

            
            break;
        case .StudentMyAppointment:
            GeneralUtility.customeNavigationBarMyAppoinment(viewController: self,title:"My Appointments");
            
            nslayoutMarkAllViewheight.constant = 0
            viewMarkAll.isHidden = true
            
            
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
    
   
    
    
    func callingViewModal(isbackGroundHit : Bool)  {
        
        let csrftoken = UserDefaultsDataSource(key: "csrf_token").readData() as! String

        var param = [ ParamName.PARAMCSRFTOKEN : csrftoken] as [String : AnyObject]
        if filterAdded.isEmpty{
            
        }
        else{
            param["filters"] = self.filterAdded as AnyObject
        }
        
        
        dashBoardViewModal.viewController = self
        dashBoardViewModal.isbackGroundHit = isbackGroundHit
        dashBoardViewModal.fetchCall(params: param,success: { (dashboardModel) in
            self.dataFeedingModal = dashboardModel
            self.refreshControl.endRefreshing()
            self.dataFeedingModalConst = self.dataFeedingModal;
            self.viewMarkAll.isHidden = false
            self.zeroStateLogic()
            self.customization()
        }) { (error, errorCode) in
            
        }
    }
    
    
    
    
    func customization()  {
        switch userTypeHome {
     
        case .Student:
            let myView = Bundle.loadView(fromNib: "HorizontalCalender", withType: HorizontalCalender.self)
            myView.frame = CGRect.init(x: 0, y: 0, width: viewHeader.frame.width, height: viewHeader.frame.height);
            viewHeader.addSubview(myView);
            self.viewHeader.cornerRadius = 3;
            myView.enumHeadType = .student
            myView.customize()

        default:
            break
        }
        tableviewHandler.viewControllerI = self
        tblView.register(UINib.init(nibName: "CoachListingTableViewCell", bundle: nil), forCellReuseIdentifier: "CoachListingTableViewCell")
        let headerNib = UINib.init(nibName: "HeaderSectionCoach", bundle: Bundle.main)
        tblView.register(headerNib, forHeaderFooterViewReuseIdentifier: "HeaderSectionCoach")
        viewSearchBar.isHidden = false
        nslayutSearchBarHeight.constant = 50
        tableviewHandler.customization()
        btnFilter.setImage(UIImage.init(named: "noun_filter_"), for: .normal);
        viewSearchBar.backgroundColor = .white
        txtSearchBar.barTintColor = UIColor.clear
        txtSearchBar.backgroundColor = UIColor.clear
        txtSearchBar.isTranslucent = true
        txtSearchBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        txtSearchBar.placeholder = "Search by Role/Name"
        txtSearchBar.backgroundColor = .clear
        txtSearchBar.delegate = self
        

    }
    
    
    
    
}

extension HomeViewController : CoachListingTableViewCellDelegate{
    
    
    func changeModal(modal: Item, seemore: Bool) {
        
        if seemore {
            
            let index = self.dataFeedingModal?.items.firstIndex(where: {$0.id == modal.id})
            var selectedCoach =   self.dataFeedingModal?.items.filter{
                $0.id == modal.id
                }[0];
            let selectedCoachI = selectedCoach;
            selectedCoach?.isSeeMoreSelected = !selectedCoachI!.isSeeMoreSelected
            self.dataFeedingModal?.items.remove(at: index!)
            self.dataFeedingModal?.items.insert(selectedCoach!, at: index!)
            self.zeroStateLogic()
            isCoachSelected()
            self.reloadTablviewCocahList()
            
        }
        else{
            let index = self.dataFeedingModal?.items.firstIndex(where: {$0.id == modal.id})
            var selectedCoach =   self.dataFeedingModal?.items.filter{
                $0.id == modal.id
                }[0];
            let selectedCoachI = selectedCoach;
            selectedCoach?.isSelected = !selectedCoachI!.isSelected
            self.dataFeedingModal?.items.remove(at: index!)
            self.dataFeedingModal?.items.insert(selectedCoach!, at: index!)
            self.zeroStateLogic()
            isCoachSelected()
            self.reloadTablviewCocahList()
            
        }
        
       
    }
    
    func changeBottomBtn(isVisible: Bool)  {
        btnSelectMuliple.isHidden = !isVisible
        
    }
    
    func scheduleAppoinment(modal: Item) {
        self.redirection(redirectionType: .coachSelection)
        
    }
    
    
    
}

extension HomeViewController : HomeViewcontrollerRedirection{
    
    func selectedModal() -> DashBoardModel?  {
        
        if (self.dataFeedingModal?.items.count ?? 0) > 0 {
            
        }
        else{
            return nil
        }
        
        var selectedModal = self.dataFeedingModal;
        let coachSelected = (self.dataFeedingModal?.items.filter({$0.isSelected == true}))!
        selectedModal?.items.removeAll()
        selectedModal?.items.append(contentsOf: coachSelected)
        return selectedModal!
    }
    
    func redirectToParticularViewController(type : RedirectionType)  {
        slideMenuController()?.closeLeft();
        switch type {
        case .profile:
                        let wvc = UIStoryboard.profileView()
                        self.navigationController?.pushViewController(wvc, animated: true)
            break
            
        case .coachSelection:
        
        self.redirection(redirectionType: .coachSelection)

        break
            
        case .logOut:
            GeneralUtility.alertViewLogout(title: "".localized(), message: "LOGOUT".localized(), viewController: self, buttons: ["Cancel","Ok"]);
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
        refreshControlAPi()

    }
    
    func dateSelected(calenderModal: CalenderModal, index: Int) {
        self.calenderModal = calenderModal
        self.redirection(redirectionType: .coachSelection)
        
    }
    
    
    
}



extension HomeViewController: ERCancelViewControllerDelegate {
    
    func refreshTableView() {
        refreshControlAPi()
    }
    
    
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
            objFeedbackViewController.appoinmentDetailModalObj =   CoachSelectionViewModal().modalConverion(objERSideAppointmentModalNewResult: self.selectedAppointmentModal)

            objFeedbackViewController.modalPresentationStyle = .overFullScreen
            self.navigationController?.pushViewController(objFeedbackViewController, animated: false)
            break
        case .appointmentDetail:
            let objERAppointmentDetailViewController = ERAppointmentDetailViewController.init(nibName: "ERAppointmentDetailViewController", bundle: nil)
            objERAppointmentDetailViewController.selectedResult =  self.selectedAppointmentModal;
            objERAppointmentDetailViewController.index = selectedHorizontal + 1
            self.navigationController?.pushViewController(objERAppointmentDetailViewController, animated: false)
            break
            
        case .cancelAppoinment:
            
            let objERCancelViewController = ERCancelViewController.init(nibName: "ERCancelViewController", bundle: nil)
            objERCancelViewController.modalPresentationStyle = .overFullScreen
            objERCancelViewController.results = self.selectedAppointmentModal
            objERCancelViewController.viewType = .cancel
            objERCancelViewController.delegate = self
            self.navigationController?.pushViewController(objERCancelViewController, animated: false)
            
            break
            
            
            
        default:
            break
        }
    }
    
}


// ALL STUDENT APPOINMENT LOGIC

extension HomeViewController:DashBoardStudentAppointmentVMDelegate,DashBoardAppointmentTableViewCellDelegate{
    func redirectAppoinment(openMOdal: ERSideAppointmentModalNewResult, isFeedback: Int) {
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
    
    func refreshApi() {
                dashBoardViewStudentApVModal.customizeVM();
    }
    
    
    // 1 : - Feedback
    // 2 :- View Detail
    // 3:- Cancel
    
    
  
    
    
    
    
    func sentDataViewController(dataAppoinmentModal: ERSideAppointmentModalNew ) {
        
        self.refreshControl.endRefreshing()
        self.dataFeedingAppointmentModal = dataAppoinmentModal
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
        viewHorizontalSelection.isHidden = false
        nslayoutHorizSelectionViewHeight.constant = 50
        viewHorizontalSelection.backgroundColor = .white
        let btnTitleNames = ["Upcoming","Pending","Past"]
        btnsHorizontalSelection.forEach { (btn) in
            btn.setTitle(btnTitleNames[btn.tag-1], for: .normal)
            if btn.tag == selectedHorizontal{
                btn.setTitleColor(ILColor.color(index: 23), for: .normal)
            }
            else{
                btn.setTitleColor(ILColor.color(index: 42), for: .normal)
            }

        }
        viewsHorizontalSelection.forEach { (view) in
            if view.tag == selectedHorizontal{
                view.isHidden = false
                view.backgroundColor = ILColor.color(index: 23)
            }
            else{
                view.isHidden = true

            }
            
        }
        
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


// MARK: Search and Filter

extension HomeViewController : ERFilterViewControllerDelegate {
    func passFilter(selectedFilter: [ERFilterTag]?) {

        self.objERFilterTag = selectedFilter
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
        self.callingViewModal(isbackGroundHit: false)

    }
    
    
    @IBAction func btnFilterTapped(_ sender: Any) {
        txtSearchBar.text = ""
        let objERFilterViewController = ERFilterViewController.init(nibName: "ERFilterViewController", bundle: nil)
        objERFilterViewController.modalPresentationStyle = .overFullScreen
        objERFilterViewController.objERFilterTag = self.objERFilterTag
        objERFilterViewController.delegate = self
        objERFilterViewController.objFilterTypeView = .Student
        self.navigationController?.pushViewController(objERFilterViewController, animated: false)
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        
        if searchBar.tag == 10001 {
            
            self.dataFeedingModal = self.dataFeedingModalConst
            if searchBar.text != ""
            {
                let filteredItems =  self.dataFeedingModal?.items.filter{
                    return   ( $0.name.lowercased().contains(searchBar.text!.lowercased())
                                || $0.coachInfo.headline!.lowercased().contains(searchBar.text!.lowercased()))
                }
                self.dataFeedingModal?.items = filteredItems!
                self.zeroStateLogic()
                self.reloadTablviewCocahList()
            }
            searchBar.resignFirstResponder();
        }
        searchBar.resignFirstResponder();
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.tag == 10001 {
            
            if searchText == "" {
                self.dataFeedingModal = self.dataFeedingModalConst
                self.reloadTablviewCocahList()
                searchBar.resignFirstResponder();
            }
            
        }
        
    }
    
}

