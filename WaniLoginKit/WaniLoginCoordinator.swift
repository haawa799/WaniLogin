//
//  WaniLoginCoordinator.swift
//  WaniLogin
//
//  Created by Andriy K. on 1/2/17.
//
//

import UIKit
import Cely

public protocol WaniLoginCoordinatorDelegate: class {
  func loginEndedWithResult(result: LoginResult, coordinator: WaniLoginCoordinator)
}

public class WaniLoginCoordinator {
  
  private struct Key {
    static let username = "username"
    static let password = "password"
    static let apiKey = "apiKey"
  }
  
  public weak var delegate: WaniLoginCoordinatorDelegate?
  
  public init() {
  }
  
  public func logOut() {
    Cely.logout()
  }
  
  public func start(window: UIWindow) {
    Cely.setup(with: window, forModel: User(), requiredProperties: [.apiKey], withOptions: [
      .loginStoryboard: UIStoryboard(name: "Login", bundle: Bundle(for: DummyClass.self)),
      .loginCompletionBlock: { (username: String, password: String, viewController: UIViewController?) in
        
        let viewController = viewController as? LoginViewController
        viewController?.showOverlay {
        }
        
        let loginVC = LoginWebViewController()
        loginVC.credentials = (username, password)
        loginVC.completionBlock = { result in
          viewController?.hideOverlay {
            switch result {
            case .failure: self.showInvalidCredantials(viewController: window.rootViewController)
            case .success(let apiKey):
              Cely.save(username, forKey: Key.username)
              Cely.save(password, forKey: Key.password, securely: true)
              Cely.save(apiKey, forKey: Key.apiKey, securely: true)
              Cely.changeStatus(to: .loggedIn)
            }
            self.delegate?.loginEndedWithResult(result: result, coordinator: self)
          }
        }
        
        // Start VC lifecycle
        _ = loginVC.view
      }
      ])
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

// MARK: - Private API
fileprivate extension WaniLoginCoordinator {
  
  func showInvalidCredantials(viewController: UIViewController?) {
    guard let viewController = viewController else { return }
    let alertViewController = UIAlertController(title: "Problem occured", message: "Invalid credentials", preferredStyle: .alert)
    let action = UIAlertAction(title: "Ok", style: .cancel) { (_) in
      Cely.changeStatus(to: .loggedOut)
    }
    alertViewController.addAction(action)
    viewController.present(alertViewController, animated: true, completion: nil)
  }
  
}
