//
//  AccountDetailsServices.swift
//  Resume
//
//  Created by VM User on 27/04/17.
//  Copyright © 2017 VM User. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

class AccountDetailsServices{
    
    func getformFields(_ success :@escaping (JSON) -> Void,failure :@escaping (String,Int) -> Void ){
        
        let headers: Dictionary<String,String> = ["Authorization": "Bearer \(UserDefaults.standard.object(forKey: "accessToken")!)"]
        Network().makeApiRequest(true, url: Urls().getAccountDetails(), methodType: .get, params: ["":"" as AnyObject], header: headers, completion: {
            response in
            if response["error"]["code"] != JSON.null{
                if response["error"]["errors"] != JSON.null {
                    if let keys = response["error"]["errors"].dictionary?.keys{
                        if let object = response["error"]["errors"][keys.first!].string {
                            failure(object,response["error"]["code"].int!)
                        }
                        else if let object = response["error"]["errors"][keys.first!].array ,object.count > 0 {
                            failure(object[0].string!,response["error"]["code"].int!)
                        }
                    }
                }else{
                    failure(response["error"]["message"].string!,response["error"]["code"].int!)
                }
            }else{
                success(response)
            }
        }
            ,failure:{ (error,errorCode) in
                failure(error,errorCode)
        })
    }
    
    
    
    func getformFieldsOption(_ success :@escaping (JSON) -> Void,failure :@escaping (String,Int) -> Void,queryParam: String ){
        
        let headers: Dictionary<String,String> = ["Authorization": "Bearer \(UserDefaults.standard.object(forKey: "accessToken")!)"]
        Network().makeApiRequest(true, url: Urls().getAccountDetailsOption(id: queryParam), methodType: .get, params: ["":"" as AnyObject], header: headers, completion: {
            response in
            if response["error"]["code"] != JSON.null{
                if response["error"]["errors"] != JSON.null {
                    if let keys = response["error"]["errors"].dictionary?.keys{
                        if let object = response["error"]["errors"][keys.first!].string {
                            failure(object,response["error"]["code"].int!)
                        }
                        else if let object = response["error"]["errors"][keys.first!].array ,object.count > 0 {
                            failure(object[0].string!,response["error"]["code"].int!)
                        }
                    }
                }else{
                    failure(response["error"]["message"].string!,response["error"]["code"].int!)
                }
            }else{
                success(response)
            }
        }
            ,failure:{ (error,errorCode) in
                failure(error,errorCode)
        })
    }
    
    
    
    
    
    func updateformFields(params: Dictionary<String, AnyObject>,_ success :@escaping (JSON) -> Void,failure :@escaping (String,Int) -> Void ){
        
        let headers: Dictionary<String,String> = ["Authorization": "Bearer \(UserDefaults.standard.object(forKey: "accessToken")!)"]
        Network().makeApiRequest(true, url: Urls().updateAccountDetails(), methodType: .put, params: params, header: headers, completion: {
            response in
            if response["error"]["code"] != JSON.null{
                failure(response["error"]["message"].string!,response["error"]["code"].int!)
            }else{
                success(response)
            }
        }
            ,failure:{ (error,errorCode) in
                failure(error,errorCode)
        })
    }
    
    func getResourceFieldsCall(url: String,_ success :@escaping (JSON) -> Void,failure :@escaping (String,Int) -> Void ){
        
        Alamofire.SessionManager.default.session.getAllTasks(completionHandler: { tasks in
            for task in tasks {
                task.cancel()
            }
        })
        
        let headers: Dictionary<String,String> = ["Authorization": "Bearer \(UserDefaults.standard.object(forKey: "accessToken")!)"]
        Network().makeApiRequest(true, url: url, methodType: .get, params: ["":"" as AnyObject], header: headers, completion: {
            response in
            if response["error"]["code"] != JSON.null{
                failure(response["error"]["message"].string!,response["error"]["code"].int!)
            }else{
                success(response)
            }
        },failure:{ (error,errorCode) in
            if errorCode !=  -999 {
                failure(error,errorCode)
            }
        })
    }
    
    func verifyAccountCall(headerIncluded: Bool,params: Dictionary<String, AnyObject>, header: Dictionary<String, String>,_ success :@escaping (JSON) -> Void,failure :@escaping (String,Int) -> Void ){
        Network().makeApiRequest(headerIncluded, url: Urls().verifyAccount(), methodType: .post, params: params, header: header , completion: {
            response in
            if response["error"]["code"] != JSON.null{
                if response["error"]["errors"] != JSON.null {
                    if let keys = response["error"]["errors"].dictionary?.keys{
                        if let object = response["error"]["errors"][keys.first!].string {
                            failure(object,response["error"]["code"].int!)
                        }
                        else if let object = response["error"]["errors"][keys.first!].array ,object.count > 0 {
                            failure(object[0].string!,response["error"]["code"].int!)
                        }
                    }
                }else{
                    failure(response["error"]["message"].string!,response["error"]["code"].int!)
                }
            }else{
                success(response)
            }
        }
            ,failure:{ (error,errorCode) in
                failure(Network().handleErrorCases(error: error),errorCode)
        })
    }
}
