//
//  Network.swift
//  Resume
//
//  Created by VM User on 30/01/17.
//  Copyright © 2017 VM User. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import CoreData

enum ErrorMessages : String{
    case NotConnected = "No connection."
    case RequestTimedOut = "Cannot reach Vmock server."
    case SomethingWentWrong = "Something went wrong please try again."
    case UnAuthorized = "Session Expired."
}

class Network {
    let configuration = URLSessionConfiguration.default
    var alamoFireManager = Alamofire.SessionManager.default
    
    private static var alamoFireManagerEventList : SessionManager = {
        
        var configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 120 // seconds
        configuration.timeoutIntervalForResource = 120
        configuration.httpShouldSetCookies = true
        return Alamofire.SessionManager(configuration: configuration)
    }()
    
    
    
    init() {
        configuration.timeoutIntervalForRequest = 120 // seconds
        configuration.timeoutIntervalForResource = 120
        configuration.httpShouldSetCookies = true
        self.alamoFireManager = Alamofire.SessionManager(configuration: configuration)
    }
    
    
    func stopAllSessions() {
        Network.alamoFireManagerEventList.session.getAllTasks { tasks in
            tasks.forEach { $0.cancel() }
        }
    }
    
    
    func makeApiglobalCompanies(_ addHeader : Bool,url : String,methodType: HTTPMethod ,params : Dictionary<String,AnyObject>,header: Dictionary<String,String>,completion: @escaping (_ parsedJSON: SwiftyJSON.JSON) -> Void , failure : @escaping (_ error: String,_ errorCode: Int) -> Void){
              
           self.stopAllSessions()
                  
        let requestParams = params
                  if(!addHeader){
                    Network.alamoFireManagerEventList.request(url, method: methodType, parameters: requestParams, encoding: URLEncoding.default).responseJSON() {
                          response in
                          switch response.result {
                          case .success:
                              completion(JSON(response.result.value!))
                          case .failure(let error):
                              failure(self.errorMsgFailure(error._code),error._code)
                          }
                      }
                  }else{
                    Network.alamoFireManagerEventList.request(url, method: methodType, parameters: requestParams, encoding: URLEncoding.default,headers: header).responseJSON {
                          response in
                          switch response.result {
                          case .success:
                              let response = JSON(response.result.value!)
                              if self.isErrorPresentInSuccessResponse(response){
                                  if let error = self.getErrorInSuccessResponse(response){
                                      if LogoutHandler.shouldLogout(errorCode: error.code){
                                          LogoutHandler.invalidateCurrentUser()
                                      }
                                      failure(error.message,error.code)
                                  }
                              }
                              else {completion(response)}
                          case .failure(let error):
                              if LogoutHandler.shouldLogout(errorCode: error._code){
                                  LogoutHandler.invalidateCurrentUser()
                              }
                              failure(self.errorMsgFailure(error._code),error._code)
                          }
                      }
                  }
          }
    
    

    
    func makeApiCoachRequest(_ addHeader : Bool,url : String,methodType: HTTPMethod ,params : Dictionary<String,AnyObject>,header: Dictionary<String,String>,completion: @escaping (_ parsedJSON: Data) -> Void , failure : @escaping (_ error: String,_ errorCode: Int) -> Void){
        
     
        let requestParams = params
        if(!addHeader){
         alamoFireManager.request(url, method: methodType, parameters: requestParams, encoding: JSONEncoding.default).responseData{
                response in
                switch response.result {
                case .success:
                 completion(response.data!)
                case .failure(let error):
                    failure(self.errorMsgFailure(error._code),error._code)
                }
            }
        }else{
             alamoFireManager.request(url, method: methodType, parameters: requestParams, encoding: URLEncoding.default,headers: header).responseData {
                response in
                switch response.result {
                case .success:
                    let responseI = JSON(response.result.value!)
                    if self.isErrorPresentInSuccessResponse(responseI){
                        if let error = self.getErrorInSuccessResponse(responseI){
                            if LogoutHandler.shouldLogout(errorCode: error.code){
                                LogoutHandler.invalidateCurrentUser()
                            }
                            failure(error.message,error.code)
                        }
                    }
                    else {
                     
                     completion(response.data!)
                     
                 }
                case .failure(let error):
                    if LogoutHandler.shouldLogout(errorCode: error._code){
                        LogoutHandler.invalidateCurrentUser()
                    }
                    failure(self.errorMsgFailure(error._code),error._code)
                }
            }
        }
    }
    
    
    func makeApiStudentList(_ addHeader : Bool,url : String,methodType: HTTPMethod ,params : Dictionary<String,AnyObject>,header: Dictionary<String,String>,completion: @escaping (_ parsedJSON: Data) -> Void , failure : @escaping (_ error: String,_ errorCode: Int) -> Void){
                 
              
        let requestParams = params
                 if(!addHeader){
                  Network.alamoFireManagerEventList.request(url, method: methodType, parameters: requestParams, encoding: JSONEncoding.default).responseData{
                         response in
                         switch response.result {
                         case .success:
                          completion(response.data!)
                         case .failure(let error):
                             failure(self.errorMsgFailure(error._code),error._code)
                         }
                     }
                 }else{
                      Network.alamoFireManagerEventList.request(url, method: methodType, parameters: requestParams, encoding: JSONEncoding.default,headers: header).responseData {
                         response in
                         switch response.result {
                         case .success:
                             let responseI = JSON(response.result.value!)
                             if self.isErrorPresentInSuccessResponse(responseI){
                                 if let error = self.getErrorInSuccessResponse(responseI){
                                     if LogoutHandler.shouldLogout(errorCode: error.code){
                                         LogoutHandler.invalidateCurrentUser()
                                     }
                                     failure(error.message,error.code)
                                 }
                             }
                             else {
                              
                              completion(response.data!)
                              
                          }
                         case .failure(let error):
                             if LogoutHandler.shouldLogout(errorCode: error._code){
                                 LogoutHandler.invalidateCurrentUser()
                             }
                             failure(self.errorMsgFailure(error._code),error._code)
                         }
                     }
                 }
             }
    
    
    
    
    
