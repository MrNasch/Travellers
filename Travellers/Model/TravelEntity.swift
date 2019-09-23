//
//  TravelEntity.swift
//  Travellers
//
//  Created by Nasch on 23/09/2019.
//  Copyright © 2019 Nasch. All rights reserved.
//

import Foundation

struct TravelEntity {
    
    let travelId: String
    let dateAdded: Date
    let dateFrom: Date
    let DateTo: Date
    let CountryDestination: String
    let userId: String
    
    init(id: String, data: [String: Any]) {
        self.travelId = id
        self.dateAdded = data["DateAdded"] as! Date
        self.dateFrom = data["From"] as! Date
        self.DateTo = data["To"] as! Date
        self.CountryDestination = data["Country"] as! String
        self.userId = data["UserId"] as! String
    }
}
