//
//  DashBoardViewModel.swift
//  Appointment
//
//  Created by Anurag Bhakuni on 18/08/20.
//  Copyright © 2020 Anurag Bhakuni. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class DashBoardViewModel  {
    var managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
    
    var viewController : UIViewController!
    var activityIndicator: ActivityIndicatorView?
    
    
    func fetchCall(params: Dictionary<String,AnyObject>,success:@escaping (DashBoardModel) -> Void,failure:@escaping (String,Int) -> Void)
    {
        activityIndicator = ActivityIndicatorView.showActivity(view: viewController.navigationController!.view, message: StringConstants.coachInfoApiLoader)
        
        DashboardService().coachListApi(params: params, { (jsonData) in
            
            self.activityIndicator?.hide()
            
            do{
                var welcome = try JSONDecoder().decode(DashBoardModel.self, from: jsonData)
                let welcomeI = welcome.coaches.sorted(by: { $0.name.lowercased() < $1.name.lowercased() })
                    welcome.coaches.removeAll()
                    welcome.coaches.append(contentsOf: welcomeI)
                    success(welcome)
                    
                
            }catch{
                print("Unable to load data: \(error)")
                CommonFunctions().showError(title: "Error", message: ErrorMessages.SomethingWentWrong.rawValue)
            }
            
            
        }) { (error, errorCode) in
            self.activityIndicator?.hide()
            CommonFunctions().showError(title: "Error", message: ErrorMessages.SomethingWentWrong.rawValue)
        }
        
    }
    
    
    func errorHandler(error: String,errorCode: Int, params: Dictionary<String,AnyObject>,headerIncluded: Bool,header: Dictionary<String,String>){
        self.activityIndicator?.hide()
        CommonFunctions().showError(title: "Error", message: error)
    }
    
    
    func fetchTimeZoneCall(success :@escaping ([TimeZoneSel]) -> Void)
    {
        
        if self.checkTimeZoneListExist(){
            success(self.getTimeZoneListFromDB())
            return
        }
        else
        {
            activityIndicator = ActivityIndicatorView.showActivity(view: viewController.navigationController!.view, message: StringConstants.FetchingCoachSelection)

        }
        
        let param : Dictionary<String, AnyObject> = ["":""] as Dictionary<String, AnyObject>
        DashboardService().timezone(params: param, { (jsonData) in
            let timeZoneArr = try? JSONDecoder().decode(TimeZoneArr.self, from: jsonData)
            self.activityIndicator?.hide()
            
            self.deleteTimeZone()
            for timeZOne in timeZoneArr!{
                self.storeTimeDetails(timeZone: timeZOne)
                 self.saveContext()
            }
              
            success(self.getTimeZoneListFromDB())
           
            
            
        }) { (error, errorCode) in
            self.activityIndicator?.hide()

        }
    }
    
    func saveContext(){
        do {
            try managedObjectContext.save()
        } catch let error as NSError {
            debugPrint("Could not save \(error), \(error.userInfo)")
        }
    }
    
    
    func storeTimeDetails(timeZone : TimeZoneModal)  {
        
        let timeZoneObject = NSEntityDescription.insertNewObject(forEntityName: "TimeZoneSel", into: managedObjectContext) as! TimeZoneSel
        
        timeZoneObject.displayName = timeZone.displayName
        timeZoneObject.group = timeZone.group
        timeZoneObject.identifier = timeZone.identifier
        timeZoneObject.offset = timeZone.offset
        timeZoneObject.keywords = timeZone.keywords
    }
    
    
    func getTimeZoneListFromDB() -> [TimeZoneSel] {
        let fetchRequest = NSFetchRequest<TimeZoneSel>(entityName: "TimeZoneSel")
        do {
            var timeZone:[TimeZoneSel]? = nil
            let nameSort = NSSortDescriptor(key:"displayName", ascending:true)
            fetchRequest.sortDescriptors = [nameSort]
            
            do {
                timeZone = try managedObjectContext.fetch(fetchRequest) as [TimeZoneSel]
                return timeZone!
            } catch {
                return timeZone!
            }
        } catch  {
            fatalError("Failed to fetch community list: \(error)")
        }
    }
    
    func checkTimeZoneListExist() -> Bool {
        let fetchRequest = NSFetchRequest<TimeZoneSel>(entityName: "TimeZoneSel")
        do {
            let fetchResultsCount = try managedObjectContext.fetch(fetchRequest).count
            if fetchResultsCount > 0{
                return true
            }
        } catch  {
            fatalError("Failed to fetch community list: \(error)")
        }
        return false
    }
    
    func deleteTimeZone(){
           let fetchRequest = NSFetchRequest<TimeZoneSel>(entityName: "TimeZoneSel")
           do {
               let objects = try managedObjectContext.fetch(fetchRequest)
               for object in objects {
                   managedObjectContext.delete(object)
                  saveContext()
               }
             
           } catch {
               
           }
       }
    func filterTimeZone(text:String) -> [TimeZoneSel] {
           let fetchRequest = NSFetchRequest<TimeZoneSel>(entityName: "TimeZoneSel")
           do {
               var timeZone:[TimeZoneSel]? = nil
               let nameSort = NSSortDescriptor(key:"displayName", ascending:true)
               fetchRequest.sortDescriptors = [nameSort]
            if text != ""
            {
               fetchRequest.predicate = NSPredicate(format: "displayName BEGINSWITH[c] %@", text)
            }
               do {
                   timeZone = try managedObjectContext.fetch(fetchRequest) as [TimeZoneSel]
                   return timeZone!
               } catch {
                   return timeZone!
               }
           } catch  {
               fatalError("Failed to fetch community list: \(error)")
           }
       }
    
}
