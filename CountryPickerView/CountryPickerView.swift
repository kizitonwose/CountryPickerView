//
//  CountryPickerView.swift
//  CountryPickerView
//
//  Created by Kizito Nwose on 18/09/2017.
//  Copyright © 2017 Kizito Nwose. All rights reserved.
//

import Foundation
import UIKit

public protocol CountryPickerViewDelegate: NSObjectProtocol {
    func countryPickerView(_ countryPickerView: CountryPickerView, didSelectCountry country: Country)
}

public protocol CountryPickerViewDataSource: NSObjectProtocol {
    func preferredCountries(in countryPickerView: CountryPickerView) -> [Country]?
    func sectionTitleForPreferredCountries(in countryPickerView: CountryPickerView) -> String?
    func navigationTitle(in countryPickerView: CountryPickerView) -> String?
    func closeButtonNavigationItem(in countryPickerView: CountryPickerView) -> UIBarButtonItem?
    func searchBarPosition(in countryPickerView: CountryPickerView) -> SearchBarPosition
    func showPhoneCodeInList(in countryPickerView: CountryPickerView) -> Bool?
}

public struct Country {
   public var name: String
   public var code: String
   public var phoneCode: String
   public var flag: UIImage? {
        return UIImage(named: "CountryPickerView.bundle/Images/\(code.uppercased())",
            in: Bundle(for: CountryPickerView.self), compatibleWith: nil)
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
    
    public var showCountryCodeInView = true {
        didSet { setup() }
    }
    public var showPhoneCodeInView = true {
        didSet { setup() }
    }
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
    
    private var _selectedCountry: Country?
    internal(set) public var selectedCountry: Country {
        get {
            return _selectedCountry ?? countries.first(where: { $0.code == "NG" })!
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
            showCountriesList(from: vc)
        }
    }
    
    public func showCountriesList(from viewController: UIViewController) {
        let countryVc = CountryPickerViewTableViewController(style: .grouped)
        countryVc.countryPickerView = self
        if let viewController = viewController as? UINavigationController {
            viewController.pushViewController(countryVc, animated: true)
        } else {
            viewController.present(UINavigationController(rootViewController: countryVc),
                                   animated: true, completion: nil)
        }
    }
}

extension CountryPickerView {
    func didSelectCountry(_ country: Country) {
        selectedCountry = country
        delegate?.countryPickerView(self, didSelectCountry: country)
    }
}

extension CountryPickerView {
    var preferredCountries: [Country] {
      return dataSource?.preferredCountries(in: self) ?? [Country]()
    }
    
    var preferredCountriesSectionTitle: String? {
        return dataSource?.sectionTitleForPreferredCountries(in: self)
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

extension CountryPickerView {
    public func getCountryByName(_ name: String) -> Country? {
        return countries.first(where: { $0.name == name })
    }
    
    public func getCountryByPhoneCode(_ phoneCode: String) -> Country? {
        return countries.first(where: { $0.phoneCode == phoneCode })
    }
    
    public func getCountryByCode(_ code: String) -> Country? {
        return countries.first(where: { $0.code == code })
    }
    
    public var countries: [Country] {
        var countries = [Country]()
        let bundle = Bundle(for: type(of: self))
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
    }
}
