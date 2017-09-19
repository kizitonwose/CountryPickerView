//
//  CountryPickerTableViewController.swift
//  CountryPicker
//
//  Created by Kizito Nwose on 18/09/2017.
//  Copyright © 2017 Kizito Nwose. All rights reserved.
//

import UIKit

class CountryPickerTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        //tableView.reloadData()
        print(CountryPickerTableViewController.countries)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 4
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "name") ?? UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "name")
        
        //cell.imageView?.image = UIImage(named: "NG", in: Bundle(for: type(of: self)), compatibleWith: nil)

        return cell
    }
    
    static var countries: [String: [String]] {
        let names = ["Emmanuel", "Olivia", "Frances", "Frank", "Kizito"]
        
        var header = Set<String>()
        names.forEach{
            header.insert(String($0[$0.startIndex]))
        }
        
        var data = [String: [String]]()
        
        names.forEach({
            let index = String($0[$0.startIndex])
            var dictValue = data[index] ?? [String]()
            dictValue.append($0)
            
            data[index] = dictValue
        })
        
        data.forEach{ data[$0] = $1.sorted() }
        
        return data
    }
}
