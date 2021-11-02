//
//  ERSideAppointmentService.swift
//  Appointment
//
//  Created by Anurag Bhakuni on 15/11/20.
//  Copyright © 2020 Anurag Bhakuni. All rights reserved.
//

import Foundation

class ERSideAppointmentService {
    
    
    func erSideAppointemntAccept(params: Dictionary<String, AnyObject>,id : Int,  _ success :@escaping (Data) -> Void,failure :@escaping (String,Int) -> Void ) {
          
          let headers: Dictionary<String,String> = ["Authorization": "Bearer \(UserDefaults.standard.object(forKey: "accessToken")!)"]
          
        Network().makeApiEventRequest(true, url: Urls().erSideAppointmentAccept(id: id), methodType: .post, params: params, header: headers, completion: { (data) in
              success(data)
          }) { (error, errorCode) in
              failure(error,errorCode)
          }
      }
    
    func erSideAppointemntNextComplete(params: Dictionary<String, AnyObject>,id : String,  _ success :@escaping (Data) -> Void,failure :@escaping (String,Int) -> Void ) {
          
          let headers: Dictionary<String,String> = ["Authorization": "Bearer \(UserDefaults.standard.object(forKey: "accessToken")!)"]
          
        Network().makeApiEventRequest(true, url: Urls().erSideAppointmentNScomplete(id: id), methodType: .post, params: params, header: headers, completion: { (data) in
              success(data)
          }) { (error, errorCode) in
              failure(error,errorCode)
          }
      }
    
    func erSideAppointemntDandC(params: Dictionary<String, AnyObject>,id : String,idIndex:Int ,_ success :@escaping (Data) -> Void,failure :@escaping (String,Int) -> Void ) {
             
             let headers: Dictionary<String,String> = ["Authorization": "Bearer \(UserDefaults.standard.object(forKey: "accessToken")!)"]
             
        Network().makeApiEventRequest(true, url: Urls().erSideAppointmentDandC(id: id, idIndex: idIndex), methodType: .post, params: params, header: headers, completion: { (data) in
                 success(data)
             }) { (error, errorCode) in
                 failure(error,errorCode)
             }
         }
    
    
    func erSideAppointemntSaveNotes(params: Dictionary<String, AnyObject>,_ success :@escaping (Data) -> Void,failure :@escaping (String,Int) -> Void ) {
                
                let headers: Dictionary<String,String> = ["Authorization": "Bearer \(UserDefaults.standard.object(forKey: "accessToken")!)"]
                
           Network().makeApiEventRequest(true, url: Urls().saveNotes(), methodType: .post, params: params, header: headers, completion: { (data) in
                    success(data)
                }) { (error, errorCode) in
                    failure(error,errorCode)
                    
                    
                }
        
        }
    
    
    
    
    func erSideAppointemntListApi(params: Dictionary<String, AnyObject>,_ success :@escaping (Data) -> Void,failure :@escaping (String,Int) -> Void ) {
        
        let headers: Dictionary<String,String> = ["Authorization": "Bearer \(UserDefaults.standard.object(forKey: "accessToken")!)"]
        
        Network().makeApiEventRequest(true, url: Urls().erSideAppointment(), methodType: .post, params: params, header: headers, completion: { (data) in
            success(data)
        }) { (error, errorCode) in
            failure(error,errorCode)
        }
    }
    
    func erSideOpenHourListApi(params: Dictionary<String, AnyObject>,_ success :@escaping (Data) -> Void,failure :@escaping (String,Int) -> Void ) {
           
           let headers: Dictionary<String,String> = ["Authorization": "Bearer \(UserDefaults.standard.object(forKey: "accessToken")!)"]
           
           Network().makeApiEventRequest(true, url: Urls().erSideOPenHourList(), methodType: .post, params: params, header: headers, completion: { (data) in
               success(data)
           }) { (error, errorCode) in
               failure(error,errorCode)
           }
       }
    
    
  
    
    
    func erSideDuplicatePurpose(params: Dictionary<String, AnyObject>,_ success :@escaping (Data) -> Void,failure :@escaping (String,Int) -> Void ) {
             
             let headers: Dictionary<String,String> = ["Authorization": "Bearer \(UserDefaults.standard.object(forKey: "accessToken")!)"]
             
             Network().makeApiEventRequest(true, url: Urls().erSideDuplicatePurpose(), methodType: .post, params: params, header: headers, completion: { (data) in
                 success(data)
             }) { (error, errorCode) in
                 failure(error,errorCode)
             }
         }
    
