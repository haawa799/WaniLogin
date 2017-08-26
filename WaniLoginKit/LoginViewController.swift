//
//  WaniStyle.swift
//  WaniLogin
//
//  Created by Andriy K. on 1/2/17.
//
//

import UIKit
import Cely

class LoginViewController: UIViewController {
  
  // MARK: - IBOutlets
  
  @IBOutlet weak var warningLabel: UILabel!
  @IBOutlet weak var spinnerContainer: UIView!
  @IBOutlet weak var spinnerImageView: UIImageView! {
    didSet {
      let bundle = Bundle(for: DummyClass.self)
      spinnerImageView?.loadGif(name: "3dDoge", bundle: bundle)
    }
  }
  @IBOutlet weak var appImageView: UIImageView!
  @IBOutlet weak var usernameField: UITextField?
  @IBOutlet weak var passwordField: UITextField?
  @IBOutlet weak var loginButton: UIButton?
  @IBOutlet var textFields: [UITextField]?
  @IBOutlet weak var bottomLayoutConstraint: NSLayoutConstraint!
  
  // MARK: - Variables
  var initialBottomConstant: CGFloat!
  var styles: CelyStyle?
  
  func showOverlay(completion: @escaping () -> Void) {
    _ = resignFirstResponder()
    guard let container = spinnerContainer else { return }
    container.alpha = 0
    container.isHidden = false
    UIView.animate(withDuration: 1.0, animations: {
      container.alpha = 1
    }) { (_) in
      completion()
    }
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
      self.warningLabel?.isHidden = false
    }
  }
  
  func hideOverlay(completion: @escaping () -> Void) {
    _ = resignFirstResponder()
    guard let container = spinnerContainer else { return }
    container.isHidden = false
    container.alpha = 1
    UIView.animate(withDuration: 1.0, animations: {
      container.alpha = 0
    }) { (_) in
      container.isHidden = true
      completion()
    }
    
  }
  
  override func resignFirstResponder() -> Bool {
    usernameField?.resignFirstResponder()
    passwordField?.resignFirstResponder()
    return super.resignFirstResponder()
  }
  
  // MARK: - ViewController Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    usernameField?.delegate = self
    passwordField?.delegate = self
    
    setupStyle()
    loginButton?.addTarget(self, action: #selector(didPressLogin), for: .touchUpInside)
  }
  
  private func setupStyle() {
    guard let styles = styles else { return }
    view.backgroundColor = styles.backgroundColor()
    loginButton?.setTitleColor(styles.buttonTextColor(), for: .normal)
    loginButton?.backgroundColor = styles.buttonBackgroundColor()
    textFields?.forEach({$0.backgroundColor = styles.textFieldBackgroundColor()})
    if let image = styles.appLogo() {
      appImageView.image = image
    }
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    setUpKeyboardNotification()
    initialBottomConstant = bottomLayoutConstraint.constant
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    NotificationCenter.default.removeObserver(self)
  }
  
  func didPressLogin() {
    if let username = usernameField?.text, let password = passwordField?.text {
      Cely.loginCompletionBlock?(username, password, self)
    }
  }
}

internal extension LoginViewController {
  
  // MARK: - Private
  
  fileprivate func setUpKeyboardNotification() {
    NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardNotification(notification:)),
                                           name: .UIKeyboardWillChangeFrame, object: nil)
  }
  
  func convertNotification(notification: NSNotification) -> (duration: Double, endFrame: CGRect, animationCurve: UIViewAnimationOptions)? {
    
    guard let userInfo = notification.userInfo,
      let duration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue,
      let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
      let rawCurve = (notification.userInfo![UIKeyboardAnimationCurveUserInfoKey] as? NSNumber)?.uint32Value else { return nil }
    
    let rawAnimationCurve = rawCurve << 16
    let animationCurve = UIViewAnimationOptions(rawValue: UInt(rawAnimationCurve))
    
    return (duration, endFrame, animationCurve)
  }
  
  func keyboardNotification(notification: NSNotification) {
    
    guard let (duration, endFrame, animationCurve) = convertNotification(notification: notification) else {
      return
    }
    
    let convertedKeyboardEndFrame = view.convert(endFrame, from: view.window)
    let newConstraint = view.bounds.maxY - convertedKeyboardEndFrame.minY + 7
    bottomLayoutConstraint.constant = newConstraint == 0 ? initialBottomConstant : newConstraint
    
    UIView.animate(withDuration: duration,
                   delay: 0.0,
                   options: [.beginFromCurrentState, animationCurve],
                   animations: {
                    self.view.layoutIfNeeded()
    }, completion: nil)
  }
}

extension LoginViewController: UITextFieldDelegate {
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    let nextTag = textField.tag + 1
    
    if let next = textFields?.filter({$0.tag == nextTag}).first {
      next.becomeFirstResponder()
      return true
    }
    
    textField.resignFirstResponder()
    return true
  }
}
