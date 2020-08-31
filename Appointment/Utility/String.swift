//
//  String.swift
//  Resume
//
//  Created by Gaurav Gupta on 01/04/19.
//  Copyright © 2019 VM User. All rights reserved.
//

import UIKit

extension String {
    
    func attrib() -> NSAttributedString {
        let text = NSMutableAttributedString(string: self)
        return text
    }
    
    
    func replace(target: String, withString: String) -> String
       {
           return self.replacingOccurrences(of: target, with: withString, options: NSString.CompareOptions.literal, range: nil)
       }
       
       
       
       var html2Attributed: NSAttributedString? {
           do {
               guard let data = data(using: String.Encoding.utf8) else {
                   return nil
               }
               return try NSAttributedString(data: data,
                                             options: [.documentType: NSAttributedString.DocumentType.html,
                                                       .characterEncoding: String.Encoding.utf8.rawValue],
                                             documentAttributes: nil)
           } catch {
               print("error: ", error)
               return nil
           }
       }
       
       
       
       func convertHtml() -> NSAttributedString{
           guard let data = data(using: .utf8) else { return NSAttributedString() }
           do{
               return try NSAttributedString(data: data, options: [.documentType : NSAttributedString.DocumentType.html,.characterEncoding : String.Encoding.utf8.rawValue], documentAttributes: nil)
           }catch{
               return NSAttributedString()
           }
       }
       
       func localized(withComment comment: String? = nil) -> String {
           return NSLocalizedString(self, comment: comment ?? "")
       }
       
       func grouping(every groupSize: String.IndexDistance, with separator: Character) -> String {
           let cleanedUpCopy = replacingOccurrences(of: String(separator), with: "")
           return String(cleanedUpCopy.enumerated().map() {
               $0.offset % groupSize == 0 ? [separator, $0.element] : [$0.element]
               }.joined().dropFirst())
       }
    
    
}

extension NSAttributedString {
    
    func font(_ font: UIFont) -> NSAttributedString {
        let text = NSMutableAttributedString(attributedString: self)
        text.setAttributes([.font: font], range: NSRange(location: 0, length: self.string.count))
        return text
    }
    func bullet(indented: Bool = false) -> NSAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.tabStops = [
            NSTextTab(textAlignment: .left, location: 15)]
        paragraphStyle.defaultTabInterval = 15
        paragraphStyle.headIndent = 15
        
        let bullet  = "●\t"
        var str = bullet
        if indented {
            str = "\t" + str
            paragraphStyle.headIndent = 30
        }
        let text = NSMutableAttributedString(attributedString: str.attrib() + self)
        text.addAttributes([.paragraphStyle: paragraphStyle], range: NSRange(location: 0, length: text.string.count))
        return text
    }
    
    public static func +(lhs:NSAttributedString, rhs: NSAttributedString) -> NSAttributedString {
        let temp = NSMutableAttributedString(attributedString: lhs)
        temp.append(rhs)
        return temp
    }
}
