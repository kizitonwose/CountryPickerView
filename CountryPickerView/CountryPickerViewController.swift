//
//  CountryPickerViewController.swift
//  CountryPickerView
//
//  Created by Kizito Nwose on 18/09/2017.
//  Copyright © 2017 Kizito Nwose. All rights reserved.
//

import UIKit

class CountryPickerViewController: UITableViewController {
    
    fileprivate var searchController: UISearchController?
    fileprivate var searchResults = [Country]()
    fileprivate var isSearchMode = false
    fileprivate var sectionsTitles = [String]()
    fileprivate var countries = [String: [Country]]()
    fileprivate var hasPreferredSection: Bool {
        return countryPickerView.preferredCountriesSectionTitle != nil &&
            countryPickerView.preferredCountries.count > 0
    }
    fileprivate var showOnlyPreferredSection: Bool {
        return countryPickerView.showOnlyPreferredSection
    }
    
    weak var countryPickerView: CountryPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareTableItems()
        prepareNavItem()
        prepareSearchBar()
    }
   
}


// UI Setup
extension CountryPickerViewController {
    
    func prepareTableItems()  {
        
        if !showOnlyPreferredSection {
            
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
        }
        
        // Add preferred section if data is available
        if hasPreferredSection, let preferredTitle = countryPickerView.preferredCountriesSectionTitle {
            sectionsTitles.insert(preferredTitle, at: sectionsTitles.startIndex)
            countries[preferredTitle] = countryPickerView.preferredCountries
        }
        
        tableView.sectionIndexBackgroundColor = .clear
        tableView.sectionIndexTrackingBackgroundColor = .clear
    }
    
    func prepareNavItem() {
        navigationItem.title = countryPickerView.navigationTitle

        // Add a close button if this is the root view controller
        if navigationController?.viewControllers.count == 1 {
            let closeButton = countryPickerView.closeButtonNavigationItem
            closeButton.target = self
            closeButton.action = #selector(close)
            navigationItem.leftBarButtonItem = closeButton
        }
    }
    
    func prepareSearchBar() {
        let searchBarPosition = countryPickerView.searchBarPosition
        if searchBarPosition == .hidden  {
            return
        }
        searchController = UISearchController(searchResultsController:  nil)
        searchController?.searchResultsUpdater = self
        searchController?.dimsBackgroundDuringPresentation = false
        searchController?.hidesNavigationBarDuringPresentation = searchBarPosition == .tableViewHeader
        searchController?.searchBar.delegate = self

        switch searchBarPosition {
        case .tableViewHeader: tableView.tableHeaderView = searchController?.searchBar
        case .navigationBar: navigationItem.titleView = searchController?.searchBar
        default: break
        }
    }
    
    @objc private func close() {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
}


//MARK:- UITableViewDataSource
extension CountryPickerViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return isSearchMode ? 1 : sectionsTitles.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearchMode ? searchResults.count : countries[sectionsTitles[section]]!.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
            ?? UITableViewCell(style: .default, reuseIdentifier: "cell")
        let country = isSearchMode ? searchResults[indexPath.row]
            : countries[sectionsTitles[indexPath.section]]![indexPath.row]
        
        let name = countryPickerView.showPhoneCodeInList ? "\(country.name) (\(country.phoneCode))" : country.name
        cell.imageView?.image = country.flag
        cell.textLabel?.text = name
        cell.accessoryType = country == countryPickerView.selectedCountry ? .checkmark : .none
        cell.separatorInset = .zero
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return isSearchMode ? nil : sectionsTitles[section]
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        if isSearchMode {
            return nil
        } else {
            if hasPreferredSection {
                return Array<String>(sectionsTitles.dropFirst())
            }
            return sectionsTitles
        }
    }
    
    override func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return sectionsTitles.index(of: title)!
    }
}


//MARK:- UITableViewDelegate
extension CountryPickerViewController {

    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let header = view as? UITableViewHeaderFooterView {
            header.textLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let country = isSearchMode ? searchResults[indexPath.row]
            : countries[sectionsTitles[indexPath.section]]![indexPath.row]

        searchController?.dismiss(animated: false, completion: nil)
        
        let completion = {
            self.countryPickerView.didSelectCountry(country)
        }
        // If this is root, dismiss, else pop
        if navigationController?.viewControllers.count == 1 {
            navigationController?.dismiss(animated: true, completion: completion)
        } else {
            navigationController?.popViewController(animated: true, completion: completion)
        }
    }
}


// MARK:- UISearchResultsUpdating
extension CountryPickerViewController: UISearchResultsUpdating {
    public func updateSearchResults(for searchController: UISearchController) {
        isSearchMode = false
        if let text = searchController.searchBar.text, text.count > 0 {
            isSearchMode = true
            searchResults.removeAll()
            
            var indexArray = [Country]()
            
            if showOnlyPreferredSection && hasPreferredSection,
                let array = countries[countryPickerView.preferredCountriesSectionTitle!] {
                indexArray = array
            } else if let array = countries[String(text[text.startIndex])] {
                indexArray = array
            }

            searchResults.append(contentsOf: indexArray.filter({ $0.name.hasPrefix(text) }))
        }
        tableView.reloadData()
    }
}


// MARK:- UISearchBarDelegate
extension CountryPickerViewController: UISearchBarDelegate {
    public func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        // Hide the back/left navigationItem button
        navigationItem.leftBarButtonItem = nil
        navigationItem.hidesBackButton = true
    }
    
    public func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        // Show the back/left navigationItem button
        prepareNavItem()
        navigationItem.hidesBackButton = false
    }
    
}


