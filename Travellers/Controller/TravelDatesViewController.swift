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
    var travelDates = [TravelEntity]()

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.reloadData()
    }
    
    func displayTravels() {
        guard let userId = user?.uid else { return }
        service.getAllTravel(userId: userId) { (travelDates) in
            self.travelDates = travelDates
        }
    }
}

extension TravelDatesViewController: UITabBarDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // travel count
        return 4
    }
    
    // data in cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "travelCell", for: indexPath) as? TravelCell else {
            return UITableViewCell()
        }
        return cell
    }
    
    // Height of the row
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
}
