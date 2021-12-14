//
//  ERSideOpenHourListVC.swift
//  Appointment
//
//  Created by Anurag Bhakuni on 26/11/20.
//  Copyright © 2020 Anurag Bhakuni. All rights reserved.
//

import UIKit

class ERSideOpenHourListVC: SuperViewController,ErSideOpenHourTCDelegate {
    func deleteDelgateRefresh() {
        refreshModal()
    }
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var btnDuplicate: UIButton!
    @IBAction func btnDuplicateTapped(_ sender: Any) {
        let objERSideOpenHourListVC = ERSideOpenCreateEditVC.init(nibName: "ERSideOpenCreateEditVC", bundle: nil)
        objERSideOpenHourListVC.objviewTypeOpenHour = .duplicateSetHour
        objERSideOpenHourListVC.delegate = self
        objERSideOpenHourListVC.dateSelected = self.dateSelected
        self.navigationController?.pushViewController(objERSideOpenHourListVC, animated: false)
        
    }
    
    @IBOutlet weak var btnSetOpenHours: UIButton!
    
    @IBAction func btnSetOpenHoursTapped(_ sender: Any) {
        let objERSideOpenHourListVC = ERSideOpenCreateEditVC.init(nibName: "ERSideOpenCreateEditVC", bundle: nil)
        objERSideOpenHourListVC.objviewTypeOpenHour = .setOpenHour
        objERSideOpenHourListVC.delegate = self

        objERSideOpenHourListVC.dateSelected = self.dateSelected
        self.navigationController?.pushViewController(objERSideOpenHourListVC, animated: false)
    }
    
    // BlackOut
    
    @IBOutlet weak var btnBlackOut: UIButton!
    
    @IBAction func btnBlackOutTapped(_ sender: Any) {
        let objAddBlackOutDateVC = AddBlackOutDateVC.init(nibName: "AddBlackOutDateVC", bundle: nil)
        self.navigationController?.pushViewController(objAddBlackOutDateVC, animated: false)
    }
    
    //Zero State
    
    @IBOutlet weak var viewZeroState: UIView!
    @IBOutlet weak var imageViewZeroState: UIImageView!
    @IBOutlet weak var lblZeroState: UILabel!
    
    
    // TimeZOne
    @IBOutlet weak var txtTimeZone: LeftPaddedTextField!
    var   timeZoneViewController : TimeZoneViewController!
    var timeZOneArr = [TimeZoneSel]()
    var dashBoardViewModal = DashBoardViewModel()
    var selectedTextZone = ""
    @IBOutlet weak var btnSelectTimeZOne: UIButton!
    
    
    // DATECALENDER VIEW
    
    @IBOutlet weak var btnMonthIncrease: UIButton!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var viewCollection: ERSideHeaderCollectionVC!
    @IBOutlet weak var btnMonthDecrease: UIButton!
    @IBOutlet weak var lblMonth: UILabel!
    var dateSelected : Date!
    @IBOutlet weak var viewOuter: UIView!
    
