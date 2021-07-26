//
//  ErEventService.swift
//  Event
//
//  Created by Anurag Bhakuni on 28/01/20.
//  Copyright © 2020 Anurag Bhakuni. All rights reserved.
//

import Foundation
import  SwiftyJSON
class ErEventService {
    
    func erChallengesApi(params: Dictionary<String, AnyObject>,_ success :@escaping (JSON) -> Void,failure :@escaping (String,Int) -> Void ) {
        let headers = ["":""]
        Network().makeApiRequest(false, url: Urls().eventErChalleges(stringEmail: GeneralUtility.optionalHandling(_param: params["email"] as? String, _returnType: String.self)  ), methodType: .get, params: params, header: headers, completion: { (response) in
            success(response)
        }, failure: { (error,errorCode) in
            failure(error,errorCode)
        })
    }
    
    
    func erAuthLogin(params: Dictionary<String, AnyObject>,_ success :@escaping (Data) -> Void,failure :@escaping (String,Int) -> Void ) {
        let headers: Dictionary<String,String> = ["Authorization": "Bearer \(UserDefaults.standard.object(forKey: "accessToken")!)"]
        Network().makeApiEventGetRequest(true, url: Urls().eventErAuth(), methodType: .get, params: params, header: headers, completion: { (response) in
              success(response)
        }, failure: { (error,errorCode) in
            failure(error,errorCode)
        })
    }
    
   
     func erLogin(params: Dictionary<String, AnyObject>,_ success :@escaping (JSON) -> Void,failure :@escaping (String,Int) -> Void ) {
         let headers = ["Content-Type" : "application/json",
                        "Accept":"application/json"
        ]
        Network().makeApiRequestJSONEncodedERLOGIN(true, url: Urls().eventErLogin(stringEmail: GeneralUtility.optionalHandling(_param: params["email"] as? String, _returnType: String.self), strPwd: GeneralUtility.optionalHandling(_param: params["password"] as? String, _returnType: String.self)  ), methodType: .post, params: params, header: headers, completion: { (response) in
             success(response)
         }, failure: { (error,errorCode) in
             failure(error,errorCode)
         })
     }
    
     
    
    func getNewCaptch(_ success :@escaping (JSON) -> Void,failure :@escaping (String,Int) -> Void ){
        Network().makeApiRequest(false, url: Urls().getNewCaptchEr(), methodType: .post, params: ["":"" as AnyObject], header: ["":""], completion: {
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
    
    
    func extendErLogin(_ success :@escaping (JSON) -> Void,failure :@escaping (String,Int) -> Void ){
        
        guard UserDefaultsDataSource(key: "csrf_token").readData() != nil else {
            return
        }
        
        let csrftoken = UserDefaultsDataSource(key: "csrf_token").readData() as! String
        let headers: Dictionary<String,String> = ["Authorization": "Bearer \(UserDefaults.standard.object(forKey: "accessToken")!)"]

        let param = [
            ParamName.PARAMCSRFTOKEN :csrftoken,
            ] as [String : Any];
        
        Network().makeApiRequest(true, url: Urls().extendErLogin(), methodType: .post, params: param as Dictionary<String, AnyObject>, header: headers, completion: {
            response in
            if response["error"]["code"] != JSON.null{
                failure(response["error"]["message"].string!,response["error"]["code"].int!)
            }else{
                
                for cookie in HTTPCookieStorage.shared.cookies! {
                    if cookie.name == "vmock_cmc_access_token_test" || cookie.name == "vmock_cmc_access_token_staging" || cookie.name == "vmock_cmc_access_token_live" {
                        UserDefaultsDataSource(key: "accessToken").writeData(cookie.value)
                        print(cookie.value);
                    }
                    
                }
                success(response)
            }
        }
            ,failure:{ (error,errorCode) in
                failure(error,errorCode)
        })
    }
    
    
    
    func erStudentList(params: Dictionary<String, AnyObject>,eventId : String, _ success :@escaping (Data) -> Void,failure :@escaping (String,Int) -> Void ){

        let headers: Dictionary<String,String> = ["Authorization": "Bearer \(UserDefaults.standard.object(forKey: "accessToken")!)"]
        Network().makeApiEventRequest(true, url: Urls().studentList(id: eventId), methodType: .post, params: params as Dictionary<String, AnyObject>, header: headers, completion: {
            response in
                success(response)
        }
            ,failure:{ (error,errorCode) in
                failure(error,errorCode)
        })
    }
    
    
    
    func SubmitAttendent(params: Dictionary<String, AnyObject>,eventId : String, _ success :@escaping (Data) -> Void,failure :@escaping (String,Int) -> Void ){
           
           let headers: Dictionary<String,String> = ["Authorization": "Bearer \(UserDefaults.standard.object(forKey: "accessToken")!)"]
           
           Network().makeApiEventRequest(true, url: Urls().studentList(id: eventId), methodType: .post, params: params as Dictionary<String, AnyObject>, header: headers, completion: {
               response in
                   success(response)
           }
               ,failure:{ (error,errorCode) in
                   failure(error,errorCode)
           })
       }
}
