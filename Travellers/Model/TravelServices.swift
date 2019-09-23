//
//  TravelServices.swift
//  Travellers
//
//  Created by Nasch on 23/09/2019.
//  Copyright © 2019 Nasch. All rights reserved.
//

import Foundation
import Firebase

class TravelService {
    func getAllTravel(userId: String, images: @escaping ([TravelEntity]) -> ()) {
        let travelsCollection = Firestore.firestore().collection("Travels")
            .order(by: "dateAdded", descending: true)
            .whereField("userId", isEqualTo: userId)
        
        travelsCollection.addSnapshotListener { (query, error) in
            guard let query = query else {
                if let error = error {
                    print("error getting images: ", error.localizedDescription)
                }
                return
            }
            
            let travelEntities = query.documents
                .map { TravelEntity(id: $0.documentID, data: $0.data()) }
            
            DispatchQueue.main.async {
                images(travelEntities)
            }
        }
    }
}
