//
//  LoginViewModel.swift
//  LoginViewModel
//
//  Created by Bruno Corrêa on 05/08/21.
//

import Foundation
import UIKit
import Firebase

public class LoginViewModel{

    private let mainViewModel = MainViewModel()

    func signIn(name:String) {
        Auth.auth().signInAnonymously { authResult, error in
            if let uid = authResult?.user.uid{
                self.mainViewModel.configDatabase()
                self.mainViewModel.uuid.value = uid
                self.mainViewModel.name.value = name
                self.mainViewModel.saveNameDatabase()
            }
        }
    }
}
