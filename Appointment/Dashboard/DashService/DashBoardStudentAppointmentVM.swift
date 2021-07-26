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
    
    func sentDataViewController(dataAppoinmentModal : OpenHourCoachModal)

}



class DashBoardStudentAppointmentVM {
    var viewController : UIViewController!
    var activityIndicator: ActivityIndicatorView?
    var dashBoardModal : DashBoardModel!
    var delegate : DashBoardStudentAppointmentVMDelegate!
    let dispatchGroup = DispatchGroup()
    
    var isbackGroundHit = false;
    
    
    var objOpenHourCoachModal1 : OpenHourCoachModal?
    var objOpenHourCoachModal2 : OpenHourCoachModal?
//    var objOpenHourCoachModal3 : OpenHourCoachModal?
//    var objOpenHourCoachModal4 : OpenHourCoachModal?


    
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
        
        var arrCreatedBy = Array<Dictionary<String,AnyObject>>()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        _ = dateFormatter.string(from: Date())
        for coach in dashBoardModal.items{
            let dictionary = [
                "entity_type":"community_user",
                "entity_id": "\(coach.id)"
                
                ] as [String : AnyObject]
            arrCreatedBy.append(dictionary)
        }
        let csrftoken = UserDefaultsDataSource(key: "csrf_token").readData() as! String
        var localTimeZoneAbbreviation: String { return TimeZone.current.identifier }
        
   
        var states = [String]();
        
        if index == 1{
            states = ["accepted_by_community_user","auto_accepted","requested_by_student_user"]
        }
       
        else if index == 2{
             states = ["rejected_by_community_user"]
        }
       
        
        
        
        var param = [
            ParamName.PARAMFILTERSEL : [
                "states" : states,
                "created_by":arrCreatedBy,
                "timezone":localTimeZoneAbbreviation
            ],
            ParamName.PARAMINTIMEZONEEL :localTimeZoneAbbreviation,
            ParamName.PARAMCSRFTOKEN : csrftoken
            
            ] as [String : AnyObject]
        
        
        if index != 2{
            param["from"] = GeneralUtility.todayDate() as AnyObject

        }
        return param
    }
    
    
    
    
    func fetchAllPointMent(index : Int)
    {
        
        
       
        
        CoachSelectionService().openHourCarrerCoachListApi(params: parameter(index: index), { (jsonData) in
            
            do {
                
                if index == 1{
                    self.objOpenHourCoachModal1 = try
                                      JSONDecoder().decode(OpenHourCoachModal.self, from: jsonData)
                                  self.dispatchGroup.leave()
                }
                else if index == 2{
                    self.objOpenHourCoachModal2 = try
                                      JSONDecoder().decode(OpenHourCoachModal.self, from: jsonData)
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
    
    func outputResult() -> OpenHourCoachModal?  {
        
        var appointmentLocal = OpenHourCoachModal()
        
        if self.objOpenHourCoachModal1 != nil &&  self.objOpenHourCoachModal2 != nil {
            
            self.objOpenHourCoachModal1?.results?.append(contentsOf: (self.objOpenHourCoachModal2?.results)!)
        }
            
        else
        {
            return nil
        }
    
        
        appointmentLocal = self.objOpenHourCoachModal1!
        
        
        var appointmentModalResult = [OpenHourCoachModalResult]()
        for var result in appointmentLocal.results!{
            result.isPastAppointment = GeneralUtility.isPastDate(date: result.endDatetimeUTC)
//            result.isFeedbackEnabled = GeneralUtility.isFeedbackEnable(particpant: (result.participants)!)
            let coach = self.dashBoardModal.items.filter({$0.id == result.createdByID})[0]
//            result.coach = coach
            appointmentModalResult.append(result)
        }
        var apointmentFinalModal = appointmentLocal;
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        appointmentModalResult =   appointmentModalResult.sorted(
            by: { formatter.date(from: $0.startDatetimeUTC ?? "") ?? Date()  > formatter.date(from: $1.startDatetimeUTC ?? "") ?? Date()
        })
        
        apointmentFinalModal.results?.removeAll()
        apointmentFinalModal.results?.append(contentsOf: appointmentModalResult);
         return apointmentFinalModal
        
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