    var viewModalERSideOH : ERSideOpenhourVM!
    var tblViewHandler : ERSideOpenHourTableHandler!
    var dataAppoinmentModal: ERSideOPenHourModal?
    
    
    @IBOutlet weak var nslayoutbtnDuplicateHeight: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        zeroStateLogic()
        btnSetOpenHours.isHidden = true
        btnDuplicate.isHidden = true
        btnBlackOut.isHidden = true
        calenderView()
        dashBoardViewModal.viewController = self
        dashBoardViewModal.fetchTimeZoneCall { (timeArr) in
            self.btnBlackOut.isHidden = false
            self.timeZOneArr = timeArr
            self.setTimeZoneTextField()
            self.viewModalCalling()
            
        }
        // Do any additional setup after loading the view.
    }
    override func buttonClicked(sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: false)
    }
    
    func zeroStateLogic()  {
        if self.dataAppoinmentModal?.results?.count == 0
        {
            let fontMedium = UIFont(name: "FontMedium".localized(), size: Device.FONTSIZETYPE13)
            
            self.viewZeroState.isHidden = false
            self.viewZeroState.backgroundColor = ILColor.color(index: 22)
            
            self.tblView.isHidden = true
            UILabel.labelUIHandling(label: lblZeroState, text: "No open hours to show", textColor:ILColor.color(index: 42) , isBold: false, fontType: fontMedium)
            self.imageViewZeroState.image = UIImage.init(named: "noOpenHour-1")
            btnDuplicate.isHidden = true
            nslayoutbtnDuplicateHeight.constant = 0
            btnSetOpenHours.isHidden = false
            
        }
        else{
            self.viewZeroState.isHidden = true
            self.tblView.isHidden = false
            btnSetOpenHours.isHidden = false
            btnDuplicate.isHidden = false
            nslayoutbtnDuplicateHeight.constant = 50

        }
    }
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        viewOuter.backgroundColor = ILColor.color(index: 46 )
        self.view.backgroundColor = ILColor.color(index: 22)
        let fontheavy = UIFont(name: "FontHeavy".localized(), size: Device.FONTSIZETYPE18)
        
        UIButton.buttonUIHandling(button: btnSetOpenHours, text: "Set Advising Appointment Hour", backgroundColor: ILColor.color(index: 23), textColor: .white, cornerRadius: 3,fontType: fontheavy)
        
        UIButton.buttonUIHandling(button: btnDuplicate, text: "Duplicate Schedules", backgroundColor: .white, textColor: ILColor.color(index: 23), cornerRadius: 3,borderColor: ILColor.color(index: 23),borderWidth: 1, fontType: fontheavy)
        
        GeneralUtility.customeNavigationBarWithOnlyBack(viewController: self, title: " Advising Appointment Hour")
        let fontheavy1 = UIFont(name: "FontHeavy".localized(), size: Device.FONTSIZETYPE13)

        UIButton.buttonUIHandling(button: btnBlackOut, text: "Add Blackout Date", backgroundColor: .clear, textColor: ILColor.color(index: 23), fontType: fontheavy1)
    }
    
    
    func refreshModal(){
        self.viewModalCalling()
        
    }
    
    func customizeTableView()
    {
        tblView.register(UINib.init(nibName: "ErSideOpenHourTC", bundle: nil), forCellReuseIdentifier: "ErSideOpenHourTC")
        tblViewHandler = ERSideOpenHourTableHandler();
        tblViewHandler.viewControllerI = self
        tblViewHandler.dateSelected = self.dateSelected
        tblViewHandler.dataAppoinmentModal = self.dataAppoinmentModal
        tblViewHandler.customization()
    }
    
}



// viewModal Call and Modal Feeding

extension ERSideOpenHourListVC:ERSideOpenhourVMDelegate{
    func sentDataToERHomeVC(dataAppoinmentModal: ERSideOPenHourModal?, success: Bool, index: Int) {
        
        if success {
            self.dataAppoinmentModal = dataAppoinmentModal
            customizeTableView()
            viewCollection.setCollectionOffest()
            self.zeroStateLogic()
        }
        else{
            CommonFunctions().showError(title: "Error", message: ErrorMessages.SomethingWentWrong.rawValue)
        }
        
        
    }
    
    
    func viewModalCalling(){
        
        self.viewModalERSideOH = ERSideOpenhourVM()
        self.viewModalERSideOH.delegate = self
        viewModalERSideOH.viewController = self
        viewModalERSideOH.dateSelected = self.dateSelected
        viewModalERSideOH.custmoziation()
    }
    
}
// BlackOut






// Collection DateCalender Horizontal

extension ERSideOpenHourListVC: ERSideHeaderCollectionVCDelegate{
    func dateSelected(modalCalender: ERSideCalender) {
        self.dateSelected = modalCalender.dateC
               self.mothDecreasebtnVisibility()
                self.viewModalCalling()
        
    }
    
    
    
