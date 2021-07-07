//
//  LoginService.swift
//  Resume
//
//  Created by VM User on 30/01/17.
//  Copyright © 2017 VM User. All rights reserved.
//

import Foundation
import SwiftyJSON

struct LoginError {
    var errorMessage : String
    var errorCode : Int
    var captchaRequired : Bool?
}

class LoginService{
    
    func loginCall(headerIncluded: Bool,params: Dictionary<String, AnyObject>,header:  Dictionary<String, String>,_ success :@escaping (JSON) -> Void,failure :@escaping (LoginError) -> Void ){
        var params = params
        params["expiry"] = "10080" as AnyObject?
        Network().makeApiRequest(headerIncluded, url: Urls().login(), methodType: .post, params: params, header: header, completion: {
            response in
            if response["error"]["code"] != JSON.null{
                let errCode = response["error"]["code"].int!
                if response["error"]["errors"] != JSON.null {
                    if let errorDict = response["error"]["errors"].dictionary {
                        var errorDictTemp = errorDict
                        var captchaRequired = errorDictTemp["requiresCaptcha"]?.bool
                        errorDictTemp.removeValue(forKey: "requiresCaptcha")
                            if let firstItem = errorDictTemp.first , let errMsg = firstItem.value.string {
                                if firstItem.key.lowercased().contains("captcha") {
                                    captchaRequired = true
                                }
                                failure(LoginError(errorMessage: errMsg, errorCode: errCode, captchaRequired: captchaRequired))
                            }
                            else if let firstItem = errorDictTemp.first , let object = firstItem.value.array , object.count > 0 {
                                if firstItem.key.lowercased().contains("captcha") {
                                    captchaRequired = true
                                }
                                failure(LoginError(errorMessage: object[0].string!, errorCode: errCode, captchaRequired: captchaRequired))
                            }
                    }
                }else{
                    let errMsg = response["error"]["message"].string!
                    failure(LoginError.init(errorMessage: errMsg, errorCode: errCode, captchaRequired: nil))
                }
            }else{
                
                UserDefaultsDataSource(key: "csrf_token").writeData(response["csrf_token"].string!)
                UserDefaultsDataSource(key: "accessToken").writeData(response["access_token"].string!)

                UserDefaultsDataSource(key: "nfRequestedFromSF").writeData(false)
                success(response)
            }
        }) { (error,errorCode) in
                let errMsg = Network().handleErrorCases(error: error)
                let errCode = errorCode
                failure(LoginError.init(errorMessage: errMsg, errorCode: errCode, captchaRequired: nil))
        }
    }
    
    
    func getUserInfo(_ success :@escaping (JSON) -> Void,failure :@escaping (String,Int) -> Void ){
        guard let token = UserDefaultsDataSource(key: "accessToken").readData() else{
            failure("yaba",105)
            return
        }
        let headers: Dictionary<String,String> = ["Authorization": "Bearer \(token)"]
        Network().makeApiRequest(true, url: Urls().getUserInfo(), methodType: .post, params: ["":"" as AnyObject], header: headers, completion: {
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
                UserDefaultsDataSource(key: "resumeUpperCutoff").writeData(response["resumeCutoff"].int)
                UserDefaultsDataSource(key: "userId").writeData(response["id"].int)
                UserDefaultsDataSource(key: "resumeLowerCutoff").writeData(response["resumeRedCutoff"].int)
                UserDefaultsDataSource(key: "isResumeCalledCv").writeData(response["isResumeCalledCv"].bool)
                var isPremium = (UserDefaultsDataSource(key: "isPremium").readData() as? Bool) ?? false
                
//                if let _ = UserDefaultsDataSource(key: "userEmail").readData() as? String , let newPremium = response["isPremium"].bool , newPremium != isPremium, let
//
//                    resumeIds = ResumeServices().getResumesId(), resumeIds.count > 0 {
//                    for resumeId in resumeIds {
//                        CommonFunctions().deleteFilesForResumeId(resumeId: resumeId)
//                    }
//                }
                SubscriptionType.set(value: response["isPremium"].bool)
                UserDefaultsDataSource(key: "canPay").writeData(response["canPay"].bool)
                UserDefaultsDataSource(key: "canRefer").writeData(response["canRefer"].bool)
                UserDefaultsDataSource(key: "userEmail").writeData(response["email"].string)
                UserDefaultsDataSource(key: "firstName").writeData(response["firstName"].string?.trimmingCharacters(in: .whitespaces))
                UserDefaultsDataSource(key: "communityLogo").writeData(response["logo"].string)
                UserDefaultsDataSource(key: "userProfile").writeData(response["picture"].string)
                UserDefaultsDataSource(key: "lastName").writeData(response["lastName"].string?.trimmingCharacters(in: .whitespaces))
                UserDefaultsDataSource(key: "benchmark").writeData(response["benchmark"].string)
                UserDefaultsDataSource(key: "community").writeData(response["community"].string)
                UserDefaultsDataSource(key: "communityName").writeData(response["communityName"].string)
                UserDefaultsDataSource(key: "link").writeData(response["community"].string)
                 
                success(response)
            }
        },failure:{ (error,errorCode) in
            failure(Network().handleErrorCases(error: error),errorCode)
        })
    }
    
    
    func getUserInfoER(_ success :@escaping (JSON) -> Void,failure :@escaping (String,Int) -> Void ){
        guard let token = UserDefaultsDataSource(key: "accessToken").readData() else{
            failure("yaba",105)
            return
        }
        let headers: Dictionary<String,String> = ["Authorization": "Bearer \(token)"]
        Network().makeApiRequest(true, url: Urls().updateProfileNew(), methodType: .get, params: ["":"" as AnyObject], header: headers, completion: {
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
                
                UserDefaultsDataSource(key: "userEmail").writeData(response["email"].string)

                UserDefaultsDataSource(key: "firstName").writeData(response["name"].string?.trimmingCharacters(in: .whitespaces))
                UserDefaultsDataSource(key: "userProfile").writeData(response["profile_pic_url"].string )
                 
                success(response)
            }
        },failure:{ (error,errorCode) in
            failure(Network().handleErrorCases(error: error),errorCode)
        })
    }
    
    
    func getCustomizations(_ success :@escaping (JSON) -> Void,failure :@escaping (String,Int) -> Void ){
        guard let token = UserDefaultsDataSource(key: "accessToken").readData() else {
            failure("yaba",105)
            return
        }
        let headers: Dictionary<String,String> = ["Authorization": "Bearer \(token)"]
        Network().makeApiRequest(true, url: Urls().getCustomizationUrl(), methodType: .get, params: ["":"" as AnyObject], header: headers, completion: {
            response in
            
            if response["error"]["code"] != JSON.null{
                failure(response["error"]["message"].string!,response["error"]["code"].int!)
            }else{
                if response["threshold_score_to_request_feedback"].exists()
                {
                    UserDefaultsDataSource(key: "thresholdScore").writeData(response["threshold_score_to_request_feedback"].int ?? 0 + 1)
                }else{
                    UserDefaultsDataSource(key: "thresholdScore").writeData(0)
                }
                if let detailsRequired = response["are_user_details_required"].int,detailsRequired == 1{
                     UserDefaultsDataSource(key: "areDetailsRequired").writeData(true)
                }else{
                    UserDefaultsDataSource(key: "areDetailsRequired").writeData(false)
                }
                
                var resumeSurveyEnable = false;
                
                if let resumeSurveyEnabled = response["is_resume_survey_enabled"].int,resumeSurveyEnabled == 1{
                    UserDefaultsDataSource(key: "resumeSurveyEnabled").writeData(true)
                    resumeSurveyEnable = true;
                    
                }else{
                    UserDefaultsDataSource(key: "resumeSurveyEnabled").writeData(false)
                    resumeSurveyEnable = false;

                }
                
                
                if let nfDisabled = response["network_feedback_disabled"].int , nfDisabled == 0 {
                    UserDefaultsDataSource(key: "isNfEnabled").writeData(true)
                }
                if let requestFeedbackExternalOff = response["request_feedback_external_off"].int, requestFeedbackExternalOff == 1{
                    UserDefaultsDataSource(key: "requestFeedbackExternalOff").writeData(true)
                }
                if let requestFeedbackOtherCoachesOff = response["request_feedback_other_coaches_off"].int, requestFeedbackOtherCoachesOff == 1{
                    UserDefaultsDataSource(key: "requestFeedbackOtherCoachesOff").writeData(true)
                }
                if let nfFeedbackText = response["nf_feedback_text"].string {
                    UserDefaultsDataSource(key: "nfFeedbackText").writeData(nfFeedbackText)
                }
                if let iosResumeVersion = response["ios_resume_version"].string {
                    UserDefaultsDataSource(key: "ios_resume_version").writeData(iosResumeVersion)
                }
                if let iosResumeMinVersion = response["ios_resume_minimum_version"].string {
                    UserDefaultsDataSource(key: "iosResumeMinimumVersion").writeData(iosResumeMinVersion)
                }
                
                success(response)

                
                if resumeSurveyEnable
                {
//                    self.carrerPreferncesAnswer(success, response1: response);
                }
                else
                {
//                    success(response)

                }
                
            }
        },failure:{ (error,errorCode) in
            failure(Network().handleErrorCases(error: error),errorCode)
        })
    }
    
