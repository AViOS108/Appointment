//
//  BackgroundEncryptionHandler.swift
//  Resume
//
//  Created by Varun Wadhwa on 05/04/19.
//  Copyright © 2019 VM User. All rights reserved.
//

import Foundation
import CoreData

class BackgroundEncryptionHandler {
    var queue : DispatchQueue
    var aesKeys : AESKeys
    
    static var shared : BackgroundEncryptionHandler = BackgroundEncryptionHandler()
    
    var filePaths : [String] = []
 
    private init() {
        self.queue = DispatchQueue.global()
        self.aesKeys = AESKeys()
    }
 
    func getFileContent(at path : String) -> String? {
        guard let data = FileSystemDataSource(path: path, fileName: "").readData() else {return nil}
        guard let string = String(data: data, encoding: .utf8) else {return nil}
        return string
    }
    
    @discardableResult
    func write(at path : String, data : Data) -> String? {
        return FileSystemDataSource(path: path, fileName: "").writeOnExistingPath(data: data)
    }
    
    func needNotesEncryption() -> Bool {
        return true
//       let notes = Note.getNotes()
//       let filteredNotes = notes?.filter({$0.title != nil || $0.details != nil})
//       if let _ = filteredNotes , filteredNotes!.count > 0 { return true }
//       else {return false}
    }
    
    func encryptNotes() {
//       let notes = Note.getNotes()
//       notes?.forEach({ note in
//         note.detailsUI = note.details
//         note.titleUI = note.title
//       })
//       let appDelegate = (UIApplication.shared.delegate as? AppDelegate)
//       appDelegate?.saveContext()
    }
    
    func needBulkEncryption() -> Bool {
        let appVersion  = AppVersionStore()
        let status = (UserDefaultsDataSource(key: "bulkEncryptionSuccess").readData() as? Bool) ?? false
        if let lastVersion = appVersion.getLastAppVersion() , !CommonFunctions.isProvidedVersionGreater(than: "1.1.9", providedVersion: lastVersion) , !status {
            return true
        }
        return false
    }
    
    //assuming positive cases
    func encryptFiles(completion : @escaping(()->())) {
        fetchFiles()
        let group = DispatchGroup()
        for path in filePaths {
            if let content = getFileContent(at: path) {
                group.enter()
                queue.async {
                    if let data = AES(key: self.aesKeys.key, iv: self.aesKeys.iv)?.encrypt(string: content) {
                        if let _ =  self.write(at: path, data: data) {}
                    }
                    if let index = self.filePaths.index(of: path) {
                        self.filePaths.remove(at: index)
                    }
                    group.leave()
                }
            } else {
                if let index = self.filePaths.index(of: path) {
                    self.filePaths.remove(at: index)
                }
            }
        }
        
        group.notify(queue: queue, execute: { // executed after all async calls in for loop finish
           UserDefaultsDataSource(key: "bulkEncryptionSuccess").writeData(true)
           completion()
        })
        
    }
    
    private func fetchFiles() {
        var paths : [String] = []
        guard let resumeIds = fetchResumeIds() else { return }
        for resumeId in resumeIds {
            if let folderPath = getFolderPath(resumeId : resumeId) {
                let files = listFiles(ofFolder: folderPath)
                if let _ = files {
                    for file in files! {
                        let newPath = "\(resumeId)/\(file)"
                        paths.append(newPath)
                    }
                }
            }
        }
        filePaths = paths
    }

    func getFolderPath(resumeId : String) -> URL? {
        let fileMngr = FileManager.default
        if var dir = fileMngr.urls(for: .documentDirectory, in: .userDomainMask).first{
             dir.appendPathComponent(resumeId)
             return dir
        }
        return nil
    }
    
    func listFiles(ofFolder pathURL : URL ) -> [String]? {
        let fileMngr = FileManager.default
        return try? fileMngr.subpathsOfDirectory(atPath: pathURL.path)
   }
    
    func fetchResumeIds() -> [String]? {
        return [""]
//            ResumeServices().getResumesId()
    }
    
}
