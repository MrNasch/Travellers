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
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func getTravelDates() {
        
        guard let userId = user?.uid else { return }
        
        db.collection("travels")
            .order(by: "dateAdded", descending: true)
            .whereField("userId", isEqualTo: userId)
            .getDocuments { (document, error) in
                
        }
    }

}
