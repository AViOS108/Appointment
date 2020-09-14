//
//  Extensions.swift
//  Resume
//
//  Created by VM User on 30/01/17.
//  Copyright © 2017 VM User. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    class func fromRGB(_ rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    static var officialApplePlaceholderGray: UIColor {
            return UIColor(red: 0, green: 0, blue: 0.0980392, alpha: 0.22)
    }
    
    class func fromHex(_ rgbValue:UInt32, alpha:Double=1.0)->UIColor {
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/255.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/255.0
        let blue = CGFloat(rgbValue & 0xFF)/255.0
        return UIColor(red:red, green:green, blue:blue, alpha:CGFloat(alpha))
        
    }
}

extension UIView {
    
   
    
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
           let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
                let mask = CAShapeLayer()
                mask.path = path.cgPath
                self.layer.mask = mask
           }
    
    func shake() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.duration = 0.9
        animation.values = [-20.0, 20.0, -20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0 ]
        layer.add(animation, forKey: "shake")
    }
    
    func addSubview(_ view : UIView?, withInsetConstraints  inset: UIEdgeInsets ){
        guard let view = view else { return }
        
        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        addConstraint(NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: inset.top))
        addConstraint(NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: inset.bottom))
        addConstraint(NSLayoutConstraint(item: view, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: inset.left))
        addConstraint(NSLayoutConstraint(item: view, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: inset.right))
    }
    
    func addSubview(_ view : UIView?, withCenterConstraints  point: CGPoint ){
        guard let view = view else { return }
        
        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        addConstraint(NSLayoutConstraint(item: view, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant:point.x))
        addConstraint(NSLayoutConstraint(item: view, attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: 1, constant: point.y))
    }
    
    func addSubview(_ view : UIView?, withCenterY centerY : CGFloat, leading : CGFloat , trailing : CGFloat ){
        guard let view = view else { return }
        
        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        addConstraint(NSLayoutConstraint(item: view, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: leading))
        addConstraint(NSLayoutConstraint(item: view, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: trailing))
        
        addConstraint(NSLayoutConstraint(item: view, attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: 1, constant: centerY))
    }
    
    func borderWithWidth(_ width : CGFloat, color : UIColor){
        layer.borderColor = color.cgColor
        layer.borderWidth = width
    }
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return self.layer.cornerRadius
        }
        
        set {
            self.layer.cornerRadius = newValue
            self.clipsToBounds = true
        }
    }
    
    @IBInspectable var shadowRadius: CGFloat {
        get {
            return self.layer.shadowRadius
        }
        
        set {
            self.layer.shadowRadius = newValue
            self.layer.shadowColor = ColorCode.textColor.cgColor
            self.layer.shadowOpacity = 0.4
            self.layer.shadowOffset = CGSize(width: 0, height: 2)
            self.layer.shadowRadius = 2
            self.clipsToBounds = false
        }
    }
}

extension String{
    func width(withConstrainedHeight height: CGFloat, font : UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font : font], context: nil )
        return ceil(boundingBox.width)
    }
    
    func isValidMobileNumber()->Bool{
        let PHONE_REGEX = "[0-9]{10}"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        return phoneTest.evaluate(with: self)
    }
    
    func isValidName() -> Bool {
        let nameRegex = "^[\\p{L} .'-]+$";
        let nameTest = NSPredicate(format: "SELF MATCHES %@", nameRegex)
        return nameTest.evaluate(with: self)
    }
    
    func isvalidEmailId() -> Bool{
        do {
            let regex = try NSRegularExpression(pattern: "(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])", options: .caseInsensitive)
            return regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.count)) != nil
        } catch {
            return false
        }
    }
    
    
    func isValidPasword() -> (status : Bool,message : String) {
        let validations : [StringValidation] = [MinCharRange(),AtleastOneCapital(),AtleastOneLoweredCase(),AtlesatOneSpecialChar(),AtleastOneNumber()] 
        let validator = PasswordValidator(password: self, validations : validations).validate()
        return (validator.status, validator.message)
    }
    
    func convertToDateFromStringInUTCFormat(format : String) -> Date? {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        var localTimeZoneAbbreviation: String { return TimeZone.current.identifier ?? "" }

        dateFormatter.timeZone = NSTimeZone(abbreviation: localTimeZoneAbbreviation) as TimeZone?
        return dateFormatter.date(from: self)   
    }
    
    func index(at position: Int, from start: Index? = nil) -> Index? {
        let startingIndex = start ?? startIndex
        return index(startingIndex, offsetBy: position, limitedBy: endIndex)
    }
    
    func character(at position: Int) -> Character? {
        guard position >= 0, let indexPosition = index(at: position) else {
            return nil
        }
        return self[indexPosition]
    }
    
}


