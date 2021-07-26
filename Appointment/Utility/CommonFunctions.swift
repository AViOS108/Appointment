//
//  CommonFunctions.swift
//  Resume
//
//  Created by VM User on 30/01/17.
//  Copyright © 2017 VM User. All rights reserved.
//

import Foundation
import BRYXBanner
import SwiftMoment
import SwiftyJSON
import SDWebImage

/* ---- Updation ------
 ------DEV------------------------------UPdation-----------------------Timing----------
 -----Anurag-------------------Adding Function getAllPeopleFromContact----------------11 Dec 2019----
 */
enum ResumeFeedback {
    case good
    case average
    case bad
}

class CommonFunctions{
    
    func showError(title: String, message: String){
        DispatchQueue.main.async {
            let banner = Banner(title: title, subtitle: message, backgroundColor: ColorCode.applicationBlue)
            banner.dismissesOnTap = true
            banner.show(duration: 3.0)
        }
    }
    
    func showSuccess(title: String, message: String){
        let banner = Banner(title: title, subtitle: message, backgroundColor: ColorCode.appGreenColor)
        banner.dismissesOnTap = true
        banner.show(duration: 3.0)
    }
    
    func returnColorOnScoreBasis(resumeScore: String) -> (UIColor,String){
        var colorCode = UIColor()
        var text = String()
        switch resumeFeedback(resumeScore : Int(resumeScore)!) {
        case .good:
            colorCode = ColorCode.appGreenColor
            text = "Your resume looks good"
        case .average:
            colorCode = ColorCode.amberColor
            text = "Your resume is on track"
        default:
            colorCode = ColorCode.appRedColor
            text = "Your resume needs work"
        }
        return (colorCode,text)
    }
    
    func resumeFeedback(resumeScore : Int) -> ResumeFeedback {
        let upperCutOff = UserDefaultsDataSource(key: "resumeUpperCutoff").readData() as? Int ?? 65
        let lowerCutOff = UserDefaultsDataSource(key: "resumeLowerCutoff").readData() as? Int ?? 32
        if resumeScore >= upperCutOff{
            return .good
        }else if resumeScore > lowerCutOff && resumeScore <= upperCutOff {
            return .average
        }else{
            return .bad
        }
    }
    
    func improvementScoreTitle(resumeScore: Int) -> String {
        //Click here to
        return "view feedback".uppercased()
       // return (100-resumeScore) >= 0 ? "Improve your score by \(100-resumeScore) points".uppercased() : "Improve your score".uppercased()
    }
    
    func returnTypeFor(resumeScore: String) -> String{
        switch resumeFeedback(resumeScore : Int(resumeScore)!) {
        case .good:
            return "2"
        case .average:
            return "1"
        default:
            return "0"
        }
    }
    
    public  class func  alertViewLogout(title : String,message : String,viewController : UIViewController,buttons:[String])  {
              let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
              for string in buttons{
                  alert.addAction(UIAlertAction(title: string, style: .default, handler: { action in
                      switch action.title{
                      case "Ok":
                       viewController.navigationController?.popViewController(animated: false)
                       case "Cancel":
                       print("")
                      case .none:
                       break;
                      case .some(_):
                       break;
                      @unknown default:
                          print("destructive")
                      }}))
              }
              viewController.present(alert, animated: true, completion: nil)
          }
       
    
    func returnBulletColorOnScoreBasis(bulletScore: String) -> UIColor{
        var colorCode = UIColor()
        if Int(bulletScore) == 2 {
            colorCode = ColorCode.appGreenColor
        }else if Int(bulletScore) == 1{
            colorCode = ColorCode.amberColor
        }else{
            colorCode = ColorCode.appRedColor
        }
        
        return colorCode
    }
    
//    func removeSpecialCharsFromString(text: String) -> String {
//        var newString = text
//        do {
//            var regex = try NSRegularExpression(pattern: "\\B\\W\\B\\s", options: .caseInsensitive)
//            newString =  regex.stringByReplacingMatches(in: newString, options: [], range: NSMakeRange(0,newString.length), withTemplate: "")
//            regex = try NSRegularExpression(pattern: "\\B\\W\\B", options: .caseInsensitive)
//            return regex.stringByReplacingMatches(in: newString, options: [], range: NSMakeRange(0,newString.length), withTemplate: "")
//        } catch  {
//            return text
//        }
//    }
    
    
    func changeTintColor(imageView: UIImageView,type: Int16){
        imageView.image = imageView.image!.withRenderingMode(.alwaysTemplate)
        if type == 1{
            imageView.tintColor = ColorCode.appGreenColor
        }else if type == 0{
            imageView.tintColor = ColorCode.appRedColor
        }else{
            imageView.tintColor = ColorCode.textColor
        }
    }
    
