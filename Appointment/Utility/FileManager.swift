//
//  FileManager.swift
//  Resume
//
//  Created by Varun Wadhwa on 01/04/19.
//  Copyright © 2019 VM User. All rights reserved.
//
import Foundation

enum FileType : String {
    case pdf = ".pdf"
    case png = ".png"
}

class FileSystemDataSource {
    
    public var path : String
    public let fileName : String
    public let fileManager = FileManager.default
    
    init(path : String , fileName : String) {
        self.path = path
        self.fileName = fileName
    }
    
    convenience init(path: String) {
        self.init(path: path, fileName: "")
    }
    
    //deafult path will be set
    convenience init(fileName: String) {
        self.init(path: "", fileName: fileName)
    }
    
    //init to call helper methods on FileManager.default
    convenience init() {
        self.init(path: "", fileName: "")
    }
    
    func readData() -> Data? {
        if let dir = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first{
            let path = dir.appendingPathComponent(self.path)
            do {
                let data = try Data(contentsOf: path)
                return data
            }
            catch {/* error handling here */}
        }
        return nil
    }
    
    func writeData(_ data: Data) -> String? {
        if let dir = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first{
            var newPath : URL
            if !path.isEmpty{
                newPath = URL(fileURLWithPath: path, relativeTo: dir)
                if !fileManager.fileExists(atPath: newPath.path){
                    // file does not exist
                    do {
                        try fileManager.createDirectory(atPath: newPath.path, withIntermediateDirectories: true, attributes: nil)
                    } catch let error as NSError {
                        debugPrint(error.localizedDescription);
                    }
                }
                newPath.appendPathComponent("\(fileName)")
            }
            else{
                newPath = URL(fileURLWithPath: "\(fileName)", relativeTo: dir)
            }
            //writing
            do {
                try data.write(to: newPath)
                return newPath.relativeString
            }
            catch {/* error handling here */
                return nil
            }
        }
        return nil
    }
    
    func writeOnExistingPath(data: Data) -> String? {
        if let dir = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first{
            var newPath : URL
            if !path.isEmpty{
                newPath = URL(fileURLWithPath: path, relativeTo: dir)
                do {
                    try data.write(to: newPath)
                    return newPath.relativeString
                }
                catch {/* error handling here */
                    return nil
                }
            }
            else{
               return nil
            }
        }
        return nil
    }
    
    func removeData() {
        guard let dir = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return
        }
        var path : URL
        path = URL(fileURLWithPath: self.path, relativeTo: dir)
        if fileManager.fileExists(atPath: path.path)
        {
            do {
                try fileManager.removeItem(at: path)
            } catch let error as NSError {
                debugPrint(error.localizedDescription);
            }
        }
    }
    
    static func removeFile(type : FileType) {
        let fileManager = FileManager.default
        guard let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.path else {
            return
        }
        do {
            let fileNames = try fileManager.contentsOfDirectory(atPath: "\(documentPath)")
            for fileName in fileNames {
                if (fileName.hasSuffix(type.rawValue)){
                    let filePathName = "\(documentPath)/\(fileName)"
                    try fileManager.removeItem(atPath: filePathName)
                }
            }
        } catch {
            debugPrint("Could not clear temp folder: \(error)")
        }
    }
    
  func clearAllData() {
        guard let folderPath = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first?.relativePath else {return}
        do {
            let contents = try fileManager.contentsOfDirectory(atPath: folderPath)
            for content in contents{
                try fileManager.removeItem(atPath: "\(folderPath)/\(content)")
            }
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
}
