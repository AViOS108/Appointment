//
//  ERLoginViewController.swift
//  Event
//
//  Created by Anurag Bhakuni on 28/01/20.
//  Copyright © 2020 Anurag Bhakuni. All rights reserved.
//

import UIKit
import SwiftyJSON

enum viewType {
    case onlyEmail
    case emailWithPwd
    case emailwithCaptcha
    case all
}



class ERLoginViewController: UIViewController {
    
    @IBOutlet weak var nslayoutCentreToMOve: NSLayoutConstraint!
    @IBOutlet weak var btnBack: UIButton!
    @IBAction func btnBackTapped(_ sender: Any) {
        
        if viewTypeEr == .onlyEmail{
            self.dismiss(animated: false) {
                
            }
        }
        else{
            self.navigationController?.popToRootViewController(animated: false)

        }
         
        
    }
    
    var activityIndicator: ActivityIndicatorView?

    @IBOutlet weak var txtFieldEmail: LeftPaddedTextField!
    @IBOutlet weak var emailContainerView: UIView!
    @IBOutlet weak var passwordContainerView: UIView!
    var captchaRequired : Bool = false
    
    var captchaId : String?
    var captchaToken : String?
    var captchaImageURL : String?
    
   @IBOutlet weak var nslayoutConstarintCaptchTop: NSLayoutConstraint!
    
    @IBOutlet weak var nslayoutConstarintCaptchBelow: NSLayoutConstraint!
    
    @IBOutlet weak var txtFieldPwd: CustomUITextField!
    @IBOutlet weak var imgViewCaptcha: UIImageView!
    @IBOutlet weak var nslayoutConstarintPwdHeight: NSLayoutConstraint!
    @IBOutlet weak var btnShowPwd: UIButton!
    @IBOutlet var txtFieldCode: UITextField!
    
    
    
    var viewTypeEr : viewType!;
    var email : String?;
    
    @IBAction func btnShowPwdTapped(_ sender: UIButton) {
        if sender.titleLabel?.text == "SHOW"{
            txtFieldPwd.isSecureTextEntry = false
            sender.setTitle("HIDE", for: .normal)
        }else if sender.titleLabel?.text == "HIDE"{
            txtFieldPwd.isSecureTextEntry = true
            sender.setTitle("SHOW", for: .normal)
        }
    }
    
    
    
    func validation() -> Bool {
        
        switch viewTypeEr {
        case .onlyEmail:
//            self.activeField!.resignFirstResponder()
            txtFieldEmail.text = txtFieldEmail.text?.trimmingCharacters(in: .whitespaces)
            if txtFieldEmail.text == "" {
                CommonFunctions().showError(title: "Error", message: StringConstants.emptyEmailError)
                emailContainerView.shake()
                return false

            }else if !(txtFieldEmail.text?.isvalidEmailId())!{
                CommonFunctions().showError(title: "Error", message: StringConstants.invalidEmailError)
                emailContainerView.shake()
                return false
            }
            break
        case .emailWithPwd:
            
//            self.activeField!.resignFirstResponder()
            txtFieldEmail.text = txtFieldEmail.text?.trimmingCharacters(in: .whitespaces)
            if txtFieldEmail.text == "" {
                CommonFunctions().showError(title: "Error", message: StringConstants.emptyEmailError)
                emailContainerView.shake()
                return false
            }else if !(txtFieldEmail.text?.isvalidEmailId())!{
                CommonFunctions().showError(title: "Error", message: StringConstants.invalidEmailError)
                emailContainerView.shake()
                return false
            }
            
            let validStatus = txtFieldPwd.text!.isValidPasword()

            if txtFieldPwd.text == "" {
                CommonFunctions().showError(title: "Error", message: StringConstants.emptyPasswordError)
                passwordContainerView.shake()
                return false
            }
                
            else if !(validStatus.status){
                CommonFunctions().showError(title: "Error", message: StringConstants.invalidPasswordError)
                passwordContainerView.shake()
                return false
            }
            
            break
        case .all:
            
//            self.activeField!.resignFirstResponder()
                      txtFieldEmail.text = txtFieldEmail.text?.trimmingCharacters(in: .whitespaces)
                      if txtFieldEmail.text == "" {
                          CommonFunctions().showError(title: "Error", message: StringConstants.emptyEmailError)
                          emailContainerView.shake()
                          return false
                      }else if !(txtFieldEmail.text?.isvalidEmailId())!{
                          CommonFunctions().showError(title: "Error", message: StringConstants.invalidEmailError)
                          emailContainerView.shake()
                          return false
                      }
                      
                      let validStatus = txtFieldPwd.text!.isValidPasword()

                      if txtFieldPwd.text == "" {
                          CommonFunctions().showError(title: "Error", message: StringConstants.emptyPasswordError)
                          passwordContainerView.shake()
                          return false
                      }
                      else if !(validStatus.status){
                          CommonFunctions().showError(title: "Error", message: StringConstants.invalidPasswordError)
                          passwordContainerView.shake()
                          return false
                      }
                    if txtFieldCode.text == "" {
                          CommonFunctions().showError(title: "Error", message: StringConstants.emptyCaptchaError)
//                          passwordContainerView.shake()
                          return false
                      }
            break
        default:
            break
        }
        return true
    }
    
    
    
