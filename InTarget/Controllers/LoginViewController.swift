//
//  LaunchViewController.swift
//  LaunchViewController
//
//  Created by Bruno Corrêa on 28/07/21.
//

import UIKit
import Lottie
import Foundation
import FirebaseAuth

class LoginViewController: UIViewController, Storyboardable {

    @IBOutlet var animationView: AnimationView!
    @IBOutlet private var bottomConstraint: NSLayoutConstraint!
    @IBOutlet private var displayNameField: UITextField!

    private let viewModel = LoginViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        displayNameField.addTarget(self, action: #selector(textFieldDidReturn), for: .primaryActionTriggered)
        startLottie()
        registerForKeyboardNotifications()
    }

    @objc private func textFieldDidReturn() {
        signInAnonymous()
    }

    @IBAction private func actionButtonPressed() {
        signInAnonymous()
    }

    override func viewWillAppear(_ animated: Bool) {
        AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.portrait, andRotateTo: UIInterfaceOrientation.portrait)
    }

    override func viewWillDisappear(_ animated: Bool) {
        AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.all)
    }

    private func startLottie(){
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.animationSpeed = 0.5
        animationView.play()
    }

    private func signInAnonymous(){
        guard let name = displayNameField.text, !name.isEmpty
        else {
            AlertHelper.showAlert(on: self, with: "Display Name Required", message: "Please enter a display name.") {}
          return
        }
        displayNameField.resignFirstResponder()
        viewModel.signIn(name: name)
    }


    // MARK: - Helpers
    private func registerForKeyboardNotifications() {
      NotificationCenter.default.addObserver(
        self,
        selector: #selector(keyboardWillShow(_:)),
        name: UIResponder.keyboardWillShowNotification,
        object: nil)

      NotificationCenter.default.addObserver(
        self,
        selector: #selector(keyboardWillHide(_:)),
        name: UIResponder.keyboardWillHideNotification,
        object: nil)
    }

    // MARK: - Notifications
    @objc private func keyboardWillShow(_ notification: Notification) {
      guard
        let userInfo = notification.userInfo,
        let keyboardHeight = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height,
        let keyboardAnimationDuration = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber),
        let keyboardAnimationCurve = (userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber)
      else {
        return
      }

      let options = UIView.AnimationOptions(rawValue: keyboardAnimationCurve.uintValue << 16)
      bottomConstraint.constant = keyboardHeight + 20

      UIView.animate(
        withDuration: keyboardAnimationDuration.doubleValue,
        delay: 0,
        options: options) {
        self.view.layoutIfNeeded()
      }
    }

    @objc private func keyboardWillHide(_ notification: Notification) {
      guard
        let userInfo = notification.userInfo,
        let keyboardAnimationDuration = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber),
        let keyboardAnimationCurve = (userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber)
      else {
        return
      }

      let options = UIView.AnimationOptions(rawValue: keyboardAnimationCurve.uintValue << 16)
      bottomConstraint.constant = 20

      UIView.animate(
        withDuration: keyboardAnimationDuration.doubleValue,
        delay: 0,
        options: options) {
        self.view.layoutIfNeeded()
      }
    }
}