extension UIDevice {
    class func isDeviceWithHeight568 () -> Bool {
        if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.phone {
            if UIScreen.main.bounds.size.height == CGFloat(568.0) {
                return true;
            }
        }
        return false;
    }
    
    //iphone 8
    class func isDeviceWithHeight667 () -> Bool {
        if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.phone {
            if UIScreen.main.bounds.size.height == CGFloat(667.0) {
                return true;
            }
        }
        return false;
    }
    
    //iphone 8 plus
    class func isDeviceWithHeight736 () -> Bool {
        if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.phone {
            if UIScreen.main.bounds.size.height == CGFloat(736.0) {
                return true;
            }
        }
        return false;
    }
    
    class func isDeviceWithHeight480 () -> Bool {
        if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.phone {
            if UIScreen.main.bounds.size.height == CGFloat(480) || UIScreen.main.bounds.size.height == CGFloat(568) {
                return true;
            }
        }
        return false;
    }
}

extension UIViewController {
    
    func addChildViewController(_ viewController : UIViewController?, forView container: UIView){
        guard let viewController = viewController else { return }
        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        addChild(viewController)
        container.addSubview(viewController.view)
        let childView = viewController.view
        
        container.addConstraint(NSLayoutConstraint(item: childView!, attribute: .top, relatedBy: .equal, toItem: container, attribute: .top, multiplier: 1.0, constant: 0))
        container.addConstraint(NSLayoutConstraint(item: childView!, attribute: .bottom, relatedBy: .equal, toItem: container, attribute: .bottom, multiplier: 1.0, constant: 0))
        container.addConstraint(NSLayoutConstraint(item: childView!, attribute: .leading, relatedBy: .equal, toItem: container, attribute: .leading, multiplier: 1.0, constant: 0))
        container.addConstraint(NSLayoutConstraint(item: childView!, attribute: .trailing, relatedBy: .equal, toItem: container, attribute: .trailing, multiplier: 1.0, constant: 0))
        viewController.didMove(toParent: self)
    }
    
    func removeChildVC(_ viewController : UIViewController?){
        
        if let viewController = viewController{
            viewController.willMove(toParent: nil)
            viewController.view.removeFromSuperview()
        }
    }
}

extension NSDate {
    func stringInFormat(_ format : String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self as Date)
    }
    
    func stringInUTCInFormat(_ format : String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        var localTimeZoneAbbreviation: String { return TimeZone.current.identifier ?? "" }

        dateFormatter.timeZone = NSTimeZone(abbreviation: localTimeZoneAbbreviation) as TimeZone?
        return dateFormatter.string(from: self as Date)
    }
    
    func fixNotificationDate() -> NSDate {
        return (self as Date).fixNotificationDate() as NSDate
    }
    
}

extension Date {
    
        func get(_ components: Calendar.Component..., calendar: Calendar = Calendar.current) -> DateComponents {
            return calendar.dateComponents(Set(components), from: self)
        }

        func get(_ component: Calendar.Component, calendar: Calendar = Calendar.current) -> Int {
            return calendar.component(component, from: self)
        }
    
    
    func fixNotificationDate() -> Date {
        
        let set = Set(arrayLiteral: Calendar.Component.day, Calendar.Component.month,Calendar.Component.year,Calendar.Component.hour,Calendar.Component.minute)
        
        var dateComponets: DateComponents = Calendar.current.dateComponents(set, from: self)
        dateComponets.second = 0
        
        return Calendar.current.date(from: dateComponets)!
    }
    
    func days(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: self , to: date).day ?? 0
    }
    
    
    
    
    
}

