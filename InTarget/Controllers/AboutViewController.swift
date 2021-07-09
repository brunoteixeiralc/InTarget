//
//  AboutViewController.swift
//  NoAlvo
//
//  Created by Bruno Corrêa on 20/06/21.
//

import UIKit
import WebKit

class AboutViewController: UIViewController, WKUIDelegate {
    
    @IBOutlet var aboutMeLabel:UILabel!
    @IBOutlet var aboutMeWebView:WKWebView!
    @IBOutlet var aboutTextView:UITextView!
    
    let urlResume = "https://portifolio-2e2eb.web.app"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ///Using textView is not translating in storyboard
        aboutTextView.text = NSLocalizedString("""
    *** Bull’s Eye ***
    Welcome to the awesome game of Bull’s Eye where you can win points and fame by dragging a slider.
    Your goal is to place the slider as close as possible to the target value. The closer you are, the more points you score. Enjoy!
    """, comment: "About the app")
        
        let tapAboutMe = UITapGestureRecognizer(target: self, action: #selector(self.aboutMeWebView(_:)))
        aboutMeLabel.addGestureRecognizer(tapAboutMe)
    }
    
    @IBAction func close(){
        dismiss(animated: true, completion: nil)
    }
    
    @objc func aboutMeWebView(_ sender:UITapGestureRecognizer){
        if (aboutMeWebView.superview?.subviews.last == aboutMeWebView){
            view.sendSubviewToBack(aboutMeWebView)
        } else {
            let url = URL(string: urlResume)
            if let url = url {
                let request = URLRequest(url: url)
                aboutMeWebView.load(request)
                view.bringSubviewToFront(aboutMeWebView)
            }
        }
    }
}
