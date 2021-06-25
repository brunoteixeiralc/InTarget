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
    
    init(uuid:String, score:Int) {
        self.uuid = uuid
        self.score = score
    }
    
    init(snapshot:DataSnapshot){
        uuid = snapshot.key
        let snapshotValue = snapshot.value as! [String:AnyObject]
        score = (snapshotValue["score"] as! Int)
    }
    
    func toAnyObject() -> Any{
        return [
            "score":score
        ]
    }
}
