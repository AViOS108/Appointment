//
//  ERSideAppoinmentDetailModal.swift
//  Appointment
//
//  Created by Anurag Bhakuni on 22/01/21.
//  Copyright © 2021 Anurag Bhakuni. All rights reserved.
//

import Foundation





protocol ERSideAppoinmentDetailModalDeletgate {

    func sendAppoinmentData(appoinmentDetailModalObj:ApooinmentDetailAllNewModal?, isSucess: Bool )
    
}

class ERSideAppoinmentDetailModal{
    
    
    var nextModalObj : [NextStepModalNew]?
    var noteModalObj :   NotesModalNew?
    var coachNoteModalObj :   NotesModalNew?
    var appoinmentDetailModalObj : AppoinmentDetailModalNew?
    
    var callbackVC: ((_ suceess: Bool) -> Void)?
    var detailType : Int = 0

    var delegate : ERSideAppoinmentDetailModalDeletgate!
    
    let dispatchGroup = DispatchGroup()
    var selectedResult : ERSideAppointmentModalNewResult!

    
    func viewModalCustomized(){
        
        dispatchGroup.enter()
        self.appoinmentDetail()
        dispatchGroup.enter()
        self.nextStepDetail()
        dispatchGroup.enter()
        self.mynotesDetail()
//        dispatchGroup.enter()
//        self.coachNotesDetail()
//
        
        dispatchGroup.notify(queue: .main) {
            self.outputResult()
        }
        
        
        
    }
    
    
    
    func appoinmentDetail()
    {
        
        var localTimeZoneAbbreviation: String { return TimeZone.current.abbreviation() ?? "" }
        
        var    param : [String : AnyObject]!
        
        if detailType == 2{
            // Upcoming
            
            let states = ["accepted","auto_accepted"]
            param = [
                ParamName.PARAMFILTERSEL : [
                    "states" : ["confirmed"],
                    "has_request":
                        ["states": states],
                    "with_request":
                        ["states":states
                        ],
                    "timezone":localTimeZoneAbbreviation,
                    "from": GeneralUtility.todayDate() as AnyObject,
                ],
                ParamName.PARAMINTIMEZONEEL :"utc",
            ] as [String : AnyObject]
        }
        else if detailType == 3{
           // Pending
            let states = ["accepted","pending","auto_accepted","rejected"]
            param = [
                ParamName.PARAMFILTERSEL : [
                    "states" : ["pending"],
                    "has_request":
                        ["states": states],
                    "with_request":
                        ["states":states
                        ],
                    "timezone":localTimeZoneAbbreviation,
                    "from": GeneralUtility.todayDate() as AnyObject,
                ],
                ParamName.PARAMINTIMEZONEEL :"utc",
            ] as [String : AnyObject]
        }
        else{
            //Past
            
            let states = ["accepted","auto_accepted"]
            param = [
                ParamName.PARAMFILTERSEL : [
                    "states" : ["confirmed"],
                    "has_request":
                        ["states": states],
                    "with_request":
                        ["states":states
                        ],
                    "timezone":localTimeZoneAbbreviation,
                    "from": GeneralUtility.todayDate() as AnyObject,
                ],
                ParamName.PARAMINTIMEZONEEL :"utc",
            ] as [String : AnyObject]
        }
        
        
      
        
        
        


       
        
        
        
        
        let headers: Dictionary<String,String> = ["Authorization": "Bearer \(UserDefaults.standard.object(forKey: "accessToken")!)"]
        Network().makeApiEventGetRequest(true, url: Urls().confirmAppointment(id: String(describing: selectedResult.id ?? 0)) , methodType: .get, params: param, header: headers, completion: { (jsonData) in
            do {
                
                self.appoinmentDetailModalObj = try
                    JSONDecoder().decode(AppoinmentDetailModalNew.self, from: jsonData)
            } catch  {
                print(error)
            }
            self.dispatchGroup.leave()
            
            
        }) { (error, errorCode) in
            self.dispatchGroup.leave()
            
        }
        
    }
    
    
    func nextStepDetail(){
        let headers: Dictionary<String,String> = ["Authorization": "Bearer \(UserDefaults.standard.object(forKey: "accessToken")!)"]
        
        var localTimeZoneAbbreviation: String { return TimeZone.current.abbreviation() ?? "" }
        
        let  param = [
            ParamName.PARAMFILTERSEL : [
                "appointment_ids" : [String(describing: selectedResult.id ?? 0)],
                "is_completed":
                    ["0","1"],
            ],
            ] as [String : AnyObject]
        
        Network().makeApiEventGetRequest(true, url: Urls().nextStepAppointment(id: String(describing: selectedResult.id ?? 0)), methodType: .get, params: param, header: headers, completion: { (jsonData) in
            do {
                
                self.nextModalObj = try
                    JSONDecoder().decode(NextStepModalNewArr.self, from: jsonData)
            } catch  {
                print(error)
            }
            self.dispatchGroup.leave()
            
            
        }) { (error, errorCode) in
            self.dispatchGroup.leave()
            
        }
        
        
    }
    
