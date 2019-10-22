//
//  TravelUsersController.swift
//  Travellers
//
//  Created by Nasch on 16/10/2019.
//  Copyright © 2019 Nasch. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher

class TravelUsersController: UIViewController {

    var userTravel = [String]()
    var users = [UserEntity]()
    var user: User?
    var db: Firestore!
    let userService = UserServices()
    
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
        tableView.layoutMargins = UIEdgeInsets.zero
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.reloadData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        db = Firestore.firestore()
        // checking user info
        Auth.auth().addStateDidChangeListener { (auth, user) in
            guard let user = user else { return }
            self.user = User(authData: user)
            self.displayUsers()
        }
    }
    
    func displayUsers() {
        userService.getAllUser(userId: userTravel) { (usersIn) in
            self.users = usersIn
            self.tableView.reloadData()
            print(self.users)
        }
    }

}

extension TravelUsersController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "usersThatTravel", for: indexPath) as? UserCell else {
            return UITableViewCell()
        }
        
        let allUsers = users[indexPath.row]
        
        cell.userName.text = allUsers.firstName
        let urlImage = URL(string: "\(allUsers.profilImage)")
        cell.userPPImage.kf.setImage(with: urlImage)
        
        return cell
    }
}
