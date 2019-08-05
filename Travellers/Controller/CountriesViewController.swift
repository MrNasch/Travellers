//
//  CountriesViewController.swift
//  Travellers
//
//  Created by Nasch on 22/05/2019.
//  Copyright © 2019 Nasch. All rights reserved.
//

import UIKit

class CountriesViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    
    let country = [Country]()
    
    @IBOutlet weak var countryFlag: UIImageView!
    @IBOutlet weak var countryPicker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return country.count
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return country.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return country[row].name
    }

}
