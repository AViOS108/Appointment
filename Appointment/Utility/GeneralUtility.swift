//
//  GeneralUtility.swift
//  Event
//
//  Created by Anurag Bhakuni on 15/01/20.
//  Copyright © 2020 Anurag Bhakuni. All rights reserved.
//

import Foundation
import UIKit

import  Reachability
struct Device {
    // iDevice detection code
    static let IS_IPAD                        = UIDevice.current.userInterfaceIdiom == .pad
    static let IS_IPHONE                      = UIDevice.current.userInterfaceIdiom == .phone
    static let IS_RETINA                      = UIScreen.main.scale >= 2.0
    static let SCREEN_WIDTH                   = Int(UIScreen.main.bounds.size.width)
    static let SCREEN_HEIGHT                  = Int(UIScreen.main.bounds.size.height)
    static let SCREEN_MAX_LENGTH                 = Int( max(SCREEN_WIDTH, SCREEN_HEIGHT) )
    static let SCREEN_MIN_LENGTH   = Int( min(SCREEN_WIDTH, SCREEN_HEIGHT) )
    static let IS_IPHONE_4_OR_LESS = IS_IPHONE && SCREEN_MAX_LENGTH  < 568
    static let IS_IPHONE_5         = IS_IPHONE && SCREEN_MAX_LENGTH == 568
    static let IS_IPHONE_6         = IS_IPHONE && SCREEN_MAX_LENGTH == 667
    static let IS_IPHONE_6P        = IS_IPHONE && SCREEN_MAX_LENGTH == 736
    static let IS_IPHONE_X         = IS_IPHONE && SCREEN_MAX_LENGTH >= 812
    static let FONTSIZETYPE8 :  CGFloat        = 8
    static let FONTSIZETYPE10 : CGFloat        = 10
    static let FONTSIZETYPE11 : CGFloat        = 11
    static let FONTSIZETYPE12 : CGFloat        = 12
    static let FONTSIZETYPE13 : CGFloat        = 13
    static let FONTSIZETYPE14 : CGFloat        = 14
    static let FONTSIZETYPE15 : CGFloat        = 15
    static let FONTSIZETYPE16 : CGFloat        = 16
    static let FONTSIZETYPE17 : CGFloat        = 17
    static let FONTSIZETYPE18 : CGFloat        = 18
    static let FONTSIZETYPE20 : CGFloat        = 20
    static let FONTSIZETYPE30 : CGFloat        = 30

}

struct ParamName {
    static let PARAMCSRFTOKEN = "csrf_token"
    static let PARAMRSVP = "rsvp"
    static let PARAMSORTEL = "sort"
    static let PARAMFIELDEL = "field"
    static let PARAMORDEREL = "order"
    static let PARAMINTIMEZONEEL = "in_timezone"
    static let PARAMFILTERSEL = "filters"
    static let PARAMFILTERSFROMEL = "from"
    static let PARAMFILTERSTOEL = "to"
    static let PARAMFILTERSTAKEEL = "take"
    static let PARAMFILTERSSKIPEL = "skip"
    static let PARAMEXPANDRECCURENCEEL = "expand_reccurence"
    static let PARAMEXPANDSESSIONEL = "expand_sessions"
    static let PARAMSTATUSEL = "status"
    static let PARAMERLOGINTOKENC = "token"
    static let PARAMERLOGINTOKENSC = "tokens"

    
    static let PARAMERLOGINCAPTCHACHALLENGE = "CaptchaChallenge"
    static let PARAMERLOGINCAPTCHACHALLENGEID = "id"
    static let PARAMERLOGINCAPTCHACHALLENGEIMAGE = "image"
    static let PARAMERLOGINCAPTCHACHALLENGEACCOUNTUNLOCK = "AccountUnlockChallenge"
    static let PARAMERLOGINCAPTCHACHALLENGEATTEMPTLEFT = "attempts_left"
    static let PARAMERLOGINCAPTCHACHALLENGEATTEMPTCONSUMED = "attempts_consumed"
    static let PARAMERLOGINCAPTCHACHALLENGEATTEMPTCHALLLENGES = "challenges"
    static let PARAMERLOGINERROR = "error"
    static let PARAMERLOGINERRORS = "errors"
    static let PARAMERLOGINMESSAGE = "message"
    static let PARAMERLOGINID = "loginId"
    static let PARAMERLOGINMARKER = "marker"
    static let PARAMERLOGINPARTICIANT = "participant"
    }

