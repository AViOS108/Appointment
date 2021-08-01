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

    
    
    func apiLogic()  {
        
        self.openHourCarrerCoach(params: parameter(skip: 0))

         activityIndicator = ActivityIndicatorView.showActivity(view: viewController.navigationController!.view, message: StringConstants.FetchingCoachSelection)
        
        
    }
    
    func parameter(skip : Int) -> Dictionary<String,AnyObject> {
        
        let particularCoach = selectedDataModal.items
        
        var arrCreatedBy = Array<Int>()
        for coach in particularCoach{
            arrCreatedBy.append(coach.id)
        }
        let csrftoken = UserDefaultsDataSource(key: "csrf_token").readData() as! String
        let param = [
            ParamName.PARAMFILTERSEL : [
                "states" : ["confirmed"],
                "from"  : previousDate(strDate: dateStirng) + " 23:59:00",
                "to" : dateStirng + " 23:59:00",
                "coach_ids":arrCreatedBy,
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
                    self.formingDataModal()
                    return
                }
                if self.carrerCoachModal?.results?.count ?? 0 >= carrerCoachLocal.total ?? 0{
                    self.formingDataModal()
                }
                else{
                    self.openHourCarrerCoach(params: self.parameter(skip: self.carrerCoachModal?.results?.count ?? 0))
                }
            } catch let error as NSError {
                self.activityIndicator?.hide()
                print(error)
                CommonFunctions().showError(title: "Error", message: ErrorMessages.SomethingWentWrong.rawValue)
            }
        }) { (error, errorCode) in
            self.activityIndicator?.hide()
            CommonFunctions().showError(title: "Error", message: ErrorMessages.SomethingWentWrong.rawValue)
        }
    }
    
    
    func formingDataModal()  {
        self.activityIndicator?.hide()
        if let objcarrerCoachModal = carrerCoachModal{
            
            var filterOpenHour = objcarrerCoachModal.results?.filter({ $0.appointmentConfig.requestApprovalType == ""
            })
            
            
            delegate.completeModal(coachOpenHourModal: objcarrerCoachModal)
        }
    }
    
}
