//
//  AppController.swift
//  AppController
//
//  Created by Bruno Corrêa on 03/08/21.
//

import UIKit
import FirebaseAuth

final class AppController {
  static let shared = AppController()
  private var window: UIWindow!
  private var rootViewController: UIViewController? {
    didSet {
      window.rootViewController = rootViewController
    }
  }

  init() {
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(handleAppState),
      name: .AuthStateDidChange,
      object: nil)
  }


  func show(in window: UIWindow?) {
    guard let window = window else {
      fatalError("Cannot layout app with a nil window.")
    }

    self.window = window

    handleAppState()

    window.makeKeyAndVisible()
  }

  // MARK: - Notifications
  @objc private func handleAppState() {

      if let _ = Auth.auth().currentUser {
      let mainViewController = MainViewController.instantiate()
      rootViewController = mainViewController
    } else {
      let loginViewController = LoginViewController.instantiate(storyboardName: "Login")
      rootViewController = loginViewController
    }
  }
}