class GeneralUtility {
    
     class func customeNavigationBarTextfield(viewController: UIViewController, searchText : String){
            let backButton = UIButton(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
            backButton.contentMode = .scaleAspectFit
            //        backButton.backgroundColor = .red
            backButton.addTarget(viewController, action: #selector(SuperViewController.changeNavigation(sender:)), for: .touchUpInside)
            backButton.setImage(UIImage.init(named: "delete"), for: .normal)
            let back =  UIBarButtonItem(customView: backButton)
            let searchBar:UISearchBar = UISearchBar.init(frame: CGRect.init(x: 0, y: 0, width: 0, height: 10))
            searchBar.searchBarStyle = UISearchBar.Style.prominent
            if #available(iOS 13.0, *) {
                searchBar.searchTextField.clearButtonMode = .never
                searchBar.searchTextField.backgroundColor = .white

            } else {

            }
            searchBar.text = searchText
            searchBar.placeholder = "Search Coaches/Alumini"
            searchBar.sizeToFit()
            //        searchBar.isTranslucent = false
            searchBar.backgroundImage = UIImage()
            searchBar.delegate = viewController as? UISearchBarDelegate
            viewController.navigationController?.navigationBar.topItem?.titleView = searchBar  ;
            viewController.navigationController?.navigationBar.topItem?.setRightBarButtonItems([back], animated: true)
    //        let bounds = viewController.navigationController!.navigationBar.bounds
    //        viewController.navigationController?.navigationBar.frame = CGRect(x: 0, y: 0, width: bounds.width, height: 64)
        }
    
    
    class func customeNavigationBar(viewController: UIViewController,title:String){
        
