//
//  NewPlantController.swift
//  LeafLog
//
//  Created by Jonathan Tipton on 4/3/23.
//

import AVFoundation
import Photos
import PhotosUI
import UIKit

class NewPlantController: UIViewController,
                          UINavigationControllerDelegate, UINavigationBarDelegate, PHPickerViewControllerDelegate, UITabBarControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        let itemProvider = results.first?.itemProvider
        
        if let itemProvider = itemProvider, itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
                DispatchQueue.main.async {
                    guard let self = self, let image = image as? UIImage else { return }
                    
                    if let vc = self.storyboard?.instantiateViewController(withIdentifier: "cameraVC") as? CameraViewController {
                        vc.newPlantController = self
                        vc.usingLibrary = true
                        vc.libraryImage = image
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                    
                }
            }
        }
    }
    
    
    weak var gardenDelegate: ViewController!
    
    @IBOutlet var newPlantTitle: UILabel!
    @IBOutlet var stackView: UIStackView!
    @IBOutlet var newButton: UIButton!
     
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Loaded NewPlantController modal")
        newPlantTitle.textColor = UIColor.init(named: "titleColor")
    }
    
    @IBAction @objc func openLibrary(_ sender: Any) {
        var config = PHPickerConfiguration()
        config.filter = .images
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        present(picker, animated: true)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        let destination = segue.destination as! CameraViewController
        destination.newPlantController = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //update view of collection in my Garden
        
    }
    
}