    func makeApiEventRequest(_ addHeader : Bool,url : String,methodType: HTTPMethod ,params : Dictionary<String,AnyObject>,header: Dictionary<String,String>,completion: @escaping (_ parsedJSON: Data) -> Void , failure : @escaping (_ error: String,_ errorCode: Int) -> Void){
           
        let requestParams = params
              if(!addHeader){
               alamoFireManager.request(url, method: methodType, parameters: requestParams, encoding: JSONEncoding.default).responseData{
                      response in
                      switch response.result {
                      case .success:
                       completion(response.data!)
                      case .failure(let error):
                          failure(self.errorMsgFailure(error._code),error._code)
                      }
                  }
              }else{
                   alamoFireManager.request(url, method: methodType, parameters: requestParams, encoding: JSONEncoding.default,headers: header).responseData {
                      response in
                       switch response.result {
                      case .success:
                          let responseI = JSON(response.result.value!)
                          if self.isErrorPresentInSuccessResponse(responseI){
                              if let error = self.getErrorInSuccessResponse(responseI){
                                  if LogoutHandler.shouldLogout(errorCode: error.code){
                                      LogoutHandler.invalidateCurrentUser()
                                  }
                                  failure(error.message,error.code)
                              }
                          }
                          else {
                           
                           completion(response.data!)
                           
                       }
                      case .failure(let error):
                          if LogoutHandler.shouldLogout(errorCode: error._code){
                              LogoutHandler.invalidateCurrentUser()
                          }
                          failure(self.errorMsgFailure(error._code),error._code)
                      }
                  }
              }
          }
       
    
    
