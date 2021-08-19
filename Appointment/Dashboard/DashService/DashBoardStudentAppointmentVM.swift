//
//  DashBoardStudentAppointmentVM.swift
//  Appointment
//
//  Created by Anurag Bhakuni on 20/09/20.
//  Copyright © 2020 Anurag Bhakuni. All rights reserved.
//

import Foundation
import Foundation
import UIKit
import CoreData

protocol DashBoardStudentAppointmentVMDelegate {
    
    func sentDataViewController(dataAppoinmentModal : ERSideAppointmentModalNew)

}



class DashBoardStudentAppointmentVM {
    var viewController : UIViewController!
    var activityIndicator: ActivityIndicatorView?
    var dashBoardModal : DashBoardModel!
    var delegate : DashBoardStudentAppointmentVMDelegate!
    let dispatchGroup = DispatchGroup()
    
    var isbackGroundHit = false;
    
    
    var objOpenHourCoachModal1 : ERSideAppointmentModalNew?
    var objOpenHourCoachModal2 : ERSideAppointmentModalNew?
    var objOpenHourCoachModal3 : ERSideAppointmentModalNew?
    var objOpenHourCoachModal4 : ERSideAppointmentModalNew?

    
    func customizeVM(){
        
        
        let param : Dictionary<String, AnyObject> = ["roles":["external_coach","career_coach"]] as Dictionary<String, AnyObject>
        
        if dashBoardModal != nil{
            self.fetchAppoinmentLogic()
        }
        else{
             self.fetchCall(params: param)
        }
        
}
   
    
    func fetchAppoinmentLogic(){
        
        
        if !isbackGroundHit{
             activityIndicator = ActivityIndicatorView.showActivity(view: viewController.navigationController!.view, message: StringConstants.appointmentInfoApiLoader)
        }
        
       
        
        dispatchGroup.enter()
        fetchAllPointMent(index: 1)
        dispatchGroup.enter()
        fetchAllPointMent(index: 2)
        dispatchGroup.enter()
        fetchAllPointMent(index: 3)
        dispatchGroup.enter()
        fetchAllPointMent(index: 4)
        
        dispatchGroup.notify(queue: .main) {
            if !self.isbackGroundHit{
            self.activityIndicator?.hide()
            }
            if let output = self.outputResult()
            {
                self.delegate.sentDataViewController(dataAppoinmentModal: output)
            }
            else{
                
                CommonFunctions().showError(title: "Error", message: ErrorMessages.SomethingWentWrong.rawValue)
                
            }
            
        }
        
    }
    
    
    
    
    
    
    func fetchCall(params: Dictionary<String,AnyObject>)
    {
         if !isbackGroundHit{
        activityIndicator = ActivityIndicatorView.showActivity(view: viewController.navigationController!.view, message: StringConstants.appointmentInfoApiLoader)
        }
        DashboardService().coachListApi(params: params, { (jsonData) in
            if !self.isbackGroundHit{
            self.activityIndicator?.hide()
            }

            do{
                var welcome = try JSONDecoder().decode(DashBoardModel.self, from: jsonData)
                let welcomeI = welcome.items.sorted(by: { $0.name < $1.name })
                welcome.items.removeAll()
                welcome.items.append(contentsOf: welcomeI)
                self.dashBoardModal = welcome
                self.fetchAppoinmentLogic()
                
                
            }catch{
                print("Unable to load data: \(error)")
                CommonFunctions().showError(title: "Error", message: ErrorMessages.SomethingWentWrong.rawValue)
            }
            
        }) { (error, errorCode) in
            if !self.isbackGroundHit{
            self.activityIndicator?.hide()
            }
            CommonFunctions().showError(title: "Error", message: ErrorMessages.SomethingWentWrong.rawValue)
        }
        
    }
    
