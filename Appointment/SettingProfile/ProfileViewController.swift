//
//  ProfileViewController.swift
//  Resume
//
//  Created by VM User on 09/02/17.
//  Copyright © 2017 VM User. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage
import AVFoundation
import Photos

import AlamofireImage
protocol ProfileViewControllerDelegate: NSObjectProtocol {
    func profileViewControllerDidUpdate()
}

class ProfileViewController: SuperViewController,UINavigationControllerDelegate {

   
    @IBOutlet weak var emailLabel: UILabel!
       @IBOutlet weak var nameLabel: UILabel!
       @IBOutlet weak var firstNameTextField: UITextField!
       @IBOutlet weak var lastNameTextField: UITextField!
       @IBOutlet weak var addImageButton: UIButton!
       @IBOutlet weak var editButton: UIButton!
       @IBOutlet weak var firstNameContainerview: UIView!
       @IBOutlet weak var lastNameContainerview: UIView!
       
       @IBOutlet weak var editNameViewHeightConstraints: NSLayoutConstraint!
    
    var imagePicker : UIImagePickerController?
    var activityView: ActivityIndicatorView?
    let activityImageIndicator =  UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
    var profileUrl: String?
    weak var delegate : ProfileViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customizedUI()
        self.editNameViewHeightConstraints.constant = 0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.title = "Edit Profile"
        GeneralUtility.customeNavigationBarWithOnlyBack(viewController: self,title:"Back");
    }
    
    @objc override func buttonClicked(sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: false)
    }

    
    @objc func logoutClicked(sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true);
    }

    func customizedUI(){
        var firstName = ""
        if let fn = UserDefaultsDataSource(key: "firstName").readData() {
            firstName = fn as! String
        }
        if let lastName = UserDefaultsDataSource(key: "lastName").readData() {
            nameLabel.text = "\(firstName) \(lastName)"
        }else{
            nameLabel.text = "\(firstName)"
        }
        
        firstNameTextField.text = UserDefaultsDataSource(key: "firstName").readData() as! String?
        lastNameTextField.text = UserDefaultsDataSource(key: "lastName").readData()as! String?
        emailLabel.text = UserDefaultsDataSource(key: "userEmail").readData() as! String?
        
        activityImageIndicator.hidesWhenStopped = true
        addImageButton.bringSubviewToFront(activityImageIndicator)
        addImageButton.addSubview(activityImageIndicator, withInsetConstraints: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        activityImageIndicator.style = .white
        activityImageIndicator.cornerRadius = addImageButton.frame.size.width / 2
        activityImageIndicator.backgroundColor = UIColor.fromHex(0x000000, alpha: 0.6)
        addImageButton.contentMode = .scaleAspectFill
        setProfilePicture()
        
    }

    
    func setProfilePicture(){
        profileUrl = UserDefaultsDataSource(key: "userProfile").readData() as? String
        self.addImageButton.imageView?.contentMode = .scaleAspectFill
        activityImageIndicator.startAnimating()
        if let profUrl = profileUrl, let url = URL(string: profUrl) {
        self.addImageButton.af_setBackgroundImage(for: .normal, url: url, placeholderImage: UIImage.init(named: "Profile"), filter: nil, progress: nil, progressQueue: .main) { (image) in
                self.activityImageIndicator.stopAnimating()
            
            }
        }else{
            self.addImageButton.setBackgroundImage(UIImage.init(named: "Profile"), for: .normal)
            self.activityImageIndicator.stopAnimating()
        }
        
    }
    
    

    @IBAction func changePasswordButtonTapped(_ sender: Any) {
        GoogleAnalyticsUtility().logEvent(GoogleAnalyticsEvent(category: "Account", action: "Change Password Initiator", label: "Change Password Initiator"))
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "profileImageSegue" {
            if let destinationVC = segue.destination as? ProfilePictureViewController {
                destinationVC.delegate = self
                destinationVC.image = self.addImageButton.currentBackgroundImage
            }
        }
    }
    
    
    @IBAction func addImageButtonTapped(_ sender: Any) {
        if let path = profileUrl, let url = URL(string: path), UIApplication.shared.canOpenURL(url){
            self.performSegue(withIdentifier: "profileImageSegue", sender: self)
        }else{
            createAlertController()
        }
    }
    
    func createAlertController(){
        let actionSheetController = UIAlertController(title: "", message: "Upload/Edit an image for your profile", preferredStyle: .actionSheet)
    
        let cancelActionButton = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
        }
        actionSheetController.addAction(cancelActionButton)
        
        let galleryAction = UIAlertAction(title: "Gallery", style: .default) { action -> Void in
            PHPhotoLibrary.requestAuthorization { status in
                switch status {
                case .authorized:
                    DispatchQueue.main.async {
                        self.imagePicker = UIImagePickerController()
                        self.imagePicker!.delegate = self
                        self.imagePicker!.allowsEditing = true
                        self.imagePicker!.sourceType = .savedPhotosAlbum
                        self.imagePicker!.modalPresentationStyle = .popover
                        self.imagePicker!.popoverPresentationController?.sourceView = self.view
                        self.imagePicker!.popoverPresentationController?.sourceRect = self.addImageButton.frame
                        self.navigationController?.present(self.imagePicker!, animated: true, completion: nil)
                    }
                case .restricted:
                    debugPrint("handle restricted")
                case .denied:
                    CommonFunctions().showError(title: "Alert", message: "Photos permission denied by user. Please go to settings and grant permission")
                default:
                    // place for .notDetermined - in this callback status is already determined so should never get here
                    break
                }
            }
        }
        actionSheetController.addAction(galleryAction)
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { action -> Void in
            self.imagePicker = UIImagePickerController()
            self.imagePicker!.delegate = self
            self.imagePicker!.allowsEditing = true
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                if AVCaptureDevice.authorizationStatus(for: AVMediaType.video) ==  AVAuthorizationStatus.authorized {
                    self.imagePicker!.sourceType = .camera
                    self.navigationController?.present(self.imagePicker!, animated: true, completion: nil)
                } else {
                    AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { (granted: Bool) -> Void in
                        DispatchQueue.main.async {
                            if granted == true {
                                self.imagePicker!.sourceType = .camera
                                self.navigationController?.present(self.imagePicker!, animated: true, completion: nil)
                            } else {
                                CommonFunctions().showError(title: "Alert", message: "Camera permission denied by user. Please go to settings and grant permission")
                            }
                        }
                    })
                }
            }else{
                CommonFunctions().showError(title: "Alert", message: "Camera not available")
            }
        }
        
        actionSheetController.addAction(cameraAction)
        actionSheetController.popoverPresentationController?.sourceView = self.view
        actionSheetController.popoverPresentationController?.sourceRect = addImageButton.frame
        self.present(actionSheetController, animated: true) {
            actionSheetController.popoverPresentationController?.passthroughViews = nil
        }
    }
    
    @IBAction func editButtonTapped(_ sender: Any) {
        view.layoutIfNeeded()
        self.editNameViewHeightConstraints.constant = 150
        UIView.animate(withDuration: 0.5, animations: {
            self.view.layoutIfNeeded()
            self.editButton.alpha = 0
        })
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        closeKeyboard()
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func cancelButtonTapped(_ sender: Any) {
        closeKeyboard()
        closeEditableNameView()
    }
    
    func closeEditableNameView(){
        view.layoutIfNeeded()
        self.editNameViewHeightConstraints.constant = 0
        UIView.animate(withDuration: 0.25, animations: {
            self.view.layoutIfNeeded()
            self.editButton.alpha = 1
        })
    }
    
    @IBAction func doneButtonTaped(_ sender: UIButton) {
        closeKeyboard()
        firstNameTextField.text = firstNameTextField.text?.trimmingCharacters(in: .whitespaces)
        lastNameTextField.text = lastNameTextField.text?.trimmingCharacters(in: .whitespaces)
        if self.firstNameTextField.text == "" || lastNameTextField.text == ""{
            if self.firstNameTextField.text == "" {
                CommonFunctions().showError(title: "Error", message: "Please enter the first Name")
                firstNameContainerview.shake()
            }else if lastNameTextField.text == ""{
                CommonFunctions().showError(title: "Error", message: "Please enter the last Name")
                lastNameContainerview.shake()
            }
        }else if !(firstNameTextField.text?.isValidName())!{
            CommonFunctions().showError(title: "Error", message: "First name should contain only letters and spaces")
        }else if !(lastNameTextField.text?.isValidName())!{
            CommonFunctions().showError(title: "Error", message: "Last name should contain only letters and spaces")
        }else{
            sender.isEnabled = false
            let params = ["first_name":firstNameTextField.text!,
                          "last_name": lastNameTextField.text!]
            activityView =  ActivityIndicatorView.showActivity(view: self.navigationController!.view, message: "Updating your profile")
            UserInfoService().updateProfile(params: params as Dictionary<String, AnyObject>,{ response in
                GoogleAnalyticsUtility().logEvent(GoogleAnalyticsEvent(category: "Settings", action: "Change Name", label: "Success"))
                sender.isEnabled = true
                CommonFunctions().showSuccess(title: "Success", message: "Name changed successfully")
                UserDefaultsDataSource(key: "firstName").writeData(self.firstNameTextField.text!)
                UserDefaultsDataSource(key: "lastName").writeData(self.lastNameTextField.text!)
               self.activityView?.hide()
                self.closeEditableNameView()
                self.customizedUI()
                self.delegate?.profileViewControllerDidUpdate()
            }, failure: { (error,errorCode) in
                sender.isEnabled = true
                self.firstNameTextField.text = UserDefaultsDataSource(key: "firstName").readData() as! String?
                self.lastNameTextField.text = UserDefaultsDataSource(key: "lastName").readData() as! String?
                self.lastNameTextField.resignFirstResponder()
                self.firstNameTextField.resignFirstResponder()
                self.activityView?.hide()
                CommonFunctions().showError(title: "Error", message: error)
            })
        }
    }

    
    func uploadImageToServer(image: UIImage){
        addActivityIndicator(show: true)
        let data = image.jpegData(compressionQuality: 0.50) as NSData?
        let headers: Dictionary<String,String> = ["Authorization": "Bearer \(UserDefaultsDataSource(key: "accessToken").readData()!)",
                                                  "Content-Type": "multipart/form-data" ]
        let csrftoken = UserDefaultsDataSource(key: "csrf_token").readData() as! String
        let param = ["_method":"put",
                     ParamName.PARAMCSRFTOKEN : csrftoken,]
        
       
        Alamofire.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(data! as Data, withName: "file", fileName: "image.jpg", mimeType: "image/jpeg")
            for (key, value) in param {
                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
            }
            
            
        },to: Urls().uploadProfilePicture(),method: .post,
          headers: headers){ (result) in
            switch result {
            case .success(let upload, _, _):
                upload.uploadProgress(closure: { (progress) in
                    
                })
                upload.responseJSON { response in
                    switch response.result {
                    case .success(let value):
                        let responseJSON = JSON(value)

                        self.updateProfile(isType: 1)
                        
                    case .failure(let error):
                        if LogoutHandler.shouldLogout(errorCode: error._code){
                            LogoutHandler.invalidateCurrentUser()
                        }
                        CommonFunctions().showError(title: "Error", message: Network().errorMsgFailure(error._code))
                    }
                }
            case .failure(let encodingError):
                if LogoutHandler.shouldLogout(errorCode: encodingError._code){
                    LogoutHandler.invalidateCurrentUser()
                }
                CommonFunctions().showError(title: "Error", message: Network().errorMsgFailure(encodingError._code))
            }
        }
    }
    
    
    func updateProfile(isType : Int) {
        
        LoginService().getUserInfoER { (json) in
            if isType == 1 {
                self.addActivityIndicator(show: false)
                self.setProfilePicture();
            }
        } failure: { (error, errorCode) in
            self.addActivityIndicator(show: false)
            CommonFunctions().showError(title: "Error", message: Network().errorMsgFailure(errorCode))
        }
    }
    
    
    func addActivityIndicator(show: Bool){
        if show {
            activityImageIndicator.startAnimating()
        }else{
            activityImageIndicator.stopAnimating()
        }
    }
    
    func closeKeyboard(){
        firstNameTextField.resignFirstResponder()
        lastNameTextField.resignFirstResponder()
    }
}

