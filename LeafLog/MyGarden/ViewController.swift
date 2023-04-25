//
//  ViewController.swift
//  LeafLog
//
//  Created by Jonathan Tipton on 4/3/23.
//

import UIKit

class ViewController: UICollectionViewController, UINavigationControllerDelegate, UICollectionViewDelegateFlowLayout  {

    var plants = [Plant]()
    let margin = 10.0
    
    //Reference to managed object context
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "My Garden"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addPlant))
        navigationController?.navigationBar.prefersLargeTitles = true
        
        guard let collectionView = collectionView, let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        flowLayout.minimumInteritemSpacing = margin
        flowLayout.minimumLineSpacing = margin
        flowLayout.sectionInset = UIEdgeInsets(top: margin, left: margin, bottom: margin, right: margin)
        
        fetchPlants()
    }
    
    func fetchPlants() {
        //Fetch data from Core Data to display in the collectionview
        do {
            self.plants = try context.fetch(Plant.fetchRequest())
            print(plants.count)
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        } catch {
            //TODO: Display alert controller w/ error
            //error
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
        detailVC.plant = plants[indexPath.item]
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.collectionView.reloadData()
    }
    
}

