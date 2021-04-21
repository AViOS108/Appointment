//
//  CoachSelectionViewModal.swift
//  Appointment
//
//  Created by Anurag Bhakuni on 03/09/20.
//  Copyright © 2020 Anurag Bhakuni. All rights reserved.
//

import Foundation
import UIKit
import CoreData



protocol CoachSelectionViewModalDelegate {
    func completeModal(coachOpenHourModal : OpenHourCoachModal)
}





class CoachSelectionViewModal {
    
    var selectedDataModal : DashBoardModel!
    var viewController : UIViewController!
    var activityIndicator: ActivityIndicatorView?
    
    var dateStirng : String!
    var delegate : CoachSelectionViewModalDelegate!
    var finalModal :OpenHourCoachModal!
    
    var carrerCoachModal :OpenHourCoachModal?
    var externalCoachModal: OpenHourCoachModal?

    
    var apiHitogic = Array<Int>()
    
    func apiLogic()  {
        
        let isCarrerSelected =   selectedDataModal.coaches.filter({$0.roleMachineName.rawValue == "career_coach"}).count > 0 ? true : false
        let isAluminiSelected =
            selectedDataModal.coaches.filter({$0.roleMachineName.rawValue == "external_coach"}).count > 0 ? true : false
        
        if isCarrerSelected{
            apiHitogic.append(0)
        }
        if isAluminiSelected{
            apiHitogic.append(0)
        }
        
        if isCarrerSelected{
            self.openHourCarrerCoach(params: parameter(typeUser: "career_coach", skip: 0))
            
        }
        if isAluminiSelected{
            self.openHourExternalCoach(params: parameter(typeUser: "external_coach", skip: 0))
        }
        
         activityIndicator = ActivityIndicatorView.showActivity(view: viewController.navigationController!.view, message: StringConstants.FetchingCoachSelection)
        
        
    }
    
