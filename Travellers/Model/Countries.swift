//
//  Countries.swift
//  Travellers
//
//  Created by Nasch on 22/05/2019.
//  Copyright © 2019 Nasch. All rights reserved.
//

import Foundation
// MARK: - Country
struct Country: Codable {
    let name: String?
    let capital: String?
    let region, subregion: String?
    let population: Int?
    let demonym: String?
    let timezones, borders: [String]?
    let nativeName, numericCode: String?
    let currencies: [Currency]?
    let languages: [Language]?
    let flag: String?
}

// MARK: - Currency
struct Currency: Codable {
    let code, name, symbol: String?
}

// MARK: - Language
struct Language: Codable {
    let name, nativeName: String?
    
    enum CodingKeys: String, CodingKey {
        case name, nativeName
    }
}

