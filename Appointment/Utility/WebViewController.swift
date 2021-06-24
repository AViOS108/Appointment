//
//  WebViewController.swift
//  Resume
//
//  Created by VM User on 09/02/17.
//  Copyright © 2017 VM User. All rights reserved.
//

import UIKit
import WebKit

extension WKWebViewConfiguration {
    /// Async Factory method to acquire WKWebViewConfigurations packaged with system cookies
    static func cookiesIncluded(completion: @escaping (WKWebViewConfiguration?) -> Void) {
        let config = WKWebViewConfiguration()
        guard let cookies = HTTPCookieStorage.shared.cookies else {
            completion(config)
            return
        }
        // Use nonPersistent() or default() depending on if you want cookies persisted to disk
        // and shared between WKWebViews of the same app (default), or not persisted and not shared
        // across WKWebViews in the same app.
        let dataStore = WKWebsiteDataStore.nonPersistent()
        let waitGroup = DispatchGroup()
        for cookie in cookies {
            waitGroup.enter()
            dataStore.httpCookieStore.setCookie(cookie) { waitGroup.leave() }
        }
        waitGroup.notify(queue: DispatchQueue.main) {
            config.websiteDataStore = dataStore
            completion(config)
        }
    }
}

class WebViewController: UIViewController {

    var webUrl: String = String()
    @IBOutlet weak var webview: WKWebView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var wkConfig : WKWebViewConfiguration!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Your webView code goes here
        
        
        WKWebViewConfiguration.cookiesIncluded { (config) in
            let webview = WKWebView(frame: self.webview.bounds, configuration: config!)
            
            self.webview.addSubview(webview)
            var request = NSURLRequest(url: URL(string: self.webUrl)!) as URLRequest
         //
                 request.httpMethod = "POST"
           webview.navigationDelegate = self
            webview.uiDelegate = self
            webview.load(request)
        }
        
//        var request = NSURLRequest(url: URL(string: webUrl)!) as URLRequest
//
//        request.httpMethod = "POST"
//        //        paymentGatewayWebView.scalesPageToFit = true
//        webview.navigationDelegate = self
//        webview.uiDelegate = self
//
//        webview.load(request)
        
        
   

         
        
        
        
        
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
