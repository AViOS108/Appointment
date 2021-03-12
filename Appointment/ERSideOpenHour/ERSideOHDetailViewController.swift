//
//  ERSideOHDetailViewController.swift
//  Appointment
//
//  Created by Anurag Bhakuni on 27/11/20.
//  Copyright © 2020 Anurag Bhakuni. All rights reserved.
//

import UIKit


struct ERSideOHDetailModal{
    
    var headLinetext : String!
    var valueText : String!
    var imageame : String!
    var index : Int!
}






class ERSideOHDetailViewController: SuperViewController {
    var dateSelected : Date!
    @IBOutlet weak var nslayoutConstarintWidth: NSLayoutConstraint!
    var viewControllerType : Int = 0;
    @IBOutlet weak var nslayoutConstraintHeighBottomView: NSLayoutConstraint!
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var viewTableContainer: UIView!
    @IBOutlet weak var viewFooter: UIView!
    @IBOutlet weak var tblview: UITableView!
    @IBOutlet weak var lblDetailHeader: UILabel!
    @IBOutlet weak var btnDeleteFooter: UIButton!
    @IBAction func btnDeleteFooterTapped(_ sender: Any) {
    }
    @IBOutlet weak var btnCancelFooter: UIButton!
    @IBAction func btnCancelFooterTapped(_ sender: Any) {
    }
    var objModalArray = Array<ERSideOHDetailModal>()
    
    @IBOutlet weak var btnDelete: UIButton!
    @IBAction func btnDeleteTapped(_ sender: Any) {
        activityIndicator = ActivityIndicatorView.showActivity(view: self.view, message: StringConstants.DeletingOpenHour)
        let param = [
            "_method" : "delete",
            "csrf_token" : UserDefaultsDataSource(key: "csrf_token").readData() as! String

        ] as Dictionary<String, AnyObject>
        
        ERSideOpenHourDetailVM().OpenHourDelete(param: param, id: (self.identifier)!
            , { (data) in
                CommonFunctions().showError(title: "", message: "successfully deleted !!!")
                self.dismiss(animated: false) {
                }
                
        }) { (error, errorCode) in
        }
    }
    @IBOutlet weak var btnEdit: UIButton!
    @IBAction func btnEditTapped(_ sender: Any) {
        
        self.dismiss(animated: false) {
            let objERSideOpenHourListVC = ERSideOpenCreateEditVC.init(nibName: "ERSideOpenCreateEditVC", bundle: nil)
            objERSideOpenHourListVC.dateSelected = self.dateSelected
            objERSideOpenHourListVC.objERSideOpenHourDetail = self.objERSideOpenHourDetail
            self.viewControllerI.navigationController?.pushViewController(objERSideOpenHourListVC, animated: false)
        }
    }
    var viewControllerI : UIViewController!

    
    var objERSideOpenHourDetail: ERSideOpenHourDetail?
    var identifier : String!
    var activityIndicator: ActivityIndicatorView?

    @IBOutlet weak var viewInner: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.callViewModal()
        viewInner.isHidden = true
        self.viewInner.backgroundColor = ILColor.color(index: 22)

