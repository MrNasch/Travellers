//
//  UserServicesTests.swift
//  TravellersTests
//
//  Created by Nasch on 22/10/2019.
//  Copyright © 2019 Nasch. All rights reserved.
//

import XCTest
import Firebase
@testable import Travellers

class UserServicesTests: XCTestCase {
    
    var users = [UserEntity]()
    var service = UserServices()
    let db = Firestore.firestore()
    let user = Auth.auth().currentUser

    func testUser_IfUserExist_DisplayUser() {
        // Given
        guard let userId = user?.uid else { return }
        //When
        let expectation = XCTestExpectation(description: "Wait for queue change")
        service.getAllUser(userId: userId) { (users) in
            //Then
            XCTAssertNotNil(users)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10)
    }

}
