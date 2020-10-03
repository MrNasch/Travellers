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
    
    // get all travel dates
    func getAllTravel(userId: String, travels: @escaping ([TravelEntity]) -> ()) {
        let travelsCollection = Firestore.firestore().collection("travels")
            .order(by: "from", descending: false)
            .whereField("userId", isEqualTo: userId)
        
        travelsCollection.addSnapshotListener { (query, error) in
            guard let query = query else {
                if let error = error {
                    print("error getting travels: ", error.localizedDescription)
                }
                return
            }
            
            let travelEntities = query.documents
                .map { TravelEntity(id: $0.documentID, data: $0.data()) }
            
            DispatchQueue.main.async {
                travels(travelEntities)
            }
        }
    }
    
    // get all user in the same date intervals
    func getUserInDate(countryDestination: String, dateFrom: String, dateTo: String, travels: @escaping ([TravelEntity]) -> ()) {
        let df = DateFormatter()
            df.dateFormat = "dd-MM-yyyy"
        guard let from = df.date(from: dateFrom) else { return }
        guard let to = df.date(from: dateTo) else { return }
        let travelsCollection = Firestore.firestore().collection("travels")
            .whereField("to", isGreaterThanOrEqualTo: to)
            .whereField("country", isEqualTo: countryDestination)
        
        travelsCollection
            .whereField("from", isEqualTo: from)
            .whereField("to", isLessThanOrEqualTo: to)
        
        travelsCollection.addSnapshotListener { (query, error) in
            guard let query = query else {
                if let error = error {
                    print("error getting travels: ", error.localizedDescription)
                }
                return
            }
            
            let travelEntities = query.documents
                .map { TravelEntity(id: $0.documentID, data: $0.data()) }
            
            DispatchQueue.main.async {
                travels(travelEntities)
            }
        }
    }
    
    //V2
    //delete travel date
//    func delete(travelId: String, completion: @escaping () -> ()) {
//        let travelDocRef = Firestore.firestore().collection("travels").document(travelId)
//        
//        travelDocRef.delete { error in
//            if let error = error {
//                print("error: ", error.localizedDescription)
//                return
//            }
//            
//            DispatchQueue.main.async {
//                completion()
//            }
//        }
//        
//        let travelStorageRef = Storage.storage().reference(withPath: "travels").child(travelId)
//        travelStorageRef.delete()
//    }
}


