//
//  Delegate+DataSource.swift
//  CountryPickerView
//
//  Created by Kizito Nwose on 16/02/2018.
//  Copyright © 2017 Kizito Nwose. All rights reserved.
//

import Foundation

public protocol CountryPickerViewDelegate: class {
    /// Called when the user selects a country from the list.
    func countryPickerView(_ countryPickerView: CountryPickerView, didSelectCountry country: Country)
}

public protocol CountryPickerViewDataSource: class {
    /// An array of countries you wish to show at the top of the list.
    /// This is useful if your app is targeted towards people in specific countries.
    /// - requires: The title for the section to be returned in `sectionTitleForPreferredCountries`
    func preferredCountries(in countryPickerView: CountryPickerView) -> [Country]
    
    /// The desired title for the preferred section.
    /// - **See:** `preferredCountries` method. Both are required for the section to be shown.
    func sectionTitleForPreferredCountries(in countryPickerView: CountryPickerView) -> String?
    
    /// This determines if only the preferred section is shown
    func showOnlyPreferredSection(in countryPickerView: CountryPickerView) -> Bool
    
    /// The navigation item title when the internal view controller is pushed/presented.
    func navigationTitle(in countryPickerView: CountryPickerView) -> String?
    
    /// A navigation item button to be used if the internal view controller is presented(not pushed).
    /// Return `nil` to use a default "Close" button.
    func closeButtonNavigationItem(in countryPickerView: CountryPickerView) -> UIBarButtonItem?
    
    /// The desired position for the search bar.
    func searchBarPosition(in countryPickerView: CountryPickerView) -> SearchBarPosition
    
    /// This determines if a country's phone code is shown alongside the country's name on the list.
    /// e.g Nigeria (+234)
    func showPhoneCodeInList(in countryPickerView: CountryPickerView) -> Bool
}

// MARK:- CountryPickerViewDataSource default implementations
public extension CountryPickerViewDataSource {
    
    func preferredCountries(in countryPickerView: CountryPickerView) -> [Country] {
        return []
    }
    
    func sectionTitleForPreferredCountries(in countryPickerView: CountryPickerView) -> String? {
        return nil
    }
    
    func showOnlyPreferredSection(in countryPickerView: CountryPickerView) -> Bool {
        return false
    }
    
    func navigationTitle(in countryPickerView: CountryPickerView) -> String? {
        return nil
    }
    
    func closeButtonNavigationItem(in countryPickerView: CountryPickerView) -> UIBarButtonItem? {
        return nil
    }
    
    func searchBarPosition(in countryPickerView: CountryPickerView) -> SearchBarPosition {
        return .tableViewHeader
    }
    
    func showPhoneCodeInList(in countryPickerView: CountryPickerView) -> Bool {
        return false
    }
}
