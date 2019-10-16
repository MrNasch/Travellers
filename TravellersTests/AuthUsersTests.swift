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
       
                //When
        let db = Firestore.firestore()
        let expectation = XCTestExpectation(description: "Wait for queue change")
                //Then
        XCTAssertNotNil(db)
        expectation.fulfill()
        
        wait(for: [expectation], timeout: 0.01)
    }
    
}