extension FileManager{
    func fileExists(atRelativePath path : String) -> Bool{
        if let dir = self.urls(for: .documentDirectory, in: .userDomainMask).first{
            let path = dir.appendingPathComponent(path)
            return self.fileExists(atPath: path.path)
        }
        return false
    }
}

extension UIImageView {
    func downloadedFrom(url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit , success : @escaping ()->() ,  failure : @escaping ()->() ) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else {
                    failure()
                    return
                }
            DispatchQueue.main.async() { () -> Void in
                self.image = image
                success()
            }
            }.resume()
    }
    
    func downloadedFrom(link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit , success : @escaping ()->() ,  failure : @escaping ()->() ) {
        guard let url = URL(string: link) else { failure(); return }
        downloadedFrom(url: url, contentMode: mode , success : {
            success()
        } , failure : {
            failure()
        })
    }
}

extension UIImage {
    func maskWithColor(color: UIColor) -> UIImage? {
        let maskImage = cgImage!
        
        let width = size.width
        let height = size.height
        let bounds = CGRect(x: 0, y: 0, width: width, height: height)
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        let context = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)!
        
        context.clip(to: bounds, mask: maskImage)
        context.setFillColor(color.cgColor)
        context.fill(bounds)
        
        if let cgImage = context.makeImage() {
            let coloredImage = UIImage(cgImage: cgImage)
            return coloredImage
        } else {
            return nil
        }
   }
}

private var __maxLengths = [UITextField: Int]()
extension UITextField {
    @IBInspectable var maxLength: Int {
        get {
            guard let l = __maxLengths[self] else {
                return 150 // (global default-limit. or just, Int.max)
            }
            return l
        }
        set {
            __maxLengths[self] = newValue
            addTarget(self, action: #selector(fix), for: .editingChanged)
        }
    }
    @objc func fix(textField: UITextField) {
//        let t = textField.text
//        textField.text = t?.safelyLimitedTo(length: maxLength)
    }
}

extension String{
//    func safelyLimitedTo(length n: Int)->String {
//        let c = self.characters
//        if (c.count <= n) { return self }
//        return String( Array(c).prefix(upTo: n) )
//    }
//
//    func padLeft(totalWidth: Int, with: String) -> String {
//        let toPad = totalWidth - self.characters.count
//        if toPad < 1 { return self }
//        return "".padding(toLength: toPad, withPad: with, startingAt: 0) + self
//    }
}

extension UIAlertController {
    func presentOnAlertWindow( animated flag: Bool, completion: (() -> Swift.Void)? = nil) {
//        if let appDelegate = UIApplication.shared.delegate as? AppDelegate, let alertWindow = appDelegate.alertWindow {
//            alertWindow.show()
//            alertWindow.rootViewController?.dismiss(animated: false, completion: nil)
//            alertWindow.rootViewController?.present(self, animated: flag, completion:completion)
//        }
    }
    
    class func makeAppWindowVisible() {
//        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
//            (appDelegate.alertWindow? as AnyObject).hide()
//            appDelegate.makeKeyWindow()
//        }
    }
}

extension Bundle {
    var releaseVersionNumber: String? {
        return infoDictionary?["CFBundleShortVersionString"] as? String
    }
    var buildVersionNumber: String? {
        return infoDictionary?["CFBundleVersion"] as? String
    }
}

extension UILabel {
    func colorString(text: String?, coloredStrings: String... , color: UIColor? = ColorCode.applicationBlue , fontSize : CGFloat = 20) {
        let attributedString = NSMutableAttributedString(string: text!)
        
        coloredStrings.forEach({ coloredString in
            let range = (text! as NSString).range(of: coloredString)
            attributedString.setAttributes([NSAttributedString.Key.foregroundColor: color! , NSAttributedString.Key.font: UIFont.systemFont(ofSize: fontSize, weight: UIFont.Weight.bold )],
                                           range: range)
        })
        
        self.attributedText = attributedString
    }
}

//
//  iOSDevCenters+GIF.swift
//  GIF-Swift
//
//  Created by iOSDevCenters on 11/12/15.
//  Copyright © 2016 iOSDevCenters. All rights reserved.
//
import UIKit
import ImageIO
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}



extension UIImage {
    
