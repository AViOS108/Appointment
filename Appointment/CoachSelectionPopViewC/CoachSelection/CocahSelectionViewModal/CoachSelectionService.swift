//
//  CoachSelectionService.swift
//  Appointment
//
//  Created by Anurag Bhakuni on 03/09/20.
//  Copyright © 2020 Anurag Bhakuni. All rights reserved.
//

import Foundation

class CoachSelectionService {
    
    
    func openHourCarrerCoachListApi(params: Dictionary<String, AnyObject>,_ success :@escaping (Data) -> Void,failure :@escaping (String,Int) -> Void ) {
           
           let headers: Dictionary<String,String> = ["Authorization": "Bearer \(UserDefaults.standard.object(forKey: "accessToken")!)"]
           Network().makeApiEventRequest(true, url: Urls().openHourCCList(), methodType: .post, params: params, header: headers, completion: { (data) in
               success(data)
           }) { (error, errorCode) in
               failure(error,errorCode)
           }
       }
    
    
    func openHourCarrerCoachListApi2(params: Dictionary<String, AnyObject>,_ success :@escaping (Data) -> Void,failure :@escaping (String,Int) -> Void ) {
           
           let headers: Dictionary<String,String> = ["Authorization": "Bearer \(UserDefaults.standard.object(forKey: "accessToken")!)"]
           Network().makeApiEventRequest(true, url: Urls().openHourCCList2(), methodType: .post, params: params, header: headers, completion: { (data) in
               success(data)
           }) { (error, errorCode) in
               failure(error,errorCode)
           }
       }
    
       
    func openHourExternalListApi(params: Dictionary<String, AnyObject>,_ success :@escaping (Data) -> Void,failure :@escaping (String,Int) -> Void ) {
        
        let headers: Dictionary<String,String> = ["Authorization": "Bearer \(UserDefaults.standard.object(forKey: "accessToken")!)"]
        Network().makeApiEventRequest(true, url: Urls().openHourECList(), methodType: .post, params: params, header: headers, completion: { (data) in
            success(data)
        }) { (error, errorCode) in
            failure(error,errorCode)
        }
    }
    
    
    func confirmAppointment(identifier : String,params: Dictionary<String, AnyObject>,_ success :@escaping (Data) -> Void,failure :@escaping (String,Int) -> Void ) {
        
        let headers: Dictionary<String,String> = ["Authorization": "Bearer \(UserDefaults.standard.object(forKey: "accessToken")!)"]
      
        
        if params["attachments_public"] != nil{
          Network().makeApiUploadFile(true, url: Urls().confirmAppointment(id: identifier), methodType: .post, params: params, header: headers, completion: { (data) in
              success(data)
          }) { (error, errorCode) in
              failure(error,errorCode)
          }
            
        }
        else
        {
            Network().makeApiEventRequest(true, url: Urls().confirmAppointment(id: identifier), methodType: .post, params: params, header: headers, completion: { (data) in
                success(data)
            }) { (error, errorCode) in
                failure(error,errorCode)
            }
        }
        
        
        
        
    }
}
