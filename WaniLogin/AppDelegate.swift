//
//  AppDelegate.swift
//  WaniLogin
//
//  Created by Andriy K. on 1/2/17.
//
//

import UIKit
import WaniLoginKit
import Cely

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?
  let waniLoginCoordinator = WaniLoginCoordinator()
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
    let window = UIWindow(frame: UIScreen.main.bounds)
    window.makeKeyAndVisible()
    waniLoginCoordinator.start(delegate: self, window: window)
    waniLoginCoordinator.delegate = self
    self.window = window
    return true
  }
}

extension AppDelegate: WaniLoginCoordinatorDelegate {
  func loginEndedWithResult(result: LoginResult, coordinator: WaniLoginCoordinator) {
    debugPrint(result)
  }

  var shouldTryUsingMainStoryboard: Bool {
    return false
  }

  func presentingCallback(window: UIWindow, status: CelyStatus) {

  }

}
