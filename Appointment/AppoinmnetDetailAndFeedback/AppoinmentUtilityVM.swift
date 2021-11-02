//
//  AppoinmentdetailViewModal.swift
//  Appointment
//
//  Created by Anurag Bhakuni on 22/09/20.
//  Copyright © 2020 Anurag Bhakuni. All rights reserved.
//

import Foundation





class AppoinmentUtilityVM{
    
    
    var callbackVC: ((_ suceess: Bool) -> Void)?
    
    
    func saveNotes(objnoteModal : NotesResult?,text : String,identifier : String)   {
        
        let dictionary = [
            "entity_id" : identifier ?? "",
            "entity_type": "event"
            ] as [String : Any]
        
        var arrEntities = Array<Dictionary<String,Any>>()
        arrEntities.append(dictionary);
        
        var params = [
            "data" : text ,
            "entities" : arrEntities,
            "csrf_token" : UserDefaultsDataSource(key: "csrf_token").readData() as! String
            ] as [String : AnyObject]
        let headers: Dictionary<String,String> = ["Authorization": "Bearer \(UserDefaults.standard.object(forKey: "accessToken")!)"]
       
        var url = ""
        if objnoteModal != nil{
            url = Urls().deletesNotes(id: "\(objnoteModal?.id ?? 0)")
            params["_method"] = "put" as AnyObject
        }
        else{
            url = Urls().saveNotes()
        }
        
        
        Network().makeApiEventRequest(true, url: url, methodType: .post, params: params, header: headers, completion: { (data) in

            self.callbackVC!(true)
            
            
        }) { (error, errorCode) in
             self.callbackVC!(false)
       
        }
        
    }
    
    
    
    func deleteNotes(objnoteModal : Int?)   {
        
        let params = [
            "_method" : "delete",
            "csrf_token" : UserDefaultsDataSource(key: "csrf_token").readData() as! String
            ] as [String : AnyObject]
        let headers: Dictionary<String,String> = ["Authorization": "Bearer \(UserDefaults.standard.object(forKey: "accessToken")!)"]
        
        Network().makeApiEventRequest(true, url: Urls().deletesNotes(id: "\(objnoteModal ?? 0)"), methodType: .post, params: params, header: headers, completion: { (data) in
            self.callbackVC!(true)
        }) { (error, errorCode) in
            CommonFunctions().showError(title: "", message: error)
            self.callbackVC!(false)
        }
        
    }
    
    
    func cancelAppoinment(id : String)   {
        
        let params = [
            "appointment_cancellation_reason" :"",
            "_method" : "patch",
            "csrf_token" : UserDefaultsDataSource(key: "csrf_token").readData() as! String
            ] as [String : AnyObject]
        let headers: Dictionary<String,String> = ["Authorization": "Bearer \(UserDefaults.standard.object(forKey: "accessToken")!)"]
        
        Network().makeApiEventRequest(true, url: Urls().cancelAppoinment(id: id), methodType: .post, params: params, header: headers, completion: { (data) in
            self.callbackVC!(true)
        }) { (error, errorCode) in
            CommonFunctions().showError(title: "", message: error)
            self.callbackVC!(false)
        }
        
    }
    
    
    
    
    
    func postFeedback(selectedAppointmentModal : AppoinmentDetailModalNew?,objFeedBackMOdal:feedbackModal)   {
          
          let params = [
            "comments" : objFeedBackMOdal.comments ?? "",
            "coach_helpfulness" : "\(objFeedBackMOdal.coach_helpfulness ?? 0)" ,
            "coach_expertise": "\(objFeedBackMOdal.coach_expertise ?? 0)" ,
            "overall_experience" : "\(objFeedBackMOdal.overall_experience ?? 0)" ,
            "csrf_token" : UserDefaultsDataSource(key: "csrf_token").readData() as? String
              ] as [String : AnyObject]
        
        
          let headers: Dictionary<String,String> = ["Authorization": "Bearer \(UserDefaults.standard.object(forKey: "accessToken")!)"]
          
        Network().makeApiEventRequest(true, url: Urls().feedBack(id: "\(selectedAppointmentModal?.id ?? 0)"), methodType: .post, params: params, header: headers, completion: { (data) in
            do {
                _ = try
                    JSONDecoder().decode(FeedBackModal.self, from: data)
                self.callbackVC!(true)
                
            } catch  {
                CommonFunctions().showError(title: "", message: ErrorMessages.SomethingWentWrong.rawValue)
                self.callbackVC!(false)
            }
            
        }) { (error, errorCode) in
              CommonFunctions().showError(title: "", message: error)
              self.callbackVC!(false)
          }
      }
    
}
