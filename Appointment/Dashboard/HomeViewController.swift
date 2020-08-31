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
    case Coaches

}
enum RedirectionType {
    case profile
    case about
    case coachSelection
}




class HomeViewController: SuperViewController,UISearchBarDelegate {
    
    

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
    var dataFeedingModalConst : DashBoardModel?
    var tableviewHandler = HomeTableView()
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = ILColor.color(index: 22)
        callingViewModal()
        GeneralUtility.customeNavigationBar(viewController: self,title:"Schedule");
        // Do any additional setup after loading the view.
    }
   
    override func searchEvent(sender: UIBarButtonItem) {
     GeneralUtility.customeNavigationBarTextfield(viewController: self, searchText: "");
    }
    
    override  func calenderClicked(sender: UIButton) {
        let frame = sender.convert(sender.frame, from:AppDelegate.getDelegate().window)
        
        let viewCalender = CalenderViewController.init(nibName: "CalenderViewController", bundle: nil)
        viewCalender.pointSign = CGPoint.init(x: abs(frame.origin.x) + abs(frame.size.width/2), y: abs(frame.origin.y) + abs(frame.size.height/2) + 10 )
        viewCalender.modalPresentationStyle = .overFullScreen
        self.present(viewCalender, animated: false) {
        }
    }
    
    
    override func changeNavigation(sender: UIBarButtonItem) {
        GeneralUtility.customeNavigationBar(viewController: self,title:"Schedule");
        self.dataFeedingModal = self.dataFeedingModalConst
        self.zeroStateLogic()
        self.reloadTablview()
        
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
    
    
    func reloadTablview()  {
        tableviewHandler.customization()
        if  isAnyCoachSelected{
            self.tblView.contentSize.height = self.tblView.contentSize.height + 100
        }
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        btnSelectMuliple.isHidden = true
        let fontHeavy2 = UIFont(name: "FontHeavy".localized(), size: Device.FONTSIZETYPE13)

        UIButton.buttonUIHandling(button: btnSelectMuliple, text: "Schedule an appointment", backgroundColor:ILColor.color(index: 23)  , textColor:.white , cornerRadius: 5, isUnderlined: false, fontType: fontHeavy2)
        
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
            self.reloadTablview()
        }
        searchBar.resignFirstResponder();
    }

    
    func callingViewModal()  {
        
        let param : Dictionary<String, AnyObject> = ["roles":["external_coach","career_coach"]] as Dictionary<String, AnyObject>
        
        dashBoardViewModal.viewController = self
        dashBoardViewModal.fetchCall(params: param,success: { (dashboardModel) in
            self.dataFeedingModal = dashboardModel
            
            var sectionHeaderI = [sectionHead]()
            let section1 = sectionHead.init(name: "Select all Coaches", id:"career_coach", selectAll: false, seeAll: false)
            sectionHeaderI.append(section1);
            
            let section2 = sectionHead.init(name: "Select all Alumini", id:"external_coach", selectAll: false, seeAll: false)
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
        self.reloadTablview()
        
        
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
        self.reloadTablview()

    }
    
    func changeModal(modal: sectionHead, seeMore: Bool) {
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
            self.reloadTablview()
            
        }
        else
        {
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
        self.reloadTablview()
    }

    func changeBottomBtn(isVisible: Bool)  {
            btnSelectMuliple.isHidden = !isVisible
       
    }
    
    func scheduleAppoinment(modal: Coach) {
        self.redirection(redirectionType: .coachSelection)
        
    }
    
    
    
}

extension HomeViewController : HomeViewcontrollerRedirection{
    
    func selectedModal() -> DashBoardModel  {
        var selectedModal = self.dataFeedingModal;
        var coachesI = [Coach]()
        for coaches in self.dataFeedingModal!.coaches
        {
            if coaches.isSelected {
                coachesI.append(coaches)
            }
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

extension HomeViewController: CalenderCollectionViewCellDelegate{
    func dateSelected(calenderModal: CalenderModal) {
        
    }
    
}



extension HomeViewController{
    
    
    func redirection(redirectionType : RedirectionType)  {
        switch redirectionType {
        case .about:
            break
        case .coachSelection:
            
            
            if isAnyCoachSelected {
                let coachSelectionViewController = CoachSelectionViewController.init(nibName: "CoachSelectionViewController", bundle: nil)
                coachSelectionViewController.selectedDataFeedingModal = self.selectedModal()
                coachSelectionViewController.dataFeedingModal = self.dataFeedingModalConst
                self.navigationController?.pushViewController(coachSelectionViewController, animated: false)
            }
            else
            {
                CommonFunctions().showError(title: "Error", message: StringConstants.nocoachSelected)
            }
            
            break
        case .profile:
            break
        default:
            break
        }
    }
    
}
