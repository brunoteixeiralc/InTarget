//
//  RanklListModel.swift
//  InTarget
//
//  Created by Bruno Corrêa on 24/06/21.
//

import UIKit
import Firebase

class RankListModel: NSObject {
    
    var rankList: [RankModel] = []
    
    init(rankList:[RankModel]) {
        self.rankList = rankList
    }
    
    init(snapshot:DataSnapshot){
        let snapshots = snapshot.value as! [String:AnyObject]
        for (key,value) in snapshots {
            let rank = RankModel(uuid: key, score: value["score"] as! Int)
            rankList.append(rank)
        }
    }
}