//    func carrerPreferncesAnswer(_ success :@escaping (JSON) -> Void,response1 : JSON)  {
//        let token = UserDefaultsDataSource(key: "accessToken").readData()
//        let headers: Dictionary<String,String> = ["Authorization": "Bearer \(token ?? "")"]
//        Network().makeApiRequest(true, url:  Urls().studentSurveyAnswer(), methodType: .get, params: ["":"" as AnyObject], header: headers, completion: {  response in
//
//            if response.count == 0
//            {
//                UserDefaultsDataSource(key: "alreadyAnswered").writeData(false)
//
//            }
//            else
//            {
//                UserDefaultsDataSource(key: "alreadyAnswered").writeData(true)
//
//            }
//
//            success(response1)
//
//
//        }) { (error,errorCode) in
//
//        }
//
//
//    }
    
    
    func sync(_ success :@escaping (JSON) -> Void,failure :@escaping (String,Int) -> Void ) {
        let token = UserDefaultsDataSource(key: "accessToken").readData() as! String
        let headers: Dictionary<String,String> = ["Authorization": "Bearer \(token)"]
        Network().makeApiRequest(true, url: Urls().sync(), methodType: .post, params: ["":"" as AnyObject], header: headers, completion: {
            response in
            if response["error"]["code"] != JSON.null{
                failure(response["error"]["message"].string!,response["error"]["code"].int!)
            }else{
                success(response)
            }
        },failure:{ (error,errorCode) in
            failure(Network().handleErrorCases(error: error),errorCode)
        })
    }
    
    func agreement(_ success :@escaping (JSON) -> Void,failure :@escaping (String,Int) -> Void ) {
        let token = UserDefaultsDataSource(key: "accessToken").readData() as! String
        let headers: Dictionary<String,String> = ["Authorization": "Bearer \(token)"]
        Network().makeApiRequest(true, url: Urls().agreement(), methodType: .get, params: ["":"" as AnyObject], header: headers, completion: {
            response in
            if response["error"]["code"] != JSON.null{
                failure(response["error"]["message"].string!,response["error"]["code"].int!)
            }else{
                success(response)
            }
        },failure:{ (error,errorCode) in
            failure(Network().handleErrorCases(error: error),errorCode)
        })
    }
    
}
