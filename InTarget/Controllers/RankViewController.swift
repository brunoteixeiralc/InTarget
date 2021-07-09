//
//  RankViewController.swift
//  InTarget
//
//  Created by Bruno Corrêa on 24/06/21.
//

import UIKit

class RankViewController: UIViewController {

    @IBOutlet var tableView:UITableView!

    var uuid:String!
    
    private let viewModel = RankViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.configDatabase()
        
        viewModel.addScoreObserver { _ in
            self.animateView(view: self.tableView)
        }
    }
    
    @IBAction func close(){
        dismiss(animated: true, completion: nil)
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
        return viewModel.rankListModel?.rankList.count ?? 0
    }
    
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell( withIdentifier: "cellRank", for: indexPath) as! RankTableViewCell
        configureCell(cell: cell, with: (viewModel.rankListModel?.rankList[indexPath.row])!)
        return cell
    }
    
    func configureCell(cell:RankTableViewCell, with item:RankModel){
        if (uuid == item.uuid){
            cell.name.text =  "\(NSLocalizedString("You!", comment: "You!")) 😀 🎯"
        }else{
            cell.name.text = item.name.isEmpty ? item.uuid : item.name
        }
        cell.score.text = String(item.score)
    }
    
}