    public class func gifImageWithData(_ data: Data) -> UIImage? {
        guard let source = CGImageSourceCreateWithData(data as CFData, nil) else {
            print("image doesn't exist")
            return nil
        }
        
        return UIImage.animatedImageWithSource(source)
    }
    
    public class func gifImageWithURL(_ gifUrl:String) -> UIImage? {
        guard let bundleURL:URL? = URL(string: gifUrl)
            else {
                print("image named \"\(gifUrl)\" doesn't exist")
                return nil
        }
        guard let imageData = try? Data(contentsOf: bundleURL!) else {
            print("image named \"\(gifUrl)\" into NSData")
            return nil
        }
        
        return gifImageWithData(imageData)
    }
    
    public class func gifImageWithName(_ name: String) -> UIImage? {
        guard let bundleURL = Bundle.main
            .url(forResource: name, withExtension: "gif") else {
                print("SwiftGif: This image named \"\(name)\" does not exist")
                return nil
        }
        guard let imageData = try? Data(contentsOf: bundleURL) else {
            print("SwiftGif: Cannot turn image named \"\(name)\" into NSData")
            return nil
        }
        
        return gifImageWithData(imageData)
    }
    
    class func delayForImageAtIndex(_ index: Int, source: CGImageSource!) -> Double {
        var delay = 0.1
        
        let cfProperties = CGImageSourceCopyPropertiesAtIndex(source, index, nil)
        let gifProperties: CFDictionary = unsafeBitCast(
            CFDictionaryGetValue(cfProperties,
                Unmanaged.passUnretained(kCGImagePropertyGIFDictionary).toOpaque()),
            to: CFDictionary.self)
        
        var delayObject: AnyObject = unsafeBitCast(
            CFDictionaryGetValue(gifProperties,
                Unmanaged.passUnretained(kCGImagePropertyGIFUnclampedDelayTime).toOpaque()),
            to: AnyObject.self)
        if delayObject.doubleValue == 0 {
            delayObject = unsafeBitCast(CFDictionaryGetValue(gifProperties,
                Unmanaged.passUnretained(kCGImagePropertyGIFDelayTime).toOpaque()), to: AnyObject.self)
        }
        
        delay = delayObject as! Double
        
        if delay < 0.1 {
            delay = 0.1
        }
        
        return delay
    }
    
    class func gcdForPair(_ a: Int?, _ b: Int?) -> Int {
        var a = a
        var b = b
        if b == nil || a == nil {
            if b != nil {
                return b!
            } else if a != nil {
                return a!
            } else {
                return 0
            }
        }
        
        if a < b {
            let c = a
            a = b
            b = c
        }
        
        var rest: Int
        while true {
            rest = a! % b!
            
            if rest == 0 {
                return b!
            } else {
                a = b
                b = rest
            }
        }
    }
    
    class func gcdForArray(_ array: Array<Int>) -> Int {
        if array.isEmpty {
            return 1
        }
        
        var gcd = array[0]
        
        for val in array {
            gcd = UIImage.gcdForPair(val, gcd)
        }
        
        return gcd
    }
    
    class func animatedImageWithSource(_ source: CGImageSource) -> UIImage? {
        let count = CGImageSourceGetCount(source)
        var images = [CGImage]()
        var delays = [Int]()
        
        for i in 0..<count {
            if let image = CGImageSourceCreateImageAtIndex(source, i, nil) {
                images.append(image)
            }
            
//            let delaySeconds = UIImage.delayForImageAtIndex(Int(i),
//                source: source)
            delays.append(1) // Seconds to ms
        }
        
        let duration: Int = {
            var sum = 0
            
            for val: Int in delays {
                sum += val
            }
            
            return sum
        }()
        
        let gcd = gcdForArray(delays)
        var frames = [UIImage]()
        
        var frame: UIImage
        var frameCount: Int
        for i in 0..<count {
            frame = UIImage(cgImage: images[Int(i)])
            frameCount = Int(delays[Int(i)] / gcd)
            
            for _ in 0..<frameCount {
                frames.append(frame)
            }
        }
        
        let animation = UIImage.animatedImage(with: frames,
            duration: 2)
        return animation
    }
}
