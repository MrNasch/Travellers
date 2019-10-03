//
//  FakeResponseData.swift
//  TravellersTests
//
//  Created by Nasch on 03/10/2019.
//  Copyright © 2019 Nasch. All rights reserved.
//

import Foundation

class FakeResponseData {
    static let responseOK = HTTPURLResponse(url: URL(string: "https://test.be")!, statusCode: 200, httpVersion: nil, headerFields: nil)
    static let responseKO = HTTPURLResponse(url: URL(string: "https://test.be")!, statusCode: 500, httpVersion: nil, headerFields: nil)
    
    class CountryError: Error {}
    static let error = CountryError()
    
    
    static var countryCorrectData: Data {
        let bundle = Bundle(for: FakeResponseData.self)
        let url = bundle.url(forResource: "Country", withExtension: "json")
        let data = try! Data(contentsOf: url!)
        return data
    }
    // Error data
    static let countryIncorrectData = "error".data(using: .utf8)!
    static let imageData = "image".data(using: .utf8)!
}
