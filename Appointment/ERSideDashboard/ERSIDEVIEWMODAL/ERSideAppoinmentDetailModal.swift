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
    func sendFinaliszeStatus(isSucess: Bool )

    
}

class ERSideAppoinmentDetailModal{
    
    
    var nextModalObj : [NextStepModalNew]?
    var noteModalObj :   NotesModalNew?
    var noteModalObjStudent :  NotesModal?
    var coachNoteModalObj :   NotesModal?
    var appoinmentDetailModalObj : AppoinmentDetailModalNew?
    
    var callbackVC: ((_ suceess: Bool) -> Void)?
    var detailType : Int = 0

    var delegate : ERSideAppoinmentDetailModalDeletgate!
    
    let dispatchGroup = DispatchGroup()
    var selectedResultID : Int!

    
    func viewModalCustomized(){
        
        dispatchGroup.enter()
        self.appoinmentDetail()
        dispatchGroup.enter()
        self.nextStepDetail()
        dispatchGroup.enter()
        self.mynotesDetail()
        let isStudent = UserDefaultsDataSource(key: "student").readData() as? Bool
        if isStudent ?? false{
            dispatchGroup.enter()
            self.coachNotesDetail()
        }
        else
        {
            
        }
        
        dispatchGroup.notify(queue: .main) {
            self.outputResult()
        }
        
        
        
    }
    
    
    