    func provideShadow(view: UIView){
        view.layer.shadowColor = ColorCode.textColor.cgColor
        view.layer.shadowOpacity = 0.4
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 2
        view.clipsToBounds = false
    }
    
    func convertDateUsingMoment(date: String!) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        var localTimeZoneAbbreviation: String { return TimeZone.current.identifier ?? "" }

        dateFormatter.timeZone = NSTimeZone(abbreviation: localTimeZoneAbbreviation) as TimeZone?
        let resumeUploaded = moment(dateFormatter.date(from: date)!).fromNow()
        
        return resumeUploaded
    }
    
    func getMomentFromDate(_ date: Date) -> String{
        return moment(date).fromNow()
    }
    
    func userHasNoCommunity() -> Bool {
        let community = UserDefaultsDataSource(key: "community").readData() as? String
        if  community != "default" && community != "" {
            return false
        } else {
            return true
        }
    }
    
    func deleteFilesForResumeId(resumeId : String) {
        FileSystemDataSource(path: resumeId, fileName: "").removeData()
    }
    
    func writeJSON(json : JSON, toFolder folder: String, fileName:String) -> String?{
        return writeString(string: json.description, toFolder: folder, fileName: "\(fileName).json")
    }
    
    func writeString(string : String, toFolder folder: String, fileName:String) -> String? {
        let aesKeys = AESKeys()
        let key = aesKeys.key
        let iv = aesKeys.iv
        if let data = AES(key: key, iv: iv)?.encrypt(string: string) {
            return FileSystemDataSource(path: folder, fileName: fileName).writeData(data)
        } else {
            return nil
        }
    }
    
    func readJSON(fromFilePath path : String) -> JSON?{
        if let string = readString(fromFilePath: path) { return JSON(parseJSON: string) }
        return nil
    }
    
    func readString(fromFilePath path : String) -> String?{
        guard let data = FileSystemDataSource(path: path, fileName: "").readData() else {
            return nil
        }
        //check if file is plain text for older versions
        guard let string = String(data: data, encoding: .utf8) else {
            let aesKeys = AESKeys()
            let key = aesKeys.key
            let iv = aesKeys.iv
            return AES(key: key, iv: iv)?.decrypt(data: data)
        }
        return string
    }
    
//    func makeUserObjectAndReturn(name: String!,email: String, networkType: String, selected: Bool) -> UserNetwork{
//        let userNetworkObject = UserNetwork()
//        userNetworkObject.name = name
//        userNetworkObject.email = email
//        userNetworkObject.addToNfEmailSource(ReviewerDatabaseManagement().returnNfEmailSourceForString(source: networkType))
//        userNetworkObject.selected = selected
//        return userNetworkObject
//    }
    
    func returnInitials(name: String) -> String{
        let name = name.components(separatedBy: " ")
        var initials = ""
        for (index, value) in name.enumerated() {
            if let f = value.first, index < 2{
                initials = initials + "\(f)"
            }
        }
        return initials
    }
    
    func changeDateFormat(date: NSDate) -> String{
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let resultString = inputFormatter.string(from: date as Date)
        return resultString
    }
    
