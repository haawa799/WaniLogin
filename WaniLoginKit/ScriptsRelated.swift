//
//  ScriptsRelated.swift
//  WaniLogin
//
//  Created by Andriy K. on 3/15/17.
//
//

import Foundation

public enum ScriptHandler: String {
  case apiKey = "apikey"
  case invalidCredentials = "invalidCredentials"
}

public enum LoginResult {
  case success(apiKey: String)
  case failure
}
