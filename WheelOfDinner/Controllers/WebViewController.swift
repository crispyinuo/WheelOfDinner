//
//  WebViewController.swift
//  WheelOfDinner
//
//  Created by Yinuo Zhou on 12/5/22.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKNavigationDelegate {

    @IBOutlet weak var webView: WKWebView!
    
    @IBOutlet weak var ActivityIndicator: UIActivityIndicatorView!
    public var selectedRestaurant: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.navigationDelegate = self
        let url = URL(string: selectedRestaurant)
        var myRequest = URLRequest(url:url!)
        myRequest.setValue("Bearer \(ResultModel.shared.ACCESS_KEY)", forHTTPHeaderField: "Authorization")
        webView.load(myRequest)
        // Do any additional setup after loading the view.
    }
    
    // When webview starts loading HTTP Request
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        ActivityIndicator.startAnimating()
    }
    
    // When webview finishes render
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        ActivityIndicator.stopAnimating()
    }

}
