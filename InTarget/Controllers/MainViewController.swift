//
//  ViewController.swift
//  NoAlvo
//
//  Created by Bruno Corrêa on 11/06/21.
//

import UIKit
import UserNotifications

class MainViewController: UIViewController {
    
    @IBOutlet var slider: UISlider!
    @IBOutlet var targetLabel: UILabel!
    @IBOutlet var scoreLabel: UILabel!
    @IBOutlet var roundLabel: UILabel!
    @IBOutlet var rankImage: UIImageView!
    
    private let viewModel = MainViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSlider()
        
        viewModel.target.bind { [weak self] targetValue in
            self?.targetLabel.text = "\(targetValue)"
        }
        
        viewModel.score.bind { [weak self] scoreValue in
            self?.scoreLabel.text = "\(scoreValue)"
        }
        
        viewModel.round.bind { [weak self] roundValue in
            self?.roundLabel.text = "\(roundValue)"
        }
        
        viewModel.rankImagePath.bind { [weak self] imagePathValue in
            self?.rankImage.image = UIImage(systemName: imagePathValue)
        }
        
        viewModel.configDatabase()
        ///local coredata
        viewModel.fetchName()
        viewModel.startNewGame()
        
        ///notification when the app goes background
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appMovedToBackground), name: UIApplication.willResignActiveNotification, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        viewModel.scoreRef.removeAllObservers()
    }
    
    func updateLabel(){
        targetLabel.text = "\(viewModel.target.value)"
        scoreLabel.text = "\(viewModel.score.value)"
        roundLabel.text = "\(viewModel.round.value)"
    }
    
    func startAnimation(_ view:UIView){
        let transition = CATransition()
        transition.type = .fade
        transition.duration = 1
        transition.timingFunction = CAMediaTimingFunction(name: .easeOut)
        view.layer.add(transition, forKey: nil)
    }
    
    func setupSlider(){
        let thumbImageNormal = UIImage(named: "sliderThumb-Normal")
        slider.setThumbImage(thumbImageNormal, for: .normal)
        let thumbImageHighlighted = UIImage(named: "sliderThumb-Highlighted")
        slider.setThumbImage(thumbImageHighlighted, for: .highlighted)
        slider.value = Float(viewModel.currentValue)
    }
    
    func showAlertRankName(){
        AlertHelper.showAlertWithTextField(on: self, with: "🎯", message: NSLocalizedString("Add a new name for your first ranking", comment: "Add a new name for your first ranking")) { content in
            let nameToSave = content
            self.viewModel.saveName(name: nameToSave)
        }
    }
    
    func scheduleNotificationRanking(rank:Int){
        let content = UNMutableNotificationContent()
        content.title = NSLocalizedString("InTarget Rank!", comment: "InTarget Rank!")
        content.body = NSLocalizedString("Thanks for playing! You are in", comment: "Thanks for playing") + "\(rank)\u{00BA}"
        content.sound = UNNotificationSound.default
        
        let trigger = UNTimeIntervalNotificationTrigger(
          timeInterval: 10,
          repeats: false)
        let request = UNNotificationRequest(
          identifier: "UserRankingLocalNotification",
          content: content,
          trigger: trigger)
        let center = UNUserNotificationCenter.current()
        center.add(request)
    }
    
    @objc func appMovedToBackground(){
        if let uRanking = viewModel.userRanking{
            scheduleNotificationRanking(rank:uRanking)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "goToRank"){
            if let rankVC = segue.destination as? RankViewController{
                rankVC.uuid = viewModel.uuid
            }
        }
    }
    
    @IBAction func startOver(){
        if (viewModel.user == nil){
            showAlertRankName()
        }
        viewModel.saveScoreDatabase()
        viewModel.startNewGame()
    }
    
    @IBAction func showAlert(){
        let result = viewModel.calculateScoreAndMessage()
        
        let message = NSLocalizedString("You scored", comment: "You scored") + " \(result.points) " + NSLocalizedString("points", comment: "points")
        
        AlertHelper.showAlert(on: self, with: result.title, message: message) {
            self.updateLabel()
            self.viewModel.startNewRound()
            self.slider.value = Float(self.viewModel.currentValue)
            self.startAnimation(self.slider)
        }
    }
    
    @IBAction func sliderMoved(_ slider:UISlider){
        viewModel.currentValue = lroundf(slider.value)
    }
}

