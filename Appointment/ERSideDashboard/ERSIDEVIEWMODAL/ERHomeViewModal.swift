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
    
    func sentDataToERHomeVC(dataAppoinmentModal : ERSideAppointmentModalNew?,success: Bool,index: Int )


}
class ERHomeViewModal {
    
    var filterAdded = Dictionary<String,Any>()
    let dispatchGroup = DispatchGroup()
    
    var objERSideAppointmentNewModal : ERSideAppointmentModalNew?
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
    
    
    func outputResultERSideMYAPPO(index : Int) -> ERSideAppointmentModalNew?  {
        
        
        if index == 2
        {
            return self.objERSideAppointmentNewModal
        }
        else if index == 3
        {
            return self.objERSideAppointmentNewModal
        }
        else if index == 4{
//            var objSectionHeaderERMyAppoArr = [SectionHeaderERMyAppo]()
//            var arrHeader = ["Pending Next Steps","Completed Next Steps","Not Attended Appointments"]
//
//            for (index, title) in arrHeader.enumerated() {
//                var objSectionHeaderERMyAppo = SectionHeaderERMyAppo();
//                objSectionHeaderERMyAppo.title = title
//                objSectionHeaderERMyAppo.index = index
//                objSectionHeaderERMyAppo.isExpand = false
//                objSectionHeaderERMyAppoArr.append(objSectionHeaderERMyAppo)
//
//            }
//
//            self.objERSideAppointmentNewModal?.sectionHeaderERMyAppo?.append(contentsOf: objSectionHeaderERMyAppoArr)
            return   self.objERSideAppointmentNewModal
            
        }
        
        
        return self.objERSideAppointmentNewModal
        
        
    }
    
    
    
    
    func outputResult() -> ERSideAppointmentModalNew?  {
        var appointmentLocal = ERSideAppointmentModalNew()
        if self.objERSideAppointmentNewModal != nil{
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
        appointmentLocal = self.objERSideAppointmentNewModal!
        appointmentLocal.sectionHeaderER = objSectionHeaderERArr
        return appointmentLocal
    }
    
    
    
    
    func parameter(index : Int) -> Dictionary<String,AnyObject> {
        let csrftoken = UserDefaultsDataSource(key: "csrf_token").readData() as! String
        var states = [String]();
        var param = Dictionary<String,AnyObject>() ;
        if index == 1{
            //ERHOMEPAGE PARAMETER
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
            
            //MY APPOINMENT UPCOMING PARAMETER
            var has_Request = Dictionary<String,Any>()
            
            if filterAdded.isEmpty{
                
            }
            else {
                if let benchmark = filterAdded["benchmark"]  {
                     has_Request = ["benchmarks" : benchmark]
                }
                if let tags : Dictionary<String,Any> = filterAdded["tag"] as? Dictionary<String, Any> {
                    var tages = Array<Dictionary<String,Any>>()
                    for (index, entry) in tags {
                        var dictionaryCat = Dictionary<String,Any>()
                        dictionaryCat["category"] = index;
                        dictionaryCat["values"] = entry;
                        tages.append(dictionaryCat)
                    }
                    
                    if has_Request.isEmpty{
                        has_Request =  ["tags" : tages]
                    }
                    else
                    {
                        var has_RequestCopy = has_Request
                        has_RequestCopy["tags"] = tages;
                        has_Request = has_RequestCopy
                    }
                }
                
                if let nameEmail = filterAdded["name_email"]{
                    if has_Request.isEmpty{
                        has_Request =  ["name_email" : nameEmail]
                    }
                    else
                    {
                        var has_RequestCopy = has_Request
                        has_RequestCopy["name_email"] = nameEmail;
                        has_Request = has_RequestCopy
                    }
                }
            }
            states = ["accepted","auto_accepted"]

            if has_Request.isEmpty{
                has_Request =  ["states" : states]
            }
            else
            {
                var has_RequestCopy = has_Request
                has_RequestCopy["states"] = states;
                has_Request = has_RequestCopy
            }
            
            
            param = [
                ParamName.PARAMFILTERSEL : [
                    "states" : ["confirmed"],
                    "has_request":
                        has_Request,
                    "with_request":
                        ["states":states
                    ],
                    "timezone":"utc",
                    "from": GeneralUtility.todayDate() as AnyObject,
                ],
                ParamName.PARAMINTIMEZONEEL :"utc",
                ParamName.PARAMCSRFTOKEN : csrftoken,
                ParamName.PARAMMETHODKEY : "post",
                ParamName.PARAMFILTERSTAKEEL: 10,
                ParamName.PARAMFILTERSSKIPEL: skip,
                ParamName.PARAMSORTEL :[
                    ParamName.PARAMFIELDEL : "created_at",
                    ParamName.PARAMORDEREL : "desc"
                ]
                ] as [String : AnyObject]
            
        }
        else if index == 3{
            //MY APPOINMENT PENDING PARAMETER
            
            var has_Request = Dictionary<String,Any>()
            
            if filterAdded.isEmpty{
                
            }
            else {
                if let benchmark = filterAdded["benchmark"]  {
                    has_Request = ["benchmarks" : benchmark]
                }
                if let tags : Dictionary<String,Any> = filterAdded["tag"] as? Dictionary<String, Any> {
                    var tages = Array<Dictionary<String,Any>>()
                    for (index, entry) in tags{
                        var dictionaryCat = Dictionary<String,Any>()
                        dictionaryCat["category"] = index;
                        dictionaryCat["values"] = entry;
                        tages.append(dictionaryCat)
                    }
                    
                    if has_Request.isEmpty{
                        has_Request =  ["tags" : tages]
                    }
                    else
                    {
                        var has_RequestCopy = has_Request
                        has_RequestCopy["tags"] = tages;
                        has_Request = has_RequestCopy
                    }
                }
                
                if let nameEmail = filterAdded["name_email"]{
                    if has_Request.isEmpty{
                        has_Request =  ["name_email" : nameEmail]
                    }
                    else
                    {
                        var has_RequestCopy = has_Request
                        has_RequestCopy["name_email"] = nameEmail;
                        has_Request = has_RequestCopy
                    }
                }
            }
            states = ["accepted","pending","auto_accepted"]
            
            if has_Request.isEmpty{
                has_Request =  ["states" : states]
            }
            else
            {
                var has_RequestCopy = has_Request
                has_RequestCopy["states"] = states;
                has_Request = has_RequestCopy
            }
            
            param = [
                ParamName.PARAMFILTERSEL : [
                    "states" : ["pending"],
                    "has_request":
                        has_Request,
                    "with_request":
                        ["states":["accepted","pending","auto_accepted","rejected"]
                    ],
                    "timezone":"utc",
                ],
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
            //MY APPOINMENT PAST PARAMETER
            var has_Request = Dictionary<String,Any>()
            
            if filterAdded.isEmpty{
                
            }
            else {
                if let benchmark = filterAdded["benchmark"]  {
                    has_Request = ["benchmarks" : benchmark]
                }
                if let tags : Dictionary<String,Any> = filterAdded["tag"] as? Dictionary<String, Any> {
                    var tages = Array<Dictionary<String,Any>>()
                    for (index, entry) in tags {
                        var dictionaryCat = Dictionary<String,Any>()
                        dictionaryCat["category"] = index;
                        dictionaryCat["values"] = entry;
                        tages.append(dictionaryCat)
                    }
                    
                    if has_Request.isEmpty{
                        has_Request =  ["tags" : tages]
                    }
                    else
                    {
                        var has_RequestCopy = has_Request
                        has_RequestCopy["tags"] = tages;
                        has_Request = has_RequestCopy
                    }
                }
                
                if let nameEmail = filterAdded["name_email"]{
                    if has_Request.isEmpty{
                        has_Request =  ["name_email" : nameEmail]
                    }
                    else
                    {
                        var has_RequestCopy = has_Request
                        has_RequestCopy["name_email"] = nameEmail;
                        has_Request = has_RequestCopy
                    }
                }
            }
            states = ["accepted","auto_accepted"]

            if has_Request.isEmpty{
                has_Request =  ["states" : states]
            }
            else
            {
                var has_RequestCopy = has_Request
                has_RequestCopy["states"] = states;
                has_Request = has_RequestCopy
            }
            
            
            param = [
                ParamName.PARAMFILTERSEL : [
                    "states" : ["confirmed"],
                    "has_request":
                        has_Request,
                    "with_request":
                        ["states":states
                    ],
                    "timezone":"utc",
                    "to": "2021-03-30 11:26:34",
                    
                ],
                ParamName.PARAMINTIMEZONEEL :"utc",
                ParamName.PARAMCSRFTOKEN : csrftoken,
                ParamName.PARAMMETHODKEY : "post",
                ParamName.PARAMFILTERSTAKEEL: 50,
                ParamName.PARAMFILTERSSKIPEL: skip,
                ParamName.PARAMSORTEL :[
                    ParamName.PARAMFIELDEL : "start_datetime_utc",
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
                    self.objERSideAppointmentNewModal = try
                        JSONDecoder().decode(ERSideAppointmentModalNew.self, from: jsonData)
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
                self.objERSideAppointmentNewModal = try
                    JSONDecoder().decode(ERSideAppointmentModalNew.self, from: jsonData)
                self.dispatchGroup.leave()
            
        } catch   {
                print(error)
                self.dispatchGroup.leave()
            }
        }) { (error, errorCode) in
            self.dispatchGroup.leave()
        }
        
    }

    
    
}

