//
//  TrackingServices.swift
//  Resume
//
//  Created by Gaurav Gupta on 01/10/19.
//  Copyright © 2019 VM User. All rights reserved.
//

import Foundation
import SwiftyJSON


class TrackingServices {
    
    func track(params: Dictionary<String, AnyObject>,_ success :@escaping (JSON) -> Void,failure :@escaping (String,Int) -> Void ) {
        let headers: Dictionary<String,String> = ["Authorization": "Bearer \(UserDefaults.standard.object(forKey: "accessToken")!)"]
        Network().makeApiRequest(true, url: Urls().tracking(), methodType: .post, params: params, header: headers, completion: {
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
}
