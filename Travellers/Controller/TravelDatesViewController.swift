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
    let service = TravelService()
    var travels = [TravelEntity]()

    @IBOutlet weak var tableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        db = Firestore.firestore()
        // checking user info
        Auth.auth().addStateDidChangeListener { (auth, user) in
            guard let user = user else { return }
            self.user = User(authData: user)
            self.displayTravels()
            self.tableView.reloadData()
        }
    }
    
    func displayTravels() {
        guard let userId = user?.uid else { return }
        service.getAllTravel(userId: userId) { (travelDates) in
            self.travels = travelDates
            print(self.travels.count)
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
        
        cell.country.text = travelDate.countryDestination
//        cell.dateFrom.text = travelDate.dateFrom
//        cell.dateTo.text = travelDate.dateTo
        cell.numberOfUser.text = travelDate.travelId
        
        
        
        return cell
    }
    
    // heigh for row
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
}