    func appoinmentDetail()
    {
        
        
        var    param : [String : AnyObject]!
        
        
        
        let isStudent = UserDefaultsDataSource(key: "student").readData() as? Bool
        var idSelected = 0;
        if isStudent ?? false{
            var localTimeZoneIndemtifier: String { return TimeZone.current.identifier}
            idSelected = selectedResultID ?? 0
            param = [ ParamName.PARAMINTIMEZONEEL :localTimeZoneIndemtifier
            ] as [String : AnyObject]
        }
        else{
            var localTimeZoneAbbreviation: String { return TimeZone.current.abbreviation() ?? "" }

            idSelected = selectedResultID ?? 0

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
            }                 }
        
        
        
        
        
        
        let headers: Dictionary<String,String> = ["Authorization": "Bearer \(UserDefaults.standard.object(forKey: "accessToken")!)"]
     
        
        Network().makeApiEventGetRequest(true, url: Urls().confirmAppointment(id: String(describing: idSelected)) , methodType: .get, params: param, header: headers, completion: { (jsonData) in
            do {
                
                self.appoinmentDetailModalObj = try
                    JSONDecoder().decode(AppoinmentDetailModalNew.self, from: jsonData)
            } catch  {
                print(error)
            }
            
            
            if isStudent ?? true{
                self.coachDetailApi(coachId: self.appoinmentDetailModalObj?.coachID ?? 0)
            }
            else{
                
                self.dispatchGroup.leave()

            }
            
            
            
        }) { (error, errorCode) in
            self.dispatchGroup.leave()
            
        }
        
    }
    
    
    func coachDetailApi (coachId : Int){
        
        let headers: Dictionary<String,String> = ["Authorization": "Bearer \(UserDefaults.standard.object(forKey: "accessToken")!)"]
     
        
        Network().makeApiEventGetRequest(true, url: Urls().coachDetail(id: String(describing: coachId)) , methodType: .get, params: ["":"" as AnyObject], header: headers, completion: { (jsonData) in
            do {
                
                self.appoinmentDetailModalObj?.coachDetailApi = try
                    JSONDecoder().decode(CoachDetailApi.self, from: jsonData)
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
                "appointment_ids" : [String(describing: selectedResultID ?? 0)],
                "is_completed":
                    ["0","1"],
            ],
            ] as [String : AnyObject]
        let isStudent = UserDefaultsDataSource(key: "student").readData() as? Bool

        var idSelected = 0;
        if isStudent ?? false{
            idSelected = selectedResultID ?? 0
        }
        else{
            idSelected = selectedResultID ?? 0
        }
        Network().makeApiEventGetRequest(true, url: Urls().nextStepAppointment(id: String(describing: idSelected ?? 0)), methodType: .get, params: param, header: headers, completion: { (jsonData) in
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
       
        
        var arrCreatedBy = Array<Dictionary<String,AnyObject>>()
        let dictionary = [
            "entity_type":"appointment",
            "entity_id": String(describing: selectedResultID ?? 0)
            
            ] as [String : AnyObject]
        arrCreatedBy.append(dictionary)
        
        let params = [
            
            ParamName.PARAMFILTERSEL :["attachable_entities[0]" :arrCreatedBy,
                                       "is_shared" : 0
            ]
        ]
        
        let headers: Dictionary<String,String> = ["Authorization": "Bearer \(UserDefaults.standard.object(forKey: "accessToken")!)","Content-Type" : "application/json"]
        let isStudent = UserDefaultsDataSource(key: "student").readData() as? Bool

        var idSelected = 0;
        if isStudent ?? false{
            idSelected = selectedResultID ?? 0
        }
        else{
            idSelected = selectedResultID ?? 0
        }
        Network().makeApiEventGetRequest(true, url: Urls().notesAppointment(id:String(describing: idSelected), isShared: "0"), methodType: .get, params: ["":""] as  Dictionary<String, AnyObject>, header: headers, completion: { (jsonData) in
            do {
                if isStudent ?? true{
                    self.noteModalObjStudent = try
                        JSONDecoder().decode(NotesModal.self, from: jsonData)
                }
                else{
                    self.noteModalObj = try
                        JSONDecoder().decode(NotesModalNew.self, from: jsonData)
                }

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
            "entity_type":"appointment",
            "entity_id": String(describing: selectedResultID ?? 0)
            
            ] as [String : AnyObject]
        arrCreatedBy.append(dictionary)
        
        let params = [
            
            ParamName.PARAMFILTERSEL :["attachable_entities[0]" :arrCreatedBy,
                                       "is_shared" : 1
            ]
        ]
        let headers: Dictionary<String,String> = ["Authorization": "Bearer \(UserDefaults.standard.object(forKey: "accessToken")!)"]
        Network().makeApiEventGetRequest(true, url: Urls().notesAppointment(id: String(describing: selectedResultID ?? 0), isShared: "1"), methodType: .get, params: ["" :""] as  Dictionary<String, AnyObject>, header: headers, completion: { (jsonData) in
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
        
        var objApooinmentDetailAllModal = ApooinmentDetailAllNewModal();
        //            self.appoinmentDetailModalObj?.coach = selectedAppointmentModal?.coach
        //            self.appoinmentDetailModalObj?.parent = selectedAppointmentModal?.parent;
        //
        objApooinmentDetailAllModal.nextModalObj = self.nextModalObj
//        objApooinmentDetailAllModal.coachNoteModalObj = self.coachNoteModalObj
        objApooinmentDetailAllModal.appoinmentDetailModalObj = self.appoinmentDetailModalObj
        let isStudent = UserDefaultsDataSource(key: "student").readData() as? Bool

        if isStudent ?? false
        {
            var allNoteModalStudent = NotesModal()
            if self.noteModalObjStudent != nil && self.noteModalObjStudent?.results?.count ?? 0 > 0{
                var objNotesResult = [NotesResult]()
                for result in self.noteModalObjStudent!.results! {
                    var resultNote = result
                    resultNote.isShared = 0
                    objNotesResult.append(resultNote);
                }
                allNoteModalStudent.results = objNotesResult
            }
            if self.coachNoteModalObj != nil && self.coachNoteModalObj?.results?.count ?? 0 > 0{
                var objNotesResult = [NotesResult]()

                for result in self.coachNoteModalObj!.results! {
                    var resultNote = result
                    resultNote.isShared = 1
                    objNotesResult.append(resultNote);
                }
                
                if allNoteModalStudent.results != nil{
                    allNoteModalStudent.results?.append(contentsOf: objNotesResult)
                }
                else{
                    allNoteModalStudent.results = objNotesResult
                }
            }
            
            
            objApooinmentDetailAllModal.noteModalObjStudent = allNoteModalStudent
        }
        else{
            objApooinmentDetailAllModal.noteModalObj = self.noteModalObj
            
        }
        delegate.sendAppoinmentData(appoinmentDetailModalObj: objApooinmentDetailAllModal, isSucess: true)
        
        
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
    
    
    
    
    func finaliseApi(selectedAppointmentid : Int)   {
          
          let params = [
            "_method": "post",
            "csrf_token" : UserDefaultsDataSource(key: "csrf_token").readData() as? String
              ] as [String : AnyObject]
        
        
          let headers: Dictionary<String,String> = ["Authorization": "Bearer \(UserDefaults.standard.object(forKey: "accessToken")!)"]
          
        Network().makeApiEventRequest(true, url: Urls().finalize(id: "\(selectedAppointmentid)"), methodType: .post, params: params, header: headers, completion: { (data) in
            do {
                self.delegate.sendFinaliszeStatus(isSucess: true)
                
            } catch  {
                CommonFunctions().showError(title: "", message: ErrorMessages.SomethingWentWrong.rawValue)
                self.delegate.sendFinaliszeStatus(isSucess: false)
            }
            
        }) { (error, errorCode) in
            
              CommonFunctions().showError(title: "", message: error)
            self.delegate.sendFinaliszeStatus(isSucess: false)
          }
          
      }
    
    
    
}
