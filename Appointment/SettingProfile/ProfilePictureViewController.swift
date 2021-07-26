//
//  ProfilePictureViewController.swift
//  Resume
//
//  Created by VM User on 17/05/17.
//  Copyright © 2017 VM User. All rights reserved.
//

import UIKit
import Photos
import AVFoundation

protocol  ProfilePictureViewControllerDelegate: NSObjectProtocol{
    func uploadProfilePicture(image: UIImage)
      func removedProfilePicture()
}

extension ProfilePictureViewControllerDelegate{
    func removedProfilePicture()
    {
        
    }
}

class ProfilePictureViewController: SuperViewController {
    
    var imagePicker : UIImagePickerController?
    @IBOutlet weak var profileImageViewer: UIImageView!
    var image: UIImage?
    weak var delegate: ProfilePictureViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileImageViewer.contentMode = .scaleAspectFit
        profileImageViewer.clipsToBounds = true
        profileImageViewer.image = image        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        GoogleAnalyticsUtility().startScreenTrackingForScreenName("Settings: Fullscreen Profile Picture")
        
        GeneralUtility.customeNavigationBarWithTwoButtons(viewController: self, titleButtonL: "Cancel", TittleButtonR: "Edit", titleNavBar: "Change Password")

        
    }
    
    @objc override func buttonClickedLeft(sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)

       }
    @objc override func buttonClickedRight(sender: UIBarButtonItem) {
        createAlertController()

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
                        self.imagePicker!.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
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
        
        let removePicture = UIAlertAction(title: "Remove picture", style: .default) { action -> Void in
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "Alert", message: "Are you sure you want to remove your profile picture?", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Remove", style: .default, handler: { (_) in
                    self.delegate?.removedProfilePicture()
                    self.navigationController?.popViewController(animated: false)
                }))
                alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (_) in
                    
                }))
                self.present(alert, animated: true, completion: nil)
            }
        }
//        actionSheetController.addAction(removePicture)
        actionSheetController.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
        self.present(actionSheetController, animated: true) { 
            actionSheetController.popoverPresentationController?.passthroughViews = nil
        }
    }
}

extension ProfilePictureViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let pickedImage = info[.originalImage] as? UIImage {
            profileImageViewer.image = pickedImage
            delegate?.uploadProfilePicture(image: pickedImage)
        }
        dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: false)
        imagePicker = nil
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
        imagePicker = nil
    }
    
}
