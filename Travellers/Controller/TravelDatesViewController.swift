//
//  TravelDatesViewController.swift
//  Travellers
//
//  Created by Nasch on 18/09/2019.
//  Copyright © 2019 Nasch. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher

class TravelDatesViewController: UIViewController {
    
    var user: User?
    var db: Firestore!
    var userEntity = [UserEntity]()
    let userService = UserServices()
    let service = TravelService()
    var travels = [TravelEntity]()
    var userIDTravel = ""
    private var cellExpanded: Int = -1
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        tableView.layoutMargins = UIEdgeInsets.zero
        tableView.separatorInset = UIEdgeInsets.zero
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        db = Firestore.firestore()
        // checking user info
        Auth.auth().addStateDidChangeListener { (auth, user) in
            guard let user = user else { return }
            self.user = User(authData: user)
            self.displayTravels()
        }
    }
    
    func displayTravels() {
        guard let userId = user?.uid else { return }
        service.getAllTravel(userId: userId) { (travelDates) in
            self.travels = travelDates
            self.tableView.reloadData()
        }
    }
}

extension TravelDatesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // travel count
        return travels.count
    }
    
    // data in cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if cellExpanded != indexPath.row {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "travelCell", for: indexPath) as? TravelCell else {
                return UITableViewCell()
            }
            
            let travelDate = travels[indexPath.row]
            let dateFrom = travelDate.dateFrom.dateValue()
            let dateTo = travelDate.dateTo.dateValue()
            
            cell.layoutMargins = UIEdgeInsets.zero
            
            service.getUserInDate(countryDestination: travelDate.countryDestination, dateFrom: dateFrom.toString(dateFormat: "dd-MM-yyyy"), dateTo: dateTo.toString(dateFormat: "dd-MM-yyyy")) { (users) in
                cell.numberOfUser.text = String(users.count)
                print(users)
                for differentUsers in users {
                    self.userIDTravel = differentUsers.userId
                }
            }
            
            cell.country.text = travelDate.countryDestination
            cell.dateFrom.text = dateFrom.toString(dateFormat: "dd-MM-yyyy")
            cell.dateTo.text = dateTo.toString(dateFormat: "dd-MM-yyyy")
            
            return cell
            
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath) as? UserCell else {
                return UITableViewCell()
            }
            
            userService.getAllUser(userId: userIDTravel) { (users) in
                self.userEntity = users
                self.tableView.reloadData()
            }
            cell.userName.text = userEntity[0].firstName
            let urlImage = URL(string: "\(userEntity[0].profilImage)")
            cell.userPPImage.kf.setImage(with: urlImage)
            
            return cell
        }
    }
    
    //selected row
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
            if indexPath.row != cellExpanded {
                cellExpanded = indexPath.row
            } else {
                cellExpanded = -1
            }
            tableView.beginUpdates()
            tableView.endUpdates()

    }
    
    // heigh for row
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == cellExpanded {
            return 200
        } else {
            return 60
        }
    }
}

extension Date {
    // convert date to string
    func toString( dateFormat format  : String ) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}


