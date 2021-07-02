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
    
    init(uuid:String, score:Int, name:String = "") {
        self.uuid = uuid
        self.score = score
        self.name = name
    }
    
    init(snapshot:DataSnapshot){
        uuid = snapshot.key
        let snapshotValue = snapshot.value as! [String:AnyObject]
        score = (snapshotValue["score"] as! Int)
        name = (snapshotValue["name"] as! String)
    }
    
//    func toAnyObject() -> Any{
//        return [
//            "score":score,
//            "name":name
//        ]
//    }
}
