//
//  ErrorView.swift
//  Resume
//
//  Created by apple on 03/04/17.
//  Copyright © 2017 VM User. All rights reserved.
//

import UIKit

enum ErrorFor {
    case home
    case systemFeedback
}


class ErrorView: UIView {

    var completionHandler : (()->Void)?
    var errorFor : ErrorFor?
    @IBOutlet weak var errorLabel: UILabel!
    var errorCode : Int = 0
    
    func setupView() -> Void {
        
        guard let errorFor = errorFor else {
            return
        }
        var image : UIImage?
        var title : String?
        
        switch errorCode {
        case -1001:
            errorLabel.text = "Something went wrong please retry"
        case -1009:
            errorLabel.text = "No connection"
        case -1005:
            errorLabel.text = "Internet connection lost"
        default:
            errorLabel.text = "No connection"
        }
    }
    
    class func canShowForErrorCode(_ errorCode : Int) -> Bool{
        switch errorCode {
        case -1001, -1009, -1005:
            return true
        default:
            return false
        }
    }
    
    class func showOnView(_ view : UIView, forErrorOn type : ErrorFor? , errorCode : Int, completion : (()->Void)?) ->ErrorView?{
        if let errorView  = Bundle.main.loadNibNamed("ErrorView", owner: self, options: nil)?.first as? ErrorView{
            errorView.completionHandler = completion
            errorView.errorFor = type
            errorView.errorCode = errorCode
            
            view.addSubview(errorView, withInsetConstraints: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
            return errorView
        }
        return nil
    }
    
    @IBAction func retryButtonAction(_ sender: Any) {
        self.removeFromSuperview()
        if let completionHandler = completionHandler{
            completionHandler()
        }
    }
}
