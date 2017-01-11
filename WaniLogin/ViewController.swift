//
//  ViewController.swift
//  WaniLogin
//
//  Created by Andriy K. on 1/2/17.
//
//

import UIKit
import WaniLoginKit

class ViewController: UIViewController {
  
  let coordinator: WaniLoginCoordinator = {
    return (UIApplication.shared.delegate as? AppDelegate)!.waniLoginCoordinator
  }()
  
  @IBAction func logOutAction(_ sender: Any) {
    coordinator.logOut()
  }
  
  @IBOutlet weak var userNameLabel: UILabel! {
    didSet {
      userNameLabel.text = "username: \(coordinator.userName!)"
    }
  }
  
  @IBOutlet weak var passwordLabel: UILabel! {
    didSet {
      passwordLabel.text = "password: \(coordinator.password!)"
    }
  }
  
  @IBOutlet weak var apiKey: UILabel! {
    didSet {
      apiKey.text = "apiKey: \(coordinator.apiKey!)"
    }
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
  }
  
}
