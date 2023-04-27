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
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 10
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var title = "Title"
        switch (section) {
        case 0:
//            title = "Display Photo"
            title = ""
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
        
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "detailImageCell") as! DetailImageCell
            cell.detailImageView.image = UIImage(data: plant.displayPhoto!)
            cell.plantLabel.text = plant.nickname
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "detailTextCell") as! DetailTextCell
            cell.detailLabel.text = plant.nickname
            return cell
        case 9:
            let cell = tableView.dequeueReusableCell(withIdentifier: "detailSlideshowCell") as! DetailSlideshowCell
            //TODO: replace with JSON data
            var arr = [UIImage]()
            for _ in 1...5 {
                let image = UIImage(data: plant.displayPhoto!)
                arr.append(image!)
            }
            cell.images = arr
            cell.displayImages()
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "detailTextCell") as! DetailTextCell
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let headerHeight: CGFloat
        
        switch section {
        case 0:
            headerHeight = CGFloat.leastNonzeroMagnitude
        default:
            headerHeight = 21
        }
        return headerHeight
    }

    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            title = plant.nickname
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            title = ""
        }
    }

    
}
