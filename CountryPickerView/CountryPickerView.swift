//
//  CountryPickerView.swift
//  CountryPickerView
//
//  Created by Kizito Nwose on 18/09/2017.
//  Copyright © 2017 Kizito Nwose. All rights reserved.
//

import UIKit


public enum SearchBarPosition {
    case tableViewHeader, navigationBar, hidden
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
    
    static func localizedName(forRegionCode code: String, defaultName: String) -> String {
        if let countryName = Locale.current.localizedString(forRegionCode: code) {
            return countryName
        }
        
        return defaultName
    }
}

public func ==(lhs: Country, rhs: Country) -> Bool {
    return lhs.code == rhs.code
}
public func !=(lhs: Country, rhs: Country) -> Bool {
    return lhs.code != rhs.code
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
    
    /// Change the font of phone code
    public var font = UIFont.systemFont(ofSize: 17.0) {
        didSet { setup() }
    }
    /// Change the text color of phone code
    public var textColor = UIColor.black {
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
        countryDetailsLabel.font = font
        countryDetailsLabel.textColor = textColor
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
            delegate?.countryPickerView(self, willShow: countryVc)
            viewController.pushViewController(countryVc, animated: true) {
                self.delegate?.countryPickerView(self, didShow: countryVc)
            }
        } else {
            let navigationVC = UINavigationController(rootViewController: countryVc)
            delegate?.countryPickerView(self, willShow: countryVc)
            viewController.present(navigationVC, animated: true) {
                self.delegate?.countryPickerView(self, didShow: countryVc)
            }
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
                
                let localizedName = Country.localizedName(forRegionCode: code, defaultName: name)
                let country = Country(name: localizedName, code: code, phoneCode: phoneCode)
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
// Returns default options where necessary if the data source is not set.
extension CountryPickerView: CountryPickerViewDataSource {
    var preferredCountries: [Country] {
        return dataSource?.preferredCountries(in: self) ?? preferredCountries(in: self)
    }
    
    var preferredCountriesSectionTitle: String? {
        return dataSource?.sectionTitleForPreferredCountries(in: self)
    }
    
    var showOnlyPreferredSection: Bool {
        return dataSource?.showOnlyPreferredSection(in: self) ?? showOnlyPreferredSection(in: self)
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
        return dataSource?.searchBarPosition(in: self) ?? searchBarPosition(in: self)
    }
    
    var showPhoneCodeInList: Bool {
        return dataSource?.showPhoneCodeInList(in: self) ?? showPhoneCodeInList(in: self)
    }
    
}
