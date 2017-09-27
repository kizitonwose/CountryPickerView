//
//  CountryPickerView.swift
//  CountryPickerView
//
//  Created by Kizito Nwose on 18/09/2017.
//  Copyright © 2017 Kizito Nwose. All rights reserved.
//

import UIKit

public protocol CountryPickerViewDelegate: NSObjectProtocol {
    /// Called when the user selects a country from the list.
    func countryPickerView(_ countryPickerView: CountryPickerView, didSelectCountry country: Country)
}

public protocol CountryPickerViewDataSource: NSObjectProtocol {
    /// An array of countries you wish to show at the top of the list. 
    /// This is useful if your app is targeted towards people in specific countries.
    /// - requires: The title for the section to be returned in `sectionTitleForPreferredCountries`
    func preferredCountries(in countryPickerView: CountryPickerView) -> [Country]?
    
    /// The desired title for the preferred section.
    /// - **See:** `preferredCountries` method. Both are required for the section to be shown.
    func sectionTitleForPreferredCountries(in countryPickerView: CountryPickerView) -> String?
    
    /// This determines if only the preferred section is shown
    func showOnlyPreferredSection(in countryPickerView: CountryPickerView) -> Bool?
    
    /// The navigation item title when the internal view controller is pushed/presented.
    func navigationTitle(in countryPickerView: CountryPickerView) -> String?
    
    /// A navigation item button to be used if the internal view controller is presented(not pushed). 
    /// Return `nil` to use a default "Close" button.
    func closeButtonNavigationItem(in countryPickerView: CountryPickerView) -> UIBarButtonItem?
    
    /// The desired position for the search bar.
    func searchBarPosition(in countryPickerView: CountryPickerView) -> SearchBarPosition
    
    /// This determines if a country's phone code is shown alongside the country's name on the list.
    /// e.g Nigeria (+234)
    func showPhoneCodeInList(in countryPickerView: CountryPickerView) -> Bool?
}

public struct Country {
   public var name: String
   public var code: String
   public var phoneCode: String
   public var flag: UIImage {
        return UIImage(named: "CountryPickerView.bundle/Images/\(code.uppercased())",
            in: Bundle(for: CountryPickerView.self), compatibleWith: nil)!
    }
    
   internal init(name: String, code: String, phoneCode: String) {
        self.name = name
        self.code = code
        self.phoneCode = phoneCode
    }
}

public func ==(lhs: Country, rhs: Country) -> Bool {
    return lhs.code == rhs.code
}
public func !=(lhs: Country, rhs: Country) -> Bool {
    return lhs.code != rhs.code
}

public enum SearchBarPosition {
   case tableViewHeader, navigationBar, hidden
}


public class CountryPickerView: NibView {
    @IBOutlet weak var spacingConstraint: NSLayoutConstraint!
    @IBOutlet public weak var flagImageView: UIImageView!
    @IBOutlet public weak var countryDetailsLabel: UILabel!
    
    // Show/Hide the country code on the view.
    public var showCountryCodeInView = true {
        didSet { setup() }
    }
    
    // Show/Hide the phone code on the view.
    public var showPhoneCodeInView = true {
        didSet { setup() }
    }
    
    /// The spacing between the flag image and the text.
    public var flagSpacingInView: CGFloat {
        get {
            return spacingConstraint.constant
        }
        set {
            spacingConstraint.constant = newValue
        }
    }
    
    weak public var dataSource: CountryPickerViewDataSource?
    weak public var delegate: CountryPickerViewDelegate?
    
    fileprivate var _selectedCountry: Country?
    internal(set) public var selectedCountry: Country {
        get {
            return _selectedCountry
                ?? countries.first(where: { $0.code == Locale.current.regionCode })
                ?? countries.first(where: { $0.code == "NG" })!
        }
        set {
            _selectedCountry = newValue
            setup()
        }
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        flagImageView.image = selectedCountry.flag
        if showPhoneCodeInView && showCountryCodeInView {
            countryDetailsLabel.text = "(\(selectedCountry.code)) \(selectedCountry.phoneCode)"
            return
        }
        
        if showCountryCodeInView || showPhoneCodeInView {
            countryDetailsLabel.text = showCountryCodeInView ? selectedCountry.code : selectedCountry.phoneCode
        } else {
            countryDetailsLabel.text = nil
        }
        
    }
    
