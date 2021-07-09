//
//  RankViewModel.swift
//  InTarget
//
//  Created by Bruno Corrêa on 08/07/21.
//

import Foundation
import Firebase

public class RankViewModel{
    
    var scoreRef: DatabaseReference!
    var rankListModel:RankListModel!
    
    func configDatabase(){
        scoreRef = Database.database().reference(withPath: "target_scores")
    }
    
    func addScoreObserver(completionHandler: @escaping (RankListModel) -> Void) {
        scoreRef.observe(.value) { snapshot in
            if (snapshot.exists()){
                let rankListModel = RankListModel(snapshot: snapshot)
                rankListModel.rankList.sort {
                    $0.score > $1.score
                }
                self.rankListModel = rankListModel
                
                completionHandler(self.rankListModel)
            }
        }
    }
}
