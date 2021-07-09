//
//  Alert.swift
//  InTarget
//
//  Created by Bruno Corrêa on 09/07/21.
//

import Foundation
import UIKit

struct AlertHelper {
    
    typealias Action = () -> ()
    
    typealias ActionWithContent = (String) -> ()
    
    static func showAlert(on vc:UIViewController, with title:String, message:String, onConfirm: @escaping Action){
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
            onConfirm()
        }))
        vc.present(ac, animated: true)
    }
    
    static func showAlertWithTextField(on vc:UIViewController, with title:String, message:String, onConfirm: @escaping ActionWithContent) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
            guard let textField = ac.textFields?.first, let content = textField.text else {
                return
            }
            onConfirm(content)
        }))
        ac.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        ac.addTextField()
        vc.present(ac, animated: true)
    }
}
