//
//  PrefilledCommunityViewController.swift
//  Resume
//
//  Created by Manu Gupta on 06/11/17.
//  Copyright © 2017 VM User. All rights reserved.
//

import UIKit
import SwiftyJSON
//import SearchTextField
import TTTAttributedLabel

class PrefilledCommunityViewController: CustomizedViewController {
    
    var activityIndicator: ActivityIndicatorView?
    var errorView: ErrorView?
    var link: String = ""
    var selectedCommunity: SelectedCommunity?
    @IBOutlet weak var communityNameView: UIView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var communitySearch: SearchTextField!
    @IBOutlet weak var noResultsLabel: UILabel!
    @IBOutlet weak var headerViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleLabel: UILabel!
    var sceenTitle : String!
    var headerViewDefaultConstant : CGFloat!

    @IBOutlet weak var continueWithoutSchoolButton: UIButton!
    @IBOutlet weak var withoutSchoolBottomConstraint: NSLayoutConstraint!
    let defaultBottomConstraint : CGFloat = 88
    
    
    @IBAction func btnBackTapped(_ sender: Any) {
               self.dismiss(animated: false) {
                   
               }
           
       }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getCommunityListFromServer()
        sceenTitle = titleLabel.text
        headerViewDefaultConstant = self.view.frame.height * 0.22
        if UIDevice.isDeviceWithHeight480() {
            headerViewDefaultConstant = self.view.frame.height * 0.02
        }
        communitySearch.delegate = self
        headerViewConstraint.constant = headerViewDefaultConstant
        setupTextField()
        self.view.backgroundColor = UIColor.clear
        nextButtonEnabled(status : false)
         
//        btnBack.isUserInteractionEnabled = true;
//        btnBack.isHidden = false;
//        btnBack.setImage(UIImage.init(named: "Back"), for: .normal);
//        btnBack.tintColor = .black
    }
    
    func setupTextField() {
        let imageView = UIImageView.init(image: UIImage.init(named: ""))
        imageView.contentMode = .center
        imageView.frame.size = CGSize.init(width: 30, height: 30)
        communitySearch.leftView = imageView
        communitySearch.leftViewMode = .unlessEditing
        
        communitySearch.theme.cellHeight = 54
        communitySearch.maxResultsListHeight = 400
        communitySearch.theme.font = UIFont.systemFont(ofSize: 15)
        communitySearch.theme.bgColor = .white
        communitySearch.theme.separatorColor = UIColor.lightGray.withAlphaComponent(0.3)
        communitySearch.highlightAttributes = [.font: UIFont.systemFont(ofSize: 15)]
        
        communitySearch.userStoppedTypingHandler = {[weak self] in
            guard let vc = self else {return}
            guard let window = vc.communitySearch.window else {return}
            for subView in window.subviews {
                if let table = subView as? UITableView {
                    if (!vc.communitySearch.text!.isEmpty){
                        vc.noResultsLabel.isHidden = (table.numberOfRows(inSection: 0) != 0)
                    } else {
                        vc.noResultsLabel.isHidden = true
                    }
                    vc.continueWithoutSchoolButton.isHidden = vc.noResultsLabel.isHidden
                }
            }
        }
        communitySearch.itemSelectionHandler = {[weak self] filteredResults, itemPosition in
            guard let vc = self else {return}
            if(itemPosition > -1){
                let item = filteredResults[itemPosition]
                let obj = CommunityListService().getCommunityFromDisplayName(displayName : item.title)!
                vc.selectedCommunity = SelectedCommunity.init(id: obj.id!, displayName: obj.displayName!, tagName: obj.tagName!)
                vc.communitySearch.text = item.title
                vc.nextButtonEnabled(status : true)
                vc.prefillCommunityName()
                vc.communitySearch.endEditing(true)
            } else {
               vc.handleTextFieldOnReturn()
            }
        }
        
    }
    
    func nextButtonEnabled(status : Bool) {
        self.nextButton.isEnabled = status
        if(status) {
            self.nextButton.backgroundColor = ColorCode.applicationBlue
        } else {
            self.nextButton.backgroundColor = ColorCode.highlightColor
        }
    }
    
    func handleTextFieldOnReturn() {
        if let community =  selectedCommunity {
            if community.displayName != communitySearch.text?.trimmingCharacters(in: .whitespacesAndNewlines) {
                selectedCommunity = nil
            }
        }
        manageNextButton()
    }
    
    func assignCommunityToSelected(){
        if link != ""{
            if link == "default"{
                selectedCommunity = SelectedCommunity(id: nil,
                                                      displayName: "Standard",
                                                      tagName: "default")
            }else{
                CommunityListService().updateCommunity(tagName: link)
                selectedCommunity = CommunityListService().getCommunityFromTagName(tagName: link)
            }
            getProvidersApiDetails()
        }
        prefillCommunityName()
    }
    
    override func viewWillAppear(_ animated: Bool) {

        super.viewWillAppear(animated)
        self.view.backgroundColor = .white
        GoogleAnalyticsUtility().startScreenTrackingForScreenName("Login & Register: Select School")
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
           self.withoutSchoolBottomConstraint.constant = keyboardSize.size.height + 10.0
           self.continueWithoutSchoolButton.isHidden = self.noResultsLabel.isHidden
        }
        UIView.animate(withDuration: 3) {
            self.nextButton.isHidden = true
            self.headerViewConstraint.constant = UIApplication.shared.statusBarFrame.size.height + 16.0
            self.view.layoutIfNeeded()
            if UIDevice.isDeviceWithHeight480() {
                self.titleLabel.text = ""
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc private func keyboardWillHide(notification: Notification) {
        UIView.animate(withDuration: 3) {
            self.withoutSchoolBottomConstraint.constant = self.defaultBottomConstraint
            self.noResultsLabel.isHidden = true
            self.nextButton.isHidden = false
            self.continueWithoutSchoolButton.isHidden = false
            self.headerViewConstraint.constant = self.headerViewDefaultConstant
            self.titleLabel.text = self.sceenTitle
            self.view.layoutIfNeeded()
        }
    }
    
    func manageNextButton() {
        if let _ = selectedCommunity {
            if selectedCommunity?.id == nil {
                nextButtonEnabled(status : false)
            }else{
                nextButtonEnabled(status : true)
            }
        } else {
            nextButtonEnabled(status : false)
        }
    }
    
    
    func prefillCommunityName() {
        if let community = selectedCommunity {
            if selectedCommunity?.id == nil {
                communitySearch.text = ""
            }else{
                self.communitySearch.text = community.displayName
            }
        }
        manageNextButton()
    }
    
    func getCommunityListFromServer(){
        activityIndicator = ActivityIndicatorView.showActivity(view: self.view, message: "Getting communities")
        CommunityListService().getCommunityListCall({[weak self] response in
            guard let vc = self else {return}
            vc.activityIndicator?.hide()
            vc.assignCommunityToSelected()
            let communityList = CommunityListService().getCommunityListFromDB()
            vc.communitySearch.filterStrings(communityList.map({$0.displayName!}))
        }, failure: {[weak self] (error,errorCode) in
            guard let vc = self else {return}
            vc.activityIndicator?.hide()
            if ErrorView.canShowForErrorCode(errorCode){
                vc.errorView = ErrorView.showOnView(vc.view, forErrorOn: nil, errorCode: errorCode, completion: {
                    vc.getCommunityListFromServer()
                })
            }else{
                CommonFunctions().showError(title: "Error", message: error)
            }
        })
    }
    
    @IBAction func standardButtonTapped(_ sender : UIButton){
        self.view.endEditing(true)
        self.communitySearch.text = ""
        selectStandardCommunity()
    }
    
    func selectStandardCommunity(){
        selectedCommunity = SelectedCommunity(id: nil,
                                              displayName: "Standard",
                                              tagName: "default")
        getProvidersApiDetails()
    }
    
    @IBAction func nextButtonTapped(_sender: UIButton){
        if selectedCommunity?.id != nil {
            GoogleAnalyticsUtility().logEvent(GoogleAnalyticsEvent(category: "Login & Register", action: "Select School", label: "Community"))
        }else{
            GoogleAnalyticsUtility().logEvent(GoogleAnalyticsEvent(category: "Login & Register", action: "Select School", label: "Standard"))
        }
        getProvidersApiDetails()
    }
    
    func getProvidersApiDetails(){
        guard let _ = selectedCommunity else {
            prefillCommunityName()
            return
        }
        activityIndicator = ActivityIndicatorView.showActivity(view: self.view, message: "Loading Community")
        ProviderServcie().providerServcieCall(link: (selectedCommunity?.tagName)!,{ response in
            if response["community"] != JSON.null{
                let communityDetails = response["community"]
                UserDefaultsDataSource(key: "link").writeData(communityDetails["community"].string)
                UserDefaultsDataSource(key: "community").writeData(communityDetails["community"].string)
                UserDefaultsDataSource(key: "communityName").writeData(communityDetails["communityName"].string)
                UserDefaultsDataSource(key: "communityLogo").writeData(communityDetails["logo"].string)
                UserDefaultsDataSource(key: "communityLogoLocal").writeData(communityDetails["logo"].string)
                UserDefaultsDataSource(key: "communityNameLocal").writeData(communityDetails["communityName"].string)
                UserDefaultsDataSource(key: "communityLocal").writeData(communityDetails["community"].string)
                UserDefaultsDataSource(key: "linkLocal").writeData(communityDetails["community"].string)
            }
            let emailAllowed = (UserDefaultsDataSource(key: "emailAllowed").readData() as? Bool) ?? false
            if emailAllowed {
                self.navigationController?.pushViewController(UIStoryboard.checkStatus(), animated: true)
            }else{
                self.navigationController?.pushViewController(UIStoryboard.ssoLogin(), animated: true)
            }
            self.activityIndicator?.hide()
        }, failure: { (error,errorCode) in
            self.activityIndicator?.hide()
            if errorCode == 404{
                (UIApplication.shared.delegate as? AppDelegate)?.checkLoginState()
            }else{
                if ErrorView.canShowForErrorCode(errorCode){
                    self.errorView = ErrorView.showOnView(self.view, forErrorOn: nil, errorCode: errorCode, completion: {
                        self.getProvidersApiDetails()
                    })
                }else{
                    CommonFunctions().showError(title: "Error", message: error)
                }
            }
        })
    }
}

extension PrefilledCommunityViewController : CommunityListViewControllerDelegate  {
    func returnSelectedCommunity(selectedCommunity: SelectedCommunity) {
        self.selectedCommunity = selectedCommunity
        prefillCommunityName()
    }
}

extension PrefilledCommunityViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handleTextFieldOnReturn()
        self.view.endEditing(true)
        return true
    }
    
}

class SelectedCommunity {
    var id: String?
    var displayName: String?
    var tagName: String?
    
    init(id: String? ,displayName: String, tagName: String) {
        self.id = id
        self.displayName = displayName
        self.tagName = tagName
    }
}
