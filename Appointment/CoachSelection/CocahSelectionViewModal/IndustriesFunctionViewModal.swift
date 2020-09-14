//
//  IndustriesFunctionViewModal.swift
//  Appointment
//
//  Created by Anurag Bhakuni on 08/09/20.
//  Copyright © 2020 Anurag Bhakuni. All rights reserved.
//

import Foundation
import SwiftyJSON


class IndustriesFunctionViewModal {

    func studentFunction( _ success :@escaping (JSON) -> Void,failure :@escaping (String,Int) -> Void ){
          let token = UserDefaultsDataSource(key: "accessToken").readData() as! String
          let headers: Dictionary<String,String> = ["Authorization": "Bearer \(token)"]
          Network().makeApiRequest(true, url: Urls().studentFunctionList(), methodType: .get, params: ["":"" as AnyObject], header: headers , completion: { response  in
              success(response)
          }) { (error,errorCode) in
              
              failure(error,errorCode)
              
          }
      }
      
      
      func studentIndustries( _ success :@escaping (JSON) -> Void,failure :@escaping (String,Int) -> Void ){
          let token = UserDefaultsDataSource(key: "accessToken").readData() as! String
          let headers: Dictionary<String,String> = ["Authorization": "Bearer \(token)"]
          Network().makeApiRequest(true, url: Urls().studentIndustriesList(), methodType: .get, params: ["":"" as AnyObject], header: headers , completion: { response  in
              success(response)

          }) { (error,errorCode) in
               failure(error,errorCode)
          }
      }
    
    func globalCompnies(_ id:String, _ success :@escaping (JSON) -> Void,failure :@escaping (String,Int) -> Void ){
             let token = UserDefaultsDataSource(key: "accessToken").readData() as! String
             let headers: Dictionary<String,String> = ["Authorization": "Bearer \(token)"]
             Network().makeApiglobalCompanies(true, url: Urls().globalCompanyList(), methodType: .get, params: ["keyword":id as AnyObject], header: headers , completion: { response  in
                    success(response)

             }) { (error,errorCode) in
                  failure(error,errorCode)
             }
         }
    
    
    
}







