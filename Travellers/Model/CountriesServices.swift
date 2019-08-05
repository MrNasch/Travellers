//
//  CountriesServices.swift
//  Travellers
//
//  Created by Nasch on 22/05/2019.
//  Copyright © 2019 Nasch. All rights reserved.
//

import Foundation

class CountriesSevices {
    //Instance
    static var shared = CountriesSevices()
    private init() {}
    
    // API URL
    private let countriesUrl = URL(string: "https://restcountries.eu/rest/v2/all")!
    
    //create session fake
    private var countriesSession = URLSession(configuration: .default)
    
    init(countriesSession: URLSession) {
        self.countriesSession = countriesSession
    }
    // task
    private var task: URLSessionDataTask?
    
    //create func that get weather from openweathermap
    func getCountries(callback: @escaping (Bool, Country?) ->Void) {
        //cancel
        task?.cancel()
        //task creation
        task = countriesSession.dataTask(with: countriesUrl) { (data, response, error) in
            DispatchQueue.main.async {
                // Check for data
                guard let data = data, error == nil else {
                    callback(false, nil)
                    return
                }
                //check response
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    callback(false, nil)
                    return
                }
                // Check decoder
                let decoder = JSONDecoder()
                guard let countries = try? decoder.decode(Country.self, from: data) else {
                    callback(false, nil)
                    return
                }
                // succes
                callback(true, countries)
            }
        }
        task?.resume()
    }
}
