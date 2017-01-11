//
//  LoginWebViewController.swift
//  WaniKani
//
//  Created by Andriy K. on 10/15/15.
//  Copyright © 2015 Andriy K. All rights reserved.
//

import UIKit
import WebKit

private enum ScriptHandler: String {
  case apiKey = "apikey"
  case invalidCredentials = "invalidCredentials"
}

public enum LoginResult {
  case success(apiKey: String)
  case failure
}

class LoginWebViewController: UIViewController {
  
  var credentials: (user: String, password: String)?
  var completionBlock: ((_ result: LoginResult) -> Void)?
  var didTriedToLogin = false
  
  private var webView: WKWebView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupWebView()
  }
  
  private func setupWebView() {
    guard let path = Bundle(for: DummyClass.self).path(forResource: "api_key_script", ofType: "js"), let js = try? String(contentsOfFile: path, encoding: String.Encoding.utf8) else { return }
    let source = js
    let userScript = WKUserScript(source: source, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
    
    let userContentController = WKUserContentController()
    userContentController.addUserScript(userScript)
    userContentController.add(self, name: ScriptHandler.apiKey.rawValue)
    userContentController.add(self, name: ScriptHandler.invalidCredentials.rawValue)
    let configuration = WKWebViewConfiguration()
    configuration.userContentController = userContentController
    
    webView = WKWebView(frame: self.view.bounds, configuration: configuration)
    let url = URL(string: "https://www.wanikani.com/dashboard")!
    let request = URLRequest(url: url, cachePolicy: NSURLRequest.CachePolicy.reloadRevalidatingCacheData, timeoutInterval: 15.0)
    webView.load(request)
    webView.navigationDelegate = self
    view.addSubview(webView)
  }
  
}

extension LoginWebViewController: WKNavigationDelegate {
  
  func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    if let credentials = credentials {
      webView.evaluateJavaScript("loginIfNeeded('\(credentials.user)','\(credentials.password)');", completionHandler: nil)
    }
  }
}

extension LoginWebViewController: WKScriptMessageHandler {
  
  func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
    guard let scriptHandler = ScriptHandler(rawValue: message.name) else { return }
    switch scriptHandler {
    case .apiKey:
      guard let apiKey = message.body as? String, apiKey.characters.count == 32 else { return }
      submitApiKey(apiKey: apiKey)
    case .invalidCredentials:
      invalidCredentials()
    }
  }
  
  private func submitApiKey(apiKey: String) {
    completionBlock?(.success(apiKey: apiKey))
  }
  
  private func invalidCredentials() {
    completionBlock?(.failure)
  }
  
}
