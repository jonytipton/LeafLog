//
//  PlantDetailViewController.swift
//  LeafLog
//
//  Created by Jonathan Tipton on 4/21/23.
//

import CoreData
import UIKit

class PlantDetailViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var plant: Plant!
    var defaultHeaderHeight: CGFloat = 30
    var needsLayout = true
    weak var garden: ViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        tableView.contentInset = UIEdgeInsets(top: -defaultHeaderHeight, left: 0, bottom: 0, right: 0)
        
        let addDetails = UIAction(title: "Add Details", image: UIImage(systemName: "magnifyingglass.circle"), handler: addDetailsTapped)
        let editPlant = UIAction(title: "Edit Plant", image: UIImage(systemName: "leaf"), handler: editTapped)
        let addPhoto = UIAction(title: "Add Photo", image: UIImage(systemName: "camera.viewfinder"), handler: addPhotoTapped)
        let deletePlant = UIAction(title: "Delete", image: UIImage(systemName: "trash"), attributes: .destructive, handler: deletePlantTapped)
        
        let menu = UIMenu(title: "", options: .displayInline, children: [addDetails, editPlant, addPhoto, deletePlant])
        let menuButton = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"), style: .plain, target: self, action: nil)
        menuButton.menu = menu
        navigationItem.rightBarButtonItems = [menuButton]
    }
    
    func addDetailsTapped(alert: UIAction) {
        let ac = UIAlertController(title: "Lookup Plant Details?", message: "If you know the common name of \(plant.nickname?.uppercased() ?? "your plant") LeafLog can search for and populate care information.", preferredStyle: .alert)
        ac.addTextField { (textField) in
            textField.placeholder = "i.e. Monstera, Golden Pothos, Snake"
        }
        ac.addAction(UIAlertAction(title: "Search", style: .default) { _ in
            if let text = ac.textFields![0].text, text.count > 0 {
                //TODO: validate search
                let searchString = text.replacingOccurrences(of: " ", with: "+")
                print("searchString: \(searchString)")
                self.lookupID(keyword: searchString) { (value) in
                    if let plantID = value {
                        print("id: \(plantID)")
                        self.lookupPlant(by: plantID)
                    }
                }
            } else {
                let ac = UIAlertController(title: "Invalid Search", message: "Enter the common or scientific name for your plant", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "See Help", style: .default)) //TODO: show gif of live lookup camera feature
                ac.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(ac, animated: true)
            }
        })
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
    func editTapped(alert: UIAction) {
        tableView.isEditing = true
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
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else {
            print("error getting image from picker")
            dismiss(animated: true); return }
        plant.userPhotos.append(image)
        garden.saveChanges()
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        dismiss(animated: true)
    }
    
    func lookupID(keyword string: String, completion: @escaping ((Int?) -> Void)) {
        var id: Int? = nil
        DispatchQueue.global().async {
            let urlString = "https://perenual.com/api/species-list?key=sk-vE9E6445aa6a8ec22611&q=\(string)"
            
            if let url = URL(string: urlString) {
                if let data = try? Data(contentsOf: url) {
                    let decoder = JSONDecoder()
                    if let search = try? decoder.decode(PlantSearch.self, from: data) {
                        if let plantID = search.data.first?.id {
                            id = plantID
                        }
                    }
                }
            }
        completion(id)
        }
    }
    
    func lookupPlant(by id: Int) {
        //TODO: error handling
        DispatchQueue.global().async {
            let urlString = "https://perenual.com/api/species/details/\(id)?key=sk-vE9E6445aa6a8ec22611"
            
            if let url = URL(string: urlString) {
                if let data = try? Data(contentsOf: url) {
                    let decoder = JSONDecoder()
                    if let plantDetails = try? decoder.decode(PlantStruct.self, from: data) {
                        print(plantDetails)
                        if let url = URL(string: plantDetails.defaultImage!.originalURL) {
                            if let data = try? Data(contentsOf: url) {
                                self.plant.defaultPhoto = data
                                print("here data")
                            }
                        }
                        self.plant.commonName = plantDetails.commonName
                        self.plant.cycle = plantDetails.cycle
                        self.plant.scientificName = plantDetails.scientificName.joined(separator: ", ")
                        self.plant.sunlight = plantDetails.sunlight
                        self.plant.watering = plantDetails.watering
                        self.garden.saveChanges()
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                            self.viewDidAppear(true)
                            print(self.plant.description)
                        }
                    }
                } else {
                    print("data error")
                }
            } else {
                print("url error 2")
            }
        }
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
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "detailTextCell") as! DetailTextCell
            cell.detailLabel.text = plant.sunlight?.joined(separator: ", ")
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "detailTextCell") as! DetailTextCell
            cell.detailLabel.text = plant.watering
            return cell
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: "detailTextCell") as! DetailTextCell
            cell.detailLabel.text = plant.cycle
            return cell
        case 5:
            let cell = tableView.dequeueReusableCell(withIdentifier: "detailTextCell") as! DetailTextCell
            cell.detailLabel.text = plant.commonName
            return cell
        case 6:
            let cell = tableView.dequeueReusableCell(withIdentifier: "detailTextCell") as! DetailTextCell
            cell.detailLabel.text = plant.scientificName
            return cell
        case 7:
            let cell = tableView.dequeueReusableCell(withIdentifier: "detailTextCell") as! DetailTextCell
            let formatter = DateFormatter()
            formatter.dateStyle = .long
            formatter.timeStyle = .none
            if let date = plant.dateAdded {
                cell.detailLabel.text = formatter.string(from: date)
            } else {
                cell.detailLabel.text = ""
            }
            return cell
        case 8:
            let cell = tableView.dequeueReusableCell(withIdentifier: "detailSlideshowCell", for: indexPath) as! DetailSlideshowCell
            if plant.userPhotos != cell.images {
                cell.images = plant.userPhotos
            }
            return cell
        case 9:
            let cell = tableView.dequeueReusableCell(withIdentifier: "detailReferenceCell", for: indexPath) as! DetailReferenceCell
            if let data = plant.defaultPhoto {
                if let image = UIImage(data: data) {
                    cell.referenceImageView.image = image
                }
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
        if indexPath.section == 8 {
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
            title = "Reference Photo"
        default:
            break
        }
        config.text = title
        config.textProperties.alignment = .center
        headerView.contentConfiguration = config
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.rowHeight
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        switch indexPath.section {
        case 1..<7:
            return true
        default:
            return false
        }
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 1...7:
            return 44
        default:
            return tableView.rowHeight
        }
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Delete") {[weak self] (action, view, completionHandler) in
            switch indexPath.section {
            case 1:
                self?.plant.nickname = nil
            case 2:
                self?.plant.sunlight = nil
            case 3:
                self?.plant.watering = nil
            case 4:
                self?.plant.cycle = nil
            case 5:
                self?.plant.commonName = nil
            case 6:
                self?.plant.scientificName = nil
            default:
                print("Error, how was button tapped?")
            }
            DispatchQueue.main.async {
                self?.garden.saveChanges()
                self?.tableView.reloadRows(at: [indexPath], with: .fade)
                completionHandler(true)
            }
        }
        
        let edit = UIContextualAction(style: .normal, title: "Edit") {[weak self] (action, view, completionHandler) in
            var title = ""
            switch indexPath.section {
            case 1:
                title = "Nickname"
            case 2:
                title = "Sunlight Needs"
            case 3:
                title = "Watering Needs"
            case 4:
                title = "Bloom Cycle"
            case 5:
                title = "Common Name"
            case 6:
                title = "Scientific Names"
            case 7:
                title = "Date Added"
            default:
                title = "section"
            }
            
            let ac = UIAlertController(title: "Edit \(title)", message: nil, preferredStyle: .alert)
            ac.addTextField()
            ac.addAction(UIAlertAction(title: "Cancel", style: .default))
            ac.addAction(UIAlertAction(title: "Update", style: .default) { [weak self] _ in
                if let value = ac.textFields?[0].text {
                    switch indexPath.section {
                    case 1:
                        self?.plant.nickname = value
                    case 2:
                        self?.plant.sunlight = [value]
                    case 3:
                        self?.plant.watering = value
                    case 4:
                        self?.plant.cycle = value
                    case 5:
                        self?.plant.commonName = value
                    case 6:
                        self?.plant.scientificName = value
                    default:
                        print("do nothing")
                    }
                    DispatchQueue.main.async {
                        self?.garden.saveChanges()
                        self?.tableView.reloadSections(IndexSet(arrayLiteral: 0, indexPath.section), with: .fade)
                    }
                }
            })
            self?.present(ac,animated: true)
        }
        
        return UISwipeActionsConfiguration(actions: [edit, delete])
    }
}