    func loginApi()  {
        let param = ["": ""]
        activityIndicator = ActivityIndicatorView.showActivity(view: self.navigationController!.view, message: StringConstants.userInfoApiLoader)

        
        ErEventService().erAuthLogin(params: param as Dictionary<String, AnyObject>, { (response) in
            do {
                let de = JSONDecoder()
                let modalEventI = try de.decode(EventErLoginModal.self, from: response)
                
                if  let Managementaccess = modalEventI.permissions?.event_management_access ,
                    let eventaccess = modalEventI.permissions?.event_management_events_access{
                    if Managementaccess && eventaccess{
                        UserDefaultsDataSource(key: "loggedIn").writeData(true)
                        AppDataSync.shared.beginTimer()
                        
                        UserDefaultsDataSource(key: "userEmail").writeData(modalEventI.email)
                        UserDefaultsDataSource(key: "firstName").writeData(modalEventI.name?.trimmingCharacters(in: .whitespaces))
                        UserDefaultsDataSource(key: "userProfile").writeData(modalEventI.picture)
                        UserDefaultsDataSource(key: "lastName").writeData("")
                        
                        (UIApplication.shared.delegate as? AppDelegate)?.checkLoginState()
                    }
                    else{
                        CommonFunctions().showError(title: "Error", message: StringConstants.notAvailableForCommunityText);
                    }

                }
                else{
                   CommonFunctions().showError(title: "Error", message: StringConstants.notAvailableForCommunityText);
                }

                print(modalEventI)
            }
            catch {
                print(error)
            }
        }) { (error, errorCode) in
       
        
        }
        
        
        
    }
    
    
    
    
    
