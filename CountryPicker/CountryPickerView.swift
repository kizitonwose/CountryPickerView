//
//  CountryView.swift
//  CountryPicker
//
//  Created by Kizito Nwose on 18/09/2017.
//  Copyright © 2017 Kizito Nwose. All rights reserved.
//

import Foundation
import UIKit

struct Country {
    var name: String?
    var code: String?
    var phoneCode: String?
    var flag: UIImage? {
        guard let code = self.code else { return nil }
        return UIImage(named: "CountryPicker.bundle/Images/\(code.uppercased())",
            in: Bundle(for: CountryPickerView.self), compatibleWith: nil)
    }
    
    init(name: String?, code: String?, phoneCode: String?) {
        self.name = name
        self.code = code
        self.phoneCode = phoneCode
    }
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
    
    
    private var _selectedCountry: Country?
    internal(set) var selectedCountry: Country {
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
        if showCodeInView, let code = selectedCountry.code {
            text = "(\(code)) "
        }
        
        if showPhoneCodeInView, let phoneCode = selectedCountry.phoneCode {
            text = "\(text)\(phoneCode)"
        }

        countryDetailsLabel.text = text
    }
    
    @IBAction func openCountryPickerController(_ sender: Any) {
        window?.topViewController?.present(CountryPickerTableViewController(), animated: true, completion: nil)
    }
    
    var countries: [Country] {
        var countries = [Country]()
        let bundle = Bundle(for: type(of: self))
        guard let jsonPath = bundle.path(forResource: "CountryPicker.bundle/Data/CountryCodes", ofType: "json"),
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


