//
//  UserInfoService.swift
//  Resume
//
//  Created by VM User on 15/02/17.
//  Copyright © 2017 VM User. All rights reserved.
//

import Foundation
import SwiftyJSON

class UserInfoService{

    func updateProfile(params: Dictionary<String,AnyObject>,_ success :@escaping (JSON) -> Void,failure :@escaping (String,Int) -> Void ){
        guard let token = UserDefaults.standard.object(forKey: "accessToken") else{
            return
        }
        let headers = ["Authorization": "Bearer \(token)"]
        Network().makeApiRequest(true, url: Urls().updateProfile(), methodType: .patch, params: params, header: headers, completion: {
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
        },failure:{ (error,errorCode) in
            failure(error,errorCode)
        })
    }
    
    func updatePasswordCall(params: Dictionary<String,AnyObject>, _ success :@escaping (JSON) -> Void,failure :@escaping (String,Int) -> Void ){
        let headers: Dictionary<String,String> = ["Authorization": "Bearer \(UserDefaults.standard.object(forKey: "accessToken")!)"]
        Network().makeApiRequest(true, url: Urls().updatePassword(), methodType: .post, params: params, header: headers, completion: {
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
        },failure:{ (error,errorCode) in
            failure(error,errorCode)
        })
    }
    
    func resetPasswordCall(headerIncluded: Bool,params: Dictionary<String, AnyObject>, header: Dictionary<String, String>,_ success :@escaping (JSON) -> Void,failure :@escaping (String,Int) -> Void ){
        Network().makeApiRequest(headerIncluded, url: Urls().resetPassword(), methodType: .post, params: params, header: header , completion: {
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
    
    func removeProfilePicCall(_ success :@escaping (JSON) -> Void,failure :@escaping (String,Int) -> Void ){
        let headers: Dictionary<String,String> = ["Authorization": "Bearer \(UserDefaults.standard.object(forKey: "accessToken")!)"]
        Network().makeApiRequest(true, url: Urls().uploadProfilePicture(), methodType: .delete, params: ["":"" as AnyObject], header: headers, completion: {
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
        },failure:{ (error,errorCode) in
            failure(error,errorCode)
        })
    }
    
}
