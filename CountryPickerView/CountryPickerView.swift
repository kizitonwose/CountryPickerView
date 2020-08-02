//
//  CountryPickerView.swift
//  CountryPickerView
//
//  Created by Kizito Nwose on 18/09/2017.
//  Copyright © 2017 Kizito Nwose. All rights reserved.
//

import UIKit

public typealias CPVCountry = Country

public enum SearchBarPosition {
    case tableViewHeader, navigationBar, hidden
}

public struct Country: Equatable {
    public let name: String
    public let code: String
    public let phoneCode: String
    public func localizedName(_ locale: Locale = Locale.current) -> String? {
        return locale.localizedString(forRegionCode: code)
    }
    public var flag: UIImage {
        return UIImage(named: "CountryPickerView.bundle/Images/\(code.uppercased())",
            in: Bundle(for: CountryPickerView.self), compatibleWith: nil)!
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
    @IBOutlet public weak var flagImageView: UIImageView! {
        didSet {
            flagImageView.clipsToBounds = true
            flagImageView.layer.masksToBounds = true
            flagImageView.layer.cornerRadius = 2
        }
    }
    @IBOutlet public weak var countryDetailsLabel: UILabel!
    
    /// Show/Hide the country code on the view.
    public var showCountryCodeInView = true {
        didSet {
            if showCountryNameInView && showCountryCodeInView {
                showCountryNameInView = false
            } else {
                setup()
            }
        }
    }
    
    /// Show/Hide the phone code on the view.
    public var showPhoneCodeInView = true {
        didSet { setup() }
    }
    
    /// Show/Hide the country name on the view.
    public var showCountryNameInView = false {
        didSet {
            if showCountryCodeInView && showCountryNameInView {
                showCountryCodeInView = false
            } else {
                setup()
            }
        }
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
    weak public var hostViewController: UIViewController?
    
    fileprivate var _selectedCountry: Country?
    internal(set) public var selectedCountry: Country {
        get {
            return _selectedCountry
                ?? usableCountries.first(where: { $0.code == Locale.current.regionCode })
                ?? usableCountries.first!
        }
        set {
            _selectedCountry = newValue
            delegate?.countryPickerView(self, didSelectCountry: newValue)
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
        if showCountryCodeInView && showPhoneCodeInView {
            countryDetailsLabel.text = "(\(selectedCountry.code)) \(selectedCountry.phoneCode)"
        } else if showCountryNameInView && showPhoneCodeInView {
            countryDetailsLabel.text = "(\(selectedCountry.localizedName() ?? selectedCountry.name)) \(selectedCountry.phoneCode)"
        } else if showCountryCodeInView || showPhoneCodeInView || showCountryNameInView {
            countryDetailsLabel.text = showCountryCodeInView ? selectedCountry.code
                : showPhoneCodeInView ? selectedCountry.phoneCode
                : selectedCountry.localizedName() ?? selectedCountry.name
        } else {
            countryDetailsLabel.text = nil
        }
    }
    
    @IBAction func openCountryPickerController(_ sender: Any) {
        if let hostViewController = hostViewController {
            showCountriesList(from: hostViewController)
            return
        }
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
    
    public let countries: [Country] = {
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
    
    internal var usableCountries: [Country] {
        let excluded = dataSource?.excludedCountries(in: self) ?? []
        return countries.filter { return !excluded.contains($0) }
    }
}

//MARK: Helper methods
extension CountryPickerView {
    public func setCountryByName(_ name: String) {
        if let country = countries.first(where: { $0.name == name }) {
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
