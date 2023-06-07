//
//  ScheduleTableViewController.swift
//  LeafLog
//
//  Created by Jonathan Tipton on 4/21/23.
//

import UIKit

class ScheduleTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 7
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UITableViewHeaderFooterView()
        var config = headerView.defaultContentConfiguration()
        config.textProperties.font = .boldSystemFont(ofSize: 36)
        config.textProperties.color = UIColor.init(named: "titleColor")!
        
        var title = ""
        switch (section) {
        case 0:
            title = "Sunday"
        case 1:
            title = "Monday"
        case 2:
            title = "Tuesday"
        case 3:
            title = "Wednesday"
        case 4:
            title = "Thursday"
        case 5:
            title = "Friday"
        default:
            title = "Saturday"
        }
        
        config.text = title
        config.textProperties.alignment = .natural
        headerView.contentConfiguration = config
        return headerView
    }

}
