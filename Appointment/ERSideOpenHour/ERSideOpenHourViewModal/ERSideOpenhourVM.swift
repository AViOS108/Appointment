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
    
    func fetchStudentDetail(params: Dictionary<String, AnyObject>, id: String,_ success :@escaping (Data) -> Void,failure :@escaping (String,Int) -> Void )
    {
        ERSideAppointmentService().erSideparticipantApi(params: params, id: id, { (data) in
            success(data)
        }) { (error, errorCode) in
            failure(error, errorCode)
        }
    }
    
    
    func OpenHourDelete(param: Dictionary<String,AnyObject>,deleteAll : String, id: String,_ success :@escaping (Data) -> Void,failure :@escaping (String,Int) -> Void )
    {
        
        ERSideAppointmentService().erSideOPenHourDeleteApi(param: param, deleteAll: deleteAll, id: id, { (data) in
            success(data)
        }) { (error, errorCode) in
            failure(error, errorCode)
        }
        
    }
    

}


protocol ERSideCreateEditOHVMDelegate {

    func sentDataToERSideCreateEditOHVC(dataModalAll : ERSideCreateEditOHVMAllModal?, success: Bool )
}


struct ERSideCreateEditOHVMAllModal {
    var purposeArr : ERSidePurposeDetailModalArr?
    var timeZOneArr = [TimeZoneSel]()
    var objERSideOPenHourModal : ERSideOPenHourModal?
    var  purposeNewArr : ERSidePurposeDetailNewModalArr?
    
    
    
}

class ERSideCreateEditOHVM {
    var objviewTypeOpenHour : viewTypeOpenHour!

    var objERSideCreateEditOHVMAllModal : ERSideCreateEditOHVMAllModal?
    
    let dispatchGroup = DispatchGroup()
    var delegate : ERSideCreateEditOHVMDelegate!
    var viewController : UIViewController!
    var  purposeNewArr : ERSidePurposeDetailNewModalArr?

    var purposeArr : ERSidePurposeDetailModalArr!
    var timeZOneArr = [TimeZoneSel]()
    var objERSideOPenHourModal : ERSideOPenHourModal?
    var dateSelected : Date!

    var activityIndicator: ActivityIndicatorView?
    
