//
//  ERSideHomeViewController.swift
//  Appointment
//
//  Created by Anurag Bhakuni on 10/11/20.
//  Copyright © 2020 Anurag Bhakuni. All rights reserved.
//

import Foundation
import UIKit

struct ERSideCalender {
    
    var dateC : Date!;
    var isClickable : Bool!;
    var isSelected : Bool!;

    
}





enum ERRedirectionType {
    case AppointmentDetail

}


class ERSideHomeViewController: SuperViewController {
    
    
    @IBOutlet weak var viewFloatingOuter: UIView!
    
    
    @IBOutlet weak var btnSetOpenHour: UIButton!
    
    @IBAction func btnSetOpenHourTaped(_ sender: Any) {
        
        var objERSideOpenHourListVC = ERSideOpenHourListVC.init(nibName: "ERSideOpenHourListVC", bundle: nil)
        self.navigationController?.pushViewController(objERSideOpenHourListVC, animated: false)
        
    }
    
    @IBOutlet weak var btnNextStep: UIButton!
    
    
    @IBAction func btnNextStepTapped(_ sender: Any) {
        
    }
    
    
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var imgViewSetOpen: UIImageView!
    @IBOutlet weak var lblSetOpen: UILabel!
    @IBOutlet weak var imgViewNextStep: UIImageView!
    @IBOutlet weak var lblNextStep: UILabel!
    @IBOutlet weak var nslayoutConstrintFloatingHeight: NSLayoutConstraint!
    @IBOutlet weak var btnFloatingButton: UIButton!

    
    @IBAction func btnFloatingButtonTapped(_ sender: UIButton) {
        
        if viewFloatingOuter.isHidden {
            
            
            UIView.animate(withDuration: 0.25, animations: {
                self.btnFloatingButton.transform = CGAffineTransform(rotationAngle: 30)
            })
            
            
            viewContainer.isHidden = false
            viewFloatingOuter.isHidden = false
            UIView.animate(withDuration:0.9,
                           delay: 0,
                           usingSpringWithDamping: 0.4,
                           initialSpringVelocity: 0,
                           options: [],
                           animations: {
                            
                            self.nslayoutConstrintFloatingHeight.constant = 106
                            self.viewContainer.layoutIfNeeded()
                            
                            //Do all animations here
            }, completion: {
                //Code to run after animating
                (value: Bool) in
            })
            
        }
        else{
            UIView.animate(withDuration: 0.25, animations: {
                self.btnFloatingButton.transform = CGAffineTransform(rotationAngle: 0)
            })
            UIView.animate(withDuration:0.9,
                           delay: 0,
                           usingSpringWithDamping: 0.4,
                           initialSpringVelocity: 0,
                           options: [],
                           animations: {
                            
                            self.viewContainer.isHidden = true
                            self.viewFloatingOuter.isHidden = true
                            self.viewContainer.layoutIfNeeded()
                            
                            //Do all animations here
            }, completion: {
                //Code to run after animating
                
                (value: Bool) in
                self.nslayoutConstrintFloatingHeight.constant = 0
                
            })
            
        }
        
    }
    
    
    
    
    @IBOutlet weak var viewOuter: UIView!
    
    @IBOutlet weak var tblView: UITableView!
    var tableViewHandler = ErSideHomeTableViewVC()
    
    
    @IBOutlet weak var btnMonthIncrease: UIButton!
    