    @IBAction func btnSignTapped(_ sender: Any) {
        
              self.nslayoutCentreToMOve.constant = -150;
              self.view.layoutIfNeeded()
        
        if ( GeneralUtility.reachablity())
        {
            if !self.validation(){
                return;
            }
            switch viewTypeEr {
            case .onlyEmail:
                let param = ["email": txtFieldEmail.text]
                 activityIndicator = ActivityIndicatorView.showActivity(view: self.navigationController!.view, message: StringConstants.checkEmailStatusApiLoader)
                ErEventService().erChallengesApi(params: param as Dictionary<String, AnyObject>, { (response) in
                    self.activityIndicator?.hide()
                    if GeneralUtility.optionalHandling(_param: response[ParamName.PARAMERLOGINCAPTCHACHALLENGEATTEMPTCHALLLENGES][ParamName.PARAMERLOGINCAPTCHACHALLENGEACCOUNTUNLOCK][ParamName.PARAMERLOGINCAPTCHACHALLENGEATTEMPTLEFT].int, _returnType: Int.self)  > 0
                    {
                         let vc = ERLoginViewController.init(nibName: "ERLoginViewController", bundle: nil);
                        if let  dicCaptcha = response[ParamName.PARAMERLOGINCAPTCHACHALLENGEATTEMPTCHALLLENGES][ParamName.PARAMERLOGINCAPTCHACHALLENGE].dictionary {
                            vc.viewTypeEr = .all
                            vc.captchaToken = dicCaptcha[ParamName.PARAMERLOGINTOKENC]?.string
                            vc.captchaId =                                     String(dicCaptcha[ParamName.PARAMERLOGINCAPTCHACHALLENGEID]!.int!)

                            vc.captchaImageURL = dicCaptcha[ParamName.PARAMERLOGINCAPTCHACHALLENGEIMAGE]?.string
                            
                            vc.email = self.txtFieldEmail.text;
                        }
                        else{
                            vc.viewTypeEr = .emailWithPwd
                            vc.email = self.txtFieldEmail.text;
                        }
                        self.navigationController?.pushViewController(vc, animated: false);
                    }
                    else
                    {
                        self.btnSign.isUserInteractionEnabled = false
                        self.btnSign.backgroundColor = ILColor.color(index: 6);
                        self.btnSign.setTitleColor(.black, for: .normal)

                        CommonFunctions().showError(title: "Error", message: GeneralUtility.optionalHandling(_param: response[ParamName.PARAMERLOGINERROR][ParamName.PARAMERLOGINMESSAGE].string, _returnType: String.self));
                        

                    }
                    
                    
                    
                }) { (error, errorCode) in
                    
                    self.activityIndicator?.hide()

                }
                
                
                
                break;
            case .emailWithPwd:
                let param = ["email": txtFieldEmail.text,"password": txtFieldPwd.text]
                activityIndicator = ActivityIndicatorView.showActivity(view: self.navigationController!.view, message: StringConstants.loginApiLoader)
                
                ErEventService().erLogin(params: param as Dictionary<String, AnyObject>, { (response) in
                    self.activityIndicator?.hide()

                    if response[ParamName.PARAMERLOGINID].int != nil{
                        UserDefaultsDataSource(key: "csrf_token").writeData(response["csrf_token"].string!)
                        if  let arrayBenchMark = response[ParamName.PARAMERLOGINBENCHMARK].arrayObject {
                           UserDefaultsDataSource(key: "benchmarksER").writeData(arrayBenchMark)
                            
                        }
                        self.loginApi();
                    }
                    else
                    {
                        if GeneralUtility.optionalHandling(_param: response[ParamName.PARAMERLOGINERROR][ParamName.PARAMERLOGINERRORS][ParamName.PARAMERLOGINCAPTCHACHALLENGEATTEMPTCHALLLENGES][ParamName.PARAMERLOGINCAPTCHACHALLENGEACCOUNTUNLOCK][ParamName.PARAMERLOGINCAPTCHACHALLENGEATTEMPTLEFT].int, _returnType: Int.self)  > 0
                        {
                            
                               if let  dicCaptcha = response[ParamName.PARAMERLOGINERROR][ParamName.PARAMERLOGINERRORS][ParamName.PARAMERLOGINCAPTCHACHALLENGEATTEMPTCHALLLENGES][ParamName.PARAMERLOGINCAPTCHACHALLENGE].dictionary{
                                  
                                let vc = ERLoginViewController.init(nibName: "ERLoginViewController", bundle: nil);
                                    vc.viewTypeEr = .all
                                vc.captchaToken = dicCaptcha[ParamName.PARAMERLOGINTOKENC]?.string
                                vc.captchaId =
                                    String(dicCaptcha[ParamName.PARAMERLOGINCAPTCHACHALLENGEID]!.int!)
                                vc.captchaImageURL = dicCaptcha[ParamName.PARAMERLOGINCAPTCHACHALLENGEIMAGE]?.string
                                    vc.email = self.txtFieldEmail.text;
                                    self.navigationController?.pushViewController(vc, animated: false);
                                }
                                else{
                                    
                            CommonFunctions().showError(title: "Error", message: GeneralUtility.optionalHandling(_param: response[ParamName.PARAMERLOGINERROR][ParamName.PARAMERLOGINMESSAGE].string, _returnType: String.self));
                            }
                            
                        }
                        else
                        {
                            self.btnSign.isUserInteractionEnabled = false
                            self.btnSign.backgroundColor = ILColor.color(index: 6);
                            self.btnSign.setTitleColor(.black, for: .normal)

                            CommonFunctions().showError(title: "Error", message: GeneralUtility.optionalHandling(_param: response[ParamName.PARAMERLOGINERROR][ParamName.PARAMERLOGINMESSAGE].string, _returnType: String.self));
                            
                            self.txtFieldPwd.text = "";

                        }
                        
                        
                    }
                    
                }) { (error, errorCode) in
                    self.activityIndicator?.hide()

                    CommonFunctions().showError(title: "Error", message: error)
                    self.txtFieldPwd.text = "";

                }
                
                
                break;
            case .emailwithCaptcha:
                                            
                break;
            case .all:
                activityIndicator = ActivityIndicatorView.showActivity(view: self.navigationController!.view, message: StringConstants.loginApiLoader)

                let param = ["email": txtFieldEmail.text
                            ,"password": txtFieldPwd.text,
                             "captcha_id": captchaId,
                             "captcha_token": captchaToken,
                             "captcha_response": txtFieldCode.text]
        
                ErEventService().erLogin(params: param as Dictionary<String, AnyObject>, { (response) in
                    self.activityIndicator?.hide()
                   
                  
                   if response[ParamName.PARAMERLOGINID].int != nil{
                    UserDefaultsDataSource(key: "csrf_token").writeData(response["csrf_token"].string!)

                                           self.loginApi();
                        }
                    else
                    {
                        
                        if GeneralUtility.optionalHandling(_param: response[ParamName.PARAMERLOGINERROR][ParamName.PARAMERLOGINERRORS][ParamName.PARAMERLOGINCAPTCHACHALLENGEATTEMPTCHALLLENGES][ParamName.PARAMERLOGINCAPTCHACHALLENGEACCOUNTUNLOCK][ParamName.PARAMERLOGINCAPTCHACHALLENGEATTEMPTLEFT].int, _returnType: Int.self)  > 0
                        {
                            
                                CommonFunctions().showError(title: "Error", message: GeneralUtility.optionalHandling(_param: response[ParamName.PARAMERLOGINERROR][ParamName.PARAMERLOGINMESSAGE].string, _returnType: String.self));
    
                            if let  dicCaptcha = response[ParamName.PARAMERLOGINERROR][ParamName.PARAMERLOGINERRORS][ParamName.PARAMERLOGINCAPTCHACHALLENGEATTEMPTCHALLLENGES][ParamName.PARAMERLOGINCAPTCHACHALLENGE].dictionary{
                                
                                let vc = ERLoginViewController.init(nibName: "ERLoginViewController", bundle: nil);
                                vc.viewTypeEr = .all
                                vc.captchaToken = dicCaptcha[ParamName.PARAMERLOGINTOKENC]?.string
                                vc.captchaId =
                                    String(dicCaptcha[ParamName.PARAMERLOGINCAPTCHACHALLENGEID]!.int!)
                                vc.captchaImageURL = dicCaptcha[ParamName.PARAMERLOGINCAPTCHACHALLENGEIMAGE]?.string
                                vc.email = self.txtFieldEmail.text;
                                self.navigationController?.pushViewController(vc, animated: false);
                            }
                            
                                                
                        }
                        else
                        {
                            CommonFunctions().showError(title: "Error", message: GeneralUtility.optionalHandling(_param: response[ParamName.PARAMERLOGINERROR][ParamName.PARAMERLOGINMESSAGE].string, _returnType: String.self));
                            self.btnSign.isUserInteractionEnabled = false
                            self.btnSign.backgroundColor = ILColor.color(index: 6);
                            self.btnSign.setTitleColor(.black, for: .normal)
                            
                        }
                         
                    }
                    
                }) { (error, errorCode) in
                    self.activityIndicator?.hide()
                    CommonFunctions().showError(title: "Error", message: error)

                }
                break;
            default:
                break
                
            }
            
        }
        else{
            GeneralUtility.alertView(title: "No Connection".localized(), message: "Connect To network".localized(), viewController: self, buttons: ["Ok"]);
            
        }
        
        
        
    }
    
