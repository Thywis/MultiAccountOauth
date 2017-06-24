//
//  ViewController.swift
//  MultiAccountOauthDemo
//
//  Created by Li Kedan on 6/23/17.
//  Copyright © 2017 Thywis inc. All rights reserved.
//

import UIKit
import MultiAccountOauth

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.layer.cornerRadius = 5
        loginButton.clipsToBounds = true
        
        OauthManager.sharedInstance.signinAllUsersSilently {
            self.tableView.reloadData()
        }
    }
    
    @IBAction func login(_ sender: Any) {
        OauthManager.sharedInstance.signin(controller: self) { (success, user, error) in
            self.tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as? InfoTableViewCell {
            let authUser = OauthManager.sharedInstance.authenticatedUsers[indexPath.row]
            cell.setDisplay(user: authUser)
            return cell
        }
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return OauthManager.sharedInstance.authenticatedUsers.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
}

