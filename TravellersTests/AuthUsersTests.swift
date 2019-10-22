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
    
    // Given
    let db = Firestore.firestore()
    let user = Auth.auth().currentUser
    let expectation = XCTestExpectation(description: "Wait for queue change")
    
    func testFirebase_Auth_Exist() {
        
        //When
        // Get document in DB
        if let user = user {
            let docRef = db.collection("users").document("\(user.uid)")
            docRef.getDocument { (document, error) in
                
            }
            //Then
            XCTAssertNotNil(db)
            XCTAssertNotNil(user)
            XCTAssertEqual(user.uid, "AmBjDdw1lCRpMNJbj8982Oh48T32")
            XCTAssertEqual(user.email, "test@test.be")
            expectation.fulfill()
            
        }
        wait(for: [expectation], timeout: 10)
    }
    
    func testFirebase_UserNotExist_ThenCreate() {
        //Given
        let segmented = 1
        let emailTextField: String = "test3@test.be"
        let passwordTextField: String = "111111"
        let firstnameTextField: String = "2"
        let lastnameTextField: String = "22"
        //When
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
                        self.db.collection("users").document("\(userId)").setData(dataToSave, completion: { (error) in
                            
                        })
                    }
                }
            }
            //Then
            XCTAssertEqual(passwordTextField, "111111")
            XCTAssertEqual(emailTextField, "test3@test.be")
            XCTAssertEqual(firstnameTextField, "2")
            XCTAssertEqual(lastnameTextField, "22")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10)
    }
}