    var activeField: UITextField?
    @IBOutlet weak var viewCaptche: UIStackView!
    
    @IBOutlet weak var nslayoutCaptchaHeight: NSLayoutConstraint!
    
    
    @IBOutlet weak var btnSign: UIButton!
    
    let activity = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        GoogleAnalyticsUtility().startScreenTrackingForScreenName("Login & Register: Login")
        customizeUI()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
   
    
  override func viewDidDisappear(_ animated: Bool) {
           super.viewDidDisappear(animated)
           NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
           NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
       }
       
       @objc private func keyboardWillShow(notification: NSNotification) {
              self.nslayoutCentreToMOve.constant = -180;
//                 self.view.layoutIfNeeded()
       }
    
    
    @objc private func keyboardWillHide(notification: Notification) {
           UIView.animate(withDuration: 3) {
            self.nslayoutCentreToMOve.constant = -150;
//               self.view.layoutIfNeeded()
           }
       }
    
    
    
    func customizeUI(){
        
        
        switch viewTypeEr {
        case .onlyEmail:
            
            nslayoutCaptchaHeight.constant = 0;
            nslayoutConstarintPwdHeight.constant = 0;
            nslayoutConstarintCaptchTop.constant = 8;
            nslayoutConstarintCaptchBelow.constant = 20;
            self.viewCaptche.isHidden = true
            self.passwordContainerView.isHidden = true;
            UIButton.buttonUIHandling(button: btnSign, text: "Next", backgroundColor: ILColor.color(index: 7), textColor: .white, cornerRadius: 5)
            btnBack.isHidden = false;
            btnBack.setImage(UIImage.init(named: "BackBlue"), for: .normal);
                       btnBack.tintColor = .black
            break;
        case .emailWithPwd:
            nslayoutConstarintPwdHeight.constant = 50;

            txtFieldEmail.text = email
            txtFieldEmail.isUserInteractionEnabled = false
            nslayoutCaptchaHeight.constant = 0;
            nslayoutConstarintCaptchTop.constant = 8;
            nslayoutConstarintCaptchBelow.constant = 20;
            self.viewCaptche.isHidden = true
            UIButton.buttonUIHandling(button: btnSign, text: "Sign In", backgroundColor: ILColor.color(index: 7), textColor: .white, cornerRadius: 5)
            btnBack.isHidden = false;
            btnBack.setImage(UIImage.init(named: "BackBlue"), for: .normal);
            btnBack.tintColor = .black
            
            break;
        case .emailwithCaptcha:
            nslayoutConstarintPwdHeight.constant = 50;
            self.viewCaptche.isHidden = false
            btnBack.isHidden = false;
            btnBack.setImage(UIImage.init(named: "BackBlue"), for: .normal);
            btnBack.tintColor = .black

            break;
        case .all:
            nslayoutConstarintPwdHeight.constant = 50;

            txtFieldEmail.text = email
            txtFieldEmail.isUserInteractionEnabled = false
            UIButton.buttonUIHandling(button: btnSign, text: "Sign In", backgroundColor: ILColor.color(index: 7), textColor: .white, cornerRadius: 5)
            btnBack.isHidden = false;
            btnBack.setImage(UIImage.init(named: "BackBlue"), for: .normal);
            configureCaptcha()
            break;
            
            
        default:
            break
            
        }
        
        
        
        self.navigationController?.navigationBar.isHidden = true;
        activity.style = .gray
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func reloadCaptchButtonTapped(_ sender: Any) {
        reloadCaptcha()
    }
    
    func configureCaptcha() {
        getCaptcha()
    }
    
    func reloadCaptcha() {
        imgViewCaptcha.image = nil
        txtFieldCode.text = ""
        self.getNewCaptcha();
    }
    
    
    func getNewCaptcha( ) {
        
        self.imgViewCaptcha.backgroundColor = UIColor.white
        imgViewCaptcha.addSubview(activity, withCenterConstraints: CGPoint(x: 0, y: 0))
        activity.startAnimating()
        ErEventService().getNewCaptch({ response in
            self.captchaId = String(response["id"].int!)
            self.captchaToken = response["token"].string!
            self.captchaImageURL = response["image"].string!
            self.activity.removeFromSuperview()
            self.getCaptcha()
        }, failure: { (error,errorCode) in
            self.activity.removeFromSuperview()
            CommonFunctions().showError(title: "Error", message: error)
        })
    }
    
    func getCaptcha() {
        self.imgViewCaptcha.backgroundColor = UIColor.white
        imgViewCaptcha.addSubview(activity, withCenterConstraints: CGPoint(x: 0, y: 0))
        activity.startAnimating()
        self.imgViewCaptcha.downloadedFrom(link:self.captchaImageURL!, success: {
                       DispatchQueue.main.async {
                           self.activity.removeFromSuperview()
                       }
                           
                       
                   }, failure: {
                    
                           DispatchQueue.main.async {
                               self.activity.removeFromSuperview()
                           }
                   })

        
    }
    
    @objc func keyboardNotification(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let duration:TimeInterval = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIView.AnimationOptions.curveEaseInOut.rawValue
            let animationCurve:UIView.AnimationOptions = UIView.AnimationOptions(rawValue: animationCurveRaw)
            if (endFrame?.origin.y)! >= UIScreen.main.bounds.size.height {
                //                self.keyboardLayoutConstraint.constant = 0.0
            } else {
                //                self.keyboardLayoutConstraint.constant = endFrame?.size.height ?? 0.0
            }
            UIView.animate(withDuration: duration,
                           delay: TimeInterval(0),
                           options: animationCurve,
                           animations: { self.view.layoutIfNeeded() },
                           completion: nil)
        }
    }
    
