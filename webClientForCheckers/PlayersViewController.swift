//
//  PlayersViewController.swift
//  webClientForCheckers
//
//  Created by hyperactive on 22/05/2020.
//  Copyright © 2020 hyperActive. All rights reserved.
//

import UIKit

class PlayersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var PlayersTableView: UITableView!
    var playersFullDescription:[[String:Any]] = []
    var playersAtDispalyFormat:[String] = []
    let cellReuseIdentifier = "cell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.PlayersTableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        PlayersTableView.delegate = self
        PlayersTableView.dataSource = self
        
        self.convertFromFullDescriptionToDisplayFormat()
        PlayersTableView.reloadData()
    }
    
    func convertFromFullDescriptionToDisplayFormat () {
        for user in playersFullDescription {
            let userDetails = user["user"]!
            let descrpitionString = (userDetails as! [String:Any])["userName"] as! String
            print (descrpitionString)
            playersAtDispalyFormat.append(descrpitionString)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.playersAtDispalyFormat.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = self.PlayersTableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier)! as UITableViewCell
        cell.textLabel?.text = self.playersAtDispalyFormat[indexPath.row]
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("row \(indexPath.row) picked")
    }
    

    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