        // Do any additional setup after loading the view.
    }
    
    
    @objc override func buttonClicked(sender: UIBarButtonItem) {
          self.navigationController?.popViewController(animated: true)
          
            }
    
    
    func creatingModal(){
        tblview.register(UINib.init(nibName: "ERSideDetailEditTableViewCell", bundle: nil), forCellReuseIdentifier: "ERSideDetailEditTableViewCell")

        var purposeModal = ERSideOHDetailModal();
        purposeModal.headLinetext = "Purpose"
        var purpose = "NA"
        if (objERSideOpenHourDetail?.purposes) != nil{
            var index = 0
            for objPurpose in (objERSideOpenHourDetail?.purposes)!{
                purpose = objPurpose.purposeText ?? ""
                index = index + 1;
                if objERSideOpenHourDetail?.purposes?.count ?? 0 > index{
                    purpose = purpose + ","
                }
            }
        }
        purposeModal.valueText = purpose
        purposeModal.index = 1;
        self.objModalArray.append(purposeModal)
        
        
        var timeZoneModal = ERSideOHDetailModal();
        timeZoneModal.headLinetext = "Time Zone"
        timeZoneModal.valueText = objERSideOpenHourDetail?.timezone;
        timeZoneModal.index = 2;
        self.objModalArray.append(timeZoneModal)
        
        
        var AppoinmentDurationModal = ERSideOHDetailModal();
        AppoinmentDurationModal.headLinetext = "Appointment Duration"
        AppoinmentDurationModal.valueText = "\(GeneralUtility.differenceBetweenTwoDateInSec(dateFirst: (objERSideOpenHourDetail?.endDatetimeUTC)!, dateSecond: (objERSideOpenHourDetail?.startDatetimeUTC)!)/60) min"
        
        AppoinmentDurationModal.index = 3;
        self.objModalArray.append(AppoinmentDurationModal)
        
        
        var TimeSlotsModal = ERSideOHDetailModal();
        TimeSlotsModal.headLinetext = "Time Slots"
        
        TimeSlotsModal.valueText = "\(GeneralUtility.currentDateDetailType3(emiDate: objERSideOpenHourDetail?.startDatetimeUTC ?? ""))  -  \(GeneralUtility.currentDateDetailType3(emiDate: objERSideOpenHourDetail?.endDatetimeUTC ?? ""))";
        TimeSlotsModal.index = 4;
        self.objModalArray.append(TimeSlotsModal)
        
        
        var AppointmentTypeModal = ERSideOHDetailModal();
        AppointmentTypeModal.headLinetext = "Appointment Type"
        
        var appointmentType = ""
        
        
        if let groupSise = objERSideOpenHourDetail?.appointmentConfig?.groupSizeLimit
        {
            if Int(groupSise) == 1{
                appointmentType = "1 on 1 Appointment"
            }
            else{
                appointmentType =  "Group Appointment"
            }
        }
        AppointmentTypeModal.valueText = appointmentType
        AppointmentTypeModal.index = 5;
        self.objModalArray.append(AppointmentTypeModal)
        
        var requestType = ""
        
        
        if let requestApprovalType = objERSideOpenHourDetail?.appointmentConfig?.requestApprovalType
        {
            if requestApprovalType == "manual"{
                appointmentType = "Manual Approval"
            }
            else{
                appointmentType =  "Automatic Approval"
            }
        }
        
        var RequestApprovalModal = ERSideOHDetailModal();
        RequestApprovalModal.headLinetext = "Request Approval"
        RequestApprovalModal.valueText = requestType
        RequestApprovalModal.index = 6;
        self.objModalArray.append(RequestApprovalModal)
        
        
        var bookingDeadlineDays = ""

        if let bookingDeadlineDaysBefore = objERSideOpenHourDetail?.appointmentConfig?.bookingDeadlineDaysBefore
        {
            if bookingDeadlineDaysBefore == "1"{
                bookingDeadlineDays = "1 day before Appointment "
            }
            else if bookingDeadlineDaysBefore == "2"{
                bookingDeadlineDays = "2 day before Appointment "

            }
            else if bookingDeadlineDaysBefore == "3"{
                bookingDeadlineDays = "3 day before Appointment "

            }
            else{
                bookingDeadlineDays = "4 day before Appointment "
            }
        }
        
        bookingDeadlineDays.append(" before ")
        
        if let bookingDeadlineTimeonDay = objERSideOpenHourDetail?.appointmentConfig?.bookingDeadlineTimeonDay
        {
            let timeDay = (Int(bookingDeadlineTimeonDay))
            let hour = (timeDay!/3600)
            if  hour <= 12{
                let mintue = (timeDay! % 3600)/60
                bookingDeadlineDays.append(" \(hour) : " + String(format: "%02d", mintue)  + "AM")
            }else{
                let mintue = (timeDay! % 3600)/60
                bookingDeadlineDays.append(" \(hour - 12) : " + String(format: "%02d", mintue)  + "PM")
            }
        }
                
        var AppointmentDeadlineModal = ERSideOHDetailModal();
        AppointmentDeadlineModal.headLinetext = "Appointment Deadline"
        AppointmentDeadlineModal.valueText = bookingDeadlineDays
        AppointmentDeadlineModal.index = 7;
        self.objModalArray.append(AppointmentDeadlineModal)
        
        
        
        var strLocation = "Not available", strLocationValue = ""
        var imageName = "false"
        
//        if let str = self.objERSideOpenHourDetail?.locations{
//            if str.count > 0 {
//                strLocationValue = (str[0].data?.value) ?? "Not available"
//                if str[0].provider == "zoom_link"{
//                    imageName = "Zoom"
//                    strLocation = " Zoom"
//                }
//                else  if str[0].provider == "physical_location"{
//                    imageName = "custom_location"
//                    strLocation = " Physical Location"
//
//                }
//                else{
//                    imageName = "In_person_meeting"
//                    strLocation = " Meeting Url"
//                }
//            }
//
//        }
        
        var LocationModal = ERSideOHDetailModal();
        LocationModal.headLinetext = "Location"
        LocationModal.valueText = strLocation
        LocationModal.imageame = imageName
        LocationModal.index = 8;
        self.objModalArray.append(LocationModal)
        
        
        
        var LocationModalValue = ERSideOHDetailModal();
        LocationModalValue.headLinetext = "Selected Location"
        LocationModalValue.valueText = strLocationValue
        LocationModalValue.index = 9;
        self.objModalArray.append(LocationModalValue)
        
        var participants = "NA"
//        if (objERSideOpenHourDetail?.participants) != nil{
//            if objERSideOpenHourDetail?.participants!.count ?? 0 > 0 {
//                participants = objERSideOpenHourDetail?.participants![0].name ?? ""
//            }
//            if objERSideOpenHourDetail?.participants!.count ?? 0 > 1 {
//                participants = participants + ", + \((objERSideOpenHourDetail?.participants!.count ?? 0) - 1 )"
//            }
//        }
        
        var privateModal = ERSideOHDetailModal();
        privateModal.headLinetext = "Private open hours \n Total Students visible for this open hours"
        privateModal.valueText = participants
        privateModal.index = 10;
        self.objModalArray.append(privateModal)
        
        self.customization();
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        switch self.viewControllerType {
        case 0:
            GeneralUtility.customeNavigationBarWithOnlyBack(viewController: self,title:"Delete Slot");
            
            break;
        case 1:
            GeneralUtility.customeNavigationBarWithOnlyBack(viewController: self,title:"Advising Appointment Hour Details");
            
            break;
        case 2:
            //            GeneralUtility.customeNavigationBarWithOnlyBack(viewController: self,title:" Edit Advising Appointment Hour");
            break;
            
        default:
            break;
        }
    }
      

    
    func callViewModal()  {
        
        activityIndicator = ActivityIndicatorView.showActivity(view: self.view, message: StringConstants.FetchingCoachSelection)
        ERSideOpenHourDetailVM().fetchOpenHourDetail(id: identifier, { (data) in
            do {
                self.activityIndicator?.hide()
                self.objERSideOpenHourDetail = try
                    JSONDecoder().decode(ERSideOpenHourDetail.self, from: data)
                self.creatingModal()
                self.viewInner.isHidden = false

            } catch   {
                print(error)
            }
        }) { (error, errorCode) in
        }
    }
    
    
    func customization()  {
        self.tblview.reloadData();
        let fontHeavy13 = UIFont(name: "FontHeavy".localized(), size: Device.FONTSIZETYPE13)
        let fontHeavy18 = UIFont(name: "FontHeavy".localized(), size: Device.FONTSIZETYPE18)
        
        if viewControllerType == 0 {
            UILabel.labelUIHandling(label: lblDetailHeader, text: "Are you sure, you want to delete this slot?", textColor: ILColor.color(index: 53), isBold: false, fontType: fontHeavy13)
            nslayoutConstarintWidth.constant = 0
            btnEdit.isHidden = true
            btnDelete.isHidden = true
            viewFooter.isHidden = false

            UIButton.buttonUIHandling(button: btnDeleteFooter, text: "Delete", backgroundColor: ILColor.color(index: 23), textColor: .white, cornerRadius: 3, fontType: fontHeavy18)
            
            UIButton.buttonUIHandling(button: btnCancelFooter, text: "Cancel", backgroundColor: .white, textColor: ILColor.color(index: 23), cornerRadius: 3,  borderColor: ILColor.color(index: 23), borderWidth: 1,  fontType: fontHeavy18)
            self.view.layoutIfNeeded()
        }
        else if viewControllerType == 1 {
            btnEdit.isHidden = false
            btnDelete.isHidden = false
            nslayoutConstraintHeighBottomView.constant = 0
            viewFooter.isHidden = true
            let timeSlot =  "\(GeneralUtility.currentDateDetailType3(emiDate: objERSideOpenHourDetail?.startDatetimeUTC ?? ""))  -  \(GeneralUtility.currentDateDetailType3(emiDate: objERSideOpenHourDetail?.endDatetimeUTC ?? ""))";
            UILabel.labelUIHandling(label: lblDetailHeader, text: timeSlot, textColor: ILColor.color(index: 53), isBold: false, fontType: fontHeavy13)
            if let fontHeavy = UIFont(name: "FontHeavy".localized(), size: Device.FONTSIZETYPE14)
            {
                UIButton.buttonUIHandling(button: btnDelete, text: "Delete", backgroundColor: .white, textColor: ILColor.color(index: 23),  fontType: fontHeavy)
                UIButton.buttonUIHandling(button: btnEdit, text: "Edit", backgroundColor: .white, textColor: ILColor.color(index: 23),  fontType: fontHeavy)
            }
        }
        else {
        }
    }
}


extension ERSideOHDetailViewController: UITableViewDelegate,UITableViewDataSource{
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ERSideDetailEditTableViewCell", for: indexPath) as! ERSideDetailEditTableViewCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.viewController = self.viewControllerI
        cell.objERSideOHDetailModal = self.objModalArray[indexPath.row];
        cell.customize()
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objModalArray.count ?? 0
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
