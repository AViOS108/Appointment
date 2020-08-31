//
//  RegisterService.swift
//  Resume
//
//  Created by VM User on 14/03/17.
//  Copyright © 2017 VM User. All rights reserved.
//

import Foundation
import SwiftyJSON

class RegisterService{
    
    func resisterUserCall(headerIncluded: Bool,headers: Dictionary<String, String>,params: Dictionary<String, AnyObject>, _ success :@escaping (JSON) -> Void,failure :@escaping (String,Int) -> Void ){

        Network().makeApiRequest(headerIncluded, url: Urls().resgister(), methodType: .post, params: params, header: headers, completion: {
            response in
            if response["status"] == true{
                success(response)
            }else{
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
                }
            }
        }
            ,failure:{ (error,errorCode) in
                failure(Network().handleErrorCases(error: error),errorCode)                
        })
    }
}
