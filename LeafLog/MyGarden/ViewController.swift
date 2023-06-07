//
//  ViewController.swift
//  LeafLog
//
//  Created by Jonathan Tipton on 4/3/23.
//

import UIKit

class ViewController: UICollectionViewController, UINavigationControllerDelegate, UICollectionViewDelegateFlowLayout  {
    
    enum PlantFilters: String {
        case ascending = "Ascending"
        case descending = "Descending"
        case favorites = "Favorites"
    }
    
    var plants = [Plant]()
    let margin = 10.0
    var selectedFilter = PlantFilters.ascending
    
    //Reference to managed object context
    let context = CoreDataManager.shared.persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchPlants()
        
        if let filter = UserDefaults.standard.object(forKey: "PlantFilter") as? String {
            selectedFilter = PlantFilters(rawValue: filter) ?? PlantFilters.ascending
        }
        
        title = "My Garden"
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addPlant))
        let filterAscending = UIAction(title: "Ascending", image: UIImage(systemName: "arrow.up"), handler: filterAscending)
        let filterDescending = UIAction(title: "Descending", image: UIImage(systemName: "arrow.down"), handler: filterDescending)
        let filterFavorites = UIAction(title: "Favorites", image: UIImage(systemName: "star"), handler: filterFavorites)
        
        switch selectedFilter {
        case .descending:
            filterDescending.state = .on
        case .favorites:
            filterFavorites.state = .on
        default:
            filterAscending.state = .on
        }
        
        let menu = UIMenu(title: "Sort By", options: .singleSelection, children: [filterAscending, filterDescending, filterFavorites])
        let menuButton = UIBarButtonItem(image: UIImage(systemName: "line.3.horizontal.decrease.circle"), style: .plain, target: self, action: nil)
        menuButton.menu = menu
        navigationItem.rightBarButtonItems = [menuButton, addButton]
        navigationController?.navigationBar.prefersLargeTitles = true
        
        guard let collectionView = collectionView, let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        flowLayout.minimumInteritemSpacing = margin
        flowLayout.minimumLineSpacing = margin
        flowLayout.sectionInset = UIEdgeInsets(top: margin, left: margin, bottom: margin, right: margin)
    }
    
    func filterAscending(alert: UIAction) {
        UserDefaults.standard.set(PlantFilters.ascending.rawValue, forKey: "PlantFilter")
        reloadPlants()
    }
    
    func filterDescending(alert: UIAction) {
        UserDefaults.standard.set(PlantFilters.descending.rawValue, forKey: "PlantFilter")
        reloadPlants()
    }
    
    func filterFavorites(alert: UIAction) {
        UserDefaults.standard.set(PlantFilters.favorites.rawValue, forKey: "PlantFilter")
        reloadPlants()
    }
    
    func filterPlants() {
        guard let filter = UserDefaults.standard.object(forKey: "PlantFilter") as? String else { return }
        selectedFilter = PlantFilters(rawValue: filter) ?? selectedFilter
        
        switch selectedFilter {
        case .descending:
            plants = self.plants.sorted(by: {
                guard let nameA = $0.nickname, let nameB = $1.nickname else { return false }
                return nameA > nameB
            })
            break
        case .favorites:
            //TODO: filter by favorites tag
            break
        default:
            //Ascending
            plants = self.plants.sorted(by: {
                guard let nameA = $0.nickname, let nameB = $1.nickname else { return false }
                return nameA < nameB
            })
        }
    }
    
    func fetchPlants() {
        //Fetch data from Core Data to display in the collectionview
        do {
            self.plants = try context.fetch(Plant.fetchRequest())
            reloadPlants()
        } catch {
            print("error in fetchPlants(): \(error)")
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return plants.count
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "plantCell", for: indexPath) as? PlantCell else { fatalError("Unable to dequeue resuable cell with identifer: 'plantCell'")}
        cell.titleLabel.text = plants[indexPath.item].nickname
        if let photoData = plants[indexPath.item].displayPhoto {
            if let image = UIImage(data: photoData) {
                cell.imageView.image = image
            }
        }
        //recalculate frame width for imageView corner radius
        cell.layoutIfNeeded()
        
        return cell
    }
    
    @objc func addPlant() {
        //present a view modally
        if let newPlantController = storyboard?.instantiateViewController(withIdentifier: "newPlantController") {
            let nav = UINavigationController(rootViewController: newPlantController)
            nav.modalPresentationStyle = .pageSheet
            nav.isModalInPresentation = true
            if let sheet = nav.sheetPresentationController {
                sheet.detents = [.medium()]
                sheet.preferredCornerRadius = 50
            }
            
            let cancel = UIBarButtonItem(__barButtonSystemItem: .close, primaryAction: .init(handler: { [weak self] _ in
                //AC confirmation prompt
                self?.dismiss(animated: true)
            }))
            
            newPlantController.navigationItem.rightBarButtonItem = cancel
            newPlantController.navigationItem.rightBarButtonItem?.tintColor = UIColor.init(named: "titleColor")
            newPlantController.navigationController?.additionalSafeAreaInsets = UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10)
            present(nav, animated: true)
        }
    }
    
    func deletePlant(_ plant: Plant) {
        //delete
        context.delete(plant)
        fetchPlants()
        do {
            try context.save()
        } catch {
            //TODO: error handling
        }
    }
    
    func saveChanges() {
        do {
            try context.save()
            fetchPlants()
        } catch {
            print("Error saving changes: \(error)")
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? PlantCell else { return }
        cell.imageView.layer.cornerRadius = cell.imageView.frame.size.width / 2.0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellsPerRowCount = 3
        
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        
        let totalSpace = flowLayout.sectionInset.left + flowLayout.sectionInset.right + (flowLayout.minimumInteritemSpacing * CGFloat(cellsPerRowCount - 1))
        
        let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(cellsPerRowCount))
        return CGSize(width: size, height: size)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let detailVC = storyboard?.instantiateViewController(withIdentifier: "plantDetailViewController") as? PlantDetailViewController else { return }
        detailVC.garden = self
        detailVC.plant = plants[indexPath.item]
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func reloadPlants() {
        filterPlants()
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        reloadPlants()
    }
    
}

