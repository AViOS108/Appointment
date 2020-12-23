//
//  ERSideOpenhourVM.swift
//  Appointment
//
//  Created by Anurag Bhakuni on 26/11/20.
//  Copyright © 2020 Anurag Bhakuni. All rights reserved.
//

import Foundation
import UIKit


protocol ERSideOpenhourVMDelegate {

    func sentDataToERHomeVC(dataAppoinmentModal : ERSideAppointmentModal?,success: Bool,index: Int )
}


class ERSideOpenhourVM {
    
    
    let dispatchGroup = DispatchGroup()
    var objERSideAppointmentModal1 : ERSideAppointmentModal?
    var objERSideAppointmentModal2 : ERSideAppointmentModal?
    var dateSelected : Date!
    var viewController : UIViewController!
    var activityIndicator: ActivityIndicatorView?
    var delegate : ERSideOpenhourVMDelegate!
    
    func custmoziation()
    {
        activityIndicator = ActivityIndicatorView.showActivity(view: viewController.view, message: StringConstants.FetchingCoachSelection)
        self.customERSIdeHome()
    }
    
    func customERSIdeHome(){
        dispatchGroup.enter()
        fetchAllPointMent(index: 1)
        dispatchGroup.notify(queue: .main) {
            
            self.activityIndicator?.hide()
            if let outputR = self.outputResult(){
                self.delegate.sentDataToERHomeVC(dataAppoinmentModal: outputR, success: true, index: 1)
            }
            else{
                
                self.delegate.sentDataToERHomeVC(dataAppoinmentModal: nil, success: false, index: 1)
                
            }
            
        }
    }
    
    
    
    func outputResult() -> ERSideAppointmentModal?  {
        
        var appointmentLocal = ERSideAppointmentModal()
        
        if self.objERSideAppointmentModal1 != nil{
            
            
        }
        else
        {
            return nil
        }
        
        
        return self.objERSideAppointmentModal1
        
    }
    
    
    func parameter(index : Int) -> Dictionary<String,AnyObject> {
        let csrftoken = UserDefaultsDataSource(key: "csrf_token").readData() as! String
        var states = [String]();
        var param = Dictionary<String,AnyObject>() ;
        if index == 1{
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let dateStart = dateFormatter.string(from: dateSelected)
            var dateCompStartChange = DateComponents()
            dateCompStartChange.day = 7 ;
            let dateEnd = Calendar.current.date(byAdding: dateCompStartChange, to: dateSelected)!
            let dateEndStr = dateFormatter.string(from: dateEnd)
            dateFormatter.dateFormat = "HH:mm:ss"
            let appendDate = dateFormatter.string(from: Date())
            var localTimeZoneAbbreviation: String { return TimeZone.current.description }
            states = ["confirmed"]
            param = [
                ParamName.PARAMFILTERSEL : [
                    "states" : states,
                    "timezone":"utc",
                    "from": dateStart + " " + appendDate,
                    "to": dateEndStr + " " + appendDate
                ],
                ParamName.PARAMINTIMEZONEEL :"utc",
                ParamName.PARAMCSRFTOKEN : csrftoken,
                ParamName.PARAMMETHODKEY : "post"
                ] as [String : AnyObject]
        }
        return param
    }
    
    
    
    
    func fetchAllPointMent(index : Int)
    {
        
        ERSideAppointmentService().erSideAppointemntListApi(params: parameter(index: index), { (jsonData) in
            do {
                if index == 1{
                    self.objERSideAppointmentModal1 = try
                        JSONDecoder().decode(ERSideAppointmentModal.self, from: jsonData)
                    self.dispatchGroup.leave()
                }
                else if index == 2{
                    self.objERSideAppointmentModal2 = try
                        JSONDecoder().decode(ERSideAppointmentModal.self, from: jsonData)
                    self.dispatchGroup.leave()
                }
            } catch   {
                print(error)
                self.dispatchGroup.leave()
            }
        }) { (error, errorCode) in
            self.dispatchGroup.leave()
        }
        
    }
    
}



