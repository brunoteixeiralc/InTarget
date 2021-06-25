//
//  RankViewController.swift
//  InTarget
//
//  Created by Bruno Corrêa on 24/06/21.
//

import UIKit
import Firebase

class RankViewController: UIViewController {

    @IBOutlet var tableView:UITableView!
    
    var scoreRef: DatabaseReference!
    var rankListModel:RankListModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addScoreObserver()
    }
    
    @IBAction func close(){
        dismiss(animated: true, completion: nil)
    }
    
    func addScoreObserver(){
        scoreRef.observe(.value) { snapshot in
            if (snapshot.exists()){
                let rankListModel = RankListModel(snapshot: snapshot)
                rankListModel.rankList.sort {
                    $0.score > $1.score
                }
                self.rankListModel = rankListModel
                self.animateView(view: self.tableView)
            }
        }
    }
    
    func animateView(view:UIView){
        UIView.transition(with: view,
                          duration: 0.35,
                          options: .transitionCrossDissolve,
                          animations: { self.tableView.reloadData() })
    }
}

extension RankViewController: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rankListModel?.rankList.count ?? 0
    }
    
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell( withIdentifier: "cellRank", for: indexPath) as! RankTableViewCell
        configureCell(cell: cell, with: (rankListModel?.rankList[indexPath.row])!)
        return cell
    }
    
    func configureCell(cell:RankTableViewCell, with item:RankModel){
        cell.name.text = item.uuid
        cell.score.text = String(item.score)
    }
    
}