//    func stringFromHtml(string: String) -> NSAttributedString? {
//        do {
//            let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
//            if let d = data {
//                let str = try NSAttributedString(data: d,
//                                                 options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,NSFontAttributeName: UIFont(name: "SanFranciscoText-Regular",size: 16.0)!,
//                                                           NSForegroundColorAttributeName: ColorCode.textColor], documentAttributes: nil)
//                return str
//            }
//        } catch {
//        }
//        return nil
//    }
    
    func canOpenURL(string: String?) -> Bool {
        guard let urlString = string else {
            return false
        }
        guard let url = NSURL(string: urlString) else {
            return false
        }
        if !UIApplication.shared.canOpenURL(url as URL) {
            return false
        }
        
        let regEx = "((https|http)://)((\\w|-)+)(([.]|[/])((\\w|-)+))+"
        let predicate = NSPredicate(format:"SELF MATCHES %@", argumentArray:[regEx])
        return predicate.evaluate(with: string)
    }
    
    func assignbackground(view: UIView){
        let background = #imageLiteral(resourceName: "vmock")
        var imageView : UIImageView!
        imageView = UIImageView(frame: view.bounds)
        imageView.contentMode =  UIView.ContentMode.scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = background
        imageView.center = view.center
        view.addSubview(imageView, withInsetConstraints: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
    }
    
    func loadLogo(imageView: UIImageView, enclosingView: UIView,logo: String?) {
        let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        activityIndicator.hidesWhenStopped = true
        imageView.bringSubviewToFront(activityIndicator)
        imageView.addSubview(activityIndicator, withInsetConstraints: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))

        activityIndicator.style = .gray

//        if #available(iOS 13.0, *) {
//            activityIndicator.style = .gray
//        } else {
//            activityIndicator.style = .white
//
//        }
        
        let classSize = UIScreen.main.traitCollection
        for constraint in enclosingView.constraints {
            if classSize.horizontalSizeClass == .regular && classSize.verticalSizeClass == .regular {
                if constraint.identifier == "enclosingWidth"{
                    constraint.constant = 150
                }else if constraint.identifier == "enclosingHeight"{
                    constraint.constant = 150
                }else{
                    constraint.constant = 22
                }
                enclosingView.layer.cornerRadius = 75
            }else{
                if constraint.identifier == "enclosingWidth"{
                    constraint.constant = 100
                }else if constraint.identifier == "enclosingHeight"{
                    constraint.constant = 100
                }else{
                    constraint.constant = 14.5
                }
                enclosingView.layer.cornerRadius = 50
            }
        }
        for constraint in (enclosingView.superview?.constraints)! {
            if classSize.horizontalSizeClass == .regular && classSize.verticalSizeClass == .regular {
                if constraint.identifier == "enclosingTop"{
                    constraint.constant = -75
                }
            }else{
                if constraint.identifier == "enclosingTop"{
                    constraint.constant = -50
                }
            }
        }
        let sdDownloader = SDWebImageDownloader.shared
        #if DEVELOPMENT
//        sdDownloader.username = "test"
//        sdDownloader.password = "wmL4NdnYPPXZiUVAmt3uPZYH2cyULuYK"
        #endif
        activityIndicator.startAnimating()
        if let logoURL = logo, let url = URL(string: logoURL) {
            sdDownloader.downloadImage(with: url, options: .useNSURLCache, progress: { (_, _, _) in
                
            }, completed: { (image, _, _, _) in
                enclosingView.layer.borderColor = ColorCode.textColor.cgColor
                enclosingView.layer.borderWidth = 1
                if let image = image{
                    imageView.image = image
                }
                activityIndicator.stopAnimating()
            })
        }
        
    }
    
    
    func loadLogo(communityName: UILabel,imageView: UIImageView, enclosingView: UIView,logo: String?,communityLogoName: String?) {
        let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        activityIndicator.hidesWhenStopped = true
        imageView.bringSubviewToFront(activityIndicator)
        imageView.addSubview(activityIndicator, withInsetConstraints: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        activityIndicator.style = .gray
        if communityLogoName?.lowercased() == "vmock default" || communityLogoName == "" {
            enclosingView.backgroundColor = UIColor.clear
            enclosingView.layer.borderWidth = 0
            communityName.text = ""
            assignbackground(view: enclosingView)
            return
        }else{
            let classSize = UIScreen.main.traitCollection
            for constraint in enclosingView.constraints {
                if classSize.horizontalSizeClass == .regular && classSize.verticalSizeClass == .regular {
                    if constraint.identifier == "enclosingWidth"{
                        constraint.constant = 150
                    }else if constraint.identifier == "enclosingHeight"{
                        constraint.constant = 150
                    }else{
                        constraint.constant = 22
                    }
                    enclosingView.layer.cornerRadius = 75
                }else{
                    if constraint.identifier == "enclosingWidth"{
                        constraint.constant = 100
                    }else if constraint.identifier == "enclosingHeight"{
                        constraint.constant = 100
                    }else{
                        constraint.constant = 14.5
                    }
                    enclosingView.layer.cornerRadius = 50
                }
            }
            for constraint in (enclosingView.superview?.constraints)! {
                if classSize.horizontalSizeClass == .regular && classSize.verticalSizeClass == .regular {
                    if constraint.identifier == "enclosingTop"{
                        constraint.constant = -75
                    }
                }else{
                    if constraint.identifier == "enclosingTop"{
                        constraint.constant = -50
                    }
                }
            }
            let sdDownloader = SDWebImageDownloader.shared
            #if DEVELOPMENT
//                sdDownloader.username = "test"
//                sdDownloader.password = "wmL4NdnYPPXZiUVAmt3uPZYH2cyULuYK"
            #endif
            activityIndicator.startAnimating()
            if let logoURL = logo, let url = URL(string: logoURL) {
                sdDownloader.downloadImage(with: url, options: .useNSURLCache, progress: { (_, _, _) in
                    
                }, completed: { (image, _, _, _) in
                    communityName.text = communityLogoName
                    enclosingView.layer.borderColor = ColorCode.textColor.cgColor
                    enclosingView.layer.borderWidth = 1
                    if let image = image{
                        imageView.image = image
                    }
                    activityIndicator.stopAnimating()
                })
            }
        }
    }
    
    func changeLinkLocalToGlobal(){
        let communityLogoLocal = UserDefaultsDataSource(key: "communityLogoLocal").readData()
        let communityNameLocal = UserDefaultsDataSource(key: "communityNameLocal").readData()
        let communityLocal = UserDefaultsDataSource(key: "communityLocal").readData()
        let linkLocal = UserDefaultsDataSource(key: "linkLocal").readData()
        
        UserDefaultsDataSource(key: "link").writeData(linkLocal as? String)
        UserDefaultsDataSource(key: "community").writeData(communityLocal as? String)
        UserDefaultsDataSource(key: "communityName").writeData(communityNameLocal as? String)
        UserDefaultsDataSource(key: "communityLogo").writeData(communityLogoLocal as? String)
    }
    
    func changeLinkGlobalToLocal(){
        let communityLogoGlobalLocal = UserDefaultsDataSource(key: "communityLogo").readData()
        let communityNameGlobal = UserDefaultsDataSource(key: "communityName").readData()
        let communityGlobal = UserDefaultsDataSource(key: "community").readData()
        let linkGlobal = UserDefaultsDataSource(key: "link").readData()
        UserDefaultsDataSource(key: "linkLocal").writeData(linkGlobal as? String)
        UserDefaultsDataSource(key: "communityLocal").writeData(communityGlobal as? String)
        UserDefaultsDataSource(key: "communityNameLocal").writeData(communityNameGlobal as? String)
        UserDefaultsDataSource(key: "communityLogoLocal").writeData(communityLogoGlobalLocal as? String)
    }
    
    class func checkIfAlreadyLogin() -> Bool {
        let loggedInStatus = (UserDefaultsDataSource(key: "loggedIn").readData() as? Bool) ?? false
        let detailsRequired = (UserDefaultsDataSource(key: "areDetailsRequired").readData() as? Bool) ?? false
        return loggedInStatus && !detailsRequired
    }
    
//    func returnTagArrayForBullet() -> [TagListNotes]{
//        var tagArray: [TagListNotes] = [TagListNotes]()
//        tagArray.append(TagListNotes(text: DefaultTag.bulletFeedback.rawValue,
//                                     selected: true))
//        return tagArray
//    }
    
    class func getAppVersion() -> String? {
        return Bundle.main.releaseVersionNumber
    }
    
    class func getComponents(_ version : String) -> [String] {
        return version.components(separatedBy: ".")
    }
    
    class func isProvidedVersionGreater(than appVersion : String? = CommonFunctions.getAppVersion() , providedVersion : String) -> Bool {
        guard let appVersion = appVersion else { return false }
        let providedVersionArray = getComponents(providedVersion)
        let appVersionArray = getComponents(appVersion)
        for index in 0 ... appVersionArray.count - 1{
            guard let providedInt = Int(providedVersionArray[index]), let appInt = Int(appVersionArray[index]) else{break}
            if providedInt == appInt {continue}
            return providedInt > appInt
        }
        return false
    }
    
    
//    class func getAllPeopleFromContact() ->  [CNContact]  {
//        let store = CNContactStore()
//        var contacts = [CNContact]()
//        let keysToFetch = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey, CNContactEmailAddressesKey, CNContactOrganizationNameKey, CNContactImageDataKey]
//        let request = CNContactFetchRequest(keysToFetch: keysToFetch as [CNKeyDescriptor])
//        do {
//            try store.enumerateContacts(with: request) { contact, stop in
//
//                contacts.append(contact)
//            }
//
//            
//        } catch {
//            print(error)
//        }
//
//        return contacts;
//
//    }
    
    
}
