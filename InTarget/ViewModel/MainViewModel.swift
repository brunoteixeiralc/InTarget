//
//  MainViewModel.swift
//  InTarget
//
//  Created by Bruno Corrêa on 07/07/21.
//

import UIKit
import Firebase
import CoreData

public class MainViewModel {
    
    var ref: DatabaseReference!
    var scoreRef: DatabaseReference!
    
    var uuid = UIDevice.current.identifierForVendor?.uuidString
    
    var rankListModelOrdered:RankListModel?
    var userRanking:Int?
    var rankImagePath = Box("")
    
    var currentValue = 0
    var target = Box(0)
    var score = Box(0)
    var round = Box(0)
    
    var user: NSManagedObject?
    
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
    
    func updateImageRank(){
        for (index,rank) in rankListModelOrdered!.rankList.enumerated() {
            if (rank.uuid == uuid){
                //self.rankImage.image = UIImage(systemName: "\(index + 1).circle")
                self.rankImagePath.value = "\(index + 1).circle"
                self.userRanking = index + 1
                break
            }
        }
    }
    
    func startNewGame(){
        score.value = 0
        round.value = 0
        startNewRound()
    }
    
    func startNewRound(){
        round.value += 1
        target.value = Int.random(in: 1...100)
        currentValue = 50
    }
    
    func calculateScoreAndMessage() -> (title:String, points:Int){
        let difference = abs(currentValue - target.value)
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
        
        score.value += points
        
        return (title, points)
    }
    
    func saveScoreDatabase(){
        if let uuid = uuid {
            self.scoreRef.child(uuid).child("score").setValue(score.value)
        }
    }
    
    func saveNameDatabase(name:String){
        if let uuid = uuid {
            self.scoreRef.child(uuid).child("name").setValue(name)
        }
    }
    
    func fetchName(){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "User")
        
        do{
            user = try managedContext.fetch(fetchRequest).first
            ///KVC - Key Value Coding
            print(user?.value(forKey: "name") as? String ?? "No name")
            
        }catch let error as NSError{
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func saveName(name:String){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "User", in: managedContext)!
        let user = NSManagedObject(entity: entity, insertInto: managedContext)
        user.setValue(name, forKey: "name")
        
        do {
            try managedContext.save()
            self.saveNameDatabase(name: user.value(forKey: "name") as! String)
            
        }catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
}
