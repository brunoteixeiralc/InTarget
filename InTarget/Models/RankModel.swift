//
//  RankModel.swift
//  InTarget
//
//  Created by Bruno Corrêa on 24/06/21.
//

import UIKit
import Firebase

class RankModel: NSObject {

    var uuid:String!
    var score:Int!
    var name:String = ""
    var round:Int!
    
    init(uuid:String, score:Int, name:String = "", round:Int) {
        self.uuid = uuid
        self.score = score
        self.name = name
        self.round = round
    }
    
    init(snapshot:DataSnapshot){
        uuid = snapshot.key
        let snapshotValue = snapshot.value as! [String:AnyObject]
        score = (snapshotValue["score"] as! Int)
        name = (snapshotValue["name"] as! String)
        round = (snapshotValue["round"] as! Int)
    }
    
//    func toAnyObject() -> Any{
//        return [
//            "score":score,
//            "name":name
//        ]
//    }
}
