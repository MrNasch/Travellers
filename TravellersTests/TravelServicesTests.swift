//
//  TravelServicesTests.swift
//  TravellersTests
//
//  Created by Nasch on 22/10/2019.
//  Copyright © 2019 Nasch. All rights reserved.
//

import XCTest
import Firebase
@testable import Travellers

class TravelServicesTests: XCTestCase {

    var travels = [TravelEntity]()
    var service = TravelService()
    let db = Firestore.firestore()
    let user = Auth.auth().currentUser

    func testUser_IfUserExist_DisplayUser() {
        // Given
        guard let userId = user?.uid else { return }
        //When
        let expectation = XCTestExpectation(description: "Wait for queue change")
        service.getAllTravel(userId: userId) { (travels) in
            //Then
            XCTAssertNotNil(travels)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10)
    }


    func testUser_IfUserInTravel_DisplayAllUser() {
        
        //When
        let expectation = XCTestExpectation(description: "Wait for queue change")
        service.getUserInDate(countryDestination: "Canada", dateFrom: "22-10-2019", dateTo: "24-10-2019") { (users) in
            //Then
            XCTAssertNotNil(users)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10)
    }
}
