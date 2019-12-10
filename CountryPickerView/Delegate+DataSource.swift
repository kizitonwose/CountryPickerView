//
//  Delegate+DataSource.swift
//  CountryPickerView
//
//  Created by Kizito Nwose on 16/02/2018.
//  Copyright © 2018 Kizito Nwose. All rights reserved.
//

import Foundation

public protocol CountryPickerViewDelegate: class {
    /// Called when the user selects a country from the list.
    func countryPickerView(_ countryPickerView: CountryPickerView, didSelectCountry country: Country)
    
    /// Called before the internal CountryPickerViewController is presented or pushed.
    /// If the CountryPickerViewController is presented(not pushed), it is embedded in a UINavigationController.
    /// The CountryPickerViewController is a UITableViewController subclass.
    func countryPickerView(_ countryPickerView: CountryPickerView, willShow viewController: CountryPickerViewController)
    
    /// Called after the internal CountryPickerViewController is presented or pushed.
    /// If the CountryPickerViewController is presented(not pushed), it is embedded in a UINavigationController.
    /// The CountryPickerViewController is a UITableViewController subclass.
    func countryPickerView(_ countryPickerView: CountryPickerView, didShow viewController: CountryPickerViewController)
}

public protocol CountryPickerViewDataSource: class {
    /// An array of countries you wish to show at the top of the list.
    /// This is useful if your app is targeted towards people in specific countries.
    /// - requires: The title for the section to be returned in `sectionTitleForPreferredCountries`
    func preferredCountries(in countryPickerView: CountryPickerView) -> [Country]
    
    /// The desired title for the preferred section.
    /// - **See:** `preferredCountries` method. Both are required for the section to be shown.
    func sectionTitleForPreferredCountries(in countryPickerView: CountryPickerView) -> String?
    
    /// Determines if only the preferred section is shown
    func showOnlyPreferredSection(in countryPickerView: CountryPickerView) -> Bool
    
    /// The desired font for the section title labels on the list. Can be used to configure the text size.
    /// Default value is UIFont.boldSystemFont(ofSize: 17)
    func sectionTitleLabelFont(in countryPickerView: CountryPickerView) -> UIFont

    /// The desired text color for the section title labels on the list.
    func sectionTitleLabelColor(in countryPickerView: CountryPickerView) -> UIColor?
    
    /// The desired font for the cell labels on the list. Can be used to configure the text size.
    /// Default value is UIFont.systemFont(ofSize: 17)
    func cellLabelFont(in countryPickerView: CountryPickerView) -> UIFont
    
    /// The desired text color for the country names on the list.
    func cellLabelColor(in countryPickerView: CountryPickerView) -> UIColor?
    
    /// The desired size for the flag images on the list.
    func cellImageViewSize(in countryPickerView: CountryPickerView) -> CGSize
    
    /// The desired corner radius for the flag images on the list. Default value is 2
    func cellImageViewCornerRadius(in countryPickerView: CountryPickerView) -> CGFloat
    
    /// The navigation item title when the internal view controller is pushed/presented.
    func navigationTitle(in countryPickerView: CountryPickerView) -> String?
    
    /// A navigation item button to be used if the internal view controller is presented(not pushed).
    /// Return `nil` to use a default "Close" button.
    func closeButtonNavigationItem(in countryPickerView: CountryPickerView) -> UIBarButtonItem?
    
    /// The desired position for the search bar.
    func searchBarPosition(in countryPickerView: CountryPickerView) -> SearchBarPosition
    
    /// Determines if a country's phone code is shown alongside the country's name on the list.
    /// e.g Nigeria (+234)
    func showPhoneCodeInList(in countryPickerView: CountryPickerView) -> Bool
    
    /// Determines if a country's code is shown alongside the country's name on the list.
    /// e.g Nigeria (NG)
    func showCountryCodeInList(in countryPickerView: CountryPickerView) -> Bool
    
    /// Determines if the selected country is checked on the list.
    func showCheckmarkInList(in countryPickerView: CountryPickerView) -> Bool
    
    /// The Locale used to generate the name of the cuntries on the list.
    func localeForCountryNameInList(in countryPickerView: CountryPickerView) -> Locale
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
    
    func sectionTitleLabelFont(in countryPickerView: CountryPickerView) -> UIFont {
        return UIFont.boldSystemFont(ofSize: 17)
    }

    func sectionTitleLabelColor(in countryPickerView: CountryPickerView) -> UIColor? {
        return nil
    }
    
    func cellLabelFont(in countryPickerView: CountryPickerView) -> UIFont {
        return UIFont.systemFont(ofSize: 17)
    }
    
    func cellLabelColor(in countryPickerView: CountryPickerView) -> UIColor? {
        return nil
    }
    
    func cellImageViewCornerRadius(in countryPickerView: CountryPickerView) -> CGFloat {
        return 2
    }
    
    func cellImageViewSize(in countryPickerView: CountryPickerView) -> CGSize {
        return CGSize(width: 34, height: 24)
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
    
    func showCountryCodeInList(in countryPickerView: CountryPickerView) -> Bool {
        return false
    }
    
    func showCheckmarkInList(in countryPickerView: CountryPickerView) -> Bool {
        return true
    }
    
    func localeForCountryNameInList(in countryPickerView: CountryPickerView) -> Locale {
        return Locale.current
    }
}


// MARK:- CountryPickerViewDelegate default implementations
public extension CountryPickerViewDelegate {

    func countryPickerView(_ countryPickerView: CountryPickerView,
                           willShow viewController: CountryPickerViewController) {
    }
    
    func countryPickerView(_ countryPickerView: CountryPickerView,
                           didShow viewController: CountryPickerViewController) {
    }

}

