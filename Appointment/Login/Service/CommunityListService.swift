//
//  CommunityListService.swift
//  Resume
//
//  Created by Manu Gupta on 06/11/17.
//  Copyright © 2017 VM User. All rights reserved.
//

import Foundation
import SwiftyJSON
import CoreData

class CommunityListService {
    
    var managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
    
    func saveContext(){
        do {
            try managedObjectContext.save()
        } catch let error as NSError {
            debugPrint("Could not save \(error), \(error.userInfo)")
        }
    }
    
    func getCommunityListCall(_ success :@escaping (JSON) -> Void,failure :@escaping (String,Int) -> Void ){
        Network().makeApiRequest(true, url: Urls().getCommunityList(), methodType: .get, params: ["":"" as AnyObject], header: ["Authorization":"Basic dGVzdDpZZ2dHRUVxOGYwYzhnYjJXRjVEM2w4MGk0VjY1cFBGaA="], completion: {
            response in
            if response["error"]["code"] != JSON.null{
                if response["error"]["errors"] != JSON.null {
                    if let keys = response["error"]["errors"].dictionary?.keys{
                        if let object = response["error"]["errors"][keys.first!].string {
                            failure(object,response["error"]["code"].int!)
                        }
                        else if let object = response["error"]["errors"][keys.first!].array ,object.count > 0 {
                            failure(object[0].string!,response["error"]["code"].int!)
                        }
                    }
                }else{
                    failure(response["error"]["message"].string!,response["error"]["code"].int!)
                }
            }else{
                if let response = response.array {
                    for community in response {
                        self.storeCommunityDetails(id: String(community["id"].int!),
                                                   tagName: community["tag_name"].string!,
                                                   displayName: community["community_name"].string!,
                                                   isMobiledDisplayEnabled: community["visible"].bool!)
                    }
                    self.saveContext()
                }

                success(response)
            }
        }
            ,failure:{ (error,errorCode) in
                failure(Network().handleErrorCases(error: error),errorCode)
        })
    }
    
    func storeCommunityDetails(id: String, tagName: String, displayName: String, isMobiledDisplayEnabled: Bool) -> Void {
        
        let communityObject = NSEntityDescription.insertNewObject(forEntityName: "CommunityList", into: managedObjectContext) as! CommunityList
        
        communityObject.id = id
        communityObject.displayName = displayName
        communityObject.isMobileEnabled = isMobiledDisplayEnabled
        communityObject.tagName = tagName
    }
    
    func getCommunityListFromDB() -> [CommunityList] {
        let fetchRequest = NSFetchRequest<CommunityList>(entityName: "CommunityList")
        fetchRequest.predicate = NSPredicate(format: "isMobileEnabled = %i ", 1)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "displayName", ascending: true ,selector: #selector(NSString.localizedCaseInsensitiveCompare))]
        do {
            let fetchResults = try managedObjectContext.fetch(fetchRequest) as [CommunityList]
            return fetchResults
        } catch  {
            fatalError("Failed to fetch community list: \(error)")
        }
    }
    
    func checkCommunityListExist() -> Bool {
        let fetchRequest = NSFetchRequest<CommunityList>(entityName: "CommunityList")
        fetchRequest.predicate = NSPredicate(format: "isMobileEnabled = %i ", 1)
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
    
    func getCommunityFromTagName(tagName: String) -> SelectedCommunity? {
        let fetchRequest = NSFetchRequest<CommunityList>(entityName: "CommunityList")
        let tagNamePredicate = NSPredicate(format: "tagName = %@ ", tagName)
        fetchRequest.predicate = tagNamePredicate
        do {
            let fetchResult = try managedObjectContext.fetch(fetchRequest) as [CommunityList]
            if let fetchedObject = fetchResult.first {
                return SelectedCommunity(id: fetchedObject.id,
                                         displayName: fetchedObject.displayName!,
                                         tagName: fetchedObject.tagName!)
            }else{
                return nil
            }
        } catch  {
            fatalError("Failed to fetch community list: \(error)")
        }
    }
    
    func getCommunityFromDisplayName(displayName: String) -> SelectedCommunity? {
        let fetchRequest = NSFetchRequest<CommunityList>(entityName: "CommunityList")
        let tagNamePredicate = NSPredicate(format: "displayName = %@ ", displayName)
        fetchRequest.predicate = tagNamePredicate
        do {
            let fetchResult = try managedObjectContext.fetch(fetchRequest) as [CommunityList]
            if let fetchedObject = fetchResult.first {
                return SelectedCommunity(id: fetchedObject.id,
                                         displayName: fetchedObject.displayName!,
                                         tagName: fetchedObject.tagName!)
            }else{
                return nil
            }
        } catch  {
            fatalError("Failed to fetch community list: \(error)")
        }
    }
    
    func updateCommunity(tagName: String){
        let fetchRequest = NSFetchRequest<CommunityList>(entityName: "CommunityList")
        let tagNamePredicate = NSPredicate(format: "tagName = %@ ", tagName)
        fetchRequest.predicate = tagNamePredicate
        do {
            let fetchResult = try managedObjectContext.fetch(fetchRequest) as [CommunityList]
            if let fetchCommunity = fetchResult.first {
                fetchCommunity.isMobileEnabled = true
            }
            saveContext()
        } catch  {
            fatalError("Failed to fetch community list: \(error)")
        }
    }
    
}
