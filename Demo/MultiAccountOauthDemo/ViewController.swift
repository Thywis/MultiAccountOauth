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
    }
    
    @IBAction func login(_ sender: Any) {
        OauthManager.sharedInstance.signin(controller: self) { (success, user, error) in
            self.tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as? InfoTableViewCell {
            let authUser = OauthManager.sharedInstance.authenticatedUsers[indexPath.row]
            cell.name.text = authUser.name
            cell.email.text = authUser.email
            let url = URL(string: authUser.profile)
            let data = try? Data(contentsOf: url!)
            if let imageData = data {
                let image = UIImage(data: imageData)
                cell.profile.image = image
            }
        }
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return OauthManager.sharedInstance.authenticatedUsers.count
    }
    
}

