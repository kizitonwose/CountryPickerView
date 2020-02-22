//
//  DemoViewController.swift
//  CountryPickerViewDemo
//
//  Created by Kizito Nwose on 18/09/2017.
//  Copyright © 2017 Kizito Nwose. All rights reserved.
//

import UIKit
import CountryPickerView

class DemoViewController: UITableViewController {

    @IBOutlet weak var searchBarPosition: UISegmentedControl!
    @IBOutlet weak var showPhoneCodeInView: UISwitch!
    @IBOutlet weak var showCountryCodeInView: UISwitch!
    @IBOutlet weak var showCountryNameInView: UISwitch!
    @IBOutlet weak var showPreferredCountries: UISwitch!
    @IBOutlet weak var showOnlyPreferredCountries: UISwitch!
    @IBOutlet weak var showPhoneCodeInList: UISwitch!
    @IBOutlet weak var showCountryCodeInList: UISwitch!
    @IBOutlet weak var cpvMain: CountryPickerView!
    
    @IBOutlet weak var phoneNumberField: UITextField!
    weak var cpvTextField: CountryPickerView!
    @IBOutlet weak var cpvIndependent: CountryPickerView!
    let cpvInternal = CountryPickerView()
    
    @IBOutlet weak var presentationStyle: UISegmentedControl!
    @IBOutlet weak var selectCountryButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
       
        let cp = CountryPickerView(frame: CGRect(x: 0, y: 0, width: 120, height: 20))
        phoneNumberField.leftView = cp
        phoneNumberField.leftViewMode = .always
        self.cpvTextField = cp

        cpvMain.tag = 1
        cpvTextField.tag = 2
        cpvIndependent.tag = 3
        
        [cpvMain, cpvTextField, cpvIndependent, cpvInternal].forEach {
            $0?.dataSource = self
        }
        
        cpvInternal.delegate = self
        cpvMain.font = UIFont.systemFont(ofSize: 20)
        
        [showPhoneCodeInView, showCountryCodeInView, showCountryNameInView,
         showPreferredCountries,  showOnlyPreferredCountries].forEach {
            $0.addTarget(self, action: #selector(switchValueChanged(_:)), for: .valueChanged)
        }
        
        selectCountryButton.addTarget(self, action: #selector(selectCountryAction(_:)), for: .touchUpInside)
        
        phoneNumberField.showDoneButtonOnKeyboard()
    }
    
    
    @objc func switchValueChanged(_ sender: UISwitch) {
        switch sender {
        case showCountryCodeInView:
            cpvMain.showCountryCodeInView = sender.isOn
            // We don't want code and name switches to be on at the same time.
            // The library does not show both values anyway but we have this so it's
            // obvious in the sample. We also do the check when country name switch is toggled.
            if sender.isOn && showCountryNameInView.isOn {
                showCountryNameInView.setOn(false, animated: true) // Action not called
            }
        case showPhoneCodeInView:
            cpvMain.showPhoneCodeInView = sender.isOn
        case showCountryNameInView:
            cpvMain.showCountryNameInView = sender.isOn
            if sender.isOn && showCountryCodeInView.isOn {
                showCountryCodeInView.setOn(false, animated: true)
            }
        case showPreferredCountries:
            if !sender.isOn && showOnlyPreferredCountries.isOn {
                showOnlyPreferredCountries.setOn(false, animated: true)
            }
        case showOnlyPreferredCountries:
            if sender.isOn && !showPreferredCountries.isOn {
                let title = "Missing requirement"
                let message = "You must select the \"Show preferred countries section\" option."
                showAlert(title: title, message: message)
                sender.isOn = false
            }
        default: break
        }
    }
    
    @objc func selectCountryAction(_ sender: Any) {
        switch presentationStyle.selectedSegmentIndex {
        case 0:
            if let nav = navigationController {
                cpvInternal.showCountriesList(from: nav)
            }
        case 1: cpvInternal.showCountriesList(from: self)
        default: break
        }
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }

}

extension DemoViewController: CountryPickerViewDelegate {
    func countryPickerView(_ countryPickerView: CountryPickerView, didSelectCountry country: Country) {
        // Only countryPickerInternal has it's delegate set
        let title = "Selected Country"
        let message = "Name: \(country.name) \nCode: \(country.code) \nPhone: \(country.phoneCode)"
        showAlert(title: title, message: message)
    }
}

extension DemoViewController: CountryPickerViewDataSource {
    func preferredCountries(in countryPickerView: CountryPickerView) -> [Country] {
        if countryPickerView.tag == cpvMain.tag && showPreferredCountries.isOn {
            var countries = [Country]()
            ["NG", "US", "GB"].forEach { code in
                if let country = countryPickerView.getCountryByCode(code) {
                    countries.append(country)
                }
            }
            return countries
        }
        return []
    }
    
    func sectionTitleForPreferredCountries(in countryPickerView: CountryPickerView) -> String? {
        if countryPickerView.tag == cpvMain.tag && showPreferredCountries.isOn {
            return "Preferred title"
        }
        return nil
    }
    
    func showOnlyPreferredSection(in countryPickerView: CountryPickerView) -> Bool {
        return countryPickerView.tag == cpvMain.tag && showOnlyPreferredCountries.isOn
    }
    
    func navigationTitle(in countryPickerView: CountryPickerView) -> String? {
        return "Select a Country"
    }
        
    func searchBarPosition(in countryPickerView: CountryPickerView) -> SearchBarPosition {
        if countryPickerView.tag == cpvMain.tag {
            switch searchBarPosition.selectedSegmentIndex {
            case 0: return .tableViewHeader
            case 1: return .navigationBar
            default: return .hidden
            }
        }
        return .tableViewHeader
    }
    
    func showPhoneCodeInList(in countryPickerView: CountryPickerView) -> Bool {
        return countryPickerView.tag == cpvMain.tag && showPhoneCodeInList.isOn
    }
    
    func showCountryCodeInList(in countryPickerView: CountryPickerView) -> Bool {
       return countryPickerView.tag == cpvMain.tag && showCountryCodeInList.isOn
    }
}


extension UITextField {
    func showDoneButtonOnKeyboard() {
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(resignFirstResponder))
        
        var toolBarItems = [UIBarButtonItem]()
        toolBarItems.append(flexSpace)
        toolBarItems.append(doneButton)
        
        let doneToolbar = UIToolbar()
        doneToolbar.items = toolBarItems
        doneToolbar.sizeToFit()
        
        inputAccessoryView = doneToolbar
    }
}
