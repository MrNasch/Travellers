//
//  FirebaseHelper.swift
//  Travellers
//
//  Created by Nasch on 03/05/2019.
//  Copyright © 2019 Nasch. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class FirebaseHelper {
    // verify if user is conencted
    func connected() -> String? {
        return Auth.auth().currentUser?.uid
    }
    
    // authentification Facebook V2
    
    
}
