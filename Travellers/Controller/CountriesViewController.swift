//
//  CountriesViewController.swift
//  Travellers
//
//  Created by Nasch on 22/05/2019.
//  Copyright © 2019 Nasch. All rights reserved.
//

import UIKit
import Kingfisher
import Firebase
import PocketSVG

class CountriesViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var user: User?
    var db: Firestore!
    var countries = [Country]()
    var request = CountriesServices()
    var name: String?
    
    @IBOutlet weak var imageView: UIView!
    @IBOutlet weak var countryPicker: UIPickerView!
    @IBOutlet weak var capitalField: UILabel!
    @IBOutlet weak var languageField: UILabel!
    @IBOutlet weak var denonymField: UILabel!
    @IBOutlet weak var populationField: UILabel!
    @IBOutlet weak var currencyField: UILabel!
    @IBOutlet weak var timeZoneField: UILabel!
    @IBOutlet weak var regionField: UILabel!
    @IBOutlet weak var startDatePicker: UIDatePicker!
    @IBOutlet weak var endDatePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // checking user info
        Auth.auth().addStateDidChangeListener { (auth, user) in
            guard let user = user else { return }
            self.user = User(authData: user)
        }
        db = Firestore.firestore()
        getPickerCountries()
        countryPicker.delegate = self
        countryPicker.dataSource = self
    }
    
    // add traveling date button 
    @IBAction func didTapAddButton(_ sender: UIButton) {
        addTravelDates()
    }
    
    func getPickerCountries() {
        request.getCountry(query: "all") { [weak self] country, error in
            guard let self = self else { return }
            if error != nil {
                self.alerts(title: "Oops", message: "unable to get countries")
            } else {
                guard let country = country else { return }
                self.countries = country
                self.countryPicker.reloadAllComponents()
                self.fillWithCountryAtRow(0)
            }
        }
    }
    
    func addTravelDates() {
        let random = randomString(length: 10)
        guard let user = user else { return }
        
        let dataToSave: [String: Any] = ["DateAdded":  Timestamp(date: Date()), "Country": name ?? "", "From": startDatePicker.date, "To": endDatePicker.date, "UserID": user.uid ]
        
        self.db.collection("travels").document("\(random)").setData(dataToSave, completion: { (error) in
            if let error = error {
                print("\(error.localizedDescription)")
            }
        })
        
        alerts(title: "Wouhou", message: "Travel dates successfully added")
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return countries.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return countries[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        fillWithCountryAtRow(row)
    }
    
    // updates view with country infos
    func fillWithCountryAtRow(_ row: Int) {
        guard let flag = countries[row].alpha3Code?.lowercased() else { return }
        let flagImage = "\(flag).png"
        let image = UIImage(named: flagImage)
        let flagView = UIImageView(image: image)
        flagView.frame = imageView.bounds
        flagView.contentMode = .scaleAspectFit
        imageView.subviews.forEach { (view) in
            view.removeFromSuperview()
        }
        imageView.addSubview(flagView)
        
        name = countries[row].name
        
        capitalField.text = countries[row].capital
        let joined = countries[row].languages?.compactMap { $0.name }.joined(separator: ", ")
        languageField.text = joined
        denonymField.text = countries[row].demonym
        
        guard let population = countries[row].population else { return }
        populationField.text = String(population)
        
        guard let currencies = countries[row].currencies else { return }
        guard let code = currencies[0].code else { return }
        currencyField.text = code
        
        guard let timeZone = countries[row].timezones else { return }
        timeZoneField.text = timeZone.joined(separator: ", ")
        regionField.text = countries[row].region
    }

}
extension CountriesViewController {
    // Random string
    func randomString(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map{ _ in letters.randomElement()! })
    }
    // alerts
    func alerts(title: String, message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alertVC, animated: true, completion: nil)
    }
}

