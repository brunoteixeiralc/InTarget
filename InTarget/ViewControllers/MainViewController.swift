//
//  ViewController.swift
//  NoAlvo
//
//  Created by Bruno Corrêa on 11/06/21.
//

import UIKit
import Firebase

class MainViewController: UIViewController {
    
    @IBOutlet var slider: UISlider!
    @IBOutlet var targetLabel: UILabel!
    @IBOutlet var scoreLabel: UILabel!
    @IBOutlet var roundLabel: UILabel!
    @IBOutlet var rankImage: UIImageView!
    
    var currentValue = 0
    var targetValue = 0
    var score = 0
    var round = 0
    
    var ref: DatabaseReference!
    var scoreRef: DatabaseReference!
    var rankListModelOrdered:RankListModel?
    var uuid = UIDevice.current.identifierForVendor?.uuidString
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configDatabase()
        setupSlider()
        startNewGame()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        scoreRef.removeAllObservers()
    }
    
    func configDatabase(){
        ref = Database.database().reference()
        scoreRef = Database.database().reference(withPath: "target_scores")
        addScoreObserver()
    }
    
    func addScoreObserver(){
        scoreRef.observe(.value) { snapshot in
            if (snapshot.exists()){
                let rankListModel = RankListModel(snapshot: snapshot)
                rankListModel.rankList.sort {
                    $0.score > $1.score
                }
                self.rankListModelOrdered = rankListModel
                self.updateImageRank()
            }
        }
    }
    
    func startNewGame(){
        score = 0
        round = 0
        startNewRound()
        startAnimation(view)
    }
    
    func startNewRound(){
        round += 1
        targetValue = Int.random(in: 1...100)
        currentValue = 50
        slider.value = Float(currentValue)
        updateLabel()
        startAnimation(slider)
    }
    
    func updateLabel(){
        targetLabel.text = "\(targetValue)"
        scoreLabel.text = "\(score)"
        roundLabel.text = "\(round)"
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
    
    func saveScoreDatabase(){
        if let uuid = uuid {
            self.scoreRef.child(uuid).child("score").setValue(score)
        }
    }
    
    func updateImageRank(){
        for (index,rank) in rankListModelOrdered!.rankList.enumerated() {
            if (rank.uuid == uuid){
                self.rankImage.image = UIImage(systemName: "\(index + 1).circle")
                break
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "goToRank"){
            if let rankVC = segue.destination as? RankViewController{
                rankVC.rankListModel = rankListModelOrdered
                rankVC.scoreRef = scoreRef
                rankVC.uuid = uuid
            }
        }
    }
    
    @IBAction func startOver(){
        saveScoreDatabase()
        startNewGame()
    }
    
    @IBAction func showAlert(){
        let difference = abs(currentValue - targetValue)
        var points = 100 - difference
        
        let title:String
        if difference == 0 {
            title = NSLocalizedString("Perfect!", comment: "Perfect!")
            points += 100
        }else if difference < 5 {
            title = NSLocalizedString("You almost had it!", comment: "You almost had it!")
            if difference == 1{
                points += 50
            }
        }else if difference < 10 {
            title = NSLocalizedString("Pretty good!", comment: "Pretty good!")
        }else{
            title = NSLocalizedString("Not even close...", comment: "Not even close...")
        }
        
        score += points
        
        let message = NSLocalizedString("You scored", comment: "You scored") + " \(points) " + NSLocalizedString("points", comment: "points")
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) {_ in
            self.startNewRound()
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)

    }
    
    @IBAction func sliderMoved(_ slider:UISlider){
        currentValue = lroundf(slider.value)
    }
}

