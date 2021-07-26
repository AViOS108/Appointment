//
//  ForgotPasswordService.swift
//  Resume
//
//  Created by VM User on 31/01/17.
//  Copyright © 2017 VM User. All rights reserved.
//

import Foundation
import SwiftyJSON

class ForgotPasswordService{
    
    func forgotPasswordCall(params: Dictionary<String, AnyObject>, _ success :@escaping (JSON) -> Void,failure :@escaping (String,Int) -> Void ){
        
        let headers = ["Content-Type":"application/json"]
        
        Network().makeApiRequest(false, url: Urls().forgotPassword(), methodType: .post, params: params, header: headers, completion: {
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
