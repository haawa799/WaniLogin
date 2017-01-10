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

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    // Override point for customization after application launch.
    let q = WaniLoginCoordinator()
    q.start(window: window!)
    return true
  }

}