    @IBAction func forgotPasswordButtonTapped(_ sender: UIButton){
        GoogleAnalyticsUtility().logEvent(GoogleAnalyticsEvent(category: "Login & Register", action: "Reset Password", label: "Reset Password Initiator"))
        let forgotPasswordController = UIStoryboard.forgot()
        forgotPasswordController.email = txtFieldEmail.text!
        forgotPasswordController.providesPresentationContextTransitionStyle = true
        forgotPasswordController.definesPresentationContext = true
        forgotPasswordController.modalPresentationStyle=UIModalPresentationStyle.overFullScreen
        forgotPasswordController.modalTransitionStyle = .crossDissolve
        self.present(forgotPasswordController, animated: true, completion: nil)
    }
    
    @IBAction func loginButtonTapped(_ sender: UIButton){
        if (txtFieldEmail.text?.isEmpty)! || (txtFieldPwd.text?.isEmpty)!{
            CommonFunctions().showError(title: "Error", message: StringConstants.emptyPasswordError)
            passwordContainerView.shake()
        }else if !(txtFieldEmail.text?.isvalidEmailId())!{
            CommonFunctions().showError(title: "Error", message: StringConstants.invalidEmailError)
            emailContainerView.shake()
        } else if  (txtFieldCode.text?.isEmpty)! {
            CommonFunctions().showError(title: "Error", message: StringConstants.emptyCaptchaError)
            viewCaptche.shake()
        }
        else{
            _ = ["email": txtFieldEmail.text!,
                          "password": txtFieldPwd.text!,
                          "provider":"email",
                          "link":link] as [String : Any]
            self.removeActiveField()
            //            if captchaRequired {
            //                params["captcha_id"] = captchaId!
            //                params["captcha_token"] = captchaToken!
            //                params["captcha_response"] = txtFieldCode.text!
            //            }
            //            loginCall(params: params as Dictionary<String, AnyObject>, headerIncluded: false,header: ["":""])
        }
    }
    
    
    
    func  removeActiveField(){
        txtFieldEmail.resignFirstResponder()
        txtFieldPwd.resignFirstResponder()
        txtFieldCode.resignFirstResponder()
        
    }
    
    func errorHandler(error: String,errorCode: Int, params: Dictionary<String,AnyObject>,headerIncluded: Bool,header: Dictionary<String,String>){
        //          self.activityIndicator?.hide()
        CommonFunctions().showError(title: "Error", message: error)
        self.txtFieldPwd.text = ""
        self.txtFieldPwd.resignFirstResponder()
        self.reloadCaptcha()
    }
    
}

    extension ERLoginViewController : UITextFieldDelegate {
        
        func textFieldDidBeginEditing(_ textField: UITextField) {
            activeField = textField
        }
        
        func textFieldDidEndEditing(_ textField: UITextField) {
            activeField = nil
        }
        
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            removeActiveField()
            return true
        }


    func customization() {
        
        
    }
  

}
