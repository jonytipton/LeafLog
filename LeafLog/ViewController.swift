//
//  ViewController.swift
//  LeafLog
//
//  Created by Jonathan Tipton on 4/3/23.
//

import UIKit

class ViewController: UICollectionViewController, UINavigationControllerDelegate  {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "My Garden"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addPlant))
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "plantCell", for: indexPath) as? PlantCell else { fatalError("Unable to dequeue resuable cell with identifer: 'plantCell'")}
        cell.titleLabel.text = "A"
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
            newPlantController.navigationController?.additionalSafeAreaInsets = UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10)
            present(nav, animated: true)
        }
        
    }

}

