//
//  ViewController.swift
//  CountryPickerViewDemo
//
//  Created by Kizito Nwose on 18/09/2017.
//  Copyright © 2017 Kizito Nwose. All rights reserved.
//

import UIKit
import CountryPicker

class DemoViewController: UITableViewController {
   
    @IBOutlet weak var searchBarPosition: UISegmentedControl!
    @IBOutlet weak var showPhoneCodeInView: UISwitch!
    @IBOutlet weak var showCountryCodeInView: UISwitch!
    @IBOutlet weak var showPreferredCountries: UISwitch!
    @IBOutlet weak var showPhoneCodeInList: UISwitch!
    @IBOutlet weak var countryPickerViewMain: CountryPickerView!
    
    @IBOutlet weak var phoneNumberField: UITextField!
    weak var countryPickerViewTextField: CountryPickerView!
    @IBOutlet weak var countryPickerViewIndependent: CountryPickerView!
    let countryPickerInternal = CountryPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        let cp = CountryPickerView(frame: CGRect(x: 0, y: 0, width: 120, height: 20))
        phoneNumberField.leftView = cp
        phoneNumberField.leftViewMode = .always
        self.countryPickerViewTextField = cp

        countryPickerViewMain.tag = 1
        countryPickerViewTextField.tag = 2
        countryPickerViewIndependent.tag = 3
        
        [countryPickerViewMain, countryPickerViewTextField,countryPickerViewIndependent].forEach {
            $0?.dataSource = self
        }
        
    }
    
    @IBAction func sectectCountryButtonAction(_ sender: Any) {
        countryPickerInternal.delegate = self
        countryPickerInternal.showCountriesList(from: navigationController!)
    }
}

extension DemoViewController: CountryPickerViewDelegate {
    func countryPickerView(_ countryPickerView: CountryPickerView, didSelectCountry country: Country) {
        // Only countryPickerInternal has it's delegate set
        let message = "Name: \(country.name) \nCode: \(country.code) \nPhone: \(country.phoneCode)"
        let alert = UIAlertController(title: "Selected Country", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

extension DemoViewController: CountryPickerViewDataSource {
    func preferredCountries(in countryPickerView: CountryPickerView) -> [Country]? {
        if countryPickerView.tag == countryPickerViewMain.tag && showPreferredCountries.isOn {
            var countries = [Country]()
            ["NG", "US", "GB"].forEach { code in
                if let country = countryPickerView.getCountryByCode(code) {
                    countries.append(country)
                }
            }
            return countries
        }
        return nil
    }
    
    func sectionTitleForPreferredCountries(in countryPickerView: CountryPickerView) -> String? {
        if countryPickerView.tag == countryPickerViewMain.tag && showPreferredCountries.isOn {
            return "Preferred Countries"
        }
        return nil
    }
    
    func navigationTitle(in countryPickerView: CountryPickerView) -> String? {
        return "Select a Country"
    }
    
    func closeButtonNavigationItem(in countryPickerView: CountryPickerView) -> UIBarButtonItem? {
        return nil
    }
}

