//  WebViewController.swift
//  Resume
//
//  Created by VM User on 09/02/17.
//  Copyright © 2017 VM User. All rights reserved.
//
import UIKit
import WebKit

enum webViewType{
    case printable
    case others
}

class WebViewController: SuperViewController {

    var webUrl: String = String()
    @IBOutlet weak var webview: WKWebView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var printController = UIPrintInteractionController.shared;
    var activityIndicatorI: ActivityIndicatorView?
    var resumeID : Int?
    @IBOutlet weak var printResume: UIButton!
    @IBOutlet weak var downloadResume: UIButton!
    @IBOutlet weak var resumePrintViewLayoutconstraint: NSLayoutConstraint!
    @IBOutlet weak var resumePrintView: UIView!
  var name : String?
    
    @IBAction func printResumeTaped(_ sender: UIButton) {
        printController.present(animated: false) { (interactionVC, bool, erro) in
        }
    }
    
    @IBAction func downloadResumeTaped(_ sender: UIButton) {
        if let resumeID = resumeID {
            apitHitForDownloadResume(resumeID: resumeID)
        }
    }
    
    
    
    
    func apitHitForDownloadResume(resumeID: Int){
        
        activityIndicatorI = ActivityIndicatorView.showActivity(view: self.navigationController!.view, message: StringConstants.FetchingCoachSelection)
        
        ERSideAppointmentService().erSideResumeView(resumeId: resumeID,{ (data) in
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    self.downloadResume(url: json["\(resumeID)"] as! String)
                   }
                
            } catch  {
                CommonFunctions().showError(title: "Error", message: ErrorMessages.SomethingWentWrong.rawValue)
            }
            
            
        }) {
            (error, errorCode) in
            self.activityIndicatorI?.hide()
        };
        
    }
    
    func downloadResume(url:String){
        
        ERSideAppointmentService().erSideDownloadResume(url: url) { (data) in
            self.activityIndicatorI?.hide()
            let destinationFileUrl  = data["destinationUrl"] as! URL;
            
            do {
                
                let documentsUrl:URL =  (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first as URL?)!
                do {
                    let contents  = try FileManager.default.contentsOfDirectory(at: documentsUrl, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
                    for indexx in 0..<contents.count {
                        if contents[indexx].lastPathComponent == destinationFileUrl.lastPathComponent {
                            let activityViewController = UIActivityViewController(activityItems: [contents[indexx]], applicationActivities: nil)
                            self.present(activityViewController, animated: true, completion: nil)
                        }
                    }
                }
                catch (let err) {
                    print("error: \(err)")
                }
            } catch (let writeError) {
                print("Error creating a file \(destinationFileUrl) : \(writeError)")
            }
            
            
        } failure: { (error, errorCode) in
            self.activityIndicatorI?.hide()

        }

        
       
    }
    
    
    var isResumeWebView = false
    override func viewDidLoad() {
        super.viewDidLoad()
        // Your webView code goes here
        activityIndicator.startAnimating()
        let request = NSURLRequest(url: URL(string: webUrl)!) as URLRequest
        
//        request.httpMethod = "POST"
        //        paymentGatewayWebView.scalesPageToFit = true
        webview.navigationDelegate = self
        webview.uiDelegate = self
        
        webview.load(request)
        activityIndicator.hidesWhenStopped = true
        if isResumeWebView{
            GeneralUtility.customeNavigationBarWithBackAndPrint(viewController: self, title: "Resume - " + (name ?? "") )
//            resumePrintView.isHidden = false
            resumePrintViewLayoutconstraint.constant = 128;
            resumePrintView.backgroundColor = .clear
            let fontHeavy = UIFont(name: "FontHeavy".localized(), size: Device.FONTSIZETYPE12)
            UIButton.buttonUIHandling(button: printResume, text: " Print Resume", backgroundColor: .clear, textColor: ILColor.color(index: 23),  buttonImage: UIImage.init(named: "printImageBlue"), fontType: fontHeavy)
            UIButton.buttonUIHandling(button: downloadResume, text: " Download Resume", backgroundColor: .clear, textColor: ILColor.color(index: 23),  buttonImage: UIImage.init(named: "downloadImage"), fontType: fontHeavy)
            
            activityIndicatorI = ActivityIndicatorView.showActivity(view: self.navigationController!.view, message: StringConstants.FetchingCoachSelection)

        }
    }
    
    
    
    
    
    @objc override func buttonClicked(sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)

    }
    
    override func viewDidAppear(_ animated: Bool) {
        let printInfo = UIPrintInfo(dictionary:nil)
        printInfo.outputType = .general
        printInfo.jobName = webUrl
        printInfo.duplex = .none
        printInfo.orientation = .portrait

        //New stuff
        printController.printPageRenderer = nil
        printController.printingItems = nil
        printController.printingItem = URL.init(string: webUrl)
        //New stuff

        printController.printInfo = printInfo
        printController.showsNumberOfCopies = true
    }
    
    
    @objc override func calenderClicked(sender: UIButton) {
        printController.present(animated: false) { (interactionVC, bool, erro) in
        }
    }
    
   

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        guard let vcs = navigationController?.viewControllers else {
            return
        }
        if vcs.count > 1{
            self.navigationController?.popViewController(animated: true)
        }
        else{
            navigationController?.dismiss(animated: true, completion: nil)
        }
        
    }
}


extension WebViewController : WKNavigationDelegate,WKUIDelegate{
   
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if activityIndicator != nil{
            activityIndicatorI?.hide()

        }
        if isResumeWebView{
            resumePrintView.isHidden = false
        }

    }
    
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
      
        CommonFunctions().showError(title: "Error", message: error.localizedDescription)
        guard let vcs = navigationController?.viewControllers else {
            return
        }
        if vcs.count > 1{
            self.navigationController?.popViewController(animated: true)
        }
        else{
            navigationController?.dismiss(animated: true, completion: nil)
        }
    }
    
     public func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!){
//        if activityIndicatorI == nil{
//            activityIndicatorI = ActivityIndicatorView.showActivity(view: self.navigationController!.view, message: StringConstants.FetchingCoachSelection)
//
//        }
    }
    
 
    
}
