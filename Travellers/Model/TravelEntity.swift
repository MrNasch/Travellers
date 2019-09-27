//
//  TravelEntity.swift
//  Travellers
//
//  Created by Nasch on 23/09/2019.
//  Copyright © 2019 Nasch. All rights reserved.
//

import Foundation
import Firebase

struct TravelEntity {
    
    let travelId: String
    let dateFrom: Timestamp
    let dateTo: Timestamp
    let countryDestination: String
    let userId: String
    
    init(id: String, data: [String: Any]) {
        self.travelId = id
        self.dateFrom = data["from"] as! Timestamp
        self.dateTo = data["to"] as! Timestamp
        self.countryDestination = data["country"] as! String
        self.userId = data["userId"] as! String
    }
}
