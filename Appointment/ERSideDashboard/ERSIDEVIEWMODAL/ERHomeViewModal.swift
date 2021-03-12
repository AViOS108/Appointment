//
//  ERHomeViewModal.swift
//  Appointment
//
//  Created by Anurag Bhakuni on 13/11/20.
//  Copyright © 2020 Anurag Bhakuni. All rights reserved.
//

import Foundation
import UIKit


enum ERSideViewModalType {
    case ERSideHome
    case ERSideUpcoming
    case ERSidePast
    case ERSidePending

    
}


protocol ERHomeViewModalVMDelegate {
    
    func sentDataToERHomeVC(dataAppoinmentModal : ERSideAppointmentModal?,success: Bool,index: Int )


}
class ERHomeViewModal {
    
    var participant : Array<Dictionary<String,AnyObject>>?
    let dispatchGroup = DispatchGroup()
    var objERSideAppointmentModal1 : ERSideAppointmentModal?
    var objERSideAppointmentModal2 : ERSideAppointmentModal?
    var dateSelected : Date!
    var viewController : UIViewController!
    
    var enumType : ERSideViewModalType!
    
    var delegate : ERHomeViewModalVMDelegate!
    var activityIndicator: ActivityIndicatorView?
    
    var skip = 0;
    
    func custmoziation()
    {
        activityIndicator = ActivityIndicatorView.showActivity(view: viewController.view, message: StringConstants.FetchingCoachSelection)
        
        
        switch enumType {
        case .ERSideHome:
            self.customERSIdeHome()
            break
        case .ERSideUpcoming:
            self.customeERSideMYAPPO(index: 2)
            break
        case .ERSidePast:
            self.customeERSideMYAPPO(index: 4)
            
            break
        case .ERSidePending:
            self.customeERSideMYAPPO(index: 3)
            break
        default: break
            
        }
        
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
    
    
    func outputResultERSideMYAPPO(index : Int) -> ERSideAppointmentModal?  {
        
        
        if index == 2
        {
            return self.objERSideAppointmentModal1
        }
        else if index == 3
        {
            return self.objERSideAppointmentModal1
        }
        else if index == 4{
            var objSectionHeaderERMyAppoArr = [SectionHeaderERMyAppo]()
            var arrHeader = ["Pending Next Steps","Completed Next Steps","Not Attended Appointments"]
            
            for (index, title) in arrHeader.enumerated() {
                var objSectionHeaderERMyAppo = SectionHeaderERMyAppo();
                objSectionHeaderERMyAppo.title = title
                objSectionHeaderERMyAppo.index = index
                objSectionHeaderERMyAppo.isExpand = false
                objSectionHeaderERMyAppoArr.append(objSectionHeaderERMyAppo)
                
            }
            
            self.objERSideAppointmentModal1?.sectionHeaderERMyAppo?.append(contentsOf: objSectionHeaderERMyAppoArr)
            return   self.objERSideAppointmentModal1
            
        }
        
        
        return self.objERSideAppointmentModal1
        
        
    }
    
    
    
    
    func outputResult() -> ERSideAppointmentModal?  {
        
        var appointmentLocal = ERSideAppointmentModal()
        
        if self.objERSideAppointmentModal1 != nil{
            
            
        }
        else
        {
            return nil
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateS = dateFormatter.string(from: dateSelected)
        
        let dateD = dateFormatter.date(from: dateS)
        
        
        var objSectionHeaderERArr = [SectionHeaderER]()
        var index = 0
        while (index < 7){
            
            var objSectionHeaderER = SectionHeaderER()
            var dateCompStartChange = DateComponents()
            dateCompStartChange.day = index ;
            let dateEnd = Calendar.current.date(byAdding: dateCompStartChange, to: dateD!)!
            objSectionHeaderER.date = dateEnd
            objSectionHeaderERArr.append(objSectionHeaderER)
            index = index + 1
        }
        appointmentLocal = self.objERSideAppointmentModal1!
        appointmentLocal.sectionHeaderER = objSectionHeaderERArr
        return appointmentLocal
        
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
            
            
            
            states = ["accepted","auto_accepted"]
            param = [
                ParamName.PARAMFILTERSEL : [
                    "states" : ["confirmed"],
                    "has_request":
                        ["states":states
                        ],
                    "with_request":
                    ["states":states
                    ],
                    "timezone":"utc",
                    "from": dateStart + " " + appendDate,
                    "to": dateEndStr + " " + appendDate
                ],
                ParamName.PARAMINTIMEZONEEL :"utc",
                ParamName.PARAMCSRFTOKEN : csrftoken,
                ParamName.PARAMMETHODKEY : "post"
                ] as [String : AnyObject]
            
            
        }
            
        else if index == 2{
            
           
            var filter : Dictionary<String,Any>
            states = ["accepted_by_community_user","auto_accepted"]

            if participant != nil {
             
                filter = [
                    "states" : states,
                    "timezone":"utc",
                    "from": GeneralUtility.todayDate() as AnyObject,
                    "participants" : participant!
                    
                ]
                
            }
            else{
                filter = [
                    "states" : states,
                    "timezone":"utc",
                    "from": GeneralUtility.todayDate() as AnyObject,
                    
                ]
                
            }
            
           
            
            param = [
                ParamName.PARAMFILTERSEL : filter,
                ParamName.PARAMINTIMEZONEEL :"utc",
                ParamName.PARAMCSRFTOKEN : csrftoken,
                ParamName.PARAMMETHODKEY : "post",
                ParamName.PARAMFILTERSTAKEEL: 50,
                ParamName.PARAMFILTERSSKIPEL: skip,
                ParamName.PARAMSORTEL :[
                    ParamName.PARAMFIELDEL : "start_datetime_utc",
                    ParamName.PARAMORDEREL : "asc"
                ]
                
                ] as [String : AnyObject]
            
           
            
        }
        else if index == 3{
            states = ["requested_by_student_user"]
            var filter : Dictionary<String,Any>
            
            if participant != nil {
                
                filter = [
                    "states" : states,
                    "timezone":"utc",
                    "participants" : participant!
                ]
                
            }
            else{
                filter = [
                    "states" : states,
                    "timezone":"utc",
                    
                ]
                
            }
            
            param = [
                ParamName.PARAMFILTERSEL : filter,
                ParamName.PARAMINTIMEZONEEL :"utc",
                ParamName.PARAMCSRFTOKEN : csrftoken,
                ParamName.PARAMMETHODKEY : "post",
                ParamName.PARAMFILTERSTAKEEL: 50,
                ParamName.PARAMFILTERSSKIPEL: skip,
                ParamName.PARAMSORTEL :[
                    ParamName.PARAMFIELDEL : "created_at",
                    ParamName.PARAMORDEREL : "desc"
                ]
                
                ] as [String : AnyObject]
            
            
        }
        else if index == 4{
            
            states = ["accepted_by_community_user","auto_accepted"]
            var filter : Dictionary<String,Any>
                       
                       if participant != nil {
                           
                           filter = [
                               "states" : states,
                               "timezone":"utc",
                               "to": GeneralUtility.todayDate() as AnyObject,
                               "from_to_strict": 1,
                               "participants" : participant!
                           ]
                           
                       }
                       else{
                           filter = [
                               "states" : states,
                               "timezone":"utc",
                               "to": GeneralUtility.todayDate() as AnyObject,
                               "from_to_strict": 1
                               
                           ]
                           
                       }
            
            
            param = [
                ParamName.PARAMFILTERSEL : filter,
                ParamName.PARAMINTIMEZONEEL :"utc",
                ParamName.PARAMCSRFTOKEN : csrftoken,
                ParamName.PARAMMETHODKEY : "post",
                ParamName.PARAMFILTERSTAKEEL: 50,
                ParamName.PARAMFILTERSSKIPEL: skip,
                ParamName.PARAMSORTEL :[
                    ParamName.PARAMFIELDEL : "created_at",
                    ParamName.PARAMORDEREL : "desc"
                ]
                
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


extension ERHomeViewModal{
    
    func customeERSideMYAPPO(index: Int)  {
        
        dispatchGroup.enter()
        self.fetchERSideMYAPPO(index: index)
       
        dispatchGroup.notify(queue: .main) {
            
            self.activityIndicator?.hide()
          
            if let outputR = self.outputResultERSideMYAPPO(index: index){
                self.delegate.sentDataToERHomeVC(dataAppoinmentModal: outputR, success: true, index: index)
            }
            else{
                
                self.delegate.sentDataToERHomeVC(dataAppoinmentModal: nil, success: false, index: index)
                
            }
            
        }
        
        
        
    }
    
    
    
    
    
    
    func fetchERSideMYAPPO(index: Int)
    {
        
        ERSideAppointmentService().erSideAppointemntListApi(params: parameter(index: index), { (jsonData) in
            do {
                 
                
                let objERSideAppointmentModalLocal = try
                        JSONDecoder().decode(ERSideAppointmentModal.self, from: jsonData)
                if objERSideAppointmentModalLocal.total ?? 0 <= self.skip + 50{
                    if  self.objERSideAppointmentModal1 != nil {
                        
                        self.objERSideAppointmentModal1?.results?.append(contentsOf: objERSideAppointmentModalLocal.results!);
                    }
                    else
                    {
                        self.objERSideAppointmentModal1  = objERSideAppointmentModalLocal;
                        
                    }
                     self.dispatchGroup.leave()
                    
                }
                else
                {
                    self.skip = self.skip + 50
                    self.fetchERSideMYAPPO(index: index)
                    if  self.objERSideAppointmentModal1 != nil {
                        
                        self.objERSideAppointmentModal1?.results?.append(contentsOf: objERSideAppointmentModalLocal.results!);
                    }
                    else
                    {
                        self.objERSideAppointmentModal1  = objERSideAppointmentModalLocal;
                        
                    }
                    
                    
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

