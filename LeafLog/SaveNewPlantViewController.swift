//
//  SaveNewPlantViewController.swift
//  LeafLog
//
//  Created by Jonathan Tipton on 4/13/23.
//

import UIKit

class SaveNewPlantViewController: UIViewController, UITextFieldDelegate {
    
    var plantImage: UIImage!
    
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
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }

        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)

//        if notification.name == UIResponder.keyboardWillHideNotification {
//            additionalSafeAreaInsets.bottom = .zero
//        } else {
//            additionalSafeAreaInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
//        }
    }
    @IBAction func addTapped(_ sender: Any) {
        //TODO: add plant to core data and collection view
        if let tabBar = self.presentingViewController as? UITabBarController {
            if let nav = tabBar.selectedViewController as? UINavigationController {
                if let gardenController = nav.topViewController as? ViewController {
                    gardenController.plants.append([textField.text!: plantImage])
                    gardenController.collectionView.reloadData()
                    dismiss(animated: true)
                }
                else {
                    print(nav.topViewController)
                }
            } else {
                print(tabBar.selectedViewController)
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
