//
//  PlantDetailViewController.swift
//  LeafLog
//
//  Created by Jonathan Tipton on 4/21/23.
//

import CoreData
import UIKit

class PlantDetailViewController: UITableViewController {
    
    var plant: Plant!
    var defaultHeaderHeight: CGFloat = 30
    var needsLayout = true
    weak var garden: ViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        tableView.contentInset = UIEdgeInsets(top: -defaultHeaderHeight, left: 0, bottom: 0, right: 0)

        let editPlant = UIAction(title: "Edit Plant", image: UIImage(systemName: "leaf"), handler: editTapped)
        let addPhoto = UIAction(title: "Add Photo", image: UIImage(systemName: "camera.viewfinder"), handler: addPhotoTapped)
        let deletePlant = UIAction(title: "Delete", image: UIImage(systemName: "trash"), attributes: .destructive, handler: deletePlantTapped)
        
        let menu = UIMenu(title: "", options: .displayInline, children: [editPlant, addPhoto, deletePlant])
        let menuButton = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"), style: .plain, target: self, action: nil)
        menuButton.menu = menu
        navigationItem.rightBarButtonItems = [menuButton]
    }

    func editTapped(alert: UIAction) {
        print("Edit Tapped")
    }
    
    func deletePlantTapped(alert: UIAction) {
        let ac = UIAlertController(title: "Delete \(plant.nickname ?? "Plant")?", message: "This cannot be undone!", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Delete", style: .destructive) { _ in
            self.garden.deletePlant(self.plant)
            self.navigationController?.popViewController(animated: true)
        })
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }

    
    func addPhotoTapped(alert: UIAction) {
        print("Add Photo Tapped")
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 10
    }

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "detailImageCell") as! DetailImageCell
            cell.detailImageView.image = UIImage(data: plant.displayPhoto!)
            cell.plantLabel.text = plant.nickname?.uppercased()
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "detailTextCell") as! DetailTextCell
            cell.detailLabel.text = plant.nickname
            return cell
        case 9:
            let cell = tableView.dequeueReusableCell(withIdentifier: "detailSlideshowCell") as! DetailSlideshowCell
            //TODO: replace with JSON data
            if cell.images.isEmpty {
                var arr = [UIImage]()
                for _ in 1...5 {
                    let image = UIImage(data: plant.displayPhoto!)
                    arr.append(image!)
                }
                cell.images = arr
            }
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
            headerHeight = 1
        default:
            headerHeight = defaultHeaderHeight
        }
        return headerHeight
    }

    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
        }
    }
    
    override func tableView(_ tableView: UITableView, didEndDisplayingHeaderView view: UIView, forSection section: Int) {
        if section == 0 {
            title = plant.nickname?.uppercased()
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if section == 0 {
            title = ""
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.section == 9 {
            let cell = cell as! DetailSlideshowCell
            cell.displayImages()
        }
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UITableViewHeaderFooterView()
        var config = headerView.defaultContentConfiguration()
        config.textProperties.alignment = .center
        
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
        config.text = title
        config.textProperties.alignment = .center
        headerView.contentConfiguration = config
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 9 {
            return view.frame.height / 3.0
        } else {
            return tableView.rowHeight
        }
    }
}
