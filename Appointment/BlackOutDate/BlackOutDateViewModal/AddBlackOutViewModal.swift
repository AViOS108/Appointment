//
//  AddBlackOutViewModal.swift
//  Appointment
//
//  Created by Anurag Bhakuni on 10/11/21.
//  Copyright © 2021 Anurag Bhakuni. All rights reserved.
//

import Foundation
import SwiftyJSON



import Foundation

// MARK: - Welcome
struct AddBlackOutModal: Codable {
    let items: [AddBlackOutModalItem]
    let total: Int
}

// MARK: - Item
struct AddBlackOutModalItem: Codable {
    let id: Int
    let message: String
}

class AddBlackOutViewModal{
    
    func callReasonList(params: Dictionary<String, AnyObject>,_ success :@escaping (AddBlackOutModal) -> Void,failure :@escaping (String,Int) -> Void ) {
        let headers: Dictionary<String,String> = ["Authorization": "Bearer \(UserDefaults.standard.object(forKey: "accessToken")!)"]
        Network().makeApiEventGetRequest(true, url: Urls().blackOutReasonList(), methodType: .get, params: params, header: headers, completion: { (response) in
            do {
                success( try
                         JSONDecoder().decode(AddBlackOutModal.self, from: response))
                
            } catch  {
                failure("error",-1)
            }
        }, failure: { (error,errorCode) in
            failure(error,errorCode)
        })
    }
    
    
    func createManySpans(params: Dictionary<String, AnyObject>,_ success :@escaping (Data) -> Void,failure :@escaping (String,Int) -> Void ) {
           
           let headers: Dictionary<String,String> = ["Authorization": "Bearer \(UserDefaults.standard.object(forKey: "accessToken")!)"]
           Network().makeApiEventRequest(true, url: Urls().createManySpans(), methodType: .post, params: params, header: headers, completion: { (data) in
               success(data)
           }) { (error, errorCode) in
               failure(error,errorCode)
           }
       }
    
}