class ERSideOpenHourDetailVM {
    
    
    func fetchOpenHourDetail(id: String,_ success :@escaping (Data) -> Void,failure :@escaping (String,Int) -> Void )
    {
        
        ERSideAppointmentService().erSideOPenHourApi(id: id, { (data) in
            success(data)
        }) { (error, errorCode) in
            failure(error, errorCode)
        }
        
    }

}


protocol ERSideCreateEditOHVMDelegate {

    func sentDataToERSideCreateEditOHVC(dataPurposeModal : ERSidePurposeDetailModalArr?,timeZOneArr:[TimeZoneSel]?, success: Bool )
}



class ERSideCreateEditOHVM {
    
    let dispatchGroup = DispatchGroup()
    var delegate : ERSideCreateEditOHVMDelegate!
    var viewController : UIViewController!
    
    var purposeArr : ERSidePurposeDetailModalArr!
    var timeZOneArr = [TimeZoneSel]()

    
    var activityIndicator: ActivityIndicatorView?
    
    func customizeCreateEditOPenHour()  {
        activityIndicator = ActivityIndicatorView.showActivity(view: viewController.view, message: StringConstants.FetchingCoachSelection)
        
        dispatchGroup.enter()
        hitApiForPurpose()
        
        dispatchGroup.enter()
        hitApiForTimeZone()
        
        dispatchGroup.notify(queue: .main) {
            
            self.activityIndicator?.hide()
            
            if self.purposeArr != nil && self.timeZOneArr != nil{

                self.delegate.sentDataToERSideCreateEditOHVC(dataPurposeModal: self.purposeArr, timeZOneArr: self.timeZOneArr, success: true)
            }
            else{
                self.delegate.sentDataToERSideCreateEditOHVC(dataPurposeModal: nil, timeZOneArr:nil, success: false)


            }
            
            
        }
        
    }
    
    
    func hitApiForPurpose()
    {
        ERSideAppointmentService().erSideOPenHourGetPurposeApi( { (data) in
            do {
                
                self.purposeArr = try JSONDecoder().decode(ERSidePurposeDetailModalArr.self, from: data)
                self.dispatchGroup.leave()
                
            } catch   {
                self.dispatchGroup.leave()
                print(error)
            }
            
        }) { (error, errorCode) in
            
        }
        
    }
    
    func hitApiForTimeZone()
    {
        let dashBoardViewModal = DashBoardViewModel()
        dashBoardViewModal.viewController = viewController
        dashBoardViewModal.fetchTimeZoneCall { (timeArr) in
            self.timeZOneArr = timeArr
            self.dispatchGroup.leave()

        }
        
        
    }
    
}





class ERSideOpenEditSecondVM {
    
    
    func fetchProvider(_ success :@escaping (Data) -> Void,failure :@escaping (String,Int) -> Void )
    {
        
        ERSideAppointmentService().erSideOPenHourProviderApi( { (data) in
            success(data)
        }) { (error, errorCode) in
            failure(error, errorCode)
        }
        
    }

}


class ERSideStudentListViewModal {
    
    
    func fetchStudentList(prameter : Dictionary<String,AnyObject>,_ success :@escaping (Data) -> Void,failure :@escaping (String,Int) -> Void)
    {
        
        ERSideAppointmentService().erSideStudentListApi(params: prameter, { (jsonData) in
            do {
                success(jsonData)
                
            } catch   {
                print(error)
            }
        }) { (error, errorCode) in
            
            failure(error, errorCode)
        }
        
    }
    
    
    
    func fetchTags(_ success :@escaping (Data) -> Void,failure :@escaping (String,Int) -> Void )
    {
        
        ERSideAppointmentService().erSideOPenHourTags( { (data) in
            success(data)
        }) { (error, errorCode) in
            failure(error, errorCode)
        }
        
    }
    
    
    
    
    
}





