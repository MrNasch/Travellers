//
//  AuthUsersTests.swift
//  TravellersTests
//
//  Created by Nasch on 16/10/2019.
//  Copyright © 2019 Nasch. All rights reserved.
//

import XCTest
import Firebase
@testable import Travellers


class AuthUsersTests: XCTestCase {
    
    func testFirebase_Auth_Exist() {

        let segmented = 0
        let db = Firestore.firestore()
        //When
        
        let user = Auth.auth().currentUser
        // Get document in DB
        if let user = user {
            let docRef = db.collection("users").document("\(user.uid)")
            docRef.getDocument { (document, error) in
                guard let document = document, document.exists else { return }
                let dataDescription = document.data()
                let firstname = dataDescription!["Firstname"] as? String ?? ""
                let lastname = dataDescription!["Lastname"] as? String ?? ""
                let email = dataDescription!["Email"] as? String ?? ""
                let password = dataDescription!["Password"] as? String ?? ""
                let firstnameTextField = firstname
                let lastnameTextField = lastname
                let emailTextField = email
                let passwordTextField = password
                
                if segmented == 1 {
                    Auth.auth().createUser(withEmail: emailTextField, password: passwordTextField) { user, error in
                        if error == nil {
                            let userId = Auth.auth().currentUser?.uid
                            if let userId = userId {
                                
                                Auth.auth().signIn(withEmail: emailTextField, password: passwordTextField)
                                let emailText = emailTextField
                                let passwordText = passwordTextField
                                let firstnameText = firstnameTextField
                                let lastnameText = lastnameTextField
                                let dataToSave: [String: Any] = ["Email": emailText, "Paswword": passwordText, "Firstname": firstnameText, "Lastname": lastnameText]
                                db.collection("users").document("\(userId)").setData(dataToSave, completion: { (error) in
                                    if let error = error {
                                        print("noooooooo \(error.localizedDescription)")
                                    } else {
                                        print("OK")
                                    }
                                })
                            }
                        }
                    }
                }
            }
        }

                let expectation = XCTestExpectation(description: "Wait for queue change")
        
        //Then
        XCTAssertNotNil(db)
        XCTAssertEqual(user?.uid, "kGrazsROPvf4ERhPd7vcdSZthZP2")
        XCTAssertEqual(user?.email, "test2@test.be")
        expectation.fulfill()
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    
    
}
