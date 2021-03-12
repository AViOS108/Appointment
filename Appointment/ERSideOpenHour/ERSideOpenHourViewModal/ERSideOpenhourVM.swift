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

    func sentDataToERHomeVC(dataAppoinmentModal : ERSideOPenHourModal?,success: Bool,index: Int )
}


class ERSideOpenhourVM {
    
    
    let dispatchGroup = DispatchGroup()
    var objERSideOPenHourModal : ERSideOPenHourModal?
//    var objERSideAppointmentModal2 : ERSideAppointmentModal?
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
    
    
    
    func outputResult() -> ERSideOPenHourModal?  {
        
        
        if self.objERSideOPenHourModal != nil{
            
            
        }
        else
        {
            return nil
        }
        
        
        return self.objERSideOPenHourModal
        
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
            dateCompStartChange.day = -1 ;
            let dateEnd = Calendar.current.date(byAdding: dateCompStartChange, to: dateSelected)!
            let dateEndStr = dateFormatter.string(from: dateEnd)
            dateFormatter.dateFormat = "HH:mm:ss"
            let appendDate = dateFormatter.string(from: Date())
            var localTimeZoneAbbreviation: String { return TimeZone.current.description }
            param = [
                ParamName.PARAMFILTERSEL : [
                    "timezone":localTimeZoneAbbreviation,
                    "from": dateEndStr + " " + "23:59:59",
                    "to": dateStart + " " + "23:59:59"
                ],
                ParamName.PARAMINTIMEZONEEL :localTimeZoneAbbreviation,
                ParamName.PARAMCSRFTOKEN : csrftoken,
                ParamName.PARAMMETHODKEY : "post"
                ] as [String : AnyObject]
        }
        return param
    }
    
    
    
    
    func fetchAllPointMent(index : Int)
    {
        
        ERSideAppointmentService().erSideOpenHourListApi(params: parameter(index: index), { (jsonData) in
            do {
                if index == 1{
                    self.objERSideOPenHourModal = try
                        JSONDecoder().decode(ERSideOPenHourModal.self, from: jsonData)
                    self.dispatchGroup.leave()
                }
                else if index == 2{
//                    self.objERSideAppointmentModal2 = try
//                        JSONDecoder().decode(ERSideAppointmentModal.self, from: jsonData)
//                    self.dispatchGroup.leave()
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
    
    
    func OpenHourDelete(param: Dictionary<String,AnyObject>,id: String,_ success :@escaping (Data) -> Void,failure :@escaping (String,Int) -> Void )
    {
        
        ERSideAppointmentService().erSideOPenHourDeleteApi(param: param, id: id, { (data) in
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
    
    
    func erSideOPenHourPostPurposeApi(prameter : Dictionary<String,Any>,_ success :@escaping (Data) -> Void,failure :@escaping (String,Int) -> Void ){
        
        let headers: Dictionary<String,String> = ["Authorization": "Bearer \(UserDefaults.standard.object(forKey: "accessToken")!)"]
        
        Network().makeApiEventGetRequest(true, url: Urls().erSideOPenHourGetPurpose(), methodType: .post, params: prameter as Dictionary<String,AnyObject>, header: headers, completion: { (jsonData) in
            success(jsonData)
            
        }) { (error, errorCode) in
            failure(error,errorCode)
            
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
    
    
   func submitNewUserPurpose(prameter : Dictionary<String,AnyObject>,_ success :@escaping (Data) -> Void,failure :@escaping (String,Int) -> Void)
    {
        
        ERSideAppointmentService().erSideSubmitNewUserPurposeApi(params: prameter, { (jsonData) in
            do {
                success(jsonData)
                
            } catch   {
                print(error)
            }
        }) { (error, errorCode) in
            
            failure(error, errorCode)
        }
        
    }
    
    
    
     
    func submitNewOpenHour(prameter : Dictionary<String,AnyObject>,_ success :@escaping (Data) -> Void,failure :@escaping (String,Int) -> Void)
     {
         
         ERSideAppointmentService().erSideSubmitNewOpenHour(params: prameter, { (jsonData) in
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





