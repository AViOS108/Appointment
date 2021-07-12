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
            GeneralUtility.customeNavigationBarWithBackAndPrint(viewController: self, title: "Print Resume")

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
    
    func printTapped(){
       
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
            activityIndicator.startAnimating()

        }    }
    
    
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
        if activityIndicator != nil{
            activityIndicator.startAnimating()

        }
    }
    
 
    
}
