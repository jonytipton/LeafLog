//
//  PlantDetailViewController.swift
//  LeafLog
//
//  Created by Jonathan Tipton on 4/21/23.
//

import UIKit

class PlantDetailViewController: UITableViewController {
    
    var plant: Plant!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = plant.nickname?.uppercased()
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 10
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var title = "Title"
        switch (section) {
        case 0:
            title = "Display Photo"
            break
        case 1:
            title = "Nickname"
            break
        case 2:
            title = "Sunlight Needs"
            break
        case 3:
            title = "Watering Needs"
            break
        case 4:
            title = "Bloom Cycle"
            break
        case 5:
            title = "Common Name"
            break
        case 6:
            title = "Scientific Names"
            break
        case 7:
            title = "Date Added"
            break
        case 8:
            title = "User Photos"
            break
        case 9:
            title = "Reference Photos"
        default:
            break
        }
        return title
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //TODO: Update with switch for section
        //TODO: Show displayPhoto next to Large title?
        //see https://www.uptech.team/blog/build-resizing-image-in-navigation-bar-with-large-title
        //see Progress app for detail page inspiration
        let cell = tableView.dequeueReusableCell(withIdentifier: "detailImageCell") as! DetailImageCell
        cell.detailImageView.image = UIImage(data: plant.displayPhoto!)
        return cell
    }
}
