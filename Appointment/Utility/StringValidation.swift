//
//  StringValidation.swift
//  Resume
//
//  Created by Varun Wadhwa on 19/06/19.
//  Copyright © 2019 VM User. All rights reserved.
//

import Foundation

protocol StringValidation {
    func validate(_ string : String) -> (status : Bool , message : String?) 
}

protocol StringValidator {
    func validate() -> (status : Bool , message : String) 
}

class AtleastOneCapital : StringValidation {
    func validate(_ string: String) -> (status: Bool, message: String?) {
        var message : String?
        let symbolRegex = "((?=.*[A-Z]).{1,})"
        let symbolTest = NSPredicate(format: "SELF MATCHES %@", symbolRegex)
        let status = (symbolTest.evaluate(with: string))
        message = !status ? "one uppercase character" : nil
        return (status,message)
    }
} 

class AtleastOneNumber : StringValidation {
    func validate(_ string: String) -> (status: Bool, message: String?) {
        var message : String?
        let symbolRegex = "((?=.*[0-9]).{1,})"
        let symbolTest = NSPredicate(format: "SELF MATCHES %@", symbolRegex)
        let status = (symbolTest.evaluate(with: string))
        message = !status ? "one number" : nil
        return (status,message)
    }
}    

class MinCharRange : StringValidation {
    func validate(_ string: String) -> (status: Bool, message: String?) {
        var message : String?
        let minCount = 8
        let status = string.count >= minCount
        message = !status ? "8 characters" : nil
        return (status,message)
    }
}

class AtlesatOneSpecialChar : StringValidation {
    func validate(_ string: String) -> (status: Bool, message: String?) {
        var message : String?
        let symbolRegex = "((?=.*[^a-z0-9A-Z]).{1,})"
        let symbolTest = NSPredicate(format: "SELF MATCHES %@", symbolRegex)
        let status = (symbolTest.evaluate(with: string))
        message = !status ? "one special character" : nil
        return (status,message)
    }
}

class AtleastOneLoweredCase : StringValidation {    
    func validate(_ string: String) -> (status: Bool, message: String?) {
        var message : String?
        let symbolRegex = "((?=.*[a-z]).{1,})"
        let symbolTest = NSPredicate(format: "SELF MATCHES %@", symbolRegex)
        let status = (symbolTest.evaluate(with: string))
        message = !status ? "one lowercase character" : nil
        return (status,message)
    }
}