    func erSideOPenHourApi(id: String,_ success :@escaping (Data) -> Void,failure :@escaping (String,Int) -> Void ){
        
        let headers: Dictionary<String,String> = ["Authorization": "Bearer \(UserDefaults.standard.object(forKey: "accessToken")!)"]
        
        Network().makeApiEventGetRequest(true, url: Urls().erSideOPenHourDetail(id:id ), methodType: .get, params: ["":"" as AnyObject], header: headers, completion: { (jsonData) in
            success(jsonData)
            
        }) { (error, errorCode) in
            failure(error,errorCode)
            
        }
        
    }
    
    
    func erSideparticipantApi(params: Dictionary<String, AnyObject>,id: String,_ success :@escaping (Data) -> Void,failure :@escaping (String,Int) -> Void ){
        
        let headers: Dictionary<String,String> = ["Authorization": "Bearer \(UserDefaults.standard.object(forKey: "accessToken")!)"]
        
        Network().makeApiEventGetRequest(true, url: Urls().erSideOpenHourParticpant(id:id ), methodType: .post, params: params, header: headers, completion: { (jsonData) in
            success(jsonData)
            
        }) { (error, errorCode) in
            failure(error,errorCode)
            
        }
        
    }
    
    
    
    
    func erSideOPenHourDeleteApi(param: Dictionary<String,AnyObject>,deleteAll : String,id : String, _ success :@escaping (Data) -> Void,failure :@escaping (String,Int) -> Void ){
          
          let headers: Dictionary<String,String> = ["Authorization": "Bearer \(UserDefaults.standard.object(forKey: "accessToken")!)"]
          
        Network().makeApiEventRequest(true, url: Urls().erSideOPenHourDelete( id: id, isDeleteAllcoocurence: deleteAll), methodType: .post, params: param, header: headers, completion: { (jsonData) in
              success(jsonData)
              
          }) { (error, errorCode) in
              failure(error,errorCode)
              
          }
          
      }
    
    
    
    func erSideOPenHourGetPurposeApi(_ success :@escaping (Data) -> Void,failure :@escaping (String,Int) -> Void ){
           
           let headers: Dictionary<String,String> = ["Authorization": "Bearer \(UserDefaults.standard.object(forKey: "accessToken")!)"]
           
           Network().makeApiEventGetRequest(true, url: Urls().erSideOPenHourGetPurpose(), methodType: .get, params: ["":"" as AnyObject], header: headers, completion: { (jsonData) in
               success(jsonData)
               
           }) { (error, errorCode) in
               failure(error,errorCode)
               
           }
           
       }
    
    
    func erSideOPenHourProviderApi(_ success :@escaping (Data) -> Void,failure :@escaping (String,Int) -> Void ){
        
        let headers: Dictionary<String,String> = ["Authorization": "Bearer \(UserDefaults.standard.object(forKey: "accessToken")!)"]
        
        Network().makeApiEventGetRequest(true, url: Urls().erSideOPenHourGetProvider(), methodType: .get, params: ["":"" as AnyObject], header: headers, completion: { (jsonData) in
            success(jsonData)
            
        }) { (error, errorCode) in
            failure(error,errorCode)
            
        }
        
    }
    
    
    func erSideStudentListApi(params: Dictionary<String, AnyObject>,_ success :@escaping (Data) -> Void,failure :@escaping (String,Int) -> Void ) {
           
           let headers: Dictionary<String,String> = ["Authorization": "Bearer \(UserDefaults.standard.object(forKey: "accessToken")!)"]
           
           Network().makeApiEventRequest(true, url: Urls().erSideStudentList(), methodType: .post, params: params, header: headers, completion: { (data) in
               success(data)
           }) { (error, errorCode) in
               failure(error,errorCode)
           }
       }
    
    
    func erSideOPenHourTags(_ success :@escaping (Data) -> Void,failure :@escaping (String,Int) -> Void ){
        
        let headers: Dictionary<String,String> = ["Authorization": "Bearer \(UserDefaults.standard.object(forKey: "accessToken")!)"]
        
        Network().makeApiEventGetRequest(true, url: Urls().erSideOPenHourTags(), methodType: .get, params: ["":"" as AnyObject], header: headers, completion: { (jsonData) in
            success(jsonData)
            
        }) { (error, errorCode) in
            failure(error,errorCode)
            
        }
        
    }
    
    
    
