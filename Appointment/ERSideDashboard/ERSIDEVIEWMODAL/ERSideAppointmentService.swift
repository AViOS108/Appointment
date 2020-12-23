//
//  ERSideAppointmentService.swift
//  Appointment
//
//  Created by Anurag Bhakuni on 15/11/20.
//  Copyright © 2020 Anurag Bhakuni. All rights reserved.
//

import Foundation

class ERSideAppointmentService {
    
    func erSideAppointemntListApi(params: Dictionary<String, AnyObject>,_ success :@escaping (Data) -> Void,failure :@escaping (String,Int) -> Void ) {
        
        let headers: Dictionary<String,String> = ["Authorization": "Bearer \(UserDefaults.standard.object(forKey: "accessToken")!)"]
        
        Network().makeApiEventRequest(true, url: Urls().erSideAppointment(), methodType: .post, params: params, header: headers, completion: { (data) in
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
    
    
    
    
    
    
}
