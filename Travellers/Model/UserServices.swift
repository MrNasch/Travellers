//
//  UserServices.swift
//  Travellers
//
//  Created by Nasch on 10/10/2019.
//  Copyright © 2019 Nasch. All rights reserved.
//

import Foundation
import Firebase

class UserServices {
//    // get all travel dates
//    func getAllTravel(userId: String, travels: @escaping ([UserEntity]) -> ()) {
//        let travelsCollection = Firestore.firestore().collection("users")
//            .whereField("userId", isEqualTo: userId)
//        
//        travelsCollection.addSnapshotListener { (query, error) in
//            guard let query = query else {
//                if let error = error {
//                    print("error getting travels: ", error.localizedDescription)
//                }
//                return
//            }
//            
//            let userEntities = query.documents
//                .map { UserServices(id: $0.documentID, data: $0.data()) }
//            
//            DispatchQueue.main.async {
//                travels(userEntities)
//            }
//        }
//    }
}
