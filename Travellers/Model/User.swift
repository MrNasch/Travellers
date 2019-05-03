//
//  User.swift
//  Travellers
//
//  Created by Nasch on 02/05/2019.
//  Copyright © 2019 Nasch. All rights reserved.
//

import Foundation
import Firebase

struct User {
    
    let uid: String
    let email: String
    
    init(authData: Firebase.User) {
        uid = authData.uid
        email = authData.email!
    }
    
    init(uid: String, email: String) {
        self.uid = uid
        self.email = email
    }
}
