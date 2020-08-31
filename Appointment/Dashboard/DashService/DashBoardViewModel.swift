//
//  DashBoardViewModel.swift
//  Appointment
//
//  Created by Anurag Bhakuni on 18/08/20.
//  Copyright © 2020 Anurag Bhakuni. All rights reserved.
//

import Foundation
import UIKit
class DashBoardViewModel  {
    
    var viewController : UIViewController!
    var activityIndicator: ActivityIndicatorView?

    
    func fetchCall(params: Dictionary<String,AnyObject>,success:@escaping (DashBoardModel) -> Void,failure:@escaping (String,Int) -> Void)
    {
        activityIndicator = ActivityIndicatorView.showActivity(view: viewController.navigationController!.view, message: StringConstants.loginApiLoader)
       
        DashboardService().coachListApi(params: params, { (jsonData) in
            
            self.activityIndicator?.hide()
            let welcome = try? JSONDecoder().decode(DashBoardModel.self, from: jsonData)
            success(welcome!)
            
            
            
        }) { (error, errorCode) in
            self.activityIndicator?.hide()
            CommonFunctions().showError(title: "Error", message: ErrorMessages.SomethingWentWrong.rawValue)
        }
        
    }
    
    
    func errorHandler(error: String,errorCode: Int, params: Dictionary<String,AnyObject>,headerIncluded: Bool,header: Dictionary<String,String>){
          self.activityIndicator?.hide()
          CommonFunctions().showError(title: "Error", message: error)
      }
    
    
    
    
}