    func customizeCreateEditOPenHour()  {
        
        activityIndicator = ActivityIndicatorView.showActivity(view: viewController.view, message: StringConstants.FetchingCoachSelection)
        
        
        switch self.objviewTypeOpenHour {
        case .duplicateSetHour:
            
            dispatchGroup.enter()
            fetchDuplicatePurpose()
            dispatchGroup.enter()
            hitApiForTimeZone()
            dispatchGroup.enter()
            fetchAllPointMentForDuplicate()
            break
            
        case .editOpenHour :
            dispatchGroup.enter()
            hitApiForPurpose()
            dispatchGroup.enter()
            hitApiForTimeZone()
            break
            
        case .setOpenHour :
            dispatchGroup.enter()
            hitApiForPurpose()
            dispatchGroup.enter()
            hitApiForTimeZone()
            break
            
        default: break
            
        }
        
        
        
        dispatchGroup.notify(queue: .main) {
            
            self.activityIndicator?.hide()
            
            switch self.objviewTypeOpenHour {
            case .duplicateSetHour:
                if self.purposeNewArr != nil && self.timeZOneArr.count > 0 && self.objERSideOPenHourModal != nil {
                    
                    self.objERSideCreateEditOHVMAllModal = ERSideCreateEditOHVMAllModal()
                    self.objERSideCreateEditOHVMAllModal?.timeZOneArr = self.timeZOneArr
                    self.objERSideCreateEditOHVMAllModal?.purposeNewArr = self.purposeNewArr
                    self.objERSideCreateEditOHVMAllModal?.objERSideOPenHourModal = self.objERSideOPenHourModal
                    
                    self.delegate.sentDataToERSideCreateEditOHVC(dataModalAll: self.objERSideCreateEditOHVMAllModal , success: true)
                }
                else{
                    self.delegate.sentDataToERSideCreateEditOHVC(dataModalAll:nil , success: false)
                }
                
                
                break
                
            case .editOpenHour :
                
                if self.purposeArr != nil && self.timeZOneArr.count > 0 {
                    self.objERSideCreateEditOHVMAllModal = ERSideCreateEditOHVMAllModal()
                    self.objERSideCreateEditOHVMAllModal?.timeZOneArr = self.timeZOneArr
                    self.objERSideCreateEditOHVMAllModal?.purposeArr = self.purposeArr
                    self.delegate.sentDataToERSideCreateEditOHVC(dataModalAll:self.objERSideCreateEditOHVMAllModal , success: true)
                }
                else{
                    self.delegate.sentDataToERSideCreateEditOHVC(dataModalAll:nil , success: false)
                }
                break
                
            case .setOpenHour :
                if self.purposeArr != nil && self.timeZOneArr.count > 0 {
                    self.objERSideCreateEditOHVMAllModal = ERSideCreateEditOHVMAllModal()
                    self.objERSideCreateEditOHVMAllModal?.timeZOneArr = self.timeZOneArr
                    self.objERSideCreateEditOHVMAllModal?.purposeArr = self.purposeArr
                    
                    self.delegate.sentDataToERSideCreateEditOHVC(dataModalAll:self.objERSideCreateEditOHVMAllModal , success: true)
                }
                else{
                    self.delegate.sentDataToERSideCreateEditOHVC(dataModalAll:nil , success: false)
                }
                
                break
                
            default: break
                
            }
        }
        
    }
    
    
    func fetchDuplicatePurpose()
       {
        let csrftoken = UserDefaultsDataSource(key: "csrf_token").readData() as! String
        var localTimeZoneAbbreviation: String { return TimeZone.current.description }
      
        let dateFormatter = DateFormatter()
                 dateFormatter.dateFormat = "yyyy-MM-dd"
                 let dateStart = dateFormatter.string(from: dateSelected)
                 var dateCompStartChange = DateComponents()
                 dateCompStartChange.day = -1 ;
                 let dateEnd = Calendar.current.date(byAdding: dateCompStartChange, to: dateSelected)!
        
        
        let params  =  [
            ParamName.PARAMFILTERSEL : [
                "timezone":localTimeZoneAbbreviation,
                "from": dateStart + " " + "00:00:00",
                "to": dateStart + " " + "23:59:59"
            ],
            ParamName.PARAMINTIMEZONEEL :localTimeZoneAbbreviation,
            ParamName.PARAMCSRFTOKEN : csrftoken,
            ParamName.PARAMMETHODKEY : "post" ] as [String : AnyObject]
        
        
        ERSideAppointmentService().erSideDuplicatePurpose(params: params, { (jsonData) in
            do {
                    self.purposeNewArr = try
                        JSONDecoder().decode(ERSidePurposeDetailNewModalArr.self, from: jsonData)
                    self.dispatchGroup.leave()
               
            } catch   {
                print(error)
                self.dispatchGroup.leave()
            }
        }) { (error, errorCode) in
            self.dispatchGroup.leave()
        }
        
    }
    
    
    