    @IBOutlet weak var lblDate: UILabel!
    
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
        self.callingViewModal()
        
        
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
        self.callingViewModal()
        
        
    }
    
    
    var dataAppoinmentModal: ERSideAppointmentModal?
    
    var erSideHomeVM = ERHomeViewModal();
    
    @IBOutlet weak var viewCollection: ERSideHeaderCollectionVC!
    
    @IBOutlet weak var btnMonthDecrease: UIButton!
    
    @IBOutlet weak var lblMonth: UILabel!
    
    var dateSelected : Date!
    
    
    
    
    
    
    override func viewDidLoad() {
        
        calenderView()
        self.callingViewModal()
        viewOuter.backgroundColor = ILColor.color(index: 44)
        self.view.backgroundColor = ILColor.color(index: 46)
        self.tblView.backgroundColor = .clear
        
        btnFloatingButton.isHidden = true
        customizFloatingButton()
        
    }
    
    
    
    func customizFloatingButton(){
        
        UIButton.buttonUIHandling(button: btnFloatingButton, text: "", backgroundColor: .white,  cornerRadius: Int(btnFloatingButton.frame.size.width)/2,  buttonImage: UIImage.init(named: "plus"))
        
        self.shadowWithCorner(viewContainer: btnFloatingButton)
        
        
        
    }
    
    
    func shadowWithCorner(viewContainer : UIView)
    {
        viewContainer.layer.masksToBounds = false
        viewContainer.layer.shadowColor = ILColor.color(index: 27).cgColor
        viewContainer.layer.shadowOffset =  CGSize.zero
        viewContainer.layer.shadowOpacity = 0.5
        viewContainer.layer.shadowRadius = 4
        
    }
    
    
    
    func callingViewModal(){
        erSideHomeVM.enumType = .ERSideHome
        erSideHomeVM.delegate = self
        erSideHomeVM.viewController = self
        erSideHomeVM.dateSelected = self.dateSelected
        erSideHomeVM.custmoziation()
        
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
    
    
    
    func customizationERAppointment()  {
        
        tableViewHandler.viewControllerI = self
        tblView.register(UINib.init(nibName: "ERSideAppointmentTableViewCell", bundle: nil), forCellReuseIdentifier: "ERSideAppointmentTableViewCell")
        
        let headerNib = UINib.init(nibName: "ERSideHomeSectionHeader", bundle: Bundle.main)
        tblView.register(headerNib, forHeaderFooterViewReuseIdentifier: "ERSideHomeSectionHeader")
        tableViewHandler.dataAppoinmentModal = self.dataAppoinmentModal
        tableViewHandler.customization()
        
        btnFloatingButton.isHidden = false
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        GeneralUtility.customeNavigationBarMyAppoinment(viewController: self,title:"Schedule");
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        foatingViewCustomization();
        
    }
    
    override func logout(sender: UIButton) {
        GeneralUtility.alertViewLogout(title: "".localized(), message: "LOGOUT".localized(), viewController: self, buttons: ["Cancel","Ok"]);
    }
    
    
    
    
    
}


extension ERSideHomeViewController : ERHomeViewModalVMDelegate,ERSideHeaderCollectionVCDelegate{
    
    
    func dateSelected(modalCalender: ERSideCalender) {
        self.dateSelected = modalCalender.dateC
        self.mothDecreasebtnVisibility()
        self.callingViewModal()
        
        
    }
    
    func sentDataToERHomeVC(dataAppoinmentModal: ERSideAppointmentModal?, success: Bool,index:Int) {
        
        if success {
            self.dataAppoinmentModal = dataAppoinmentModal
            customizationERAppointment()
            viewCollection.setCollectionOffest()
        }
        else{
            CommonFunctions().showError(title: "Error", message: ErrorMessages.SomethingWentWrong.rawValue)
        }
        
    }
    
}


extension ERSideHomeViewController:UIGestureRecognizerDelegate{
    
    func foatingViewCustomization()
    {
        self.viewContainer.isHidden = true
        self.viewFloatingOuter.isHidden = true
        
        let fontHeavy = UIFont(name: "FontHeavy".localized(), size: Device.FONTSIZETYPE15)
        UILabel.labelUIHandling(label: lblSetOpen, text: "Set Open Hours", textColor: .white, isBold: false, fontType: fontHeavy)
        UILabel.labelUIHandling(label: lblNextStep, text: "Next Steps", textColor: .white, isBold: false, fontType: fontHeavy)
        
        imgViewSetOpen.image = UIImage.init(named: "Calendar")
        imgViewNextStep.image = UIImage.init(named: "NextImage")
        viewContainer.backgroundColor = ILColor.color(index: 25)
        
        
        self.viewFloatingOuter.tag = 19683
        tapGesture()
        viewFloatingOuter.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.2)
        
        
    }
    
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view?.isDescendant(of: self.view) == true  && touch.view?.tag != 19683  {
            self.view.resignFirstResponder()
            
            return false
        }
        return true
    }
    
    func tapGesture()  {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        tap.delegate = self
        self.viewFloatingOuter.isUserInteractionEnabled = true
        self.viewFloatingOuter.addGestureRecognizer(tap)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        viewContainer.isHidden = true
        viewFloatingOuter.isHidden = true
        self.nslayoutConstrintFloatingHeight.constant = 0
        UIView.animate(withDuration: 0.25, animations: {
            self.btnFloatingButton.transform = CGAffineTransform(rotationAngle: 0)
        })
        
    }
    
    
    
}
