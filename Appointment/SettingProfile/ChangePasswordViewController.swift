//
//  ChangePasswordViewController.swift
//  Resume
//
//  Created by VM User on 09/02/17.
//  Copyright © 2017 VM User. All rights reserved.
//

import UIKit

class ChangePasswordViewController: SuperViewController,UITextFieldDelegate {

    
    var activityIndicator : ActivityIndicatorView?
    
    @IBOutlet weak var txtOldPassword: CustomUITextField!
    
    @IBOutlet weak var txtNewPassword: CustomUITextField!
    
    @IBOutlet weak var txtConfirmPassword: CustomUITextField!
    
    @IBOutlet weak var pwdHintlabek: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pwdHintlabek.text = StringConstants.invalidPasswordError
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        GoogleAnalyticsUtility().startScreenTrackingForScreenName("Settings: Change Password")
        GeneralUtility.customeNavigationBarWithTwoButtons(viewController: self, titleButtonL: "Cancel", TittleButtonR: "Done", titleNavBar: "Change Password")

    }
    
    
    
    @objc override func buttonClickedLeft(sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)

          }
    @objc override func buttonClickedRight(sender: UIBarButtonItem) {
           let validStatus = txtNewPassword.text!.isValidPasword()
           if txtOldPassword.text == ""{
               CommonFunctions().showError(title: "Error", message: "Please enter the old password")
               txtOldPassword.shake()
           }else if txtNewPassword.text == ""{
               CommonFunctions().showError(title: "Error", message: "Please enter the new password")
               txtNewPassword.shake()
           }else if txtConfirmPassword.text == "" {
               CommonFunctions().showError(title: "Error", message: "Please enter the confirm password")
               txtConfirmPassword.shake()
           }else if txtNewPassword.text != txtConfirmPassword.text{
               CommonFunctions().showError(title: "Error", message: "New password and confirm password doesn't match")
               txtNewPassword.shake()
               txtConfirmPassword.shake()
           }else if !(validStatus.status){
               CommonFunctions().showError(title: "Error", message: validStatus.message)
               txtNewPassword.shake()
               txtConfirmPassword.shake()
           }else{
               activityIndicator = ActivityIndicatorView.showActivity(view: self.view, message: "Updating your password")
            let csrftoken = UserDefaultsDataSource(key: "csrf_token").readData() as! String
            let params = [
                "_method":"post",
                "old_password": txtOldPassword.text!,
                "password" : txtNewPassword.text!,
                ParamName.PARAMCSRFTOKEN : csrftoken]
            
               UserInfoService().updatePasswordCall(params: params as Dictionary<String, AnyObject>,{ response in
                   CommonFunctions().showSuccess(title: "Success", message: "Password updated successfully")
                   GoogleAnalyticsUtility().logEvent(GoogleAnalyticsEvent(category: "Settings", action: "Change Password", label: "Success"))
                   self.activityIndicator?.hide()
                   self.navigationController?.popViewController(animated: true)
               }, failure: {(error,errorCode) in
                   self.activityIndicator?.hide()
                   CommonFunctions().showError(title: "Error", message: error)
               })
           }
           
       }
    
   
        
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func showPasswordButtonTapped(_ sender: UIButton) {
        if sender.titleLabel?.text == "SHOW"{
            txtNewPassword.isSecureTextEntry = false
            sender.setTitle("HIDE", for: .normal)
        }else if sender.titleLabel?.text == "HIDE"{
            txtNewPassword.isSecureTextEntry = true
            sender.setTitle("SHOW", for: .normal)
        }
    }
    
    @IBAction func showConfirmPasswordButtonTapped(_ sender: UIButton) {
        if sender.titleLabel?.text == "SHOW"{
            txtConfirmPassword.isSecureTextEntry = false
            sender.setTitle("HIDE", for: .normal)
        }else if sender.titleLabel?.text == "HIDE"{
            txtConfirmPassword.isSecureTextEntry = true
            sender.setTitle("SHOW", for: .normal)
        }
    }
    
    @IBAction func showOldPasswordButtonTapped(_ sender: UIButton) {
        if sender.titleLabel?.text == "SHOW"{
            txtOldPassword.isSecureTextEntry = false
            sender.setTitle("HIDE", for: .normal)
        }else if sender.titleLabel?.text == "HIDE"{
            txtOldPassword.isSecureTextEntry = true
            sender.setTitle("SHOW", for: .normal)
        }
    }
    
    
}