    func erSideSubmitNewUserPurposeApi(params: Dictionary<String, AnyObject>,_ success :@escaping (Data) -> Void,failure :@escaping (String,Int) -> Void ) {
        
        let headers: Dictionary<String,String> = ["Authorization": "Bearer \(UserDefaults.standard.object(forKey: "accessToken")!)"]
        
        Network().makeApiEventRequest(true, url: Urls().erSideOPenHourGetProvider(), methodType: .post, params: params, header: headers, completion: { (data) in
            success(data)
        }) { (error, errorCode) in
            failure(error,errorCode)
        }
    }
    
    
    func erSideSubmitNewOpenHour(params: Dictionary<String, AnyObject>,_ success :@escaping (Data) -> Void,failure :@escaping (String,Int) -> Void ) {
        
        let headers: Dictionary<String,String> = ["Authorization": "Bearer \(UserDefaults.standard.object(forKey: "accessToken")!)"]
        
        Network().makeApiEventRequest(true, url: Urls().createNewOpenHour(), methodType: .post, params: params, header: headers, completion: { (data) in
            success(data)
        }) { (error, errorCode) in
            failure(error,errorCode)
        }
    }
    
    func erSideSubmitEditedOpenHour(params: Dictionary<String, AnyObject>,id : String,_ success :@escaping (Data) -> Void,failure :@escaping (String,Int) -> Void ) {
           
           let headers: Dictionary<String,String> = ["Authorization": "Bearer \(UserDefaults.standard.object(forKey: "accessToken")!)"]
           
        Network().makeApiEventRequest(true, url: Urls().editedOpenHour(id: id), methodType: .post, params: params, header: headers, completion: { (data) in
               success(data)
           }) { (error, errorCode) in
               failure(error,errorCode)
           }
       }
    
    func erSideStudentList(params: Dictionary<String, AnyObject>,_ success :@escaping (Data) -> Void,failure :@escaping (String,Int) -> Void ) {
           
           let headers: Dictionary<String,String> = ["Authorization": "Bearer \(UserDefaults.standard.object(forKey: "accessToken")!)"]
           
           Network().makeApiStudentList(true, url: Urls().erSideStudentListAppoinment(), methodType: .post, params: params, header: headers, completion: { (data) in
               success(data)
           }) { (error, errorCode) in
               failure(error,errorCode)
           }
       }
    
    
    func erSideResumeList(params: Dictionary<String, AnyObject>,_ success :@escaping (Data) -> Void,failure :@escaping (String,Int) -> Void ) {
              
              let headers: Dictionary<String,String> = ["Authorization": "Bearer \(UserDefaults.standard.object(forKey: "accessToken")!)"]
              
              Network().makeApiStudentList(true, url: Urls().erSideStudentList(), methodType: .post, params: params, header: headers, completion: { (data) in
                  success(data)
              }) { (error, errorCode) in
                  failure(error,errorCode)
              }
          }
    
    func erUpdateAttendence(params: Dictionary<String, AnyObject>,studentId : Int ,_ success :@escaping (Data) -> Void,failure :@escaping (String,Int) -> Void ) {
                
                let headers: Dictionary<String,String> = ["Authorization": "Bearer \(UserDefaults.standard.object(forKey: "accessToken")!)"]
                
        Network().makeApiStudentList(true, url: Urls().erSideUpdateAttendence(studentId: studentId), methodType: .post, params: params, header: headers, completion: { (data) in
                    success(data)
                }) { (error, errorCode) in
                    failure(error,errorCode)
                }
            }
    
    func erSideRoleList(_ success :@escaping (Data) -> Void,failure :@escaping (String,Int) -> Void ){
          
          let headers: Dictionary<String,String> = ["Authorization": "Bearer \(UserDefaults.standard.object(forKey: "accessToken")!)"]
          
          Network().makeApiEventGetRequest(true, url: Urls().erSideRolelist(), methodType: .get, params: ["":"" as AnyObject], header: headers, completion: { (jsonData) in
              success(jsonData)
              
          }) { (error, errorCode) in
              failure(error,errorCode)
              
          }
          
      }
    
    
    func erSideResumeView(resumeId: Int,  _ success :@escaping (Data) -> Void,failure :@escaping (String,Int) -> Void ){
        
        let headers: Dictionary<String,String> = ["Authorization": "Bearer \(UserDefaults.standard.object(forKey: "accessToken")!)"]
        
        let paramsResumeIDs = ["resume_ids" : [resumeId]
        ] as Dictionary<String, AnyObject>
        
        Network().makeApiEventGetRequest(true, url: Urls().erSideResumeView(resumeId: resumeId), methodType: .get, params: paramsResumeIDs , header: headers, completion: { (jsonData) in
            success(jsonData)
            
        }) { (error, errorCode) in
            failure(error,errorCode)
            
        }
        
    }
    
    func erSideDownloadResume(url: String,  _ success :@escaping (Dictionary<String,Any>) -> Void,failure :@escaping (String,Int) -> Void ){
        
        let headers: Dictionary<String,String> = ["Authorization": "Bearer \(UserDefaults.standard.object(forKey: "accessToken")!)"]
        
        Network().makeApiDownloadFile(false, url:  url, methodType: .get, params: ["":"" as AnyObject], header: headers) { (data) in
            success(data)
            
        } failure: { (error, errorCode) in
            
        }
        
        
    }
    
    
    
