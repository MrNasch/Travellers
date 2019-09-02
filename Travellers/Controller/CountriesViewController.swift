//
//  CountriesViewController.swift
//  Travellers
//
//  Created by Nasch on 22/05/2019.
//  Copyright © 2019 Nasch. All rights reserved.
//

import UIKit


class CountriesViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    
    var country: Country!
    var countries = [Country]()
    var request = CountriesServices()
    
    @IBOutlet weak var countryFlag: UIImageView!
    @IBOutlet weak var countryPicker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getPickerCountries()
        
    }
    
    func getPickerCountries() {
        request.getCountry(query: "all") { [weak self] country, error in
            guard let self = self else { return }
            if error != nil {
                self.alerts(title: "Oops", message: "unable to get countries")
                print("KO")
            } else {
                self.countries = country!
                print("OK")
            }
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "countries.name"
    }

}
extension CountriesViewController {
    // alerts
    func alerts(title: String, message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alertVC, animated: true, completion: nil)
    }
}
