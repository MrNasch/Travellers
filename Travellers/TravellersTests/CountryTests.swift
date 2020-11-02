//
//  countryTests.swift
//  TravellersTests
//
//  Created by Nasch on 03/10/2019.
//  Copyright © 2019 Nasch. All rights reserved.
//

import XCTest

@testable import Travellers

class CountryTests: XCTestCase {

    func testGivenGetCountry_WhenGetNoData_ThenError() {
            //Given
            let countryServices = CountriesServices()
            countryServices.networkRequest = FakeNetworkRequest(data: nil, error: FakeResponseData.error, statusCode: 500)
            
            //When
            let expectation = XCTestExpectation(description: "Wait for queue change")
            countryServices.getCountry(query: "belgique") { (country, error) in
                //then
                XCTAssertNil(country)
                XCTAssertNotNil(error)
                expectation.fulfill()
            }
            wait(for: [expectation], timeout: 0.01)
        }
        
        func testGivenGetCountry_WhenGetCorrectData_ThenNoError() {
            //Given
            let countryServices = CountriesServices()
            countryServices.networkRequest = FakeNetworkRequest(data: FakeResponseData.countryCorrectData, error: nil, statusCode: 200)
            
            //When
            let expectation = XCTestExpectation(description: "Wait for queue change")
            countryServices.getCountry(query: "belgique") { (country, error) in
                //then
                XCTAssertNotNil(country)
                XCTAssertNil(error)
                expectation.fulfill()
            }
            wait(for: [expectation], timeout: 0.01)
        }
        
        func testGivenGetCountry_WhenGetData_ThenIncorrectData() {
            //Given
            let countryServices = CountriesServices()
            countryServices.networkRequest = FakeNetworkRequest(data: FakeResponseData.countryIncorrectData, error: nil, statusCode: 200)
            
            //When
            let expectation = XCTestExpectation(description: "Wait for queue change")
            countryServices.getCountry(query: "belgique") { (country, error) in
                //then
                XCTAssertNil(country)
                XCTAssertNotNil(error)
                expectation.fulfill()
            }
            wait(for: [expectation], timeout: 0.01)
        }
        
    }

