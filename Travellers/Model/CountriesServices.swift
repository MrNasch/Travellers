//
//  CountriesServices.swift
//  Travellers
//
//  Created by Nasch on 22/05/2019.
//  Copyright © 2019 Nasch. All rights reserved.
//

import Foundation
import Alamofire


protocol NetworkRequest {
    func request<Model: Codable>(_ url: String, completion: @escaping (Model?, Error?) -> Void)
}

// Alamofire Request
struct AlamofireNetworkRequest: NetworkRequest {
    func request<Model: Codable>(_ url: String, completion: @escaping (Model?, Error?) -> Void) {
        AF.request(url).responseDecodable { (response: DataResponse<Model>) in
            if case .failure(let error) = response.result {
                // Dans le cas d'erreur
                return completion(nil, error)
            }
            
            let statusCode = response.response?.statusCode
            
            if statusCode == 401 {
                return completion(nil, NSError())
            }
            guard case .success(let result) = response.result else {
                //Erreur improbable
                return
            }
            completion(result, nil)
            
        }
    }
}

// fake request for tests
struct FakeNetworkRequest: NetworkRequest {
    
    var data: Data?
    var error: Error?
    var statusCode: Int?
    
    func request<Model: Codable>(_ url: String, completion: @escaping (Model?, Error?) -> Void) {
        
        if let error = error {
            // Dans le cas d'erreur
            return completion(nil, error)
        }
        
        if statusCode == 401 {
            return completion(nil, NSError())
        }
        
        guard let data = data else { return }
        
        do {
            let decoded = try JSONDecoder().decode(Model.self, from: data)
            completion(decoded, nil)
        } catch {
            completion(nil, error)
        }
    }
}
// country Service
class CountriesServices {
    var networkRequest: NetworkRequest = AlamofireNetworkRequest()
    
    func getCountry(query: String, completion: @escaping ([Country]?, Error?) -> Void) {
        let url = "https://restcountries.eu/rest/v2/\(query)"
        networkRequest.request(url, completion: completion)
    }
}