    func parameter(index : Int) -> Dictionary<String,AnyObject> {
        
        var arrCreatedBy = Array<Int>()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        _ = dateFormatter.string(from: Date())
        for coach in dashBoardModal.items{
            arrCreatedBy.append(coach.id)
        }
        let csrftoken = UserDefaultsDataSource(key: "csrf_token").readData() as! String
        var localTimeZoneAbbreviation: String { return TimeZone.current.identifier }
        var states = [String](), has_request = [String](),with_request = [String]() ;
        
        if index == 1{
            states = ["confirmed","pending"]
            has_request = ["auto_accepted","accepted"]
            with_request = ["auto_accepted","accepted"]
        }
        else if index == 2{
             states = ["pending"]
            has_request = ["pending"]
            with_request = ["pending"]
        }
        else if index == 3{
             states = ["pending","confirmed","cancelled"]
            has_request = ["rejected"]
            with_request = ["rejected","auto_accepted","accepted"]
        }
        else if index == 4{
            states = ["pending","confirmed"]
           has_request = ["pending","auto_accepted","accepted"]
           with_request = ["pending","auto_accepted","accepted"]
       }
        
        
        
        var param = [
            ParamName.PARAMFILTERSEL : [
                "states" : states,
                "coach_ids":arrCreatedBy,
                "timezone":localTimeZoneAbbreviation,
                "has_request":[
                    "states" : has_request
                ],
                "with_request":[
                    "states" : with_request
                ],
                
               
            ],
            ParamName.PARAMINTIMEZONEEL :localTimeZoneAbbreviation,
            ParamName.PARAMCSRFTOKEN : csrftoken
            
            ] as [String : AnyObject]
        
        
        if index == 1{
            
            var filter  :[String : AnyObject]{
                get {
                    return param[ ParamName.PARAMFILTERSEL] as! [String : AnyObject]
                }
                set {
                    param[ ParamName.PARAMFILTERSEL] = newValue as AnyObject
                }
            }
            filter["from"] = GeneralUtility.todayDate() as AnyObject
            param[ ParamName.PARAMFILTERSEL] = filter as AnyObject?
            
        }
        else if index == 2{
            var filter  :[String : AnyObject]{
                get {
                    return param[ ParamName.PARAMFILTERSEL] as! [String : AnyObject]
                }
                set {
                    param[ ParamName.PARAMFILTERSEL] = newValue as AnyObject
                }
            }
            filter["from"] = GeneralUtility.todayDate() as AnyObject
            param[ ParamName.PARAMFILTERSEL] = filter as AnyObject?

        }
        else if index == 3{

        }
        else if index == 4{
            var filter  :[String : AnyObject]{
                get {
                    return param[ ParamName.PARAMFILTERSEL] as! [String : AnyObject]
                }
                set {
                    param[ ParamName.PARAMFILTERSEL] = newValue as AnyObject
                }
            }
            filter["to"] = GeneralUtility.todayDate() as AnyObject
            param[ ParamName.PARAMFILTERSEL] = filter as AnyObject?

       }
    
        return param
    }
    
    
    
    
    func fetchAllPointMent(index : Int)
    {
        
        
       
        
        CoachSelectionService().openHourCarrerCoachListApi(params: parameter(index: index), { (jsonData) in
            
            do {
                
                if index == 1{
                    self.objOpenHourCoachModal1 = try
                                      JSONDecoder().decode(ERSideAppointmentModalNew.self, from: jsonData)
                                  self.dispatchGroup.leave()
                }
                else if index == 2{
                    self.objOpenHourCoachModal2 = try
                                      JSONDecoder().decode(ERSideAppointmentModalNew.self, from: jsonData)
                                  self.dispatchGroup.leave()
                }
                
                else if index == 3{
                    self.objOpenHourCoachModal3 = try
                                      JSONDecoder().decode(ERSideAppointmentModalNew.self, from: jsonData)
                                  self.dispatchGroup.leave()
                }
                else if index == 4{
                    self.objOpenHourCoachModal4 = try
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
    
    func outputResult() -> ERSideAppointmentModalNew?  {
        
        var appointmentLocal = ERSideAppointmentModalNew()
        
        
        if self.objOpenHourCoachModal1 != nil &&  self.objOpenHourCoachModal2 != nil && self.objOpenHourCoachModal3 != nil &&  self.objOpenHourCoachModal4 != nil{
            
        }
        
        else
        {
            return nil
        }
        
        appointmentLocal.total = (self.objOpenHourCoachModal1!.total ?? 0) + (self.objOpenHourCoachModal2!.total  ?? 0) + (self.objOpenHourCoachModal3!.total  ?? 0) 
            
        appointmentLocal.total =  appointmentLocal.total!  + (self.objOpenHourCoachModal4!.total  ?? 0)
        
        appointmentLocal.results = [ERSideAppointmentModalNewResult]()
        
        for var objApointment in self.objOpenHourCoachModal1!.results!{
            
            objApointment.typeERSide = 1
            appointmentLocal.results?.append(objApointment);
            
        }
        
        for var objApointment in self.objOpenHourCoachModal2!.results!{
            
            objApointment.typeERSide = 2
            appointmentLocal.results?.append(objApointment);
            
        }
        
        for var objApointment in self.objOpenHourCoachModal4!.results!{
            
            objApointment.typeERSide = 3
            appointmentLocal.results?.append(objApointment);
            
        }
        
        
        for var objApointment in self.objOpenHourCoachModal3!.results!{
            if  GeneralUtility.isPastDate(date: objApointment.endDatetimeUTC!){
                objApointment.typeERSide = 3

            }
            else{
                objApointment.typeERSide = 1

            }
            appointmentLocal.results?.append(objApointment);
            
        }
        
     
        return appointmentLocal
        
    }
    
    
}

import SwiftyJSON

protocol StudentSideFilterVMDelegate {
    func sendDataToFilterVC(objERFilterTag : [ERFilterTag] )
}

class StudentSideFilterVM {
    
    let dispatchGroup = DispatchGroup()
    var identifier : String!
    var objERFilterTag : [ERFilterTag]?
    var delegate : StudentSideFilterVMDelegate?

    
    var objSSFilterRoles :   SSFilterRoles?
    var objSSFilterExpertiseArr: SSFilterExpertiseArr?
    var objSSFilterClubs : SSFilterClubsArr?
    var objSSFilterIndustriesArr : SSFilterIndustriesArr?
    
     func customizationViewModel(identifier : String) {
        self.identifier = identifier;
        dispatchGroup.enter()
        self.studentFilterRoles();
        dispatchGroup.enter()
        self.studentFilterClubs()
        dispatchGroup.enter()
        self.studentFilterExpertise()
        dispatchGroup.enter()
        self.studentFilterIndustries()
        
        
        dispatchGroup.notify(queue: .main) {
            self.modalFormation()
            if let delegetaI = self.delegate, let objERtags =  self.objERFilterTag{
                delegetaI.sendDataToFilterVC(objERFilterTag : objERtags)
                
            }
            
        }
        
    }
    
    func modalFormation(){
        
       
        
        
        
        if let roles = self.objSSFilterRoles, let expertise = objSSFilterExpertiseArr, let clubs = objSSFilterClubs, let industries = objSSFilterIndustriesArr {
            objERFilterTag = [ERFilterTag]()
            var erfilterTag = ERFilterTag.init(id: 1)
            erfilterTag.categoryTitle = "Role"
            var objTagValueArr =  [TagValueObject]()
            for items in roles.items!{
                var objTagValue = TagValueObject()
                objTagValue.eRFilterid =  1
                objTagValue.id = items.id ?? 0
                objTagValue.tagValueText = items.displayName
                objTagValue.machineName = items.machineName ?? ""
                objTagValueArr.append(objTagValue)
            }
            erfilterTag.objTagValue = objTagValueArr
            objERFilterTag?.append(erfilterTag)
            
            var erfilterTagInd = ERFilterTag.init(id: 2)
            erfilterTagInd.categoryTitle = "Industry"
            var objTagValueArrInd =  [TagValueObject]()
            for items in industries{
                var objTagValue = TagValueObject()
                objTagValue.eRFilterid = 2
                objTagValue.id = items.industryID ?? 0
                objTagValue.tagValueText = items.displayName
                objTagValueArrInd.append(objTagValue)
            }
            erfilterTagInd.objTagValue = objTagValueArrInd

            objERFilterTag?.append(erfilterTagInd)
            
            
            var erfilterTagExp = ERFilterTag.init(id: 3)
            erfilterTagExp.categoryTitle = "Expertise"
            var objTagValueArrExp =  [TagValueObject]()
            for items in expertise{
                var objTagValue = TagValueObject()
                objTagValue.eRFilterid = 3
                objTagValue.id = items.expertiseID ?? 0

                objTagValue.tagValueText = items.displayName
                objTagValueArrExp.append(objTagValue)
            }
            erfilterTagExp.objTagValue = objTagValueArrExp

            objERFilterTag?.append(erfilterTagExp)
            
            
            var erfilterTagClub = ERFilterTag.init(id:4)
            erfilterTagClub.categoryTitle = "Club Affliation"
            var objTagValueArrClub =  [TagValueObject]()
            for items in clubs{
                var objTagValue = TagValueObject()
                objTagValue.eRFilterid = 4
                objTagValue.id = items.id ?? 0
                objTagValue.tagValueText = items.displayName
                objTagValueArrClub.append(objTagValue)
            }
            erfilterTagClub.objTagValue = objTagValueArrClub
            objERFilterTag?.append(erfilterTagClub)
            
            
            
        }
        
        
    }
    
    
    
    func studentFilterRoles(){
        let token = UserDefaultsDataSource(key: "accessToken").readData() as! String
        let headers: Dictionary<String,String> = ["Authorization": "Bearer \(token)"]
        
        
        Network().makeApiEventGetRequest(true, url: Urls().studentSideRole(Id: self.identifier), methodType: .get, params: ["":"" as AnyObject], header: headers, completion: { (jsonData) in
            do {
                self.objSSFilterRoles = try
                    JSONDecoder().decode(SSFilterRoles.self, from: jsonData)
            } catch  {
                print(error)
            }
            self.dispatchGroup.leave()
            
            
        }) { (error, errorCode) in
            self.dispatchGroup.leave()
            
        }
    }
    
    func studentFilterExpertise(){
        let token = UserDefaultsDataSource(key: "accessToken").readData() as! String
        let headers: Dictionary<String,String> = ["Authorization": "Bearer \(token)"]
        
        
        Network().makeApiEventGetRequest(true, url: Urls().studentSideExpertise(Id: self.identifier), methodType: .get, params: ["":"" as AnyObject], header: headers, completion: { (jsonData) in
            do {
                
                self.objSSFilterExpertiseArr = try
                    JSONDecoder().decode(SSFilterExpertiseArr.self, from: jsonData)
            } catch  {
                print(error)
            }
            self.dispatchGroup.leave()
            
            
        }) { (error, errorCode) in
            self.dispatchGroup.leave()
            
        }
    }
    
    func studentFilterClubs(){
        let token = UserDefaultsDataSource(key: "accessToken").readData() as! String
        let headers: Dictionary<String,String> = ["Authorization": "Bearer \(token)"]
        
        
        Network().makeApiEventGetRequest(true, url: Urls().studentSideClubs(Id: self.identifier), methodType: .get, params: ["":"" as AnyObject], header: headers, completion: { (jsonData) in
            do {
                
                self.objSSFilterClubs = try
                    JSONDecoder().decode(SSFilterClubsArr.self, from: jsonData)
            } catch  {
                print(error)
            }
            self.dispatchGroup.leave()
            
            
        }) { (error, errorCode) in
            self.dispatchGroup.leave()
            
        }
    }
    
    
    func studentFilterIndustries(){
        let token = UserDefaultsDataSource(key: "accessToken").readData() as! String
        let headers: Dictionary<String,String> = ["Authorization": "Bearer \(token)"]
        
        
        Network().makeApiEventGetRequest(true, url: Urls().studentSideIndustries(Id: self.identifier), methodType: .get, params: ["":"" as AnyObject], header: headers, completion: { (jsonData) in
            do {
               
                self.objSSFilterIndustriesArr = try
                    JSONDecoder().decode(SSFilterIndustriesArr.self, from: jsonData)
            } catch  {
                print(error)
            }
            self.dispatchGroup.leave()
            
            
        }) { (error, errorCode) in
            self.dispatchGroup.leave()
            
        }
    }
}