    func makeApiUploadFile(_ addHeader : Bool,url : String,methodType: HTTPMethod , params : Dictionary<String,AnyObject>,header: Dictionary<String,String>,completion: @escaping (_ parsedJSON: Data) -> Void , failure : @escaping (_ error: String,_ errorCode: Int) -> Void){

        let URL2 = try! URLRequest(url: url, method: .post, headers: ["Authorization" :"Bearer \(UserDefaults.standard.object(forKey: "accessToken")!)"])

        
        var params = params
        
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in

            let paramI = (params["attachments_public"] as! Array<Data>)[0]
            
            multipartFormData.append(paramI , withName: "attachments_public[0]", fileName: "filename", mimeType: "text/plain")
          
            params.removeValue(forKey: "attachments_public")

           
            
            for id in  params["user_purpose_ids"] as! Array<String> {
                
                multipartFormData.append((id as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: "user_purpose_ids[]")
                
            }

            params.removeValue(forKey: "user_purpose_ids")

            
            for (key, value) in params {
                multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
            }
        }, with: URL2 , encodingCompletion: { (result) in

            switch result {
                case .success(let upload, _, _):
                    print("s")
                    upload.responseJSON {
                        response in
                        
                          completion(response.data!)
                        
                        if let JSON = response.result.value as? [String : Any]{
                            _ = JSON["message"] as? String
                             // use the JSON
                            }else {
                               //error hanlding
                            }

                        }
                
            case .failure(let encodingError):
                
                 failure(self.errorMsgFailure(encodingError._code),encodingError._code)
                
                break
                                  // error handling
                               }
                
                    }
               
        );
        
        
    }
    
    
    
    
    
    func makeApiEventGetRequest(_ addHeader : Bool,url : String,methodType: HTTPMethod ,params : Dictionary<String,AnyObject>,header: Dictionary<String,String>,completion: @escaping (_ parsedJSON: Data) -> Void , failure : @escaping (_ error: String,_ errorCode: Int) -> Void){
        
        let requestParams = params
        if(!addHeader){
         alamoFireManager.request(url, method: methodType, parameters: requestParams, encoding: URLEncoding.default).responseData{
                response in
                switch response.result {
                case .success:
                 completion(response.data!)
                case .failure(let error):
                    failure(self.errorMsgFailure(error._code),error._code)
                }
            }
        }else{
            alamoFireManager.request(url, method: methodType, parameters: requestParams, encoding: URLEncoding.default,headers: header).responseData {
                response in
                switch response.result {
                case .success:
                    let responseI = JSON(response.result.value!)
                    if self.isErrorPresentInSuccessResponse(responseI){
                        if let error = self.getErrorInSuccessResponse(responseI){
                            if LogoutHandler.shouldLogout(errorCode: error.code){
                                LogoutHandler.invalidateCurrentUser()
                            }
                            failure(error.message,error.code)
                        }
                    }
                    else {
                     
                     completion(response.data!)
                     
                 }
                case .failure(let error):
                    if LogoutHandler.shouldLogout(errorCode: error._code){
                        LogoutHandler.invalidateCurrentUser()
                    }
                    failure(self.errorMsgFailure(error._code),error._code)
                }
            }
        }
    }
    
    
    func makeApiDownloadFile(_ addHeader : Bool,url : String,methodType: HTTPMethod ,params : Dictionary<String,AnyObject>,header: Dictionary<String,String>,completion: @escaping (_ parsedJSON: Dictionary<String,Any>) -> Void , failure : @escaping (_ error: String,_ errorCode: Int) -> Void){
        
        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
            var documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            // the name of the file here I kept is yourFileName with appended extension
               documentsURL.appendPathComponent("yourFileName"+".pdf")
               return (documentsURL, [.removePreviousFile])
        }
        if(!addHeader){
            
            Alamofire.download(url, to: destination).response { response in
                
                let responseDict =          ["destinationUrl":response.destinationURL,
                                "tempUrl": response.temporaryURL]
                
                completion(responseDict as Dictionary<String, Any>)
            }
        }else{
            Alamofire.download(url, to: destination).response { response in
                print(response)
            }
        }
    }
    
    
    
    func makeApiRequest(_ addHeader : Bool,url : String,methodType: HTTPMethod ,params : Dictionary<String,AnyObject>,header: Dictionary<String,String>,completion: @escaping (_ parsedJSON: SwiftyJSON.JSON) -> Void , failure : @escaping (_ error: String,_ errorCode: Int) -> Void){
        
        let requestParams = params
        if(!addHeader){
            alamoFireManager.request(url, method: methodType, parameters: requestParams, encoding: URLEncoding.default).responseJSON() {
                response in
                switch response.result {
                case .success:
                    completion(JSON(response.result.value!))
                case .failure(let error):
                    failure(self.errorMsgFailure(error._code),error._code)
                }
            }
        }else{
            alamoFireManager.request(url, method: methodType, parameters: requestParams, encoding: URLEncoding.default,headers: header).responseJSON {
                response in
                switch response.result {
                case .success:
                    let response = JSON(response.result.value!)
                    if self.isErrorPresentInSuccessResponse(response){
                        if let error = self.getErrorInSuccessResponse(response){
                            if LogoutHandler.shouldLogout(errorCode: error.code){
                                LogoutHandler.invalidateCurrentUser()
                            }
                            failure(error.message,error.code)
                        }
                    }
                    else {completion(response)}
                case .failure(let error):
                    if LogoutHandler.shouldLogout(errorCode: error._code){
                        LogoutHandler.invalidateCurrentUser()
                    }
                    failure(self.errorMsgFailure(error._code),error._code)
                }
            }
        }
    }
    
    func makeApiRequestJsonEncoded(_ addHeader : Bool,url : String,methodType: HTTPMethod ,params : Dictionary<String,AnyObject>,header: Dictionary<String,String>,completion: @escaping (_ parsedJSON: SwiftyJSON.JSON) -> Void , failure : @escaping (_ error: String,_ errorCode: Int) -> Void){
        
        let requestParams = params
        if(!addHeader){
            alamoFireManager.request(url, method: methodType, parameters: requestParams, encoding: URLEncoding.default).responseJSON() {
                response in
                switch response.result {
                case .success:
                    completion(JSON(response.result.value!))
                case .failure(let error):
                    failure(self.errorMsgFailure(error._code),error._code)
                }
            }
        }else{
            
            
            
            alamoFireManager.request(url, method: methodType, parameters: requestParams, encoding: JSONEncoding.default,headers: header).responseJSON {
                response in
                switch response.result {
                case .success:
                    let response = JSON(response.result.value!)
                    if self.isErrorPresentInSuccessResponse(response){
                        if let error = self.getErrorInSuccessResponse(response){
                            if LogoutHandler.shouldLogout(errorCode: error.code){
                                LogoutHandler.invalidateCurrentUser()
                            }
                            failure(error.message,error.code)
                        }
                    }
                    else {completion(response)}
                case .failure(let error):
                    if LogoutHandler.shouldLogout(errorCode: error._code){
                        LogoutHandler.invalidateCurrentUser()
                    }
                    failure(self.errorMsgFailure(error._code),error._code)
                }
            }
        }
    }
    
    
    
    
    
    
    func makeThirdPartyApiRequest(_ addHeader : Bool,url : String,methodType: HTTPMethod ,params : Dictionary<String,AnyObject>,header: Dictionary<String,String>,completion: @escaping (_ parsedJSON: SwiftyJSON.JSON) -> Void , failure : @escaping (_ error: String,_ errorCode: Int) -> Void){
        let requestParams = params
        if(!addHeader){
            alamoFireManager.request(url, method: methodType, parameters: requestParams, encoding: URLEncoding.default).responseJSON() {
                response in
                switch response.result {
                case .success:
                    completion(JSON(response.result.value!))
                case .failure(let error):
                    failure(self.errorMsgFailure(error._code),error._code)
                }
            }
        }else{
            alamoFireManager.request(url, method: methodType, parameters: requestParams, encoding: URLEncoding.default,headers: header).responseJSON {
                response in
                switch response.result {
                case .success:
                    let response = JSON(response.result.value!)
                    if self.isErrorPresentInSuccessResponse(response){
                        if let error = self.getErrorInSuccessResponse(response){
                            failure(error.message,error.code)
                        }
                    }
                    else {completion(response)}
                case .failure(let error):
                    failure(self.errorMsgFailure(error._code),error._code)
                }
            }
        }
    }
    
    func makeApiRequestJSONEncoded(_ addHeader : Bool,url : String,methodType: HTTPMethod ,params : Dictionary<String,AnyObject>,header: Dictionary<String,String>,completion: @escaping (_ parsedJSON: SwiftyJSON.JSON) -> Void , failure : @escaping (_ error: String,_ errorCode: Int) -> Void){
        let requestParams = params
        if(!addHeader){
            alamoFireManager.request(url, method: methodType, parameters: requestParams, encoding: JSONEncoding.default).responseJSON() {
                response in
                switch response.result {
                case .success:
                    let response = JSON(response.result.value!)
                    if self.isErrorPresentInSuccessResponse(response){
                        if let error = self.getErrorInSuccessResponse(response){
                            if LogoutHandler.shouldLogout(errorCode: error.code){
                                LogoutHandler.invalidateCurrentUser()
                            }
                            failure(error.message,error.code)
                        }
                    }
                    else {completion(response)}
                case .failure(let error):
                    if LogoutHandler.shouldLogout(errorCode: error._code){
                        LogoutHandler.invalidateCurrentUser()
                    }
                    failure(self.errorMsgFailure(error._code),error._code)
                }
            }
        }else{
            alamoFireManager.request(url, method: methodType, parameters: requestParams, encoding: JSONEncoding.default,headers: header).responseJSON {
                response in
                switch response.result {
                case .success:
                    let response = JSON(response.result.value!)
                    if self.isErrorPresentInSuccessResponse(response){
                        if let error = self.getErrorInSuccessResponse(response){
                            if LogoutHandler.shouldLogout(errorCode: error.code){
                                LogoutHandler.invalidateCurrentUser()
                            }
                            failure(error.message,error.code)
                        }
                    }
                    else {completion(response)}
                case .failure(let error):
                    if LogoutHandler.shouldLogout(errorCode: error._code){
                        LogoutHandler.invalidateCurrentUser()
                    }
                    failure(self.errorMsgFailure(error._code),error._code)
                }
            }
        }
    }
    
    func makeApiRequestJSONEncodedERLOGIN(_ addHeader : Bool,url : String,methodType: HTTPMethod ,params : Dictionary<String,AnyObject>,header: Dictionary<String,String>,completion: @escaping (_ parsedJSON: SwiftyJSON.JSON) -> Void , failure : @escaping (_ error: String,_ errorCode: Int) -> Void){
        let requestParams = params
         if(!addHeader){
             alamoFireManager.request(url, method: methodType, parameters: requestParams, encoding: JSONEncoding.default).responseJSON() {
                 response in
                 switch response.result {
                 case .success:
                     let response = JSON(response.result.value!)
                     completion(response)
                    
                 case .failure(let error):
                     if LogoutHandler.shouldLogout(errorCode: error._code){
                         LogoutHandler.invalidateCurrentUser()
                     }
                     failure(self.errorMsgFailure(error._code),error._code)
                 }
             }
         }else{
             alamoFireManager.request(url, method: methodType, parameters: requestParams, encoding: JSONEncoding.default,headers: header).responseJSON {
                 response in
                 switch response.result {
                 case .success:
                    for cookie in HTTPCookieStorage.shared.cookies! {
                        if cookie.name == "vmock_cmc_access_token_test" || cookie.name == "vmock_cmc_access_token_staging" || cookie.name == "vmock_cmc_access_token_live" {
                            UserDefaultsDataSource(key: "accessToken").writeData(cookie.value)
                            print(cookie.value);
                        }
                        
                    }
                    
                    let response = JSON(response.result.value!)
                    
//                     if self.isErrorPresentInSuccessResponse(response){
//                         if let error = self.getErrorInSuccessResponse(response){
//                             if LogoutHandler.shouldLogout(errorCode: error.code){
//                                 LogoutHandler.invalidateCurrentUser()
//                             }
//                             failure(error.message,error.code)
//                         }
//                     }
//                     else {
                    completion(response)
                 case .failure(let error):
                     if LogoutHandler.shouldLogout(errorCode: error._code){
                         LogoutHandler.invalidateCurrentUser()
                     }
                     failure(self.errorMsgFailure(error._code),error._code)
                 }
             }
         }
     }
    
    
    
    
    
    
    func makeUploadRequestApi(url : String ,multipartFormData: @escaping (MultipartFormData) -> Void ,params : Dictionary<String,String>,header: Dictionary<String,String>,completion: @escaping (_ parsedJSON: SwiftyJSON.JSON) -> Void , failure : @escaping (_ error: String,_ errorCode: Int) -> Void , progress : @escaping (Int)->Void  ){
        
        Alamofire.upload(multipartFormData: { multipartFormDataInternal in
            multipartFormData(multipartFormDataInternal)
        }, to: url,
           headers : header,
           encodingCompletion: { encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.uploadProgress(closure: { (progressCompleted) in
                    let value = Int(progressCompleted.fractionCompleted * 100)
                    progress(value)
                })
                upload.responseJSON{ response in
                    switch response.result {
                    case .success:
                        let response = JSON(response.result.value!)
                        if self.isErrorPresentInSuccessResponse(response){
                            if let error = self.getErrorInSuccessResponse(response){
                                failure(error.message,error.code)
                            }
                        }
                        else {completion(response)}
                    case .failure(let error):
                        if LogoutHandler.shouldLogout(errorCode: error._code){
                            LogoutHandler.invalidateCurrentUser()
                        }
                        failure(self.errorMsgFailure(error._code),error._code)
                    }
                }
            case .failure(let error):
                if LogoutHandler.shouldLogout(errorCode: error._code){
                    LogoutHandler.invalidateCurrentUser()
                }
                failure(self.errorMsgFailure(error._code),error._code)
            }
        })
    }
    
    func makeApiRequestForHTMLResponse(_ addHeader : Bool,url : String,methodType: HTTPMethod ,params : Dictionary<String,AnyObject>,header: Dictionary<String,String>,completion: @escaping (_ parsedJSON: SwiftyJSON.JSON) -> Void , failure : @escaping (_ error: String,_ errorCode: Int) -> Void){
        if(!addHeader){
            alamoFireManager.request(url, method: methodType, parameters: params, encoding: URLEncoding.default).responseString() {
                response in
                switch response.result {
                case .success:
                    let response = JSON(parseJSON: response.result.value!)
                    if self.isErrorPresentInSuccessResponse(response){
                        if let error = self.getErrorInSuccessResponse(response){
                            if LogoutHandler.shouldLogout(errorCode: error.code){
                                LogoutHandler.invalidateCurrentUser()
                            }
                            failure(error.message,error.code)
                        }
                    }
                    else {completion(response)}
                case .failure(let error):
                    if LogoutHandler.shouldLogout(errorCode: error._code){
                        LogoutHandler.invalidateCurrentUser()
                    }
                    failure(self.errorMsgFailure(error._code),error._code)
                }
            }
        }else{
            alamoFireManager.request(url, method: methodType, parameters: params, encoding: URLEncoding.default,headers: header).responseString() {
                response in
                
                switch response.result {
                case .success:
                    let response = JSON(response.result.value!)
                    if self.isErrorPresentInSuccessResponse(response){
                        if let error = self.getErrorInSuccessResponse(response){
                            if LogoutHandler.shouldLogout(errorCode: error.code){
                                LogoutHandler.invalidateCurrentUser()
                            }
                            failure(error.message,error.code)
                        }
                    }
                    else {completion(response)}
                case .failure(let error):
                    if LogoutHandler.shouldLogout(errorCode: error._code){
                        LogoutHandler.invalidateCurrentUser()
                    }
                    failure(self.errorMsgFailure(error._code),error._code)
                }
            }
        }
    }

    static func cancelAllRequests() {
        Alamofire.SessionManager.default.session.getAllTasks(completionHandler: { tasks in
            for task in tasks {
                task.cancel()
            }
        })
    }

    func isErrorPresentInSuccessResponse( _ response:SwiftyJSON.JSON) -> Bool {
        if response["error"]["code"] != JSON.null{
            return true
        }
        return false
    }
    
    func getErrorInSuccessResponse( _ response:SwiftyJSON.JSON) -> (message : String, code : Int)?{
        // If has error then return error tuple only if it needs to be shown. Otherwise handle here
        let code = response["error"]["code"].int!
        return (self.errorMsg(code,response: response),code)
    }
    
    func errorMsg(_ statusCode : Int,response: SwiftyJSON.JSON) -> (String){
        if(statusCode == -1009) || (statusCode == -1018){
            return ErrorMessages.NotConnected.rawValue
        }
        else if(statusCode == -1001){
            return ErrorMessages.RequestTimedOut.rawValue
        }
        if(statusCode == 401){
            return ErrorMessages.UnAuthorized.rawValue
        }else {
            var message = ""
            if response["error"]["errors"] != JSON.null {
                if let keys = response["error"]["errors"].dictionary?.keys{
                    if let object = response["error"]["errors"][keys.first!].string {
                        message = object
                    }
                    else if let object = response["error"]["errors"][keys.first!].array ,object.count > 0 {
                        message = object[0].string!
                    }                    
                }else{
                    if let object = response["error"]["errors"][0].string {
                        message = object
                    }
                }
            }else{
                message = response["error"]["message"].string!
            }
            return message
        }
    }
    
    
    
    
    
    
    func errorMsgFailure(_ statusCode : Int) -> (String){
        if(statusCode == -1009) || (statusCode == -1018){
            return ErrorMessages.NotConnected.rawValue
        }
        else if(statusCode == -1001){
            return ErrorMessages.RequestTimedOut.rawValue
        }
        if(statusCode == 401){
            return ErrorMessages.UnAuthorized.rawValue
        }else {
            return ErrorMessages.SomethingWentWrong.rawValue
        }
    }
    
    func handleErrorCases(error: String) -> String{
        var errorMessage = error
        var authError = false
        if error == "USER_OAUTH_INVALID_EMAIL"{
            errorMessage = "Please grant permission to your email address. It is required to create your account."
            authError = true
        }else if error == "USER_AUTHENTICATED"{
            errorMessage = "You are already logged in!"
            authError = true
        }else if error == "USER_OAUTH_ERROR"{
            errorMessage = "Session expired. Please try again."
            authError = true
        }else if error == "FIREWALL_COUNTRY_BLOCK"{
            errorMessage = "Our services are not available in this region. In case you have any queries, please contact us."
            authError = true
        }        
        if authError{
            let cookieStorage = HTTPCookieStorage.shared
            for each: HTTPCookie in cookieStorage.cookies! {
                cookieStorage.deleteCookie(each)
            }
        }
        
        return errorMessage
    }
}
