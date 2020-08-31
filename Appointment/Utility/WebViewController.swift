//
//  WebViewController.swift
//  Resume
//
//  Created by VM User on 09/02/17.
//  Copyright © 2017 VM User. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {

    var webUrl: String = String()
    @IBOutlet weak var webview: WKWebView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Your webView code goes here
        var request = NSURLRequest(url: URL(string: webUrl)!) as URLRequest
        
        request.httpMethod = "POST"
        //        paymentGatewayWebView.scalesPageToFit = true
        webview.navigationDelegate = self
        webview.uiDelegate = self
        
        webview.load(request)
        activityIndicator.hidesWhenStopped = true
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
        activityIndicator.stopAnimating()
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
        activityIndicator.startAnimating()
    }
    
 
    
}