    @IBAction func openCountryPickerController(_ sender: Any) {
        if let vc = window?.topViewController {
            if let tabVc = vc as? UITabBarController,
                let selectedVc = tabVc.selectedViewController {
                showCountriesList(from: selectedVc)
            } else {
                showCountriesList(from: vc)
            }
        }
    }
    
    public func showCountriesList(from viewController: UIViewController) {
        let countryVc = CountryPickerViewController(style: .grouped)
        countryVc.countryPickerView = self
        if let viewController = viewController as? UINavigationController {
            viewController.pushViewController(countryVc, animated: true)
        } else {
            viewController.present(UINavigationController(rootViewController: countryVc),
                                   animated: true)
        }
    }
    
    public var countries: [Country] = {
        var countries = [Country]()
        let bundle = Bundle(for: CountryPickerView.self)
        guard let jsonPath = bundle.path(forResource: "CountryPickerView.bundle/Data/CountryCodes", ofType: "json"),
            let jsonData = try? Data(contentsOf: URL(fileURLWithPath: jsonPath)) else {
                return countries
        }
        
        if let jsonObjects = (try? JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization
            .ReadingOptions.allowFragments)) as? Array<Any> {
            
            for jsonObject in jsonObjects {
                
                guard let countryObj = jsonObject as? Dictionary<String, Any> else {
                    continue
                }
                
                guard let name = countryObj["name"] as? String,
                    let code = countryObj["code"] as? String,
                    let phoneCode = countryObj["dial_code"] as? String else {
                        continue
                }
                
                let country = Country(name: name, code: code, phoneCode: phoneCode)
                countries.append(country)
            }
            
        }
        
        return countries
    }()
}

//MARK: Helper methods
extension CountryPickerView {
    public func setCountryByName(_ name: String) {
        if let country = countries.first(where: { $0.name == name }){
            selectedCountry = country
        }
    }
    
    public func setCountryByPhoneCode(_ phoneCode: String) {
        if let country = countries.first(where: { $0.phoneCode == phoneCode }) {
            selectedCountry = country
        }
    }
    
    public func setCountryByCode(_ code: String) {
        if let country = countries.first(where: { $0.code == code }) {
            selectedCountry = country
        }
    }
    
    public func getCountryByName(_ name: String) -> Country? {
        return countries.first(where: { $0.name == name })
    }
    
    public func getCountryByPhoneCode(_ phoneCode: String) -> Country? {
        return countries.first(where: { $0.phoneCode == phoneCode })
    }
    
    public func getCountryByCode(_ code: String) -> Country? {
        return countries.first(where: { $0.code == code })
    }
}


// MARK:- An internal implementation of the CountryPickerViewDelegate.
// Sets internal properties before calling external delegate.
extension CountryPickerView {
    func didSelectCountry(_ country: Country) {
        selectedCountry = country
        delegate?.countryPickerView(self, didSelectCountry: country)
    }
}

// MARK:- An internal implementation of the CountryPickerViewDataSource.
// Returns default options where necessary.
extension CountryPickerView {
    var preferredCountries: [Country] {
        return dataSource?.preferredCountries(in: self) ?? [Country]()
    }
    
    var preferredCountriesSectionTitle: String? {
        return dataSource?.sectionTitleForPreferredCountries(in: self)
    }
    
    var showOnlyPreferredSection: Bool {
        return dataSource?.showOnlyPreferredSection(in: self) ?? false
    }
    
    var navigationTitle: String? {
        return dataSource?.navigationTitle(in: self)
    }
    
    var closeButtonNavigationItem: UIBarButtonItem {
        guard let button = dataSource?.closeButtonNavigationItem(in: self) else {
            return UIBarButtonItem(title: "Close", style: .done, target: nil, action: nil)
        }
        return button
    }
    
    var searchBarPosition: SearchBarPosition {
        return dataSource?.searchBarPosition(in: self) ?? .tableViewHeader
    }
    
    var showPhoneCodeInList: Bool {
        return dataSource?.showPhoneCodeInList(in: self) ?? false
    }
    
}
