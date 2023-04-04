//
//  NewPlantController.swift
//  LeafLog
//
//  Created by Jonathan Tipton on 4/3/23.
//

import UIKit

class NewPlantController: UIViewController, UINavigationControllerDelegate, UINavigationBarDelegate, UIImagePickerControllerDelegate, UITabBarControllerDelegate {
    
    weak var gardenDelegate: ViewController!
    
    @IBOutlet var newPlantImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("view loaded")

    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //save image
        guard let image = info[.editedImage] as? UIImage else { return }
        newPlantImage.image = image
        newPlantImage.layer.cornerRadius = 50
        newPlantImage.layer.masksToBounds = true
        dismiss(animated: true)
    }
    
    @objc func addImage() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //update view of collection in my Garden
        
    }
    
}