    func erSideSpecifcList(params: Dictionary<String, AnyObject> ,_ success :@escaping (Data) -> Void,failure :@escaping (String,Int) -> Void ) {
        
        let headers: Dictionary<String,String> = ["Authorization": "Bearer \(UserDefaults.standard.object(forKey: "accessToken")!)"]
        
        Network().makeApiStudentList(true, url: Urls().erSideSpecificUserlist(), methodType: .post, params: params, header: headers, completion: { (data) in
            success(data)
        }) { (error, errorCode) in
            failure(error,errorCode)
        }
    }
    
    func erSideSubmitNotes(params: Dictionary<String, AnyObject> ,_ success :@escaping (Data) -> Void,failure :@escaping (String,Int) -> Void ,noteModelResult : NotesModalNewResult?) {
        
        let headers: Dictionary<String,String> = ["Authorization": "Bearer \(UserDefaults.standard.object(forKey: "accessToken")!)"]
        var url = ""
       
            if noteModelResult != nil{
                url = Urls().erSideEditNotes(id: String( noteModelResult?.id ?? 0))
            }
            else{
                url = Urls().erSideSubmitNotes()
            }
       
        Network().makeApiStudentList(true, url: url, methodType: .post, params: params, header: headers, completion: { (data) in
            success(data)
        }) { (error, errorCode) in
            failure(error,errorCode)
        }
    }
    
    
    func studentSideSubmitNotes(params: Dictionary<String, AnyObject> ,_ success :@escaping (Data) -> Void,failure :@escaping (String,Int) -> Void ,noteModelResult : NotesResult?) {
        
        let headers: Dictionary<String,String> = ["Authorization": "Bearer \(UserDefaults.standard.object(forKey: "accessToken")!)"]
        var url = ""
            if noteModelResult != nil{
                url = Urls().studentEditNotes(id: String( noteModelResult?.id ?? 0))
            }
            else{
                url = Urls().saveNotes()
            }
        Network().makeApiStudentList(true, url: url, methodType: .post, params: params, header: headers, completion: { (data) in
            success(data)
        }) { (error, errorCode) in
            failure(error,errorCode)
        }
    }
    
    
    
    func erSideStandardResponse(_ success :@escaping (Data) -> Void,failure :@escaping (String,Int) -> Void ){
          
          let headers: Dictionary<String,String> = ["Authorization": "Bearer \(UserDefaults.standard.object(forKey: "accessToken")!)"]
          
          Network().makeApiEventGetRequest(true, url: Urls().erSideStandardRepone(), methodType: .get, params: ["":"" as AnyObject], header: headers, completion: { (jsonData) in
              success(jsonData)
              
          }) { (error, errorCode) in
              failure(error,errorCode)
              
          }
          
      }
    
    func erSideSubmitNextStep(params: Dictionary<String, AnyObject> ,_ success :@escaping (Data) -> Void,failure :@escaping (String,Int) -> Void ) {
           
           let headers: Dictionary<String,String> = ["Authorization": "Bearer \(UserDefaults.standard.object(forKey: "accessToken")!)"]
           
           Network().makeApiStudentList(true, url: Urls().erSideSubmitNext(), methodType: .post, params: params, header: headers, completion: { (data) in
               success(data)
           }) { (error, errorCode) in
               failure(error,errorCode)
           }
       }
    
    
    
    func erSideSubmitAdhocAppoiment(params: Dictionary<String, AnyObject>,_ success :@escaping (Data) -> Void,failure :@escaping (String,Int) -> Void ) {
                
                let headers: Dictionary<String,String> = ["Authorization": "Bearer \(UserDefaults.standard.object(forKey: "accessToken")!)"]
                
                Network().makeApiEventRequest(true, url: Urls().submitAdhocAppointment(), methodType: .post, params: params, header: headers, completion: { (data) in
                    success(data)
                }) { (error, errorCode) in
                    failure(error,errorCode)
                }
            }
    
    
//    
//    func erSideStudentListApi(params: Dictionary<String, AnyObject>,_ success :@escaping (Data) -> Void,failure :@escaping (String,Int) -> Void ) {
//
//              let headers: Dictionary<String,String> = ["Authorization": "Bearer \(UserDefaults.standard.object(forKey: "accessToken")!)"]
//
//              Network().makeApiEventRequest(true, url: Urls().erSideStudentList(), methodType: .post, params: params, header: headers, completion: { (data) in
//                  success(data)
//              }) { (error, errorCode) in
//                  failure(error,errorCode)
//              }
//          }
    
    
}
