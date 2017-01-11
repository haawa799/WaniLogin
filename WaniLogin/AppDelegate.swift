//
//  AppDelegate.swift
//  WaniLogin
//
//  Created by Andriy K. on 1/2/17.
//
//

import UIKit
import WaniLoginKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?
  let waniLoginCoordinator = WaniLoginCoordinator()
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
    waniLoginCoordinator.start(window: window!)
    waniLoginCoordinator.delegate = self
    return true
  }
}

extension AppDelegate: WaniLoginCoordinatorDelegate {
  func loginEndedWithResult(result: LoginResult, coordinator: WaniLoginCoordinator) {
    debugPrint(result)
  }
}
