//
//  SaveNewPlantViewController.swift
//  LeafLog
//
//  Created by Jonathan Tipton on 4/13/23.
//

import UIKit

class SaveNewPlantViewController: UIViewController, UITextFieldDelegate {
    
    var plantImage: UIImage!
    let context = CoreDataManager.shared.persistentContainer.viewContext
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var addPlantButton: UIButton!
    @IBOutlet var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.textColor = UIColor.init(named: "titleColor")
        //textField.backgroundColor = addPlantButton.backgroundColor
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        textField.delegate = self
        textField.layer.cornerRadius = 50
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        //guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }

//        let keyboardScreenEndFrame = keyboardValue.cgRectValue
//        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)

//        if notification.name == UIResponder.keyboardWillHideNotification {
//            additionalSafeAreaInsets.bottom = .zero
//        } else {
//            additionalSafeAreaInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
//        }
    }
    @IBAction func addTapped(_ sender: Any) {
        if let tabBar = self.presentingViewController as? UITabBarController {
            if let nav = tabBar.selectedViewController as? UINavigationController {
                if let gardenController = nav.topViewController as? ViewController {
                    let text = textField.text!
                    
                    let newPlant = Plant(context: self.context)
                    newPlant.nickname = text
                    if let photoData = plantImage.jpegData(compressionQuality: 1.0) {
                        newPlant.displayPhoto = photoData
                        newPlant.userPhotos.append(plantImage)
                        newPlant.dateAdded = Date.now
                        print(newPlant.userPhotos)
                    } else {
                        print("error convering image to data")
                    }
                    do {
                        try self.context.save()
                    } catch {
                        print("ERROR SAVING NEW PLANT")
                    }
                    gardenController.fetchPlants()
                    dismiss(animated: true)
                }
                else {
                    //print(nav.topViewController)
                }
            } else {
                //print(tabBar.selectedViewController)
            }
        } else {
            let ac = UIAlertController(title: "Missing Name", message: "Type nickname for plant in textfield before adding", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .cancel))
            present(ac, animated: true)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        addPlantButton.isHidden = false
        return false
    }

}