        //search_white
        let searchButton = UIButton(frame: CGRect(x: 0, y: 0, width: 20, height: 15))
        searchButton.contentMode = .scaleAspectFit
        //        searchButton.backgroundColor = .red
        searchButton.addTarget(viewController, action: #selector(SuperViewController.searchEvent(sender:)), for: .touchUpInside)
        searchButton.setImage(UIImage.init(named: "Searrch_white"), for: .normal)
        let search =  UIBarButtonItem(customView: searchButton)
        
        
        let calenderButton = UIButton(frame: CGRect(x: 0, y: 0, width: 20, height: 15))
        calenderButton.contentMode = .scaleAspectFit
        //        searchButton.backgroundColor = .red
        calenderButton.addTarget(viewController, action: #selector(SuperViewController.calenderClicked(sender:)), for: .touchUpInside)
        calenderButton.setImage(UIImage.init(named: "Calendar"), for: .normal)
        let calender =  UIBarButtonItem(customView: calenderButton)
        let hamburger = UIButton(frame: CGRect(x: 0, y: 0, width: 20, height: 15))
        hamburger.contentMode = .scaleAspectFit
        //        searchButton.backgroundColor = .red
        hamburger.addTarget(viewController, action: #selector(SuperViewController.humbergerCilcked(sender:)), for: .touchUpInside)
        hamburger.setImage(UIImage.init(named: "humberger"), for: .normal)
        let slider =  UIBarButtonItem(customView: hamburger)
        viewController.navigationController?.navigationBar.topItem?.titleView = nil  ;
        
        viewController.navigationController?.navigationBar.topItem?.setRightBarButtonItems([search,calender], animated: true)
        viewController.navigationController?.navigationBar.topItem?.setLeftBarButtonItems([slider], animated: true)
        
        viewController.navigationController?.navigationBar.topItem?.title = title;
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        viewController.navigationController?.navigationBar.titleTextAttributes = textAttributes
        viewController.navigationController?.navigationBar.barTintColor = ILColor.color(index: 8);
        
        //        let bounds = viewController.navigationController!.navigationBar.bounds
        //        viewController.navigationController?.navigationBar.frame = CGRect(x: 0, y: 0, width: bounds.width, height: 64)
        
    }
    
    
    class func customeNavigationBarWithBack(viewController: UIViewController,title:String){
        let back = UIBarButtonItem(title: title, style: .plain, target: viewController, action: #selector(SuperViewController.buttonClicked(sender:)));
        back.image = UIImage.init(named: "Back");
        viewController.navigationItem.leftBarButtonItems = [back];
        
        let calenderButton = UIButton(frame: CGRect(x: 0, y: 0, width: 20, height: 15))
        calenderButton.contentMode = .scaleAspectFit
        //        searchButton.backgroundColor = .red
        calenderButton.addTarget(viewController, action: #selector(SuperViewController.calenderClicked(sender:)), for: .touchUpInside)
        calenderButton.setImage(UIImage.init(named: "Calendar"), for: .normal)
        let calender =  UIBarButtonItem(customView: calenderButton)
        viewController.navigationItem.rightBarButtonItems = [calender];
        
        viewController.navigationController?.navigationBar.isTranslucent = true
//        viewController.navigationController?.navigationBar.topItem?.title = title;
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        viewController.navigationController?.navigationBar.titleTextAttributes = textAttributes
        viewController.navigationController?.navigationBar.barTintColor = ILColor.color(index: 8);
    }
    
    
    
    public class func optionalHandling<T>(_param: T!, _returnType: T.Type) -> T {
        if let value = _param {
            return value
        }
        else if _returnType is String.Type {
            return "" as! T
        }else if _returnType is Int.Type {
            return 0 as! T
        }else if _returnType is Bool.Type {
            return false as! T
        }else if _returnType is Int64.Type {
            return 0 as! T
        }else{
            return "" as! T
        }
    }
    
    public class func reachablity() -> Bool{
        
        let reachability = try! Reachability()
        
        reachability.whenReachable = { reachability in
            return true
        }
        reachability.whenUnreachable = { _ in
            return false;
        }
        
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
        
        return true;
        
    }
    
    
    public  class func  alertView(title : String,message : String,viewController : UIViewController,buttons:[String])  {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.view.tag = 10012;
        for string in buttons{
            alert.addAction(UIAlertAction(title: string, style: .default, handler: { action in
                switch action.style{
                case .default:
                    print("default")
                    
                case .cancel:
                    print("cancel")
                    
                case .destructive:
                    print("destructive")
                @unknown default:
                    print("destructive")
                }}))
        }
        
        viewController.present(alert, animated: true, completion: nil)
    }
    
    
    
    public  class func  alertViewLogout(title : String,message : String,viewController : UIViewController,buttons:[String])  {
           let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
           for string in buttons{
               alert.addAction(UIAlertAction(title: string, style: .default, handler: { action in
                   switch action.title{
                   case "Ok":
                    LogoutHandler.logout(removeEmail: true);
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
    
    
    
    public  class func   currentDate(emiDate : String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//        var localTimeZoneAbbreviation: String { return TimeZone.current.abbreviation() ?? "" }
//
//        dateFormatter.timeZone = TimeZone(abbreviation: localTimeZoneAbbreviation)
        let date = dateFormatter.date(from: emiDate)
        dateFormatter.dateFormat = "MMM dd, yyyy hh:mm a "
        if let dateF  = date{
            return dateFormatter.string(from: dateF)
        }
        return ""
    }
    
    
    public  class func   remaining1Hour(emiDate : String) -> Dictionary<String,Int> {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//        var localTimeZoneAbbreviation: String { return TimeZone.current.abbreviation() ?? "" }
//
//        dateFormatter.timeZone = TimeZone(abbreviation: localTimeZoneAbbreviation)
        let date = dateFormatter.date(from: emiDate)
        var dictionaryT : Dictionary<String,Int>;
        var minutes : Int = 1000;
        if let eventStartDate = date {
            minutes =  Calendar.current.dateComponents([.minute], from:Date() , to:eventStartDate ).minute ?? 0;
            if minutes <= 60 && minutes > 0{
                dictionaryT = ["minutes" : minutes ,
                               "ishours" : 1 ];
            }
            else if minutes < 0{
                dictionaryT = ["minutes" : 0 ,
                "ishours" : 0 ];
            }
            else{
                dictionaryT = ["minutes" : 0 ,
                               "ishours" : 0 ];
            }
            
        }else{
            dictionaryT = ["minutes" : 0 ,
                           "ishours" : 0 ];
        }
        
        return dictionaryT
    }
    
    
    public  class func   eventEnded(emiDate : String) -> Bool{
          let dateFormatter = DateFormatter()
          dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//        var localTimeZoneAbbreviation: String { return TimeZone.current.abbreviation() ?? "" }
//
//          dateFormatter.timeZone = TimeZone(abbreviation: localTimeZoneAbbreviation)
          let date = dateFormatter.date(from: emiDate)
          var dictionaryT : Dictionary<String,Int>;
          var minutes : Int = 1000;
          if let eventStartDate = date {
              minutes =  Calendar.current.dateComponents([.minute], from:Date() , to:eventStartDate ).minute ?? 0;
             if minutes < 0{
                  return true
              }
              else{
                  return false

              }
        }
         return false

      }
      
    
    
    
    
    
    
    public  class func   currentDateDetail(emiDate : String) -> String {
        let dateFormatter = DateFormatter()
        let dateFormatter1 = DateFormatter()

        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//        var localTimeZoneAbbreviation: String { return TimeZone.current.abbreviation() ?? "" }
//
//        dateFormatter.timeZone = TimeZone(abbreviation: localTimeZoneAbbreviation)
        let date = dateFormatter.date(from: emiDate)
        dateFormatter.dateFormat = "MMM dd, yyyy"
        
        dateFormatter1.dateFormat  = "EE" // "EE" to get short style
        if let dateF  = date{
            let dayInWeek = dateFormatter1.string(from: date!)
            return "\(dayInWeek), \(dateFormatter.string(from: dateF) )"
        }
        return ""
    }
    public  class func   currentDateDetailType2(emiDate : String) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//        var localTimeZoneAbbreviation: String { return TimeZone.current.abbreviation() ?? "" }
//
//        dateFormatter.timeZone = TimeZone(abbreviation: localTimeZoneAbbreviation)
        let date = dateFormatter.date(from: emiDate)
        dateFormatter.dateFormat = "hh:mm a"
        if let dateF  = date{
            return dateFormatter.string(from: dateF)
        }
        
        return ""
    }
    
    public  class func   currentDateDetailType3(emiDate : String) -> String {
        
        let dateString = emiDate
        var formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let token = UserDefaultsDataSource(key: "timeZoneOffset").readData() as! String

        formatter.timeZone = TimeZone.init(abbreviation: "UTC")

        

        
        var localTimeZoneAbbreviation: String { return TimeZone.current.abbreviation() ?? "" }
        if let date = formatter.date(from: dateString) {
            
            formatter.timeZone = TimeZone.init(identifier: token)
            formatter.dateFormat = "hh:mm a"
            return formatter.string(from: date)
        }
      
        return ""
    }
    
    
    public  class func   monthFromGivenDate(emiDate : String) -> String {
          
            let dateFormatter = DateFormatter()
           dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//        var localTimeZoneAbbreviation: String { return TimeZone.current.abbreviation() ?? "" }
//
//           dateFormatter.timeZone = TimeZone(abbreviation: localTimeZoneAbbreviation)
           let date = dateFormatter.date(from: emiDate)
           dateFormatter.dateFormat = "MMM"
           if let dateF  = date{
               return dateFormatter.string(from: dateF)
           }
           return ""
       }
    
    
    
    
    
    public  class func   dateFromGivenDate(emiDate : String) -> String {
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//        var localTimeZoneAbbreviation: String { return TimeZone.current.abbreviation() ?? "" }
//
//            dateFormatter.timeZone = TimeZone(abbreviation: localTimeZoneAbbreviation)
            let date = dateFormatter.date(from: emiDate)
            dateFormatter.dateFormat = "dd"
            
            if let dateF  = date{
                return dateFormatter.string(from: dateF)
            }
            
            return ""
        }
    
    
    
    public  class func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    
    
  public  class  func  startNameCharacter(stringName : String) -> String {
        guard stringName != nil else {
            return ""
        }
        let whitespace = NSCharacterSet.whitespaces
        var Intial = ""
        let range = stringName.rangeOfCharacter(from: whitespace)
        if range != nil {
            let arrayName = stringName.split(separator: " ");
            if arrayName.count >= 2{
                if arrayName[0].count > 0 {
                    Intial =    String(arrayName[0].first!)
                }
                if arrayName[1].count > 0 {
                    Intial = Intial + String(arrayName[1].first!)
                }
            }
            else if  arrayName.count >= 1{
                
                if arrayName[0].count > 0 {
                    Intial = String(arrayName[0].first!)
                               
                }
            }
            
            var upper = "\(Intial)".uppercased() ;
            return upper
        }
        else {
            var upper = "\(String(stringName.first!))" ;

            return upper.uppercased()
        }
    }
    
    func getCurrentTimeZone() -> String{

        return  TimeZone.current.identifier

    }
    
    func currentOffset() -> String {
        let hours = TimeZone.current.secondsFromGMT()/3600
        let minutes = abs(TimeZone.current.secondsFromGMT()/60) % 60
        let tz_hr = String(format: "%+.2d:%.2d", hours, minutes) // "+hh:mm"
        return "UTC "+tz_hr
    }
    
    
}
