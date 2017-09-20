//
//  CountryPickerTableViewController.swift
//  CountryPicker
//
//  Created by Kizito Nwose on 18/09/2017.
//  Copyright © 2017 Kizito Nwose. All rights reserved.
//

import UIKit

class CountryPickerTableViewController: UITableViewController {
    
    weak var countryPickerView: CountryPickerView! {
        didSet { prepareTableItems() }
    }
    var sectionsTitles = [String]()
    var countries = [String: [Country]]()
    var isRoot: Bool {
        return navigationController?.viewControllers.count == 1
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //tableView.reloadData()
        print(sectionsTitles)
        prepareNavItem()
        prepareSearchBar()
        
    }
   
}


// UI Setup
extension CountryPickerTableViewController {
    
    func prepareTableItems()  {
        let countriesArray = countryPickerView.countries
        
        var header = Set<String>()
        countriesArray.forEach{
            let name = $0.name
            header.insert(String(name[name.startIndex]))
        }
        
        var data = [String: [Country]]()
        
        countriesArray.forEach({
            let name = $0.name
            let index = String(name[name.startIndex])
            var dictValue = data[index] ?? [Country]()
            dictValue.append($0)
            
            data[index] = dictValue
        })
        
        // Sort the sections
        data.forEach{ key, value in
            data[key] = value.sorted(by: { (lhs, rhs) -> Bool in
                return lhs.name < rhs.name
            })
        }
        
        sectionsTitles = header.sorted()
        countries = data
        if let preferredTitle = countryPickerView.preferredCountriesSectionTitle(),
            countryPickerView.preferredCountries().count > 0 {
            sectionsTitles[0] = preferredTitle
            countries[preferredTitle] = countryPickerView.preferredCountries()
        }
    }
    
    func prepareNavItem() {
        // Add a close button if this is the root view controller
        if isRoot {
            let closeButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(close))
            navigationItem.rightBarButtonItem = closeButton
        }
        navigationItem.title = countryPickerView.navigationTitle()
    }
    
    func prepareSearchBar() {
        
    }
    
    @objc private func close() {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
}


//MARK: UITableViewDataSource
extension CountryPickerTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        print(sectionsTitles.count)
        return sectionsTitles.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries[sectionsTitles[section]]!.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "name")
            ?? UITableViewCell(style: .default, reuseIdentifier: "name")
        let country = countries[sectionsTitles[indexPath.section]]![indexPath.row]
        
        cell.imageView?.image = country.flag
        cell.textLabel?.text = country.name
        cell.accessoryType = country == countryPickerView.selectedCountry ? .checkmark : .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionsTitles[section]
    }
}


//MARK: UITableViewDelegate
extension CountryPickerTableViewController {

    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let header = view as? UITableViewHeaderFooterView {
            header.textLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let country = countries[sectionsTitles[indexPath.section]]![indexPath.row]
        countryPickerView.countryPickerView(didSelectCountry: country)
        tableView.deselectRow(at: indexPath, animated: true)
        dismiss(animated: true, completion: nil)
    }
}
