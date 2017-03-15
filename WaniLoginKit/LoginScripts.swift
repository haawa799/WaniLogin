//
//  LoginScripts.swift
//  WaniLogin
//
//  Created by Andriy K. on 3/15/17.
//
//

import Foundation

typealias Script = String

struct LoginScripts {

  private static func stringForJavascriptFileName(fileName: String) -> String! {
    let path = Bundle(for: DummyClass.self).path(forResource: fileName, ofType: "js")!
    return try! String(contentsOfFile: path, encoding: String.Encoding.utf8) // swiftlint:disable:this force_try
  }

  static let apiKeyFetching: Script = {
    return LoginScripts.stringForJavascriptFileName(fileName: "api_key_script")
  }()

  static let wkWebviewCallbackSetup: Script = {
    return LoginScripts.stringForJavascriptFileName(fileName: "wkwebview_callback_setup")
  }()

  static var combined: Script {
    return apiKeyFetching + wkWebviewCallbackSetup
  }

  static func loginIfNeededScript(userName: String, password: String) -> Script {
    return "\nloginIfNeeded('\(userName)','\(password)');"
  }

}
