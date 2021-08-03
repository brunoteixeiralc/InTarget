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

class LoginViewController: UIViewController {

    @IBOutlet var animationView: AnimationView!
    @IBOutlet private var bottomConstraint: NSLayoutConstraint!
    @IBOutlet private var displayNameField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.animationSpeed = 0.5
        animationView.play()

        displayNameField.addTarget(
          self,
          action: #selector(textFieldDidReturn),
          for: .primaryActionTriggered)

        registerForKeyboardNotifications()
    }

    @objc private func textFieldDidReturn() {
      signIn()
    }

    @IBAction private func actionButtonPressed() {
      signIn()
    }

    override func viewWillAppear(_ animated: Bool) {
        AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.portrait, andRotateTo: UIInterfaceOrientation.portrait)
    }

    override func viewWillDisappear(_ animated: Bool) {
        AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.all)
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

    private func signIn() {
      guard
        let name = displayNameField.text,
        !name.isEmpty
      else {
          AlertHelper.showAlert(on: self, with: "Display Name Required", message: "Please enter a display name.") {}
        return
      }
      displayNameField.resignFirstResponder()

      //AppSettings.displayName = name
      Auth.auth().signInAnonymously()

      let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
      let mainViewController = storyBoard.instantiateViewController(withIdentifier: "mainViewController") as! MainViewController
      self.present(mainViewController, animated: true, completion: nil)
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
