//
//  WebViewController.swift
//  Smashtag
//
//  Created by anna on 26.08.17.
//  Copyright © 2017 anna. All rights reserved.
//

import UIKit

class WebViewController: UIViewController, UIWebViewDelegate {

    var URL: URL?
    
    @IBOutlet weak var webView: UIWebView! {
        didSet {
            if URL != nil {
                webView.delegate = self
                self.title = URL!.host
                webView.scalesPageToFit = true
                webView.loadRequest(URLRequest(url: URL!))
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        print("cannot load webpage")
    }

}
