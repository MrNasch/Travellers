//
//  UserEntity.swift
//  Travellers
//
//  Created by Nasch on 10/10/2019.
//  Copyright © 2019 Nasch. All rights reserved.
//

import Foundation


struct UserEntity {
    var userId: String
    let firstName: String
    let profilImage: String
    
    init(id: String, data: [String: Any]) {
        self.userId = id
        self.firstName = data["Firstname"] as? String ?? ""
        self.profilImage = data["Profil"] as? String ?? ""
    }
}
