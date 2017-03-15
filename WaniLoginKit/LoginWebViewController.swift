//
//  LoginWebViewController.swift
//  WaniKani
//
//  Created by Andriy K. on 10/15/15.
//  Copyright © 2015 Andriy K. All rights reserved.
//

import UIKit
import WebKit

class LoginWebViewController: UIViewController {

  fileprivate struct Constants {
    static let apiKeyLength = 32
    static let mainUrl = URL(string: "https://www.wanikani.com/dashboard")!
    static let timeout: TimeInterval = 15
  }

  var credentials: (user: String, password: String)?
  var completionBlock: ((_ result: LoginResult) -> Void)?

  fileprivate var webView: WKWebView!
  fileprivate var uiwebView: UIWebView!

  override func viewDidLoad() {
    super.viewDidLoad()
    setupWebView()
  }

  private func setupWebView() {
    let source = LoginScripts.combined
    let userScript = WKUserScript(source: source, injectionTime: .atDocumentEnd, forMainFrameOnly: true)

    let userContentController = WKUserContentController()
    userContentController.addUserScript(userScript)
    userContentController.add(self, name: ScriptHandler.apiKey.rawValue)
    userContentController.add(self, name: ScriptHandler.invalidCredentials.rawValue)
    let configuration = WKWebViewConfiguration()
    configuration.userContentController = userContentController

    webView = WKWebView(frame: self.view.bounds, configuration: configuration)
    let url = Constants.mainUrl
    let request = URLRequest(url: url, cachePolicy: URLRequest.CachePolicy.useProtocolCachePolicy, timeoutInterval: Constants.timeout)
    webView.load(request)
    webView.navigationDelegate = self
    view.addSubview(webView)

    uiwebView = UIWebView(frame: self.view.bounds)
    uiwebView.delegate = self
    uiwebView.loadRequest(request)
    view.addSubview(uiwebView)
  }

}

// MARK: - Login into uiwebview to store cookies
extension LoginWebViewController: UIWebViewDelegate {
  func webViewDidFinishLoad(_ webView: UIWebView) {
    guard let credentials = credentials else { return }
    let script = LoginScripts.apiKeyFetching
    // Pass main scripts to webview
    _ = uiwebView.stringByEvaluatingJavaScript(from: script)
    // Trigger 'loginIfNeeded' script
    let loginIfNeededScript = LoginScripts.loginIfNeededScript(userName: credentials.user, password: credentials.password)
    _ = uiwebView.stringByEvaluatingJavaScript(from: loginIfNeededScript)
  }
}

// MARK: - Start login process in wkwebview
extension LoginWebViewController: WKNavigationDelegate {
  func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    guard let credentials = credentials else { return }
    // Trigger 'loginIfNeeded' script
    let loginIfNeededScript = LoginScripts.loginIfNeededScript(userName: credentials.user, password: credentials.password)
    webView.evaluateJavaScript(loginIfNeededScript, completionHandler: nil)
  }
}

// MARK: - Handle callbacks from wkwebview
extension LoginWebViewController: WKScriptMessageHandler {
  func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
    guard let scriptHandler = ScriptHandler(rawValue: message.name) else { return }
    switch scriptHandler {
    case .apiKey:
      guard let apiKey = message.body as? String, apiKey.characters.count == Constants.apiKeyLength else { return }
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
