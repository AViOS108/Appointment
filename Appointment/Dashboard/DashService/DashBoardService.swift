//
//  DashBoardService.swift
//  Appointment
//
//  Created by Anurag Bhakuni on 18/08/20.
//  Copyright © 2020 Anurag Bhakuni. All rights reserved.
//

import Foundation
class DashboardService {
    
    func coachListApi(params: Dictionary<String, AnyObject>,_ success :@escaping (Data) -> Void,failure :@escaping (String,Int) -> Void ) {
        
        let headers: Dictionary<String,String> = ["Authorization": "Bearer \(UserDefaults.standard.object(forKey: "accessToken")!)"]
        Network().makeApiCoachRequest(true, url: Urls().coachesList(), methodType: .get, params: params, header: headers, completion: { (data) in
            success(data)
        }) { (error, errorCode) in
            failure(error,errorCode)
        }
    }
}
