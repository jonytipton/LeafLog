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
    var defaultHeaderHeight: CGFloat = 40.0
    var sectionHeaderTopPadding: CGFloat = 10.0
    var needsLayout = true
    weak var garden: ViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.contentInset = UIEdgeInsets(top: -defaultHeaderHeight, left: 0, bottom: 0, right: 0)
        tableView.sectionHeaderTopPadding = sectionHeaderTopPadding
        title = plant.nickname
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.tintColor = UIColor(named: "titleColor")
        navigationController?.navigationBar.barTintColor = UIColor(named: "appBackground")
        let appearance = UINavigationBarAppearance()
        appearance.titleTextAttributes = [.foregroundColor: UIColor(named: "titleColor")!, .font: UIFont(name: "Futura", size: 20)!]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor(named: "titleColor")!, .font: UIFont(name: "Futura", size: 34)!]
        appearance.backgroundColor = UIColor(named: "appBackground")
        navigationItem.standardAppearance = appearance
        
        let addDetails = UIAction(title: "Add Details", image: UIImage(systemName: "magnifyingglass.circle"), handler: addDetailsTapped)
        let addReminder = UIAction(title: "Add Reminder", image: UIImage(systemName: "alarm"), handler: addReminderTapped)
        let addPhoto = UIAction(title: "Add Photo", image: UIImage(systemName: "camera.viewfinder"), handler: addPhotoTapped)
        let deletePlant = UIAction(title: "Delete", image: UIImage(systemName: "trash"), attributes: .destructive, handler: deletePlantTapped)
        
        let menu = UIMenu(title: "", options: .displayInline, children: [addDetails, addReminder, addPhoto, deletePlant])
        let menuButton = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"), style: .plain, target: self, action: nil)
        menuButton.menu = menu
        navigationItem.rightBarButtonItems = [menuButton]
        tableView.backgroundColor = UIColor(named: "appBackground")
    }
    
    func addReminderTapped(alert: UIAction) {
        if let reminderDetailController = storyboard?.instantiateViewController(withIdentifier: "reminderDetailVC") as? ReminderPlantDetailController {
            let nav = UINavigationController(rootViewController: reminderDetailController)
            nav.modalPresentationStyle = .pageSheet
            //nav.isModalInPresentation = true
            if let sheet = nav.sheetPresentationController {
                sheet.detents = [.medium()]
                sheet.preferredCornerRadius = 50
            }
            reminderDetailController.delegate = self
            reminderDetailController.plant = self.plant
            present(nav, animated: true)
        }
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
        
        return plant.defaultPhoto == nil ? 9 : 10
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "detailImageCell") as! DetailImageCell
            cell.detailImageView.image = UIImage(data: plant.displayPhoto!)
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
                tableView.layoutIfNeeded()
                cell.images = plant.userPhotos
            }
            cell.selectionStyle = .none
            return cell
        case 9:
            let cell = tableView.dequeueReusableCell(withIdentifier: "detailReferenceCell", for: indexPath) as! DetailReferenceCell
            if let data = plant.defaultPhoto {
                if let image = UIImage(data: data) {
                    cell.referenceImageView.image = image
                }
            }
            cell.selectionStyle = .none
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
            headerHeight = sectionHeaderTopPadding * 2
        default:
            headerHeight = defaultHeaderHeight
        }
        return headerHeight
    }

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.section == 9 {
            if plant.defaultPhoto == nil {
                cell.isHidden = true
            } else {
                cell.isHidden = false
            }
        }
        cell.backgroundColor = UIColor.clear
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UITableViewHeaderFooterView()
        var config = headerView.defaultContentConfiguration()
        var title = "Title"
        switch (section) {
        case 0:
            return nil
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
            break
        case 7:
            title = "Date Added"
        case 8:
            title = "User Photos"
        case 9:
            if plant.defaultPhoto == nil {
                return nil
            } else {
                title = "Reference Photo"
            }
        default:
            break
        }
        config.text = title
        config.textProperties.font = UIFont(name: "Futura", size: 22)!
        config.textProperties.alignment = .center
        headerView.contentConfiguration = config
        return headerView
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return tableView.window!.frame.height / 3
        case 8:
            return (tableView.window!.frame.height / 3) + 30
        case 9:
            return tableView.window!.frame.height / 3
        default:
            return UITableView.automaticDimension
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        switch indexPath.section {
        case 0:
            return false
        case 8:
            return false
        default:
            return true
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
            case 7:
                self?.plant.dateAdded = nil
            case 9:
                self?.plant.defaultPhoto = nil
            default:
                print("Error: Verify sections 0 and 8 are disabled for trailing swipe gesture. Selected section is: \(indexPath.section)")
            }
            DispatchQueue.main.async {
                self?.garden.saveChanges()
                self?.tableView.reloadData()
                completionHandler(true)
            }
        }
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
    func displayDatePicker() {
        //present a view modally
        if let updatePlantController = storyboard?.instantiateViewController(withIdentifier: "updatePlantVC") as? UpdatePlantController {
            let nav = UINavigationController(rootViewController: updatePlantController)
            nav.modalPresentationStyle = .pageSheet
            nav.isModalInPresentation = true
            if let sheet = nav.sheetPresentationController {
                sheet.detents = [.medium()]
                sheet.preferredCornerRadius = 50
            }
            
            let cancel = UIBarButtonItem(__barButtonSystemItem: .close, primaryAction: .init(handler: { [weak self] _ in
                //AC confirmation prompt
                self?.tableView.isScrollEnabled = true
                self?.dismiss(animated: true)
            }))
            updatePlantController.navigationItem.rightBarButtonItem = cancel
            updatePlantController.navigationItem.rightBarButtonItem?.tintColor = UIColor.init(named: "titleColor")
            updatePlantController.navigationController?.additionalSafeAreaInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
            updatePlantController.delegate = self
            present(nav, animated: true)
        }
    }
    
    @objc func cancelPressed() {
        self.view.endEditing(true)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.section {
        case 0:
            let ac = UIAlertController(title: "Change Display Photo?", message: "Choose from Photo Library or take a new photo", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Photo Library", style: .default))
            ac.addAction(UIAlertAction(title: "Take Photo", style: .default))
            ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            present(ac, animated: true)
        case 1...6:
            displayDetailModal(indexPath.section)
            break
        case 7:
            tableView.isScrollEnabled = false
            displayDatePicker()
        default:
            break
        }
    }
    
    func displayDetailModal(_ section: Int) {
        if let updateDetailController = storyboard?.instantiateViewController(withIdentifier: "updateDetailVC") as? UpdatePlantDetailViewController {
            let nav = UINavigationController(rootViewController: updateDetailController)
            nav.modalPresentationStyle = .pageSheet
            //nav.isModalInPresentation = true
            if let sheet = nav.sheetPresentationController {
                sheet.detents = [.medium()]
                sheet.preferredCornerRadius = 50
            }
            updateDetailController.delegate = self
            updateDetailController.section = section
            present(nav, animated: true)
        }
    }
    
    func didFinishUpdatingDetailField(_ value: (Int, String)) {
        switch value.0 {
        case 1:
            plant.nickname = value.1
        case 2:
            plant.sunlight = [value.1]
        case 3:
            plant.watering = value.1
        case 4:
            plant.cycle = value.1
        case 5:
            plant.commonName = value.1
        case 6:
            plant.scientificName = value.1
        default:
            break
        }
        garden.saveChanges()
        tableView.reloadData()
        tableView.isScrollEnabled = true
    }
    
}
