//
//  TravelDatesViewController.swift
//  Travellers
//
//  Created by Nasch on 18/09/2019.
//  Copyright © 2019 Nasch. All rights reserved.
//

import UIKit
import Firebase

class TravelDatesViewController: UIViewController {
    
    var user: User?
    var db: Firestore!
    var userEntity = [UserEntity]()
    let userService = UserServices()
    let service = TravelService()
    var travels = [TravelEntity]()
    var userIDTravel = [String: [String]]()
    var userTravel = [String]()
    
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
    
    // display travel dates
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
        
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "travelCell", for: indexPath) as? TravelCell else {
                return UITableViewCell()
            }
            
            let travelDate = travels[indexPath.row]
            let dateFrom = travelDate.dateFrom.dateValue()
            let dateTo = travelDate.dateTo.dateValue()
            
            cell.layoutMargins = UIEdgeInsets.zero
            
            service.getUserInDate(countryDestination: travelDate.countryDestination, dateFrom: dateFrom.toString(dateFormat: "dd-MM-yyyy"), dateTo: dateTo.toString(dateFormat: "dd-MM-yyyy")) { (users) in
                let usersId = users.map { $0.userId }
                let uniqueUsersId = Set(usersId)
                cell.numberOfUser.text = String(uniqueUsersId.count)
                self.userIDTravel[self.travels[indexPath.row].travelId] = Array(uniqueUsersId)
                
            }
            cell.country.text = travelDate.countryDestination
            cell.dateFrom.text = dateFrom.toString(dateFormat: "dd-MM-yyyy")
            cell.dateTo.text = dateTo.toString(dateFormat: "dd-MM-yyyy")
            
            return cell
    }
    //selected row
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let users = self.userIDTravel[travels[indexPath.row].travelId]
        self.performSegue(withIdentifier: "travelUsers", sender: users)
    }
    
    // heigh for row
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 60
    }
}

extension Date {
    // convert date to string
    func toString(dateFormat format : String ) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}
extension TravelDatesViewController {
    // prepare for segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "travelUsers" {
            let travelUsersVC = segue.destination as! TravelUsersController
            travelUsersVC.userTravel = (sender as? [String])!
        }
    }
}


