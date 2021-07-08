//
//  ViewController.swift
//  NoAlvo
//
//  Created by Bruno Corrêa on 11/06/21.
//

import UIKit
import Firebase
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
    }
    
    func showAlertRankName(){
        let alert = UIAlertController(title: "🎯", message:  NSLocalizedString("Add a new name for your first ranking", comment: "Add a new name for your first ranking"),preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: NSLocalizedString("Save", comment: "Save"), style: .default) {
            [unowned self] action in
                                          
            guard let textField = alert.textFields?.first, let nameToSave = textField.text else {
                return
            }
            viewModel.saveName(name: nameToSave)
        }
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel"),style: .cancel)
          
        alert.addTextField()
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    //TODO: Translate - Localizable
    func scheduleNotificationRanking(rank:Int){
        let content = UNMutableNotificationContent()
        content.title = "InTarget Rank!"
        content.body = "Thanks for playing! You are in \(rank)\u{00BA}"
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
        scheduleNotificationRanking(rank: viewModel.userRanking!)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "goToRank"){
            if let rankVC = segue.destination as? RankViewController{
                rankVC.rankListModel = viewModel.rankListModelOrdered
                rankVC.scoreRef = viewModel.scoreRef
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
        let alert = UIAlertController(title: result.title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) {_ in
            self.updateLabel()
            self.viewModel.startNewRound()
            self.slider.value = Float(self.viewModel.currentValue)
            self.startAnimation(self.slider)
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func sliderMoved(_ slider:UISlider){
        viewModel.currentValue = lroundf(slider.value)
    }
}