    func mynotesDetail(){
       
        
        
        let headers: Dictionary<String,String> = ["Authorization": "Bearer \(UserDefaults.standard.object(forKey: "accessToken")!)","Content-Type" : "application/json"]
        Network().makeApiEventGetRequest(true, url: Urls().notesAppointment(id:String(describing: selectedResult.id ?? 0)), methodType: .get, params: ["":"" as AnyObject] as  Dictionary<String, AnyObject>, header: headers, completion: { (jsonData) in
            do {
                self.noteModalObj = try
                    JSONDecoder().decode(NotesModalNew.self, from: jsonData)
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
            "entity_id": String(describing: selectedResult.id ?? 0)
            
            ] as [String : AnyObject]
        arrCreatedBy.append(dictionary)
        
        let params = [
            
            ParamName.PARAMFILTERSEL :["attachable_entities[0]" :arrCreatedBy,
                                       "is_shared" : 1
            ]
        ]
        let headers: Dictionary<String,String> = ["Authorization": "Bearer \(UserDefaults.standard.object(forKey: "accessToken")!)"]
        Network().makeApiEventGetRequest(true, url: Urls().notesAppointment(id: String(describing: selectedResult.id ?? 0)), methodType: .get, params: params as  Dictionary<String, AnyObject>, header: headers, completion: { (jsonData) in
            do {
                
                self.coachNoteModalObj = try
                    JSONDecoder().decode(NotesModalNew.self, from: jsonData)
            } catch  {
                print(error)
            }
            self.dispatchGroup.leave()
            
            
        }) { (error, errorCode) in
            self.dispatchGroup.leave()
            
        }
        
        
    }
    
    
    func outputResult(){
        
          var objApooinmentDetailAllModal = ApooinmentDetailAllNewModal();
        //            self.appoinmentDetailModalObj?.coach = selectedAppointmentModal?.coach
        //            self.appoinmentDetailModalObj?.parent = selectedAppointmentModal?.parent;
        //
                    objApooinmentDetailAllModal.nextModalObj = self.nextModalObj
                    objApooinmentDetailAllModal.noteModalObj = self.noteModalObj
                    objApooinmentDetailAllModal.coachNoteModalObj = self.coachNoteModalObj
                    objApooinmentDetailAllModal.appoinmentDetailModalObj = self.appoinmentDetailModalObj
                    delegate.sendAppoinmentData(appoinmentDetailModalObj: objApooinmentDetailAllModal, isSucess: true)
            
        return
        
        
        if let _ = self.nextModalObj , let _ = self.noteModalObj , let _ = self.coachNoteModalObj , let _ = self.appoinmentDetailModalObj{
            var objApooinmentDetailAllModal = ApooinmentDetailAllNewModal();
//            self.appoinmentDetailModalObj?.coach = selectedAppointmentModal?.coach
//            self.appoinmentDetailModalObj?.parent = selectedAppointmentModal?.parent;
//
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
    
    
    
    
    
    func postFeedback(selectedAppointmentModal : OpenHourCoachModalResult?,objFeedBackMOdal:feedbackModal)   {
          
          let params = [
            "comments" : objFeedBackMOdal.comments ?? "",
            "coach_helpfulness" : "\(objFeedBackMOdal.coach_helpfulness ?? 0)" ,
            "coach_expertise": "\(objFeedBackMOdal.coach_expertise ?? 0)" ,
            "overall_experience" : "\(objFeedBackMOdal.overall_experience ?? 0)" ,
            "csrf_token" : UserDefaultsDataSource(key: "csrf_token").readData() as? String
              ] as [String : AnyObject]
        
        
          let headers: Dictionary<String,String> = ["Authorization": "Bearer \(UserDefaults.standard.object(forKey: "accessToken")!)"]
          
        Network().makeApiEventRequest(true, url: Urls().feedBack(id: selectedAppointmentModal?.identifier ?? ""), methodType: .post, params: params, header: headers, completion: { (data) in
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
