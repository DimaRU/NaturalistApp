/////
////  WebViewController.swift
///   Copyright © 2019 Dmitriy Borovikov. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    private var webView: WKWebView!
    
    var url: URL!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupWebView()
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    private func setupWebView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(webView)
        NSLayoutConstraint.box(item: webView, in: view.safeAreaLayoutGuide)
    }
}
