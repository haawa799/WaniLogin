//
//  WaniLoginCoordinator.swift
//  WaniLogin
//
//  Created by Andriy K. on 1/2/17.
//
//

import UIKit
import Cely

public struct WaniLoginCoordinator {
  
  private struct Key {
    static let username = "username"
    static let password = "password"
    static let apiKey = "username"
  }
  
  public init() {
    
  }
  
  public func start(window: UIWindow) {
    Cely.logout()
    Cely.setup(with: window, forModel: User(), requiredProperties: [.apiKey], withOptions: [
      .loginStoryboard: UIStoryboard(name: "Login", bundle: Bundle(for: DummyClass.self)),
      .loginCompletionBlock: { (username: String, password: String) in
        
        let loginVC = LoginWebViewController()
        loginVC.credentials = (username, password)
        loginVC.completionBlock = { result in
          
          switch result {
          case .failure: self.showInvalidCredantials(vc: window.rootViewController)
          case .success(let apiKey):
            Cely.save(username, forKey: Key.username)
            Cely.save(password, forKey: Key.password, securely: true)
            Cely.save(apiKey, forKey: Key.apiKey, securely: true)
            Cely.changeStatus(to: .loggedIn)
          }
        }
        
        // Start VC lifecycle
        _ = loginVC.view
      }
      ])
  }
  
  private func showInvalidCredantials(vc: UIViewController?) {
    guard let vc = vc else { return }
    let alertViewController = UIAlertController(title: "Problem occured", message: "Invalid credentials", preferredStyle: .alert)
    let action = UIAlertAction(title: "Ok", style: .cancel) { (_) in
      Cely.changeStatus(to: .loggedOut)
    }
    alertViewController.addAction(action)
    vc.present(alertViewController, animated: true, completion: nil)
  }
  
  public var userName: String? {
    return Cely.get(key: Key.username) as? String
  }
  
  public var password: String? {
    return Cely.get(key: Key.password) as? String
  }
  
  public var apiKey: String? {
    return Cely.get(key: Key.apiKey) as? String
  }
  
}
