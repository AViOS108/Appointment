//
//  PasswordValidator.swift
//  Resume
//
//  Created by Varun Wadhwa on 19/06/19.
//  Copyright © 2019 VM User. All rights reserved.
//

import Foundation

class PasswordValidator : StringValidator{
    var password : String?
    private var validations : [StringValidation]
    
    init(password : String , validations : [StringValidation] = []) {
        self.password = password
        self.validations = validations
    }
    
    func validate() -> (status : Bool , message : String) {
        guard let password = self.password else { return (true,StringConstants.emptyPasswordError)}
        guard validations.count == 0 else {
            var status = true
            var errorMsg : [String?] = ["Password should contain at least"]
            for validation in validations {
                let validate = validation.validate(password)
                if !validate.status {
                    errorMsg.append(validate.message)
                    status = false
                }
            }
            
            let message = formatMessage(errorMsg.compactMap({$0}), status: status)
            return (status,message)
        }
        return (true,"")
    }
    
    private func formatMessage(_ messages : [String] , status : Bool) -> String {
        var formattedMsg = String()
        guard !status else { return formattedMsg}
        let errCount = messages.count
        guard errCount > 1 else {return formattedMsg}
        
        //string combine chars
        let singleSpace = " "
        let comma =  "," + singleSpace
        let and = singleSpace + "and" + singleSpace
        let fullStop = "."
        ////
        
        
        if errCount == 2 { //only one error
            formattedMsg = messages.joined(separator: singleSpace)
        } else { //
            formattedMsg = messages[0] + singleSpace + messages[1..<errCount-1].joined(separator: comma) + and + messages[errCount-1] 
        }
        formattedMsg += fullStop
        return formattedMsg
    }
}

