//
//  NewPlantController.swift
//  LeafLog
//
//  Created by Jonathan Tipton on 4/3/23.
//

import AVFoundation
import UIKit

class NewPlantController: UIViewController,
                          UINavigationControllerDelegate, UINavigationBarDelegate, UIImagePickerControllerDelegate, UITabBarControllerDelegate {
    
    weak var gardenDelegate: ViewController!
    
    @IBOutlet var newPlantTitle: UILabel!
    @IBOutlet var stackView: UIStackView!
    @IBOutlet var newButton: UIButton!
     
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Loaded NewPlantController modal")
        newPlantTitle.textColor = UIColor.init(named: "titleColor")
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //save image
        //guard let image = info[.editedImage] as? UIImage else { return }
       
    }
    
//    @IBAction func openCamera(_ sender: Any) {
//        let picker = UIImagePickerController()
//        picker.delegate = self
//        picker.sourceType = .camera
//        picker.allowsEditing = false
//        picker.showsCameraControls = false
//        picker.cameraCaptureMode = .photo
//        picker.view.frame = self.view.bounds
//        addChild(picker)
//        picker.view.layer.frame = CGRect(x: view.layer.frame.width, y: view.center.y / 2, width: picker.view.frame.size.width / 1.5, height: view.frame.size.width / 1.5)
//        picker.view.layer.borderColor = UIColor.init(named: "appGreen")?.cgColor
//        picker.view.layer.borderWidth = 5
//        picker.view.frame = CGRectInset(picker.view.frame, -picker.view.layer.borderWidth, -picker.view.layer.borderWidth)
//        picker.view.clipsToBounds = true
//        picker.view.layer.cornerRadius = picker.view.layer.bounds.width / 2
//        self.view.addSubview(picker.view)
//        takePhotoView.layer.position = CGPoint(x: picker.view.layer.position.x, y: view.safeAreaInsets.top)
//
//        UIView.transition(with: picker.view, duration: 0.5, animations: {
//            self.stackView.transform = CGAffineTransform(translationX: -self.view.frame.size.width, y: 0)
//            picker.view.center = self.view.center
//            self.view.addSubview(self.takePhotoView)
//            self.takePhotoView.layer.position.x = picker.view.layer.position.x
//        })
//        let overlayView = UIView(frame: picker.view.frame)
//        picker.view.addSubview(overlayView)
//        let tap = UITapGestureRecognizer(target: self, action: #selector(takePhoto(_:)))
//        overlayView.addGestureRecognizer(tap)
//        picker.cameraOverlayView = overlayView
//    }
    
    
    @IBAction func openLibrary(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        present(picker, animated: true)
    }
//

//
    
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

