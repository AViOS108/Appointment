//
//  ProviderServcie.swift
//  Resume
//
//  Created by Manu Gupta on 23/08/17.
//  Copyright © 2017 VM User. All rights reserved.
//

import Foundation
import SwiftyJSON

class ProviderServcie{
    
    func providerServcieCall(link: String,_ success :@escaping (JSON) -> Void,failure :@escaping (String,Int) -> Void ){
        
        let headers = ["Content-Type":"application/json"]
        
        Network().makeApiRequest(false, url: Urls().getProviderDetails(link: link), methodType: .get, params: ["":"" as AnyObject], header: headers, completion: {
            response in
            UserDefaultsDataSource(key: "emailAllowed").writeData(false)
            UserDefaultsDataSource(key: "facebookAllowed").writeData(false)
            UserDefaultsDataSource(key: "linkedInAllowed").writeData(false)
            UserDefaultsDataSource(key: "ssoAllowed").writeData(false)
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
                for (key,value) in response["providers"] {
                    switch key{
                    case "email":
                        UserDefaultsDataSource(key: "emailAllowed").writeData(true)
                    case "facebook":
                        let facebookDetails = response["providers"][key]
                        UserDefaultsDataSource(key: "facebookUrl").writeData(facebookDetails["oauth2"]["url"].string)
                        UserDefaultsDataSource(key: "facebookClientId").writeData(facebookDetails["oauth2"]["params"]["client_id"].string)
                        UserDefaultsDataSource(key: "facebookScope").writeData(facebookDetails["oauth2"]["params"]["scope"].string)
                        UserDefaultsDataSource(key: "facebookState").writeData(facebookDetails["oauth2"]["params"]["state"].string)
                        UserDefaultsDataSource(key: "facebookResponseType").writeData(facebookDetails["oauth2"]["params"]["response_type"].string)
                        UserDefaultsDataSource(key: "facebookAllowed").writeData(true)
                    case "linkedin":
                        let linkedInDetails = response["providers"][key]
                        UserDefaultsDataSource(key: "linkedInUrl").writeData(linkedInDetails["oauth2"]["url"].string)
                        UserDefaultsDataSource(key: "linkedInClientId").writeData(linkedInDetails["oauth2"]["params"]["client_id"].string)
                        UserDefaultsDataSource(key: "linkedInScope").writeData(linkedInDetails["oauth2"]["params"]["scope"].string)
                        UserDefaultsDataSource(key: "linkedInState").writeData(linkedInDetails["oauth2"]["params"]["state"].string)
                        UserDefaultsDataSource(key: "linkedInResponseType").writeData(linkedInDetails["oauth2"]["params"]["response_type"].string)
                        UserDefaultsDataSource(key: "linkedInAllowed").writeData(true)
                    case "vmock_url":
                        debugPrint("ignore")
                    case "apple":
                        let linkedInDetails = response["providers"][key]
                        UserDefaultsDataSource(key: "appleUrl").writeData(linkedInDetails["oauth2"]["url"].string)
                        UserDefaultsDataSource(key: "appleClientId").writeData(linkedInDetails["oauth2"]["params"]["client_id"].string)
                        UserDefaultsDataSource(key: "appleScope").writeData(linkedInDetails["oauth2"]["params"]["scope"].string)
                        UserDefaultsDataSource(key: "appleState").writeData(linkedInDetails["oauth2"]["params"]["state"].string)
                        UserDefaultsDataSource(key: "appleResponseType").writeData(linkedInDetails["oauth2"]["params"]["response_type"].string)
                        UserDefaultsDataSource(key: "appleAllowed").writeData(true)
                        
                        debugPrint("ignore")
                        
                        
                        
                    default:
                        let ssoDetails = response["providers"][key]
                        UserDefaultsDataSource(key: "ssoName").writeData(ssoDetails["name"].string)
                        UserDefaultsDataSource(key: "ssoUrl").writeData(ssoDetails["oauth2"]["url"].string)
                        UserDefaultsDataSource(key: "ssoState").writeData(ssoDetails["oauth2"]["params"]["state"].string)
                        UserDefaultsDataSource(key: "ssoAllowed").writeData(true)
                    }
                }
                success(response)
            }
        },failure:{ (error,errorCode) in
            failure(error,errorCode)
        })
    }
}
