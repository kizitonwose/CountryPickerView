//
//  CountryView.swift
//  CountryPicker
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
    func preferredCountries(in countryPickerView: CountryPickerView) -> [Country]
    func preferredCountriesSectionTitle(in countryPickerView: CountryPickerView) -> String?
    func navigationTitle(in countryPickerView: CountryPickerView) -> String?
}

public struct Country {
    var name: String
    var code: String
    var phoneCode: String
    var flag: UIImage? {
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

public class CountryPickerView: NibView {
    
    @IBOutlet weak var flagImageView: UIImageView!
    @IBOutlet weak var countryDetailsLabel: UILabel!
    
    var showCodeInView = true {
        didSet { setup() }
    }
    var showPhoneCodeInView = true {
        didSet { setup() }
    }
    var showFlagInView = true  {
        didSet { setup() }
    }
    
    var showPhoneCodeInList = false
    
    weak var dataSource: CountryPickerViewDataSource?
    weak var delegate: CountryPickerViewDelegate?
    
    private var _selectedCountry: Country?
    internal(set) public var selectedCountry: Country {
        get {
            return _selectedCountry ?? countries.first(where: { $0.code == "US" })!
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
        
        var text: String = ""
        if showCodeInView {
            text = "(\(selectedCountry.code)) "
        }
        
        if showPhoneCodeInView {
            text = "\(text)\(selectedCountry.phoneCode)"
        }

        countryDetailsLabel.text = text
    }
    
    @IBAction func openCountryPickerController(_ sender: Any) {
        if let vc = window?.topViewController {
            showCountriesList(from: vc)
        }
    }
    
    public func showCountriesList(from viewController: UIViewController) {
        let countryVc = CountryPickerTableViewController(style: .grouped)
        countryVc.countryPickerView = self
        if let viewController = viewController as? UINavigationController {
            viewController.pushViewController(countryVc, animated: true)
        } else {
            viewController.present(UINavigationController(rootViewController: countryVc), animated: true, completion: nil)
        }
    }
}

extension CountryPickerView {
    func countryPickerView(didSelectCountry country: Country) {
        selectedCountry = country
        delegate?.countryPickerView(self, didSelectCountry: country)
    }
}

extension CountryPickerView {
    func preferredCountries() -> [Country] {
      return dataSource?.preferredCountries(in: self) ?? [Country]()
    }
    
    func preferredCountriesSectionTitle() -> String? {
        return dataSource?.preferredCountriesSectionTitle(in: self)
    }
    
    func navigationTitle() -> String? {
        return dataSource?.navigationTitle(in: self) ?? "Select a Country"
    }
}

extension CountryPickerView {
    func getCountryByName(_ name: String) -> Country? {
        return countries.first(where: { $0.name == name })
    }
    
    func getCountryByPhoneCode(_ phoneCode: String) -> Country? {
        return countries.first(where: { $0.phoneCode == phoneCode })
    }
    
    func getCountryByCode(_ code: String) -> Country? {
        return countries.first(where: { $0.code == code })
    }
    
    var countries: [Country] {
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


public class NibView: UIView {
    
    weak var view: UIView!
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        nibSetup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        nibSetup()
    }
    
    fileprivate func nibSetup() {
        view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        addSubview(view)
    }
    
    fileprivate func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let nibView = nib.instantiate(withOwner: self, options: nil).first as! UIView
        
        return nibView
    }
    
}