       func fetchAllPointMentForDuplicate()
       {
        let csrftoken = UserDefaultsDataSource(key: "csrf_token").readData() as! String
        var localTimeZoneAbbreviation: String { return TimeZone.current.description }
      
        let dateFormatter = DateFormatter()
                 dateFormatter.dateFormat = "yyyy-MM-dd"
                 let dateStart = dateFormatter.string(from: dateSelected)
                 var dateCompStartChange = DateComponents()
                 dateCompStartChange.day = -1 ;
                 let dateEnd = Calendar.current.date(byAdding: dateCompStartChange, to: dateSelected)!
                 let dateEndStr = dateFormatter.string(from: dateEnd)
        
        
        let params  =  [
            ParamName.PARAMFILTERSEL : [
                "timezone":localTimeZoneAbbreviation,
                "from": dateEndStr  + " " + "23:59:59",
                "to": dateStart + " " + "23:59:59"
            ],
            ParamName.PARAMCSRFTOKEN : csrftoken,
            ParamName.PARAMMETHODKEY : "post" ] as [String : AnyObject]
        
        ERSideAppointmentService().erSideOpenHourListApi(params: params, { (jsonData) in
            do {
                    self.objERSideOPenHourModal = try
                        JSONDecoder().decode(ERSideOPenHourModal.self, from: jsonData)
                    self.dispatchGroup.leave()
               
            } catch   {
                print(error)
                self.dispatchGroup.leave()
            }
        }) { (error, errorCode) in
            self.dispatchGroup.leave()
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
    
    func submitEditedOpenHour(prameter : Dictionary<String,AnyObject>,id : String, _ success :@escaping (Data) -> Void,failure :@escaping (String,Int) -> Void)
        {
            
            ERSideAppointmentService().erSideSubmitEditedOpenHour(params: prameter, id: id, { (jsonData) in
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


struct ERSideADHOCAPISecondModal {
    
    var purposeArr : ERSidePurposeDetailModalArr!
    var objStudentDetailModal: StudentDetailModal!
    var objProviderModalArr : ProviderModalArr!

}

protocol ERSideADHOCAPISecondVCDelegate {
 
    func sendDataERSideADHOCAPISecondVC( objERSideADHOCAPISecondModal : ERSideADHOCAPISecondModal,isSuccess: Bool)
    
}

class ERSideADHOCAPISecondVC{
    let dispatchGroup = DispatchGroup()
     var activityIndicator: ActivityIndicatorView?
    var delegate : ERSideADHOCAPISecondVCDelegate!

    var objProviderModalArr : ProviderModalArr!
    var purposeArr : ERSidePurposeDetailModalArr!
    var objStudentDetailModal: StudentDetailModal!
    var objERSideADHOCAPISecondModal : ERSideADHOCAPISecondModal!
    var viewController : UIViewController!
    func customAPI(){
        activityIndicator = ActivityIndicatorView.showActivity(view: viewController.view, message: StringConstants.FetchingCoachSelection)
        dispatchGroup.enter()
        hitApiForPurpose()
        dispatchGroup.enter()
        fetchStudentList()
        dispatchGroup.enter()
        hitLocationProvider()
        dispatchGroup.notify(queue: .main) {
            self.activityIndicator?.hide()
            if self.purposeArr != nil && self.objStudentDetailModal != nil && self.objProviderModalArr != nil{
                
                self.objERSideADHOCAPISecondModal = ERSideADHOCAPISecondModal()
                self.objERSideADHOCAPISecondModal.purposeArr = self.purposeArr;
                self.objERSideADHOCAPISecondModal.objStudentDetailModal = self.objStudentDetailModal
                self.objERSideADHOCAPISecondModal.objProviderModalArr = self.objProviderModalArr
                
                
                self.delegate.sendDataERSideADHOCAPISecondVC(objERSideADHOCAPISecondModal: self.objERSideADHOCAPISecondModal, isSuccess: true)
            }
            else{
                self.delegate.sendDataERSideADHOCAPISecondVC(objERSideADHOCAPISecondModal: self.objERSideADHOCAPISecondModal, isSuccess: false)
            }
            
        }
    }
    
    func hitLocationProvider()  {
           ERSideOpenEditSecondVM().fetchProvider({ (data) in
               do {
                   self.objProviderModalArr = try
                       JSONDecoder().decode(ProviderModalArr.self, from: data)
                  
               } catch   {
                   print(error)
                  
               }
              self.dispatchGroup.leave()
           }) { (error, errorCode) in
              self.dispatchGroup.leave()
           }
       }
    
    
    func hitApiForPurpose()
    {
        ERSideAppointmentService().erSideOPenHourGetPurposeApi( { (data) in
            do {
                self.purposeArr = try JSONDecoder().decode(ERSidePurposeDetailModalArr.self, from: data);
                
                
            } catch   {
                print(error)
            }
            self.dispatchGroup.leave()
        }) { (error, errorCode) in
            self.dispatchGroup.leave()
        }
        
    }
    
    
    func fetchStudentList()
    {
        
        let includes = ["invitation_id","benchmark","tags"]
        let csrftoken = UserDefaultsDataSource(key: "csrf_token").readData() as! String
        let  param = [
            ParamName.PARAMCSRFTOKEN : csrftoken,
            ParamName.PARAMMETHODKEY : "post",
            "includes"  : includes
            ] as [String : AnyObject]
        
        ERSideAppointmentService().erSideStudentListApi(params: param, { (jsonData) in
            do {
                self.objStudentDetailModal = try
                    JSONDecoder().decode(StudentDetailModal.self, from: jsonData)

            } catch   {
                print(error)
            }
            self.dispatchGroup.leave()
        }) { (error, errorCode) in
            
            self.dispatchGroup.leave()
        }
        
    }
    
    
    
}






