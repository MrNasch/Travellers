//
//  CountriesServices.swift
//  Travellers
//
//  Created by Nasch on 23/09/2019.
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
        AF.request(url).responseDecodable { (response: DataResponse<Model, AFError>) in
            if case .failure(let error) = response.result {
                return completion(nil, error)
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
            return completion(nil, error)
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
// RecipesServices
class CountriesServices {
    var networkRequest: NetworkRequest = AlamofireNetworkRequest()
    
    func getCountry(query: String, completion: @escaping (Country?, Error?) -> Void) {
        let url = "https://restcountries.eu/rest/v2/\(query)"
        networkRequest.request(url, completion: completion)
    }
}