    func mothDecreasebtnVisibility(){
          let fontHeavy = UIFont(name: "FontHeavy".localized(), size: Device.FONTSIZETYPE15)
          let fontBook =  UIFont(name: "FontBook".localized(), size: Device.FONTSIZETYPE14)
          
          UILabel.labelUIHandling(label: lblDate, text: GeneralUtility.todayDateDDMMYYYY(date: dateSelected), textColor: ILColor.color(index: 25), isBold: true, fontType: fontHeavy)
          
          UILabel.labelUIHandling(label: lblMonth, text: GeneralUtility.todayDateMMYYYY(date: dateSelected), textColor: ILColor.color(index: 34), isBold: false, fontType: fontBook)
          
          
          let componentI = dateSelected.get(.day,.month,.year)
          let componentII = Date().get(.day,.month,.year)
          
          
          if ((componentI.year ?? 0) >= (componentII.year ?? 0)){
              
              if ((componentI.year ?? 0) == (componentII.year ?? 0)) && ((componentI.month ?? 0)  <= (componentII.month ?? 0)) {
                  btnMonthDecrease.isEnabled = false
                  btnMonthDecrease.isUserInteractionEnabled =   false
              }
              else{
                  btnMonthDecrease.isEnabled = true
                  btnMonthDecrease.isUserInteractionEnabled = true
                  
              }
              
              
              
          }else{
              btnMonthDecrease.isEnabled = false
              btnMonthDecrease.isUserInteractionEnabled = false
          }
          
      }
    
    
    func calenderView(){
        self.dateSelected = Date()
        viewCollection.selectedDate = self.dateSelected
        viewCollection.delegateI = self;
        viewCollection.customize(date:dateSelected!)
        
        let fontHeavy = UIFont(name: "FontHeavy".localized(), size: Device.FONTSIZETYPE15)
        let fontBook =  UIFont(name: "FontBook".localized(), size: Device.FONTSIZETYPE14)
        
        btnMonthDecrease.setImage(UIImage.init(named: "Left_arrow"), for: .normal)
        btnMonthIncrease.setImage(UIImage.init(named: "right_arrow"), for: .normal)
        
        
        UILabel.labelUIHandling(label: lblDate, text: GeneralUtility.todayDateDDMMYYYY(date: Date()), textColor: ILColor.color(index: 25), isBold: true, fontType: fontHeavy)
        
        UILabel.labelUIHandling(label: lblMonth, text: GeneralUtility.todayDateMMYYYY(date: Date()), textColor: ILColor.color(index: 34), isBold: false, fontType: fontBook)
        
        self.mothDecreasebtnVisibility()
        
    }
    
    
    
    
    
    @IBAction func btnMonthIncreaseTapped(_ sender: Any) {
        
        var startDate = Date()
        
        if let dateS = dateSelected{
            startDate = dateS
        }
        
        let comp: DateComponents = Calendar.current.dateComponents([.year, .month], from: startDate)
        let startOfMonth = Calendar.current.date(from: comp)!
        var dateCompStartChange = DateComponents()
        dateCompStartChange.month = 1;
        let date = Calendar.current.date(byAdding: dateCompStartChange, to: startOfMonth)!
        
        dateSelected = date
        viewCollection.selectedDate = self.dateSelected
        viewCollection.customize(date:date)
        viewCollection.setCollectionOffest()
        self.mothDecreasebtnVisibility()
        self.viewModalCalling()

        
    }
    
    @IBAction func btnMonthDeceaseTapped(_ sender: Any) {
        
        var startDate = Date()
        if let dateS = dateSelected{
            startDate = dateS
        }
        
        let comp: DateComponents = Calendar.current.dateComponents([.year, .month], from: startDate)
        let startOfMonth = Calendar.current.date(from: comp)!
        var dateCompStartChange = DateComponents()
        dateCompStartChange.month = -1;
        var date = Calendar.current.date(byAdding: dateCompStartChange, to: startOfMonth)!
        
        let componentI = date.get(.day,.month,.year)
        let componentII = Date().get(.day,.month,.year)
        
        if  componentI.month ?? 0  == componentII.month  && componentI.year  == componentII.year {
            
            date = Date()
            
        }else{
            
        }
        
        dateSelected = date
        viewCollection.selectedDate = self.dateSelected
        viewCollection.customize(date:date)
        viewCollection.setCollectionOffest()
        
        mothDecreasebtnVisibility()
        self.viewModalCalling()

        
    }
    
}


// TIME ZONE
extension ERSideOpenHourListVC : TimeZoneViewControllerDelegate {
    
    func sendTimeZoneSelected(timeZone: TimeZoneSel) {
        self.txtTimeZone.text = timeZone.displayName
        self.viewModalCalling()
        
    }
    
    
    func setTimeZoneTextField()  {
        let fontMedium = UIFont(name: "FontMedium".localized(), size: Device.FONTSIZETYPE12)
        let fontHeavy1 = UIFont(name: "FontHeavy".localized(), size: Device.FONTSIZETYPE11)
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
    
    
    @IBAction func btnSelectTimeZoneTapped(_ sender: UIButton) {
        let frameI =
            txtTimeZone.superview?.convert(txtTimeZone.frame, to: nil)
        
        timeZoneViewController.txtfieldRect = frameI
        self.present(timeZoneViewController, animated: false) {
            self.timeZoneViewController.reloadTableview()
        }
    }
    
    
    
}
