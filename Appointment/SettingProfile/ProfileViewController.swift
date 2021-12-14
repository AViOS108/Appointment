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

   
       @IBOutlet weak var nameLabel: UILabel!
       @IBOutlet weak var addImageButton: UIButton!
       @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var viewInner: UIView!
    @IBOutlet weak var chnagePwdLabel: UILabel!

    @IBOutlet weak var viewTop: UIView!
    @IBOutlet weak var viewChangePwd: UIView!


    var imagePicker : UIImagePickerController?
    var activityView: ActivityIndicatorView?
    
    let activityImageIndicator =  UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
    var profileUrl: String?
    weak var delegate : ProfileViewControllerDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()

        activityImageIndicator.cornerRadius = addImageButton.frame.size.width / 2
        addImageButton.cornerRadius = addImageButton.frame.size.width / 2
        viewTop.cornerRadius = 3;
        viewChangePwd.cornerRadius = 3;
        if  let fontHeavy = UIFont(name: "FontHeavy".localized(), size: Device.FONTSIZETYPE13)
        {
            UILabel.labelUIHandling(label: chnagePwdLabel, text: "Change Password", textColor: ILColor.color(index: 62), isBold: true, fontType: fontHeavy)

        }
        
        let isStudent = UserDefaultsDataSource(key: "student").readData() as? Bool
        if isStudent ?? false {
            self.customizedUI()
        }
        else{
            if UserDefaultsDataSource(key: "roles").readData() != nil {
                self.customizedUI()
            }
            else{
                viewInner.isHidden = true
                activityView = ActivityIndicatorView.showActivity(view: self.view, message: StringConstants.FetchingCoachSelection)

                self.updateProfile(isType: -1)
            }
        }
        
       
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.title = "Edit Profile"
        GeneralUtility.customeNavigationBarWithOnlyBack(viewController: self,title:"Back");
    }
    override func viewDidAppear(_ animated: Bool) {
       
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
        let userEmail : String = (UserDefaultsDataSource(key: "userEmail").readData() as? String) ?? ""
        
        var roles = "";
        
        
        let isStudent = UserDefaultsDataSource(key: "student").readData() as? Bool
        if isStudent ?? false {
            roles = UserDefaultsDataSource(key: "benchmark").readData() as? String ?? ""
        }
        else
        {
            if let roleStored : [String] = UserDefaultsDataSource(key: "roles").readData() as? [String]{
                var index = 0
                for roleI in  roleStored {
                    if index != 0{
                        roles.append(" ")
                    }
                    roles.append(roleI)
                    roles.append(" ")
                    index = index + 1;
                    if index != roleStored.count{
                        roles.append("•")
                    }
                }
            }
        }
        
       
        
        
        if   let fontHeavy = UIFont(name: "FontHeavy".localized(), size: Device.FONTSIZETYPE14) ,
             let fontBook =  UIFont(name: "FontBook".localized(), size: Device.FONTSIZETYPE14) ,
             let fontMedium = UIFont(name: "FontMediumWithoutNext".localized(), size: Device.FONTSIZETYPE13) {
            let strHeader = NSMutableAttributedString.init()
            let strTiTle = NSAttributedString.init(string: firstName
                                                   , attributes: [NSAttributedString.Key.foregroundColor : ILColor.color(index:62),NSAttributedString.Key.font : fontHeavy]);
            
            let strType = NSAttributedString.init(string: roles
                                                  , attributes: [NSAttributedString.Key.foregroundColor : ILColor.color(index: 62),NSAttributedString.Key.font : fontBook]);
            let strEmail = NSAttributedString.init(string: userEmail
                                                  , attributes: [NSAttributedString.Key.foregroundColor : ILColor.color(index: 7),NSAttributedString.Key.font : fontMedium]);
            let nextLine1 = NSAttributedString.init(string: "\n")

            let para = NSMutableParagraphStyle.init()
            //            para.alignment = .center
            para.lineSpacing = 4
            strHeader.append(strTiTle)
            strHeader.append(nextLine1)
            strHeader.append(strType)
            strHeader.append(nextLine1)
            strHeader.append(strEmail)

            strHeader.addAttribute(NSAttributedString.Key.paragraphStyle, value: para, range: NSMakeRange(0, strHeader.length))
            nameLabel.attributedText = strHeader
        }
        
        activityImageIndicator.hidesWhenStopped = true
        addImageButton.bringSubviewToFront(activityImageIndicator)
        addImageButton.addSubview(activityImageIndicator, withInsetConstraints: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        activityImageIndicator.style = .white
        activityImageIndicator.backgroundColor = UIColor.fromHex(0x000000, alpha: 0.6)
        addImageButton.contentMode = .scaleAspectFill
        setProfilePicture()
        UIButton.buttonUIHandling(button:editButton, text: "", backgroundColor: .clear, buttonImage: UIImage.init(named: "imageCircle"))
        
//        addActivityIndicator(show: true)

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
      
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        closeKeyboard()
        self.navigationController?.popViewController(animated: true)
    }

    
 

    func uploadImageToServerStudent(image: UIImage){
        addActivityIndicator(show: true)
        let data = image.jpegData(compressionQuality: 0.50) as NSData?
        let headers: Dictionary<String,String> = ["Authorization": "Bearer \(UserDefaultsDataSource(key: "accessToken").readData()!)",
                                                  "Content-Type": "multipart/form-data" ]
        let csrftoken = UserDefaultsDataSource(key: "csrf_token").readData() as! String
        let param = ["_method":"patch",
                     ParamName.PARAMCSRFTOKEN : csrftoken]
        
       
        Alamofire.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(data! as Data, withName: "profile_pic", fileName: "image.jpg", mimeType: "image/jpeg")
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
                        UserDefaultsDataSource(key: "userProfile").writeData(responseJSON["message"].string)
                        self.setProfilePicture()


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
    
    func uploadImageToServerER(image: UIImage){
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
    
    
    func uploadImageToServer(image: UIImage){
        let isStudent = UserDefaultsDataSource(key: "student").readData() as? Bool
        if isStudent ?? false {
            self.uploadImageToServerStudent(image: image)
            
        }
        else
        {
            self.uploadImageToServerER(image: image)
        }
    }
    
    
    func updateProfile(isType : Int) {
        
        LoginService().getUserInfoER { (json) in
            if isType == 1 {
                self.addActivityIndicator(show: false)
                self.setProfilePicture();
            }
            if isType == -1 {
                self.activityView?.hide()
              
                
                var roles : [String] = [];
                for roleI in json["roles"].array!{
                    roles.append(roleI["display_name"].string ?? "")
                }
                UserDefaultsDataSource(key: "roles").writeData(roles)
                self.customizedUI()
                self.viewInner.isHidden = false
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