    func parameter(typeUser: String,skip : Int) -> Dictionary<String,AnyObject> {
        
        let particularCoach = selectedDataModal.coaches.filter({$0.roleMachineName.rawValue == typeUser})
        
        var arrCreatedBy = Array<Dictionary<String,AnyObject>>()
        for coach in particularCoach{
            let dictionary = [
                "entity_type":"community_user",
                "entity_id": "\(coach.id)"

                ] as [String : AnyObject]
            arrCreatedBy.append(dictionary)
        }
        let csrftoken = UserDefaultsDataSource(key: "csrf_token").readData() as! String
        let param = [
            ParamName.PARAMFILTERSEL : [
                "states" : ["confirmed"],
                "from"  : previousDate(strDate: dateStirng) + " 23:59:00",
                "to" :  dateStirng + " 23:59:00",
                "created_by":arrCreatedBy,
                "timezone":"utc",
                "skip": skip
            ],
            ParamName.PARAMINTIMEZONEEL : "utc",
            ParamName.PARAMCSRFTOKEN : csrftoken
            
            ] as [String : AnyObject]
        return param
        
    }
    
    
    func previousDate(strDate: String)-> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        var date = dateFormatter.date(from: strDate)
        let prvious = Calendar.current.date(byAdding: .day, value: -1, to: date!)
        return  dateFormatter.string(from: prvious!)
    }
    
    func openHourCarrerCoach(params: Dictionary<String,AnyObject>)
    {
        CoachSelectionService().openHourCarrerCoachListApi(params: params, { (jsonData) in
            do {
                let carrerCoachLocal = try
                    JSONDecoder().decode(OpenHourCoachModal.self, from: jsonData)
                if self.carrerCoachModal != nil{
                    if (carrerCoachLocal.results?.count)! > 0
                    {
                        self.carrerCoachModal?.results?.append(contentsOf: (carrerCoachLocal.results)!);
                    }
                    
                }
                else
                {
                    self.carrerCoachModal = carrerCoachLocal
                }
                
                if GeneralUtility.isPastDateDifferentDateFormater(date: self.dateStirng){
                    if self.carrerCoachModal != nil {
                        if self.carrerCoachModal?.results?.count ?? 0 > 0
                        {
                            self.carrerCoachModal?.results?.removeAll()
                        }
                    }
                    self.apiHitogic[0] = 1
                    let setI = Set(self.apiHitogic)
                    
                    if setI.count == 1
                    {
                        self.formingDataModal()
                    }
                    
                   return
                    
                }
                
                
                if self.carrerCoachModal?.results?.count ?? 0 >= carrerCoachLocal.total ?? 0{
                    self.apiHitogic[0] = 1
                    let setI = Set(self.apiHitogic)
                    
                    if setI.count == 1
                    {
                        self.formingDataModal()
                    }
                }
                else{
                    
                    self.openHourCarrerCoach(params: self.parameter(typeUser: "career_coach", skip: self.carrerCoachModal?.results?.count ?? 0))
                }
                
                
            } catch let _ as NSError {
                self.activityIndicator?.hide()
                CommonFunctions().showError(title: "Error", message: ErrorMessages.SomethingWentWrong.rawValue)
            }
            
           
        }) { (error, errorCode) in
            
            self.activityIndicator?.hide()
            CommonFunctions().showError(title: "Error", message: ErrorMessages.SomethingWentWrong.rawValue)
        }
    }
    
    func openHourExternalCoach(params: Dictionary<String,AnyObject>)  {
        
        CoachSelectionService().openHourExternalListApi(params: params, { (jsonData) in
            do {
                let externalCoachModalLocal = try JSONDecoder().decode(OpenHourCoachModal.self, from: jsonData)
                if self.externalCoachModal != nil{
                    if (externalCoachModalLocal.results?.count)! > 0
                    {
                        self.externalCoachModal?.results?.append(contentsOf: (externalCoachModalLocal.results)!);
                    }
                }
                else
                {
                    self.externalCoachModal = externalCoachModalLocal
                }
                
                
                if GeneralUtility.isPastDateDifferentDateFormater(date: self.dateStirng){
                    
                    if self.externalCoachModal != nil {
                        if self.externalCoachModal?.results?.count ?? 0 > 0
                        {
                            self.externalCoachModal?.results?.removeAll()
                        }
                        
                    }
                    
                    
                    
                    
                    if self.apiHitogic.count > 1{
                        self.apiHitogic[1] = 1
                    }
                    else{
                        self.apiHitogic[0] = 1
                    }
                    let setI = Set(self.apiHitogic)
                    
                    if setI.count == 1
                    {
                        self.formingDataModal()
                    }
                    
                }
    
                if self.externalCoachModal?.results?.count ?? 0   >= externalCoachModalLocal.total ?? 0{
                    if self.apiHitogic.count > 1{
                        self.apiHitogic[1] = 1
                    }
                    else{
                        self.apiHitogic[0] = 1
                    }
                    let setI = Set(self.apiHitogic)
                    
                    if setI.count == 1
                    {
                        self.formingDataModal()
                    }
                }
                else{
                    
                    self.openHourExternalCoach(params: self.parameter(typeUser: "external_coach", skip: self.carrerCoachModal?.results?.count ?? 0))
                }
            } catch  {
                print(error)
            }
            
            
        }) { (error, errorCode) in
            self.activityIndicator?.hide()
            CommonFunctions().showError(title: "Error", message: ErrorMessages.SomethingWentWrong.rawValue)
        }
        
    }
    
    
    
    func formingDataModal()  {
        
        self.activityIndicator?.hide()
        
        if let _ = carrerCoachModal?.results, let _ = externalCoachModal?.results{
            
            if (carrerCoachModal?.results?.count)! > 0 && (externalCoachModal?.results?.count)! > 0{
                carrerCoachModal?.results?.append(contentsOf: (externalCoachModal?.results)!)
                carrerCoachModal?.total = (carrerCoachModal?.total)! + (externalCoachModal?.total)!
                finalModal = carrerCoachModal

            }
            else if (carrerCoachModal?.results?.count)! > 0{
                finalModal = carrerCoachModal

            }
            else{
                finalModal = externalCoachModal
            }
            
            
        }
        else if carrerCoachModal?.results != nil{
            finalModal = carrerCoachModal
        }
        else{
            finalModal = externalCoachModal
            
        }
        delegate.completeModal(coachOpenHourModal: finalModal)
        
    }
    
    
    
    
    
}
