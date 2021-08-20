//
//  AppoinmentdetailViewModal.swift
//  Appointment
//
//  Created by Anurag Bhakuni on 22/09/20.
//  Copyright © 2020 Anurag Bhakuni. All rights reserved.
//

import Foundation




protocol AppoinmentdetailViewModalDeletgate {

    func sendAppoinmentData(appoinmentDetailModalObj:ApooinmentDetailAllModal?, isSucess: Bool )
    
}

class AppoinmentdetailViewModal{
    
    
    var nextModalObj : [NextStepModal]?
    var noteModalObj :   NotesModal?
    var coachNoteModalObj :   NotesModal?
    var appoinmentDetailModalObj : AppoinmentDetailModal?
    
    var callbackVC: ((_ suceess: Bool) -> Void)?


    var delegate : AppoinmentdetailViewModalDeletgate!
    
    let dispatchGroup = DispatchGroup()
    var selectedAppointmentModal : OpenHourCoachModalResult?
    
    
    func viewModalCustomized(){
        
        dispatchGroup.enter()
        self.appoinmentDetail()
        dispatchGroup.enter()
        self.nextStepDetail()
        dispatchGroup.enter()
        self.mynotesDetail()
        dispatchGroup.enter()
        self.coachNotesDetail()
        
        
        dispatchGroup.notify(queue: .main) {
            self.outputResult()
        }
        
        
        
    }
    
    
    
    func appoinmentDetail()
    {
        
        let headers: Dictionary<String,String> = ["Authorization": "Bearer \(UserDefaults.standard.object(forKey: "accessToken")!)"]
        Network().makeApiEventGetRequest(true, url: Urls().confirmAppointment(id: selectedAppointmentModal?.identifier ?? "") , methodType: .get, params: ["":"" as AnyObject], header: headers, completion: { (jsonData) in
            do {
                
                self.appoinmentDetailModalObj = try
                    JSONDecoder().decode(AppoinmentDetailModal.self, from: jsonData)
            } catch  {
                
            }
            self.dispatchGroup.leave()
            
            
        }) { (error, errorCode) in
            self.dispatchGroup.leave()
            
        }
        
        
        
    }
    
    
    func nextStepDetail(){
        let headers: Dictionary<String,String> = ["Authorization": "Bearer \(UserDefaults.standard.object(forKey: "accessToken")!)"]
        Network().makeApiEventGetRequest(true, url: Urls().nextStepAppointment(id: selectedAppointmentModal?.identifier ?? ""), methodType: .get, params: ["":"" as AnyObject], header: headers, completion: { (jsonData) in
            do {
                
                self.nextModalObj = try
                    JSONDecoder().decode(NextStepArr.self, from: jsonData)
            } catch  {
                print(error)
            }
            self.dispatchGroup.leave()
            
            
        }) { (error, errorCode) in
            self.dispatchGroup.leave()
            
        }
        
        
    }
    
    func mynotesDetail(){
        
        var arrCreatedBy = Array<Dictionary<String,AnyObject>>()
        let dictionary = [
            "entity_type":"event",
            "entity_id": selectedAppointmentModal?.identifier ?? ""
            
            ] as [String : AnyObject]
        arrCreatedBy.append(dictionary)
        
        let params = [
            
            ParamName.PARAMFILTERSEL :["attachable_entities[0]" :arrCreatedBy,
                                       "is_shared" : 0
            ]
        ]
       
        
        
        
        let headers: Dictionary<String,String> = ["Authorization": "Bearer \(UserDefaults.standard.object(forKey: "accessToken")!)"]
        Network().makeApiEventGetRequest(true, url: Urls().notesAppointment(id: selectedAppointmentModal?.identifier ?? ""), methodType: .get, params: params as  Dictionary<String, AnyObject>, header: headers, completion: { (jsonData) in
            do {
                
                self.noteModalObj = try
                    JSONDecoder().decode(NotesModal.self, from: jsonData)
            } catch  {
                print(error)
            }
            self.dispatchGroup.leave()
            
            
        }) { (error, errorCode) in
            self.dispatchGroup.leave()
            
        }
        
        
        
        
    }
    
    func coachNotesDetail()  {
        var arrCreatedBy = Array<Dictionary<String,AnyObject>>()
        let dictionary = [
            "entity_type":"event",
            "entity_id": selectedAppointmentModal?.identifier ?? ""
            
            ] as [String : AnyObject]
        arrCreatedBy.append(dictionary)
        
        let params = [
            
            ParamName.PARAMFILTERSEL :["attachable_entities[0]" :arrCreatedBy,
                                       "is_shared" : 1
            ]
        ]
        let headers: Dictionary<String,String> = ["Authorization": "Bearer \(UserDefaults.standard.object(forKey: "accessToken")!)"]
        Network().makeApiEventGetRequest(true, url: Urls().notesAppointment(id: selectedAppointmentModal?.identifier ?? ""), methodType: .get, params: params as  Dictionary<String, AnyObject>, header: headers, completion: { (jsonData) in
            do {
                
                self.coachNoteModalObj = try
                    JSONDecoder().decode(NotesModal.self, from: jsonData)
            } catch  {
                print(error)
            }
            self.dispatchGroup.leave()
            
            
        }) { (error, errorCode) in
            self.dispatchGroup.leave()
            
        }
        
        
    }
    
    
    func outputResult(){
        
        if let _ = self.nextModalObj , let _ = self.noteModalObj , let _ = self.coachNoteModalObj , let _ = self.appoinmentDetailModalObj{
            var objApooinmentDetailAllModal = ApooinmentDetailAllModal();
//            self.appoinmentDetailModalObj?.coach = selectedAppointmentModal?.coach
//            self.appoinmentDetailModalObj?.parent = selectedAppointmentModal?.parent;
        
            objApooinmentDetailAllModal.nextModalObj = self.nextModalObj
            objApooinmentDetailAllModal.noteModalObj = self.noteModalObj
            objApooinmentDetailAllModal.coachNoteModalObj = self.coachNoteModalObj
            objApooinmentDetailAllModal.appoinmentDetailModalObj = self.appoinmentDetailModalObj
            delegate.sendAppoinmentData(appoinmentDetailModalObj: objApooinmentDetailAllModal, isSucess: true)
            
        }
        else{
            delegate.sendAppoinmentData(appoinmentDetailModalObj: nil, isSucess: false)
            
        }
        
    }
    
    
    
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
    
    
    
    func deleteNotes(objnoteModal : NotesModalNewResult?)   {
        
        let params = [
            "_method" : "delete",
            "csrf_token" : UserDefaultsDataSource(key: "csrf_token").readData() as! String
            ] as [String : AnyObject]
        let headers: Dictionary<String,String> = ["Authorization": "Bearer \(UserDefaults.standard.object(forKey: "accessToken")!)"]
        
        Network().makeApiEventRequest(true, url: Urls().deletesNotes(id: "\(objnoteModal?.id ?? 0)"), methodType: .post, params: params, header: headers, completion: { (data) in
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
    
    
    
    
    
    func postFeedback(selectedAppointmentModal : ERSideAppointmentModalNewResult?,objFeedBackMOdal:feedbackModal)   {
          
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