extension ProfileViewController: ProfilePictureViewControllerDelegate{
  
    

    func uploadProfilePicture(image: UIImage) {
        uploadImageToServer(image: image)
    }

//    func removedProfilePicture(){
//        self.addActivityIndicator(show: true)
//        UserInfoService().removeProfilePicCall({ response in
//            self.addImageButton.sd_setImage(with: nil, for: .normal)
//            self.addImageButton.layoutSubviews()
//            self.addActivityIndicator(show: false)
//            self.profileUrl = nil
//            UserDefaultsDataSource(key: "userProfile").removeData()
//            self.setProfilePicture()
//            CommonFunctions().showSuccess(title: "Success", message: "Profile picture removed successfully")
//            self.delegate?.profileViewControllerDidUpdate()
//        }, failure: { (error,errorCode) in
//            self.addActivityIndicator(show: false)
//            CommonFunctions().showError(title: "Error", message: error)
//            self.setProfilePicture()
//        })
//    }
}

extension ProfileViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        if let pickedImage = info[.originalImage] as? UIImage {
            uploadImageToServer(image: pickedImage)
        }
        dismiss(animated: true, completion: nil)
        self.imagePicker = nil
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
        self.imagePicker = nil
    }
    
}

extension ProfileViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension ProfileViewController : UIPopoverPresentationControllerDelegate {
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
        
    }
}
